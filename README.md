# TableView.jl

[![CI](https://github.com/gryumova/TableView.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/gryumova/TableView.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/gryumova/TableView.jl/graph/badge.svg?token=vsEt7JjjYT)](https://codecov.io/gh/gryumova/TableView.jl)

TableView is a Julia package for generating an html file with a table based on [AgGrid](https://www.ag-grid.com). You can set the configuration for filters and customize the display of column cells.

## Installation
To install TableView, simply use the Julia package manager:
```
] add TableView
```

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
#       style => Dict(
#           colorUp => "red",
#           colorDown => "green",
#           threshold => 10,
#       )
#       or
#       style => Dict(
#           color => "red",
#           equals => 10,
#       )

settings = Dict(
    "a" => Dict(
        "filter" => "number",
        "style" => Dict(
            "color" => "red",
            "background" => "#FFFF79"
        )
    ),
    "c" => Dict(
        "filter" => "text",
    ),
    "cols" => Dict()
)

# first argument specifies the data to be displayed in the table

# 'column_settings' argument specifies the columns to filter, the type of filtering, and the styling of the columns. 
# If you want to filter by columns, specify the key 'cols'

# 'resize' argument indicates the ability to change the width of the columns. 
#If resize=false, you cannot reduce the column size to less than 150px.

show_table(data, column_settings=settings, resize=false, out_file="./index.html")
```

## Contributing
Contributions to TableView are welcome! If you encounter a bug, have a feature request, or would like to contribute code, please open an issue or a pull request on GitHub.