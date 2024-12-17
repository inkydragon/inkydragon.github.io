# https://github.com/JuliaCI/PkgTemplates.jl

using PkgTemplates

# Template Plugins
plugins = [
    Git(;
        # ignore=String[],
        branch="main",
        jl=true,  # add a .jl suffix to the remote URL.
        # gpgsign=false,
    ),
    License(; name="MIT", destination="LICENSE"),
    Tests(;
        project=true,
        # aqua=false,
        # aqua_kwargs=NamedTuple(),
        # jet=false,
    ),

    # CI
    Dependabot(),
    GitHubActions(; extra_versions=["lts", "pre"],),
    Codecov(),
    Documenter{GitHubActions}(),
]

tpl = Template(;
    # User Options
    user="inkydragon",
    authors=["Chengyu HAN <cyhan.dev@outlook.com> and contributors"],
    # Package Options
    dir=".",
    # Template Plugins
    plugins=plugins,
    interactive=false,
)

tpl("PurePkgname.jl")
