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

To generate an html file you need to use the `show_table` function:
```julia
show_table(table::Tuple; kw...)
```

The `table` passed to the function must be a `Tuple` whose elements are identical `NamedTuple` objects.
Thus, each element of the table will represent its rows.
Row cells will be specified in key-value pairs of each `NamedTuple`.

## Keyword arguments
- `column_settings::Dict`: Configuration for table filters. There you can specify following settings:
  - list the names of the columns and their parameters by another dict.
  - each name has a dictionary with an indication of the filter type:

    `"filter" => type`
    - `"filter" => "text"`: checkboxes listing the values that will be displayed;
    - `"filter" => "number"`: the range of numeric values that will be displayed;
    - `"filter" => "date"`: the range of date values that will be displayed;
  - you can also specify the following styles for columns in dict:
    
    - `"color" => String`: sets the text color (color names, hex codes, rgb values);
      `"background" => String`: sets the color of the framing block (color names, hex codes, rgb values);

        `"style" => Dict( "color" => "red, "backgound" => "#FFFFEE")`
    - `"equals"`: define the value you want to highlight with `color`;

      `"color" => "red"`: sets the text color (color names, hex codes, rgb values);

        `"style" => Dict( "color" => "red", "backgound" => "#FFFFEE", "equals" => 23)`
    - `"threshold"`: to dynamically determine the color of the text, set this value;
    
      `"colorUp" => String`: text color, if the cell value is lower than the set value (color names, hexadecimal codes, rgb values);

      `"colorDown" => String`: text color, if the cell value is higher than the set value (color names, hexadecimal codes, rgb values).

        `"style" => Dict( "threshold" => 50, "colorUp" => "#3d85c6", "colorDown" => "#a64d79", "backgound" => "rgb(230, 230, 250)")`

- `resize::Bool`: Determines whether the column width can be changed by less than 150px.
- `out_file::String`: Output file name.


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

show_table(data, column_settings=settings, resize=false, out_file="./index.html")
```

## Contributing
Contributions to TableView are welcome! If you encounter a bug, have a feature request, or would like to contribute code, please open an issue or a pull request on GitHub.