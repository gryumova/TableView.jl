include("TableView.jl")
using .TableView

data = (
    (a = 0, b = 1, c = 6),
    (a = 1, b = 35, c = 7),
    (a = 2, b = 134, c = 6),
    (a = 3, b = 868, c = 7),
    (a = 4, b = 34, c = 0),
    
)


columnsDict = Dict(
    "a" => Dict(
        "filter" => "number",
        "style" => (
            "color" => "red",
            "background" => "#FFFF79"
        )
    ),
    "b" => Dict(
        "filter" => "number",
    ),
    "c" => Dict(
        "filter" => "number",
    ),
    "cols" => Dict()
)

haskey(columnsDict["a"], "filter")

TableView.showTable(data, columnsDict, false, "./index.html")
