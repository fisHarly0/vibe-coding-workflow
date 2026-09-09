# remind-reflect.ps1 — Stop advisory hook（自我迭代轻提醒）
# 作用：会话收尾时，轻提醒"本次有无可沉淀经验/复发的坑 → 要不要追加 self-iteration\reflection-log.md"。
# 设计：节流——至多每 3 小时提醒一次（Stop 每轮都触发，不节流会刷屏）。永不阻断停止。
# 触发主力仍是"手动"（用户说"反思一下"），本 hook 只是轻量助攻。觉得烦随时在 settings.json 删。
# 配套：self-iteration\protocol.md。铁律：永远 exit 0、永不发 block 决定。
# 编码：显式按 UTF-8 写 stdout（systemMessage 含中文）。

function Write-StdoutUtf8([string]$s) {
  $b = [System.Text.Encoding]::UTF8.GetBytes($s)
  $o = [Console]::OpenStandardOutput()
  $o.Write($b, 0, $b.Length); $o.Flush()
}

try {
  $marker = Join-Path $env:TEMP "vcw-reflect-last.txt"
  $now = Get-Date
  $throttleHours = 3

  if (Test-Path -LiteralPath $marker) {
    try {
      $last = [datetime]::Parse((Get-Content -LiteralPath $marker -Raw).Trim())
      if (($now - $last).TotalHours -lt $throttleHours) { exit 0 }
    } catch { }
  }

  # 更新节流标记
  try { Set-Content -LiteralPath $marker -Value ($now.ToString("o")) -Encoding ASCII } catch { }

  $msg = "[自我迭代轻提醒] 若本次会话有可迁移的经验、或复发的老坑，考虑追加一条到 self-iteration\reflection-log.md（格式见 self-iteration\protocol.md）。无则忽略。"
  $out = @{
    systemMessage = $msg
    continue = $true
  } | ConvertTo-Json -Depth 6 -Compress
  Write-StdoutUtf8 $out
  exit 0
}
catch { exit 0 }
