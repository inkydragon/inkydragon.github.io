using PureLibm
using Documenter

DocMeta.setdocmeta!(PureLibm, :DocTestSetup, :(using PureLibm); recursive=true)

pages=[
    "Home" => "index.md",
]

makedocs(;
    modules=[PureLibm],
    authors="Chengyu HAN <cyhan.dev@outlook.com> and contributors",
    sitename="PureLibm.jl",
    format=Documenter.HTML(;
        # canonical="https://inkydragon.github.io/PureLibm.jl",
        canonical="https://cyhan.dev/PureLibm.jl",
        edit_link="main",
        assets=String[],
    ),
    warnonly=true,
    checkdocs=:exports,
    pages=pages,
)

deploydocs(;
    repo="github.com/inkydragon/PureLibm.jl",
    devbranch="main",
    push_preview=true,
)
