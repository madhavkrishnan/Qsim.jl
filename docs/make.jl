using Qsim
using Documenter

DocMeta.setdocmeta!(Qsim, :DocTestSetup, :(using Qsim); recursive=true)

makedocs(;
    modules=[Qsim],
    authors="Madhav Vijayan <39261345+madhavkrishnan@users.noreply.github.com> and contributors",
    repo="https://github.com/madhavkrishnan/Qsim.jl/blob/{commit}{path}#{line}",
    sitename="Qsim.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://madhavkrishnan.github.io/Qsim.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/madhavkrishnan/Qsim.jl",
    devbranch="main",
)
