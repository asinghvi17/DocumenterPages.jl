using DocumenterPages
using Documenter

DocMeta.setdocmeta!(DocumenterPages, :DocTestSetup, :(using DocumenterPages); recursive=true)

makedocs(;
    modules=[DocumenterPages],
    authors="Anshul Singhvi <anshulsinghvi@gmail.com> and contributors",
    sitename="DocumenterPages.jl",
    format=Documenter.HTML(;
        canonical="https://asinghvi17.github.io/DocumenterPages.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        PageNode("Examples" => "gallery.md", ["helk" => "helk.md", "park.md"])
    ],
    warnonly=true,
)

deploydocs(;
    repo="github.com/asinghvi17/DocumenterPages.jl",
    devbranch="main",
)
