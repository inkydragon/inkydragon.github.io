调试 Pkg 的间歇性故障
性能测试面板
code coverage

推进 windows ci 迁移到 buildkite
build on WINE

Some of my recent ideas. No order of preference:
- [CI/test] At the moment it looks like julia's code coverage tests may be a bit problematic.
I'd be happy to write more tests for julia when it works properly

- [build] I do want to fix this,  https://github.com/JuliaLang/julia/issues/31530


- [doc/PDF] PDF manual issue. Maybe open a new issue: https://github.com/JuliaLang/julia/issues/35495#issuecomment-1007249423

- [doc/PDF backend; mid-/longterm] TeX in pure Julia.  https://github.com/TeX-host/JuTeX.jl
- [test; Loooong term] write tests like SQLite. https://www.sqlite.org/testing.html



My long-term goal or dream is to improve Julia to the point where I can sell it to my advisor/collaborators and 
use Julia to replace a mixture of Python (Core Algo.), Java (backend for web APP), and CPP (Legacy Code).
(a mixture? yes, That's another long story. If you're interested, we can discuss it further later.)

But maintaining that mixture exhausts me and doesn't leave me much time to write new julia code.
So I'm trying to find ~~simple~~ tasks that I can handle with fragmented time and get feedback quickly.
For me, doing some open source contribution is relaxing.
