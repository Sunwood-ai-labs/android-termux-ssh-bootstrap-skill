param(
    [string]$RepoRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

Set-Location $RepoRoot

$requiredFiles = @(
    "SKILL.md",
    "README.md",
    "README.ja.md",
    "CONTRIBUTING.md",
    "SECURITY.md",
    "CODE_OF_CONDUCT.md",
    "LICENSE",
    ".gitignore",
    ".gitattributes",
    ".editorconfig",
    "agents/openai.yaml",
    "assets/icon.svg",
    "assets/android-termux-ssh-bootstrap.svg",
    "assets/social-card.svg",
    ".github/CODEOWNERS",
    ".github/ISSUE_TEMPLATE/config.yml",
    ".github/pull_request_template.md",
    ".github/workflows/validate-skill.yml"
)

$missing = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missing += $file
    }
}

if ($missing.Count -gt 0) {
    Write-Error ("Missing required files: " + ($missing -join ", "))
}

$skill = Get-Content "SKILL.md" -Raw -Encoding utf8
$yaml = Get-Content "agents/openai.yaml" -Raw -Encoding utf8
$readme = Get-Content "README.md" -Raw -Encoding utf8
$readmeJa = Get-Content "README.ja.md" -Raw -Encoding utf8

if ($skill -notmatch '^---\s*[\r\n]+name:\s+android-termux-ssh-bootstrap\s*[\r\n]+description:\s+') {
    Write-Error "SKILL.md frontmatter is missing or the skill name is wrong."
}

if ($yaml -notmatch 'display_name:\s+"Android Termux SSH Bootstrap"') {
    Write-Error "agents/openai.yaml display_name is missing or wrong."
}

if ($yaml -notmatch 'icon_small:\s+"\./assets/icon\.svg"' -or $yaml -notmatch 'icon_large:\s+"\./assets/android-termux-ssh-bootstrap\.svg"') {
    Write-Error "agents/openai.yaml icon references are missing or wrong."
}

if ($yaml -notmatch 'default_prompt:\s+"Use \$android-termux-ssh-bootstrap') {
    Write-Error "agents/openai.yaml default_prompt does not reference `$android-termux-ssh-bootstrap."
}

if ($readme -notmatch '\./assets/icon\.svg' -or $readmeJa -notmatch '\./assets/icon\.svg') {
    Write-Error "README icon references are missing or wrong."
}

if ($readme -notmatch 'README\.ja\.md' -or $readmeJa -notmatch 'README\.md') {
    Write-Error "README language switch links are missing."
}

Write-Host "Validation passed."
Write-Host "Checked files:" ($requiredFiles -join ", ")
