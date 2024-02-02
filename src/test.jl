include("TableView.jl")
using .TableView

data = (
        (a = 0, b = 1, c = 6, date = "2022.05.03"),
        (a = 1, b = 35, c = 7, date = "2022.06.02"),
        (a = 2, b = 134, c = 6, date = "2022.03.10"),
        (a = 3, b = 868, c = 7, date = "2022.02.08"),
        (a = 4, b = 34, c = 0, date = "2022.08.01"),
    ) 
columnsDictDate = Dict(
    "a" => Dict(
        "filter" => "date",
)) 
TableView.showTable(data, columnSettings=columnsDictDate, resize=true)


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

nttable = [
    (a = Inf, b = NaN, c = missing),
    (a = 3.0, b = 12, c = nothing)
]

TableView.showTable(nttable)

array = rand(10, 10)
TableView.showTable(array)

TableView.showTable(data, columnSettings=columnsDict, resize=false, outFile="./index.html")
