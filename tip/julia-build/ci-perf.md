
https://github.com/jimblandy/perf-event/blob/master/perf-event-open-sys/RELEASE-NOTES.md#400
深入研究了下 rust 的性能测试过程

测试程序通过 perf-event 板条箱调用 perf_event_open API 来获取性能信息。
板条箱绑定到特定的内核版本，例如最新的 v0.4.8 绑定到内核版本 5.19.4-200。

通过 perf_event 获取了以下信息
- cycles
- instructions
- branch_misses
- cache_misses
- cache_references


## Other Lang

- rust: https://perf.rust-lang.org/
- python: https://speed.python.org/
- go: https://perf.golang.org/
- ruby: https://rubybench.org/

### CPU
> NOTE: `:u` means "User Time".

*`perf_event_open`*
- `cycles`
- `cycles:u`
- `instructions:u`
- `branch-misses`
- `cache-misses`
- `wall-time`: 运行时间

- `context-switches`
- `cpu-clock`
- `cpu-clock:u`
- `faults`
- `faults:u`
- `max-rss`
- `task-clock`
- `task-clock:u`

### Codegen unit size
*Rustc* guesses the codegen unit size by MIR count.
- `size:codegen_unit_size_estimate`

The codegen unit size by llvm ir count, the real size of a cgu.
- `size:cgu_instructions`
- `size:dep_graph`
- `size:linked_artifact`
- `size:object_file`
- `size:query_cache`
- `size:work_product_index`
- `size:crate_metadata`
- `size:dwo_file`
- `size:assembly_file`
- `size:llvm_bitcode`
- `size:llvm_ir`

### doc
- `size:doc_bytes`: Total bytes of a generated documentation directory
- `size:doc_files_count`: Number of files inside a generated documentation directory.
