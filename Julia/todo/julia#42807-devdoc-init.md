## [1.6] [devdoc/init] Update doc: "Initialization of the Julia runtime"

需要 rebase

> [[1.6] [devdoc/init] Update doc: "Initialization of the Julia runtime" by inkydragon · Pull Request #42807 · JuliaLang/julia](https://github.com/JuliaLang/julia/pull/42807)

*tl; dr*
- cherry pick commit: https://github.com/JuliaLang/julia/commit/523a7c2b3f0e906d32a1647b7e95cfb68e3dfd20 (PR #42304)
- Update function names and source code links along the call chain
- Adjusting the order of functions according to the order of calls
- Update source code snippet
- Update stack dump (cygwin - mingw64 - x86_64)

need check:

- `jl_add_standard_imports`: There appears to be no direct call to this function, nor in the stack traceback.
  I'm not sure if there is an indirect call.
- stack dump on *nix platfrom

Some improvement ideas

- change links point to `v1.6.3` not `master`.
  The link in the current documentation points to the master branch, perhaps for the LTS version we could point the link to the corresponding version of the code.

----

For review purposes, the detailed call chain is listed below, with links to the source code (v1.6.3).

**doc sections**

- `main()`
- `julia_init()`
- `true_main()`
- `Base._start`
- `Core.eval`: include the stack dump table
- `jl_atexit_hook()`

<details>
<summary>All func calls and src links</summary>


## `main()`

Call chain to next section: [`mainCRTStartup`][] -> [`jl_load_repl`][] -> [`repl_entrypoint`][] -> [`julia_init`][]

[`mainCRTStartup`][] @ cli/loader_exe.c:26
- [#L51][cli/loader_exe.c#L51] -> [`jl_load_repl`][]

[`jl_load_repl`][] @ cli/loader_lib.c:183
- [#209][cli/loader_lib.c#L209] -> [`repl_entrypoint`][]

[`repl_entrypoint`][] @ src/jlapi.c:668
- [#L677][jlapi.c#L677] -> [`libsupport_init`][] -> [`ios_init_stdstreams`][]
- [#L684][jlapi.c#L684] -> [`jl_parse_opts`][]  (xref [`Base.exec_options`][])
- [#L696][jlapi.c#L696] -> **[`julia_init`][] (SECTION 2)**
- [#L702][jlapi.c#L702] -> **[`true_main`][] (SECTION 3)**
- [#L703][jlapi.c#L703] -> [`jl_atexit_hook`][]

[cli/loader_exe.c#L51]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_exe.c#L51
[cli/loader_lib.c#L209]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_lib.c#L209
[jlapi.c#L677]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L677
[support/libsupportinit.c#L22]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/support/libsupportinit.c#L22
[jlapi.c#L684]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L684
[jlapi.c#L696]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L696
[jlapi.c#L702]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L702
[jlapi.c#L703]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L703

[`mainCRTStartup`]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_exe.c#L26
[`jl_load_repl`]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_lib.c#L183
[`repl_entrypoint`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L668
[`ios_init_stdstreams`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/support/ios.c#L1049
[`jl_parse_opts`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jloptions.c#L172


## `julia_init()`

Call chain to next section: [`julia_init`][] -> `return` -> [`true_main`][]

[`julia_init`][] @ src/task.c:309 ->
[`_julia_init`][] @ src/init.c:631
- [#L639][src/init.c#L639] -> [`libsupport_init`][]
- [#L648][src/init.c#L648] -> [`restore_signals`][]
- [#L725][src/init.c#L725] -> [`jl_gc_init`][]
- [#L732][src/init.c#L732] -> [`jl_resolve_sysimg_location`][]
- [#L735][src/init.c#L735] -> [`jl_preload_sysimg_so`][]
- [#L740][src/init.c#L740] -> [`jl_restore_system_image`][]
- [#L743][src/init.c#L743] -> [`jl_init_types`][]
- [#L744][src/init.c#L744] -> [`jl_init_codegen`][]
- [#L748][src/init.c#L748] -> [`jl_init_root_task`][]
- [#L751][src/init.c#L751] -> [`jl_init_serializer`][]
- [#L758][src/init.c#L758] -> [`jl_init_intrinsic_functions`][]
- [#L759][src/init.c#L759] -> [`jl_init_primitives`][]
- [#L760][src/init.c#L760] -> [`jl_init_main_module`][]
- [#L761][src/init.c#L761] -> [`jl_load`][] -> [`jl_load_`][] -> [`jl_parse_eval_all`][] -> [`jl_toplevel_eval_flex`][]
- [#L762][src/init.c#L762] -> [`post_boot_hooks`][] -> [`jl_init_box_caches`][]
- [#L783][src/init.c#L783] -> [`jl_install_default_signal_handlers`][]
- [#L794][src/init.c#L794] -> [`jl_module_run_initializer`][]

[src/init.c#L639]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L639
[src/task.c#L309]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/task.c#L309
[src/init.c#L648]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L648
[src/init.c#L725]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L725
[src/init.c#L732]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L732
[src/init.c#L735]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L735
[src/init.c#L740]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L740
[src/init.c#L743]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L743
[src/init.c#L744]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L744
[src/init.c#L748]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L748
[src/init.c#L750]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L750
[src/init.c#L751]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L751
[src/init.c#L758]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L758
[src/init.c#L759]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L759
[src/init.c#L760]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L760
[src/init.c#L761]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L761
[src/init.c#L762]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L762
[src/init.c#L783]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L783
[src/init.c#L794]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L794

[`julia_init`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/task.c#L307
[`_julia_init`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L631
[`libsupport_init`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/support/libsupportinit.c#L18
[`restore_signals`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/signals-win.c#L117
[`jl_gc_init`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gc.c#L3327
[`jl_resolve_sysimg_location`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L545
[`jl_preload_sysimg_so`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/staticdata.c#L1656
[`jl_restore_system_image`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/staticdata.c#L1682
[`jl_init_types`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jltypes.c#L1839
[`jl_init_codegen`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/codegen.cpp#L7882
[`jl_init_root_task`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/task.c#L1231
[`jl_init_flisp`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/ast.c#L316
[`jl_init_serializer`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/dump.c#L2610
[`jl_init_intrinsic_functions`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/builtins.c#L1476
[`jl_init_primitives`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/builtins.c#L1508
[`jl_init_main_module`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L46
[`jl_load`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L1058
[`jl_load_`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L1046
[`jl_parse_eval_all`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L961
[`jl_toplevel_eval_flex`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L616
[`post_boot_hooks`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L809
[`jl_init_box_caches`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/datatype.c#L890
[`jl_install_default_signal_handlers`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/signals-win.c#L426
[`jl_module_run_initializer`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L63


## `true_main()`
Call chain to next section: [`true_main`][] -> [`jl_apply`][] -> [`Base._start`][]

[`true_main`][] @ src/jlapi.c:549
- [#L551][src/jlapi.c#L551] -> [`jl_set_ARGS`][]
- [#L554][src/jlapi.c#L554] -> [`jl_get_global`][]
- [#L560][src/jlapi.c#L560] -> [`jl_apply`][] -> [`Base._start`][]
- [#L572][src/jlapi.c#L572] -> [`exec_program`][]

[src/jlapi.c#L551]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L551
[src/jlapi.c#L554]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L554
[src/jlapi.c#L560]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L560
[src/jlapi.c#L572]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L572

[`true_main`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L549
[`jl_set_ARGS`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L39
[`jl_get_global`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/module.c#L617
[`jl_apply`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1701
[`exec_program`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L497


## `Base._start`

[`Base._start`][] @ base/client.jl:477
- [#L485][base/client.jl#L485] -> [`Base.exec_options`][]
- [#L261][base/client.jl#L261] -> [`Core.eval`][]`(  Main, `[`Base.parse_input_line`][]`(args) )`

[base/client.jl#L485]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L485
[base/client.jl#L261]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L261

[`Base._start`]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L477
[`Base.exec_options`]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L204
[`Base.parse_input_line`]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L173

## `Core.eval`

Call chain to next section: [`Core.eval`][] -> `return to repl_entrypoint` -> [`jl_atexit_hook`][]

[`Core.eval`][] @ base/boot.jl:360

[`Core.eval`]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/boot.jl#L360


<details>
<summary>Full stack dumps</summary>


| Stack frame                   | Source file              | next call (GDB output)                      | `Notes`                                                       |
|:------------------------------|:-------------------------|:--------------------------------------------|:--------------------------------------------------------------|
| `jl_uv_write`                 | [jl_uv.c:463][]          | cli/trampolines/<br/>trampolines_x86_64.S   | called though [`ccall`]                                       |
| `julia_uv_write_async_21396`  | [stream.jl:1017][]       | [stream.jl:1024][]                          | `Base.uv_write_async(s::LibuvStream, p::Ptr{UInt8}, n::UInt)` |
| `julia_uv_write_35687`        | [stream.jl:980][]        | [stream.jl:981][]                           | `Base.uv_write(s::LibuvStream, p::Ptr{UInt8}, n::UInt)`       |
| `julia_unsafe_write_20103`    | [stream.jl:1046][]       | [stream.jl:1064][]                          | `Base.unsafe_write(s::LibuvStream, p::Ptr{UInt8}, n::UInt)`   |
| `write`                       | [strings/io.jl:185][]    | [strings/io.jl:185][]                       | `Base.write(io::IO, s::Union{String,SubString{String}})`      |
| `print`                       | [strings/io.jl:187][]    | [strings/io.jl:187][]                       | `Base.print(io::IO, s::Union{String,SubString{String}})`      |
| `japi1_print_42299`           | [strings/io.jl:42][]     | [strings/io.jl:46][]                        | `Base.print(io::IO, xs...)`                                   |
| `jl_fptr_args`                | [gf.c:2001][]            | cli/trampolines/<br/>trampolines_x86_64.S   |                                                               |
| `_jl_invoke`                  | [gf.c:2210][]            | [gf.c:2218][]                               |                                                               |
| `jl_apply_generic`            | [gf.c:2412][]            | cli/trampolines/<br/>trampolines_x86_64.S   | `print(::Base.TTY, ::String, ::Char)`                         |
| `jl_apply`                    | [julia.h:1701][]         | [julia.h:1703][]                            |                                                               |
| `do_apply`                    | [builtins.c:512][]       | [builtins.c:670][]                          |                                                               |
| `jl_f__apply_iterate`         | [builtins.c:675][]       | cli/trampolines/<br/>trampolines_x86_64.S   | `JL_CALLABLE(jl_f__apply_iterate)`                            |
| `japi1_println_27966`         | [strings/io.jl:73][]     | [strings/io.jl:73][]                        | `Base.println(io::IO, xs...)`                                 |
| `jl_fptr_args`                | [gf.c:2001][]            | cli/trampolines/<br/>trampolines_x86_64.S   |                                                               |
| `_jl_invoke`                  | [gf.c:2210][]            | [gf.c:2218][]                               |                                                               |
| `jl_apply_generic`            | [gf.c:2412][]            | cli/trampolines/<br/>trampolines_x86_64.S   | `println(::Base.TTY, ::String)`                               |
| `japi1_println_27976`         | [coreio.jl:4][]          | [coreio.jl:4][]                             | `Base.println(xs...)`                                         |
| `jl_fptr_args`                | [gf.c:2001][]            | cli/trampolines/<br/>trampolines_x86_64.S   |                                                               |
| `_jl_invoke`                  | [gf.c:2210][]            | [gf.c:2218][]                               |                                                               |
| `jl_apply_generic`            | [gf.c:2412][]            | cli/trampolines/<br/>trampolines_x86_64.S   | `println(::String)`                                           |
| `jl_apply`                    | [julia.h:1701][]         | [julia.h:1703][]                            |                                                               |
| `do_call`                     | [interpreter.c:107][]    | [interpreter.c:115][]                       |                                                               |
| `eval_value`                  | [interpreter.c:159][]    | [interpreter.c:204][]                       |                                                               |
| `eval_stmt_value`             | [interpreter.c:153][]    | [interpreter.c:155][]                       |                                                               |
| `eval_body`                   | [interpreter.c:391][]    | [interpreter.c:558][]                       |                                                               |
| `jl_interpret_toplevel_thunk` | [interpreter.c:655][]    | [interpreter.c:670][]                       |                                                               |
| `jl_toplevel_eval_flex`       | [toplevel.c:825][]       | [toplevel.c:877][]                          |                                                               |
| `jl_toplevel_eval_flex`       | [toplevel.c:616][]       | [toplevel.c:825][]                          |                                                               |
| `jl_toplevel_eval`            | [toplevel.c:884][]       | cli/trampolines/<br/>trampolines_x86_64.S   |                                                               |
| `jl_toplevel_eval_in`         | [toplevel.c:917][]       | cli/trampolines/<br/>trampolines_x86_64.S   |                                                               |
| `Core.eval`                   | [boot.jl:360][]          | [boot.jl:360][]                             | `Base.eval(m::Module, @nospecialize(e))`                      |
| `julia_exec_options_19488`    | [client.jl:204][]        | [client.jl:261][]                           | `Base.exec_options(opts)`                                     |
| `julia__start_46180`          | [client.jl:477][]        | [client.jl:485][]                           | `Base._start()`                                               |
| `jfptr.start_46181`           | 0x2a6b11fa5              |                                             |                                                               |
| `_jl_invoke`                  | [gf.c:2210][]            | [gf.c:2218][]                               |                                                               |
| `jl_apply_generic`            | [gf.c:2412][]            | cli/trampolines/<br/>trampolines_x86_64.S   | `_start()`                                                    |
| `jl_apply`                    | [julia.h:1701][]         | [julia.h:1703][]                            |                                                               |
| `true_main`                   | [jlapi.c:549][]          | [jlapi.c:560][]                             |                                                               |
| `repl_entrypoint`             | [jlapi.c:668][]          | [jlapi.c:702][]                             |                                                               |
| `jl_load_repl`                | [cli/loader_lib.c:183][] | [cli/loader_lib.c:214][]                    |                                                               |
| `mainCRTStartup`              | [cli/loader_exe.c:26][]  | [cli/loader_exe.c:51][]                     |                                                               |


[boot.jl:360]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/boot.jl#L360
[builtins.c:512]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/builtins.c#L512
[builtins.c:670]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/builtins.c#L670
[builtins.c:675]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/builtins.c#L675
[cli/loader_exe.c:26]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_exe.c#L26
[cli/loader_exe.c:51]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_exe.c#L51
[cli/loader_lib.c:183]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_lib.c#L183
[cli/loader_lib.c:214]: https://github.com/JuliaLang/julia/blob/v1.6.3/cli/loader_lib.c#L214

[client.jl:204]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L204
[client.jl:261]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L261
[client.jl:477]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L477
[client.jl:485]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/client.jl#L485
[coreio.jl:4]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/coreio.jl#L4
[coreio.jl:4]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/coreio.jl#L4
[gf.c:2001]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gf.c#L2001
[gf.c:2210]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gf.c#L2210
[gf.c:2218]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gf.c#L2218
[gf.c:2412]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gf.c#L2412
[interpreter.c:107]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L107
[interpreter.c:115]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L115
[interpreter.c:153]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L153
[interpreter.c:155]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L155
[interpreter.c:159]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L159
[interpreter.c:204]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L204
[interpreter.c:391]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L391
[interpreter.c:558]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L558
[interpreter.c:655]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L655
[interpreter.c:670]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/interpreter.c#L670
[jl_uv.c:463]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jl_uv.c#L463
[jlapi.c:549]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L549
[jlapi.c:560]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L560
[jlapi.c:668]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L668
[jlapi.c:702]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/jlapi.c#L702
[julia.h:1701]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1701
[julia.h:1701]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1701
[julia.h:1701]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1701
[julia.h:1703]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1703
[julia.h:1703]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1703
[julia.h:1703]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/julia.h#L1703
[stream.jl:1017]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L1017
[stream.jl:1024]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L1024
[stream.jl:1046]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L1046
[stream.jl:1064]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L1064
[stream.jl:980]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L980
[stream.jl:981]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/stream.jl#L981
[strings/io.jl:185]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L185
[strings/io.jl:185]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L185
[strings/io.jl:187]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L187
[strings/io.jl:187]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L187
[strings/io.jl:42]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L42
[strings/io.jl:46]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L46
[strings/io.jl:73]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L73
[strings/io.jl:73]: https://github.com/JuliaLang/julia/blob/v1.6.3/base/strings/io.jl#L73
[toplevel.c:616]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L616
[toplevel.c:825]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L825
[toplevel.c:825]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L825
[toplevel.c:877]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L877
[toplevel.c:884]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L884
[toplevel.c:917]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/toplevel.c#L917

</details>


## `jl_atexit_hook()`
Call chain to next section: [`jl_atexit_hook`][] -> [`jl_write_compiler_output`][]

[`jl_atexit_hook`][] @ src/init.c:203
- [#L211][src/init.c#L211] -> **[`jl_write_compiler_output`][]  (NEXT SECTION)**
- [#L240][src/init.c#L240] -> [`jl_gc_run_all_finalizers`][]

[src/init.c#L211]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L211
[src/init.c#L240]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L240

[`jl_atexit_hook`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L203
[`jl_gc_run_all_finalizers`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/gc.c#L473


## `jl_write_compiler_output()`

[if `exitcode == 0`][src/init.c#L210] && [`jl_generating_output()`][] then call:
[`jl_write_compiler_output`][] @ src/precompile.c:25
- [#L33][src/precompile.c#L33] -> [`jl_precompile`][] -> [`jl_compile_all_defs`][]
- [#L81][src/precompile.c#L81] -> [`jl_save_system_image`][]

[src/init.c#L210]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/init.c#L210
[src/precompile.c#L33]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L33
[src/precompile.c#L81]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L81
[`jl_generating_output()`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L27

[`jl_write_compiler_output`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L25
[`jl_precompile`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L371
[`jl_compile_all_defs`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/precompile.c#L302
[`jl_save_system_image`]: https://github.com/JuliaLang/julia/blob/v1.6.3/src/staticdata.c#L1485

</details>
