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
