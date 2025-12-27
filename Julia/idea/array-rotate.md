# in-place array rotate

- [WIP: Fast 1-d in-place circshift! by Keno · Pull Request #42676 · JuliaLang/julia](https://github.com/JuliaLang/julia/pull/42676)
- https://github.com/scandum/rotate
- [rotate/README-zh-cn.md at note · one-pr/rotate](https://github.com/one-pr/rotate/blob/note/README-zh-cn.md)


## TODO

- [ ] more test
- [ ] more benchmark


## impl

### not in std
+ python
+ perl

### cpp
[std::rotate - cppreference.com](https://en.cppreference.com/w/cpp/algorithm/rotate)
+ `void rotate( ForwardIt first, ForwardIt n_first, ForwardIt last );`

**MSVC**
[rotate - microsoft/STL](https://github.com/microsoft/STL/blob/472161105d596192194d4715ccad307c6c163b4a/stl/inc/xutility#L5392-L5446)

**LLVM**
[rotate.h - llvm/llvm-project](https://github.com/llvm/llvm-project/blob/llvmorg-13.0.0/libcxx/include/__algorithm/rotate.h)

**GCC**
[stl_algo.h - gcc-mirror/gcc](https://github.com/gcc-mirror/gcc/blob/releases%2Fgcc-11.2.0/libstdc%2B%2B-v3/include/bits/stl_algo.h#L1213-L1416)

### rust
[slice.rotate_left - Rust](https://doc.rust-lang.org/core/primitive.slice.html#method.rotate_left)
+ `rotate_left(&mut self, mid: usize)`
+ `rotate::ptr_rotate(mid, p.add(mid), k)`
+ `ptr_rotate<T>(mut left: usize, mut mid: *mut T, mut right: usize)`

### java
[Collections.rotate - (Java Platform SE 8)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#rotate-java.util.List-int-)
+ `void rotate(List<?> list, int distance)`
+ `void rotate1(List<T> list, int distance)`
+ `void rotate2(List<?> list, int distance)`
+ `void reverse(List<?> list)`

### ruby
[Array.rotate! (Ruby 3.0.3)](https://ruby-doc.org/core-3.0.3/Array.html#method-i-rotate-21)
+ `Array.rotate!`
+ `VALUE rb_ary_rotate_bang(int argc, VALUE *argv, VALUE ary)`
+ `VALUE rb_ary_rotate(VALUE ary, long cnt)`
+ `void ary_rotate_ptr(VALUE *ptr, long len, long cnt)`
+ `void ary_reverse(VALUE *p1, VALUE *p2)`
