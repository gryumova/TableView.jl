include("TableView.jl")
using .TableView

data = (
    (a = 0, b = 1, c = 6),
    (a = 1, b = 35, c = 7),
    (a = 2, b = 134, c = 6),
    (a = 3, b = 868, c = 7),
    (a = 4, b = 34, c = 0),
    
)

columnsData = (
    a = (
        filter = "number",
        style = (
            color = "red",
            background = "#FFFF79"
        )
    ),
    b = (
        filter = "number",
    ),
    c = (
        filter = "number",
    ),
    cols = ()
)

TableView.showTable(data, columnsData, false, "./index.html")
