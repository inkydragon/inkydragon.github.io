# 运行 julia 程序的各种方式


Yeah, this can be a little confusing. There are quite a few different ways of running Julia and more are coming.

* There’s the `julia` REPL. It’s already a native compiler! As you type in Julia code, it’ll get compiled to your architecture on the fly! Of course not a very great distribution mechanism.
* There’s `julia script.jl`. Julia will parse the `script` and similarly generate native code on the fly. But again, every time you run this, it’ll *re-do* the compilation work.
* There’s `julia --project=@script script.jl` that’ll use the packages defined in the `Project.toml` that appears alongside the script. These packages will precompile the first time you instantiate them — down to native code! And then all those packages — particularly if they use [PrecompileTools.jl](https://juliaregistries.github.io/General/packages/redirect_to_repo/PrecompileTools) — will preemptively cache native code for you, so Julia only needs to on-demand compile the stuff that appears in `script.jl` or is missing from the package precompiles. But of course distributing this is still hard — it’s not “just” an `.exe` (or equivalent).
* There’s [PackageCompiler.jl](https://juliaregistries.github.io/General/packages/redirect_to_repo/PackageCompiler), which can create a native executable given a particular set of packages and workflow. This can make distributing much easier! But… it gathers up *everything* you might *possibly* call. It’s *slow* and *big*. The outputs in the hundreds of MB or even GB range.
* Then, finally, there’s `juliac` and in particular `juliac --experimental --trim`. These are still experimental, but the latter will trim out everything you *don’t* call, leading to much more reasonable executable sizes. The big limitation on getting a small binary is with type stability, not allocations — if things aren’t type stable, Julia won’t be able to predict what methods you’ll need to compile. The best place to see info here is in live talks; see Jeff at [JuliaCon 2024](https://www.youtube.com/watch?v=R0DEG-ddBZA&pp=ygUGanVsaWFj0gcJCY0JAYcqIYzv) and [PyData 2024](https://www.youtube.com/watch?v=LluyXFj9YDI).


https://discourse.julialang.org/t/question-about-the-future-of-juliac/129228/4

There is also StaticCompiler.jl which has the heap allocations limitations (and others).
