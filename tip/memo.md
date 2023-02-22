

- 未使用的 julia 符号
```jl
help?> $=
search:

  x $= y is a synonym for x = x $ y
```

`@fredrikekre` 有一些 julia 符号可以解析，但是并未使用，你可以自行赋值。
```jl
julia> const var"$" = +

julia> x = 1
1

julia> x $= 2
3

julia> x
3
```


- 同时定义一元和二元操作符 `~`
```jl
julia> Base.isbinaryoperator(:~)
true

julia> Base.isunaryoperator(:~)
true
```

- 调整宏展开顺序
https://jkrumbiegel.com/pages/2022-08-09-composing-macros/


### 下载 youtube 的视频列表

```cmd
..\yt-dlp_win\yt-dlp.exe  `
--playlist-items 1:150  `
--no-playlist  `
-f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best `
https://www.youtube.com/playlist?list=PLWiiO7FHwvr9DRqaeyJEU8E0OYc1-1K6n
```
