# warn-ps1-no-bom.ps1 — PostToolUse(Write|Edit) advisory hook
# 作用：刚写/改的 .ps1 含中文却没有 UTF-8 BOM 时提醒（不阻断）。
# 依据：Windows PowerShell 5.1 对无 BOM 的 .ps1 按 GBK 解码，中文乱码、引号被吃、解析失败。
# 安装见 sops\09-hook-guards.md。铁律：advisory 永不阻断、异常 exit 0 静默。
# 注意：PostToolUse 时文件已落盘，故直接读磁盘字节判断 BOM。
# 编码：显式按 UTF-8 读 stdin / 写 stdout。

function Read-StdinUtf8 {
  $r = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), [System.Text.Encoding]::UTF8)
  try { return $r.ReadToEnd() } finally { $r.Dispose() }
}
function Write-StdoutUtf8([string]$s) {
  $b = [System.Text.Encoding]::UTF8.GetBytes($s)
  $o = [Console]::OpenStandardOutput()
  $o.Write($b, 0, $b.Length); $o.Flush()
}

try {
  $raw = Read-StdinUtf8
  if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
  $obj = $raw | ConvertFrom-Json
  $path = [string]$obj.tool_input.file_path
  if ([string]::IsNullOrWhiteSpace($path)) { exit 0 }
  if ($path -notmatch '\.ps1$') { exit 0 }
  if (-not (Test-Path -LiteralPath $path)) { exit 0 }

  $bytes = [System.IO.File]::ReadAllBytes($path)
  if ($bytes.Length -lt 1) { exit 0 }

  # 含中文？（CJK 统一表意区）
  $text = [System.IO.File]::ReadAllText($path)
  if ($text -notmatch '[一-鿿]') { exit 0 }

  # 有 UTF-8 BOM？（EF BB BF）
  $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
  if ($hasBom) { exit 0 }

  $msg = "[hook 提醒] 刚写的 $path 含中文但没有 UTF-8 BOM。Windows PowerShell 5.1 会按 GBK 解码，导致中文乱码、引号被吃、脚本解析失败。请补 BOM 再用：用带 BOM 的 UTF8Encoding 重写该文件。"
  $out = @{
    hookSpecificOutput = @{
      hookEventName = "PostToolUse"
      additionalContext = $msg
    }
    continue = $true
  } | ConvertTo-Json -Depth 8 -Compress
  Write-StdoutUtf8 $out
  exit 0
}
catch { exit 0 }
