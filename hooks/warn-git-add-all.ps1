# warn-git-add-all.ps1 — PreToolUse(Bash) advisory hook
# 作用：出现 git add . / git add -A / git add --all 时提醒（不阻断）。
# 依据：共享/并行会话里 git add . 会把他人未提交的 WIP 一起 stage。
# 安装见 sops\09-hook-guards.md。铁律：advisory 永不阻断、异常 exit 0 静默。
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
  $cmd = [string]$obj.tool_input.command
  if ([string]::IsNullOrWhiteSpace($cmd)) { exit 0 }

  # 匹配 git add . / git add -A / git add --all（允许前后有其它命令段）
  if ($cmd -notmatch 'git\s+add\s+(\.(\s|$)|-A(\s|$)|--all(\s|$))') { exit 0 }

  $msg = "[hook 提醒] 检测到 git add . / -A / --all。共享或并行会话里这会把别人未提交的 WIP 一起 stage。建议先 git status / git diff 确认，再显式 git add 列出本次要提交的文件。"
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
