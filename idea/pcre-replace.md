# 替换 PCRE 为 C++ regex

Base: path, methodshow, version, binaryplatforms, show, env, irrationals, even libc.

v1.10.5

## regex.jl

```jl
# from mtest
Regex
r""
compile

match
eachmatch

    findfirst
    findnext
    findall

    ?count
replace
occursin

    startswith
    endswith
    chopprefix
    chopsuffix

    Base.PCRE
```

### match

```jl
D:\jl\julia\base\binaryplatforms.jl
    triplet_regex = Regex(string(
        "^",
        # First, the core triplet; arch/os/libc/call_abi
        c(arch_mapping),
        c(os_mapping),
        c(libc_mapping),
        c(call_abi_mapping),
        # Next, optional things, like libgfortran/libstdcxx/cxxstring abi
        c(libgfortran_version_mapping),
        c(cxxstring_abi_mapping),
        c(libstdcxx_version_mapping),
        # Finally, the catch-all for extended tags
        "(?<tags>(?:-[^-]+\\+[^-]+)*)?",
        "\$",
    ))

    if os == "windows"
        # On Windows, libraries look like `libnettle-6.dll`
        dlregex = r"^(.*?)(?:-((?:[\.\d]+)*))?\.dll$"sa
    elseif os == "macos"
        # On OSX, libraries look like `libnettle.6.3.dylib`
        dlregex = r"^(.*?)((?:\.[\d]+)*)\.dylib$"sa
    else
        # On Linux and FreeBSD, libraries look like `libnettle.so.6.3.0`
        dlregex = r"^(.*?)\.so((?:\.[\d]+)*)$"sa
    end
  693,9:     m = match(triplet_regex, triplet)
  736,22:             m_osvn = match(pattern, m[os_name])
  810,9:     m = match(dlregex, basename(path))

D:\jl\julia\base\irrationals.jl
  247,9:     m = match(r"^(.*?)(=.*)$", sprint(show, x, context=io, sizehint=0))
  
D:\jl\julia\base\methodshow.jl
  396,26:                     u = (match(LibGit2.GITHUB_REGEX,u)::AbstractMatch).captures[1]

D:\jl\julia\base\path.jl
if Sys.isunix()
    const path_separator    = "/"
    const path_separator_re = r"/+"sa
    const path_directory_re = r"(?:^|/)\.{0,2}$"sa
    const path_dir_splitter = r"^(.*?)(/+)([^/]*)$"sa
    const path_ext_splitter = r"^((?:.*/)?(?:\.|[^/\.])[^/]*?)(\.[^/\.]*|)$"sa

    splitdrive(path::String) = ("",path)
elseif Sys.iswindows()
    const path_separator    = "\\"
    const path_separator_re = r"[/\\]+"sa
    const path_absolute_re  = r"^(?:[A-Za-z]+:)?[/\\]"sa
    const path_directory_re = r"(?:^|[/\\])\.{0,2}$"sa
    const path_dir_splitter = r"^(.*?)([/\\]+)([^/\\]*)$"sa
    const path_ext_splitter = r"^((?:.*[/\\])?(?:\.|[^/\\\.])[^/\\]*?)(\.[^/\\\.]*|)$"sa

    function splitdrive(path::String)
        m = match(r"^([^\\]+:|\\\\[^\\]+\\[^\\]+|\\\\\?\\UNC\\[^\\]+\\[^\\]+|\\\\\?\\[^\\]+:|)(.*)$"sa, path)::AbstractMatch
        String(something(m.captures[1])), String(something(m.captures[2]))
    end

  38,13:         m = match(r"^([^\\]+:|\\\\[^\\]+\\[^\\]+|\\\\\?\\UNC\\[^\\]+\\[^\\]+|\\\\\?\\[^\\]+:|)(.*)$"sa, path)::AbstractMatch
  138,9:     m = match(path_dir_splitter,b)
  209,9:     m = match(path_ext_splitter, b)
  
D:\jl\julia\base\shell.jl
for (r,e) = (r"^[A-Za-z0-9/\._-]+\z"sa => "",
                         r"^[^']*\z"sa => "'", r"^[^\$\`\"]*\z"sa => "\"",
                         r"^[^']+"sa  => "'", r"^[^\$\`\"]+"sa  => "\"")
  304,26:                 if ((m = match(r, SubString(arg, i))) !== nothing)

D:\jl\julia\base\show.jl
  3027,9:     m = match(r"^(.*?)((?:[\.eEfF].*)?)$", s)
  3033,9:     m = match(r"^(.*[^ef][\+\-])(.*)$", s)
  3039,9:     m = match(r"^(.*?/)(/.*)$", s)
  
D:\jl\julia\base\version.jl
const VERSION_REGEX = r"^
    v?                                      # prefix        (optional)
    (\d+)                                   # major         (required)
    (?:\.(\d+))?                            # minor         (optional)
    (?:\.(\d+))?                            # patch         (optional)
    (?:(-)|                                 # pre-release   (optional)
    ([a-z][0-9a-z-]*(?:\.[0-9a-z-]+)*|-(?:[0-9a-z-]+\.)*[0-9a-z-]+)?
    (?:(\+)|
    (?:\+((?:[0-9a-z-]+\.)*[0-9a-z-]+))?    # build         (optional)
    ))
$"ix
  125,9:     m = match(VERSION_REGEX, String(v)::String)
```


### eachmatch
```jl
D:\jl\julia\base\show.jl
const ansi_regex = r"(?s)(?:\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~]))|."
  69,48: ANSIIterator(s::AbstractString) = ANSIIterator(eachmatch(ansi_regex, s))
```

### replace

```jl
D:\jl\julia\base\methodshow.jl
  10,19:     return Symbol(replace(String(sym), r"^(.*)#(.*#)?\d+$"sa => s"\1"))

D:\jl\julia\base\compiler\ssair\show.jl
  806,27: _strip_color(s::String) = replace(s, r"\e\[\d+m"a => "")
```

### occursin

```jl
D:\jl\julia\base\binaryplatforms.jl
nonos = raw"""+- /<>:"'\|?*"""
  134,12:     if any(occursin(nono, tag) for nono in nonos)
  140,12:     if any(occursin(nono, value) for nono in nonos)
  
D:\jl\julia\base\libc.jl
  231,13:         if !occursin(r"([^%]|^)%(a|A|j|w|Ow)"a, fmt)
  
D:\jl\julia\base\methodshow.jl
  379,18:     line <= 0 || occursin(r"In\[[0-9]+\]"a, file) && return ""

D:\jl\julia\base\path.jl
const path_absolute_re  = r"^(?:[A-Za-z]+:)?[/\\]"sa
  82,39:     isabspath(path::AbstractString) = occursin(path_absolute_re, path)
  117,27: isdirpath(path::String) = occursin(path_directory_re, splitdrive(path)[2])

D:\jl\julia\base\shell.jl
  400,5:     occursin(r"[\r\n\0]"sa, s) &&
  455,28:         if isempty(arg) || occursin(r"[ \t\"]"sa, arg)

D:\jl\julia\base\version.jl
  56,21:                 if !occursin(r"^(?:|[0-9a-z-]*[a-z-][0-9a-z-]*)$"i, ident) ||
  66,21:                 if !occursin(r"^(?:|[0-9a-z-]*[a-z-][0-9a-z-]*)$"i, ident) ||
  119,36:     pidents = Union{UInt64,String}[occursin(r"^\d+$", ident) ? parse(UInt64, ident) : String(ident) for ident in idents]

```
