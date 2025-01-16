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
}

function main {
    # install rust if not already present
    if (-Not (Get-Command cargo -errorAction SilentlyContinue)) {
        Install-Rust
    }

    # install starkli
    Install-Starkli

}

main