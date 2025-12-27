

https://github.com/JuliaLang/julia/issues/31530

in docker
- build: ~10 GiB / 4Core
- test:  ~20 GiB / 4Core

## Run WSL in Win docker?


- [ ] WSL2: maybe not possiable
- [ ] WSL1: need to mount `install.wim`
    https://github.com/Microsoft/WSL/issues/3555

windows:20H2-amd64
```pwsh
docker run  `
    -it  --name wsl `
    --cpus="4" --memory=12G  `
    --mount type=bind,source=V:\tmp,target=C:\tmp,readonly  `
    mcr.microsoft.com/windows:20H2-amd64

## -------- in docker
powershell
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
wsl --install -d Ubuntu-16.04
Add-AppxPackage C:\tmp\Ubuntu_1804.2019.522.0_x64.appx
```


```pwsh
docker run  `
    -it  --name wsl `
    --cpus="4" --memory=12G  `
    --mount type=bind,source=V:\win10-offline,target=C:\win10-offline,readonly  `
    woclass/msys2-mingw-w64


## -------- in docker
powershell
dism /Online /Get-FeatureInfo /featurename:Microsoft-Windows-Subsystem-Linux /English
dism /get-wiminfo /wimfile:C:\win10\install.wim
dism /mount-wim /wimfile:C:\win10\install.wim /index:5 /mountdir:c:\offline /readonly

# host
dism /mount-wim /wimfile:F:\sources\install.wim /index:5 /mountdir:V:\win10-offline /readonly

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -Source C:\win10-offline
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /source:C:\win10-offline
```
