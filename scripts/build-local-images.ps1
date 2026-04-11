Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$platformImage = 'bizza12345/opencti-platform:local'
$workerImage = 'bizza12345/opencti-worker:local'

Write-Step "Building OpenCTI platform image: $platformImage"
docker build `
    -f opencti-platform/Dockerfile_featurebranch `
    --target app `
    -t $platformImage `
    opencti-platform
if ($LASTEXITCODE -ne 0) {
    throw "Platform image build failed."
}

Write-Step "Building OpenCTI worker image: $workerImage"
docker build `
    -f opencti-worker/Dockerfile `
    -t $workerImage `
    opencti-worker
if ($LASTEXITCODE -ne 0) {
    throw "Worker image build failed."
}

Write-Step "Built local images"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}" | Select-String "bizza12345/opencti-platform|bizza12345/opencti-worker"
