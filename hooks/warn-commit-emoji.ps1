# warn-commit-emoji.ps1 — PreToolUse(Bash) advisory hook
# 作用：git commit 的 message 里出现 emoji 时，提醒（不阻断）。配套约定：commit msg 纯文字。
# 安装见 sops\09-hook-guards.md。
# 契约：stdin 收 hook JSON；exit 0 放行；advisory 走 hookSpecificOutput.additionalContext。
# 铁律：advisory 永不阻断、永不抛错——任何异常都 exit 0 静默。
# 编码：显式按 UTF-8 读 stdin / 写 stdout（中文 Windows 控制台默认 GBK 会损坏中文与 emoji）。

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
  $cmd = [string]$obj.tool_input.command
  if ([string]::IsNullOrWhiteSpace($cmd)) { exit 0 }

  # 只管 git commit
  if ($cmd -notmatch 'git\s+commit') { exit 0 }

  # emoji 探测（符号杂项区 + 高代理区）
  $emoRe = [regex]'[☀-➿⬀-⯿️\uD83C-\uDBFF]'
  if (-not $emoRe.IsMatch($cmd)) { exit 0 }

  $msg = "[hook 提醒] 这条 git commit 的 message 含 emoji。约定：commit message 纯文字、不加 emoji。建议去掉 emoji 后再提交。"
  $out = @{
    hookSpecificOutput = @{
      hookEventName = "PreToolUse"
      permissionDecision = "allow"
      additionalContext = $msg
    }
    continue = $true
  } | ConvertTo-Json -Depth 8 -Compress
  Write-StdoutUtf8 $out
  exit 0
}
catch { exit 0 }
