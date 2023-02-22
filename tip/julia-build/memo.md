## libstdc/build-stats
- `make build-stats` 需要使用 Julia 自带的的 c++ 库才能正常运行
need  `libstdc++-6.dll` (julia used)


..\yt-dlp_win\yt-dlp.exe  `
--playlist-items 1:150  `
--no-playlist  `
-f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best `
https://www.youtube.com/playlist?list=PLWiiO7FHwvr9DRqaeyJEU8E0OYc1-1K6n

## 生成文档 tex

*documenter.sty*
```tex
\usepackage{listings}
\usepackage[draft=true]{minted}
```

```sh
julia --color=yes /mnt/v/julia/doc/make.jl -- pdf linkcheck= doctest= buildroot=/mnt/v/julia texplatform= revise=
```

tectonic -X compile --keep-logs -Z shell-escape  PDFCoverPage.tex 

## 
https://julialangnightlies.s3.amazonaws.com/assert_pretesting/winnt/x64/1.9/julia-e4257cbc89-win64.zip

## test
- 部分测试需要网络 TOML=github.com/KristofferC/toml-test-julia/archive/refs/tags/v1.2.0.tar.gz


## MSSY2 / cygwin / WSL2
```
woclass@wos-PC MINGW64 /v/julia
$ make print-OS
OS=WINNT
$ make print-BUILD_OS
BUILD_OS=WINNT

woclass@wos-PC /cygdrive/v/julia
$ make print-OS
OS=WINNT
$ make print-BUILD_OS
BUILD_OS=CYGWIN_NT-10.0-19045

woclass@wos-PC:/mnt/v/julia$ make print-OS
OS=Linux
woclass@wos-PC:/mnt/v/julia$ make print-BUILD_OS
BUILD_OS=Linux
```
