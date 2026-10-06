param([string]$QuartusRoot = 'C:\intelFPGA_lite\18.1\quartus')
$ErrorActionPreference='Stop'
$taskProjectRoot=$PSScriptRoot
$taskCompiler=Join-Path $QuartusRoot 'bin64\quartus_sh.exe'
if(!(Test-Path -LiteralPath $taskCompiler)) { throw "找不到 Quartus：$taskCompiler" }
Push-Location $taskProjectRoot
try {
    & $taskCompiler --flow compile DE2_115_CAMERA *> 'docs\quartus_compile.txt'
    if($LASTEXITCODE -ne 0) { throw 'Quartus 編譯失敗，請查看 docs\quartus_compile.txt。' }
    $taskSummary=Get-Content -LiteralPath 'output_files\DE2_115_CAMERA.sta.summary' -Raw
    $taskSlacks=[regex]::Matches($taskSummary,'Slack\s*:\s*(-?\d+(?:\.\d+)?)')
    if($taskSlacks.Count -eq 0) { throw '找不到可驗證的時序報告。' }
    foreach($taskSlack in $taskSlacks) {
        if([double]::Parse($taskSlack.Groups[1].Value,[cultureinfo]::InvariantCulture) -lt 0) {
            throw '編程檔已產生，但仍有負的時序 slack；請先查看 Timing Analyzer 報告。'
        }
    }
    Write-Output '編譯成功，報告中的時序 slack 均非負。尚需板上及外部 I/O 時序驗證。'
} finally { Pop-Location }
