using TableView
using Documenter

DocMeta.setdocmeta!(TableView, :DocTestSetup, :(using TableView); recursive = true)

makedocs(;
    modules = [TableView],
    repo = "https://github.com/gryumova/TableView.jl/blob/{commit}{path}#{line}",
    sitename = "TableView.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://github.com/gryumova/TableView.jl",
        edit_link = "master",
        repolink = "https://github.com/gryumova/TableView.jl.git",
    ),
    pages = [
        "Home" => "index.md",
        "Generate HTML " => "showTable.md"
    ],
)

deploydocs(; repo = "github.com/gryumova/TableView.jl", devbranch = "master")