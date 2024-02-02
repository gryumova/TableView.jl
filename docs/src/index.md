# TableView.jl
TableView is a Julia package for generating an html file with a table based on [AgGrid](https://www.ag-grid.com). You can set the configuration for filters and customize the display of column cells.

## Usage
Simple example:
```julia
using TableView


data = (
    (a = 0, b = 1, c = 6),
    (a = 1, b = 35, c = 7),
    (a = 2, b = 134, c = 6),
    (a = 3, b = 868, c = 7),
    (a = 4, b = 34, c = 0),
)

# 'table' argument can be 'number', 'text', 'date'
# 'style' argument can include 'color' and 'background'. You can change text color depending of a value of cell.
#       style = (
#           colorUp = "red",
#           colorDown = "green",
#           threshold = 10,
#       )
#       or
#       style = (
#           color = "red",
#           equals = 10,
#       )

settings = Dict(
    a => Dict(
        filter => "number",
        style => (
            color => "red",
            background => "#FFFF79"
        )
    ),
    c => Dict(
        filter = "text",
    ),
    cols => Dict()
)

# 'table' argument specifies the data to be displayed in the table

# 'settings' argument specifies the columns to filter, the type of filtering, and the styling of the columns. 
# If you want to filter by columns, specify the key 'cols'

# 'resize' argument indicates the ability to change the width of the columns. 
#If resize=false, you cannot reduce the column size to less than 150px.

showTable(table=data, columnSettings=settings, resize=false, outFile="./index.html")
```