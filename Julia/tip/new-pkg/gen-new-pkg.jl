# https://github.com/JuliaCI/PkgTemplates.jl

using PkgTemplates

# Template Plugins
plugins = [
    # Tests(;  # [default]
    #     project=false,
    #     aqua=false,
    #     aqua_kwargs=NamedTuple(),
    #     jet=false,
    # ),
    Formatter(;
        style="sciml"
    ),

    # CI
    # Dependabot(),  # [default]
    GitHubActions(; extra_versions=["lts", "1", "nightly"],),
    Codecov(),
    Documenter{GitHubActions}(),
]

tpl = Template(;
    # User Options
    user="inkydragon",
    authors=["Chengyu HAN <cyhan.dev@outlook.com> and contributors"],
    # Package Options
    dir=".",
    julia=v"1.6",
    # Template Plugins
    plugins=plugins,
    interactive=false,
)

tpl("Libm.jl")
# julia --project=@script .\gen-new-pkg.jl
