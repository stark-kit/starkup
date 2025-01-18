### Tools

function Get-HostTriple {
    # let rustup identify the host triple for us
    return rustup show | select-string "^Default host" | ForEach-Object { $_.Line -replace (".+?(?=: ): ") }
}


### Install functions

function Install-Rust {
    Write-Host "Installing Rust..." -ForegroundColor Cyan
    $exePath = "$env:TEMP\rustup-init.exe"

    Write-Host "Downloading..."
    (New-Object Net.WebClient).DownloadFile('https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe', $exePath)
    
    Write-Host "Installing..."
    ## use this AND prompt user to install visual studio libraries in order for rust to work
    cmd /c start /wait $exePath
    ## automatic installation of visual studio libraries
    # winget install Microsoft.VisualStudio.2022.BuildTools --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621"
    Remove-Item $exePath

    $env:Path = "$env:Path;$env:USERPROFILE\.cargo\bin"
    
    cargo --version
    rustup --version
    rustc --version
    
    Write-Host "Rust installed" -ForegroundColor Green
}

function Install-Starkli {
    cargo install --locked --git https://github.com/xJonathanLEI/starkli

function Install-Scarb {
    Write-Host "Installing Scarb..." -ForegroundColor Cyan
    $hostTriple = Get-HostTriple

    # resolve latest version from github API
    $githubAPIContent = Invoke-WebRequest -Uri "https://api.github.com/repos/software-mansion/scarb/releases/latest"
    $content = $githubAPIContent.Content | ConvertFrom-JSON
    $compatibleContent = $content.assets.where{ $_.name -Match $hostTriple }
    $archiveFilename = $compatibleContent.name

    # download scarb
    $scarbURL = $compatibleContent.browser_download_url
    $archivePath = "$env:TEMP\$archiveFilename"
    $tempPath = "$env:TEMP\scarbTemp"
    (New-Object Net.WebClient).DownloadFile($scarbURL, $archivePath)

    # install scarb
    $installPath = "$env:LOCALAPPDATA\Programs\scarb"
    Expand-Archive -Force -Path "$archivePath" -DestinationPath $tempPath
    Move-Item -Path "$tempPath\*" -Destination $installPath -Force
    Remove-Item -Recurse $archivePath
    Remove-Item -Recurse $tempPath

    # add scarb path to environment
    if (! ("$env:PATH" -match [regex]::Escape("$installPath\\bin"))) {
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$installPath\bin", "User") # todo: change Machine Path instead of User
    }

    # test
    $env:Path = "$env:Path;$installPath\bin"
    scarb --version

    Write-Host "Scarb installed" -ForegroundColor Green
}

function main {
    # install rust if not already present
    if (-Not (Get-Command cargo -errorAction SilentlyContinue)) {
        Install-Rust
    }

    # install starkli
    if (-Not (Get-Command starkli -errorAction SilentlyContinue)) {
    Install-Starkli
    }

    # install scarb
    if (-Not (Get-Command scarb -errorAction SilentlyContinue)) {
        Install-Scarb
    }
}

main