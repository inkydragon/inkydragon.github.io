# State of Julia

> An overview of the state of Julia in a year.

## YouTube

- [State of Julia | Valentin Churavy, Jameson Nash, Tim Holy | JuliaCon 2023 - YouTube](https://www.youtube.com/watch?v=jFhL8EVrz7s)
- [State of Julia |  Jeff Bezanson | JuliaCon 2022 - YouTube](https://www.youtube.com/watch?v=N4h46_TCmGc)  
    *The State of Julia (In 2022) with Jeff Bezanson*
- [State of Julia | Stefan Karpinksi, Viral Shah, Jeff Bezanson, & Keno Fischer | JuliaCon 2021 - YouTube](https://www.youtube.com/watch?v=IlFVwabDh6Q)  
    *The State of Julia*
- [State of Julia | Jeff Bezanson & Stefan Karpinski | JuliaCon 2020 - YouTube](https://www.youtube.com/watch?v=xKrIp4ZVOrg)

## Timestamps

> Copy From: [MIT] [JuliaCommunity/YouTubeVideoTimestamps](https://github.com/JuliaCommunity/YouTubeVideoTimestamps)

### 2023

- 00:00 Introduction
- 01:02 Neuroscientist, cognitive scientist and physicist are doing work on Julia compiler
- 01:32 Part 1: Highlights of Julia. Interactivity
- 03:42 Speed
- 04:39 Expressivity
- 05:51 Onboarding newcomers
- 06:39 Can Julia became language of Computer Science 101?
- 07:08 Part 2: New futures. History of Julia releases
- 08:59 Latency and load times
- 14:32 Package extensions
- 17:38 Independence of Stdlibs from base Julia
- 19:00 JuliaSyntax.jl
- 21:00 REPL improvements
- 22:46 Other language highlights
- 23:34 Improved debugging & profiler tools
- 26:38 Stacktrace rendering
- 28:00 Static compilation
- 35:05 GPU ecosystem & accelerated computing
- 37:32 Threading
- 38:07 Garbage collection
- 39:00 Part 3: Ecosystem highlights
- 39:43 Parallel efficiency (ImplicitGlobalGrid.jl)
- 40:19 Black hole imaging (w/ Julia & Enzyme.jl)
- 42:03 Q&A: precompilation (time & profiling)
- 43:03 Q&A: When new LTS with all this cool features will be released?
- 44:03 Q&A: Documentation, testing & macro hygiene
- 46:00 Q&A: Independence of Stdlibs
- 46:50 Q&A: Can Julia debugger can be more user-friendly?
- 49:35 Q&A: Comment on Cormullion's art

### 2022

- 00:00 Introduction of the speaker
- 00:13 We want to look in the last year and into the future
- 00:49 This talk will be a little compiler heavy
- 00:59 We add a lot of features in the year 2021-2022
- 03:16 Compiler internal improvements
- 05:07 LLVM and codegen are now optional in Julia binaries
- 06:31 StaticCompiler.jl approach to the compiling Julia code
- 08:22 Improvements to precompilation of the code
- 10:07 New toys for effect analysis
- 11:42 Effect analysis allows more compiler optimizations
- 12:46 Effect analysis allows faster compilation
- 14:22 Inlining improvements
- 14:39 Features still to come
- 16:03 Threading roadmap
- 16:44 Foreign thread support
- 18:15 Interactive thread pool
- 19:08 A lot of work was done about garbage collector
- 21:26 GPU support in Julia
- 21:48 Profiling enhancements
- 22:37 Inspecting package load time
- 22:53 More package stuff
- 23:11 Improvement of `using`
- 24:37 Overview of package ecosystem
- 25:12 Reflection on Julia releases
- 26:54 Why we use Julia, 10 years later
- 27:38 Q&A: Is Julia 2.0 coming after 1.9?
- 28:41 Q&A: What are the prospects of creating executable files in Julia?
- 29:20 Thank you!

### 2021

- 00:00 Welcome!
- 01:15 Opening of the talk
- 02:21 Threading roadmap
- 02:48 Threading: things done, somewhat done and not done
- 05:27 Compiler roadmap: things done in the past year
- 08:29 Compiler roadmap: things we still need to do
- 09:48 Separating LLVM and codegen components to produce smaller binaries
- 10:24 Removing debug info, metadata and LLVM IR from artifacts
- 11:20 More advanced array optimizations
- 11:41 Removing speed bumps in GC behaviour
- 11:53 Users extensions of Julia compiler
- 13:13 New compiler directions
- 14:00 How do we make it possible to extend the compiler as naturally as extending the library?
- 15:12 Composability of compiler transformations
- 16:53 AbstractInterpreter added in Julia 1.6
- 17:52 Things make possible by AbstractInterpreter
- 18:47 Limitations of AbstractInterpreter
- 19:33 OpaqueClouser
- 24:23 Compiler plugins
- 25:54 State of the AD
- 27:55 Linear Algebra Roadmap
- 28:39 Libblasttrampoline in Julia 1.7
- 29:35 A native Julia BLAS?
- 30:47 The future of sparse matrix capabilities in stdlib
- 32:57 We need more flexibility in our linear algebra stack
- 34:04 Packages Reaching 1.0 since January 2020
- 37:33 What percent of register packages have version Julia 1.0+
- 38:43 Speed of CSV.jl
- 39:33 Speed of DataFrames.jl
- 40:50 Q&A: What is a roadmap for separate compilation?
- 41:13 Q&A: What are the plans on conditional dependencies and how can the community help with it?
- 42:11 Q&A: How much faster can we make Julia interpreter and how hard it will be?

### 2020

- 00:00 Welcome!
- 00:15 Introduction by Stefan Karpinski
- 00:58 Multithreading
- 02:39 Latency: "I think about it every day, I worry about it every day."
- 04:54 Debugger for Julia
- 07:50 Pkg3, Julia package manager
- 10:51 Package ecosystem
- 15:21 JuliaMono, Julia typeface
- 16:16 Where are we now: v1.5
- 16:48 Multithreading in v1.5
- 17:49 Why is Julia sometimes slower than C++?
- 18:11 Heap allocation in Julia
- 19:49 What are watershed moments in the development of language?
- 20:32 Scope of variable
- 24:25 Pkg protocol
- 26:42 PkgServer.jl package and servers infrastructure
- 27:46 Latency still is a problem
- 28:30 Tasks and threads system
- 29:47 Compiler: the next generation
- 31:32 Pkg features coming with Julia v1.6
- 33:11 The king is dead: Julia 1.0 will stop being LTS version
- 33:54 Long live the king: Julia 1.6 will be the new LTS
- 35:37 Amazing progress & bright future
- 36:17 Thank you!
- 37:32 Q&A: Does the work plan for latency include working on tasks and threads?
- 38:14 Q&A: What is the best-case scenario for Julia's compiler latency?

## License

- Code in the project: [MIT License](LICENSE)
- All other content: All rights reserved
