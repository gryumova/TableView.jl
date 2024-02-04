# TableView.jl

[![Build Status](https://github.com/gryumova/TableView.jl/actions/workflows/WORKFLOW-FILE/badge.svg?branch=master)](https://github.com/gryumova/TableView.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/gryumova/TableView.jl/graph/badge.svg?token=vsEt7JjjYT)](https://codecov.io/gh/gryumova/TableView.jl)
TableView is a Julia package for generating an html file with a table based on [AgGrid](https://www.ag-grid.com). You can set the configuration for filters and customize the display of column cells.

## Installation
To install EasyCurl, simply use the Julia package manager:
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

settings = (
    a = (
        filter = "number",
        style = (
            color = "red",
            background = "#FFFF79"
        )
    ),
    c = (
        filter = "text",
    ),
    cols = ()
)

# 'table' argument specifies the data to be displayed in the table

# 'settings' argument specifies the columns to filter, the type of filtering, and the styling of the columns. 
# If you want to filter by columns, specify the key 'cols'

# 'resize' argument indicates the ability to change the width of the columns. 
#If resize=false, you cannot reduce the column size to less than 150px.

showTable(table=data, columnSettings=settings, resize=false, outFile="./index.html")
```

## Contributing
Contributions to EasyCurl are welcome! If you encounter a bug, have a feature request, or would like to contribute code, please open an issue or a pull request on GitHub.