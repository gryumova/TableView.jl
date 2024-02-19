# Generating HTML-file

To generate an HTML table, use the `show_table` function. Next, we will show how you can customize the style and formatting of such a table.

```@docs
TableView.show_table
```

## Extended examples



### Filter settings

```@example
using TableView #hide
headers = (:text_col, :number_col, :date_col)
table = (
    NamedTuple{headers}(("a", 1, "2024-01-01T00:00:00")),
    NamedTuple{headers}(("b", 2, "2024-02-01T00:00:00")),
    NamedTuple{headers}(("c", 3, "2024-03-01T00:00:00")),
)

settings = Dict(
    "text_col" => Dict(
        "filter" => "text"
    ),
    "number_col" => Dict(
        "filter" => "number"
    ),
    "date_col" => Dict(
        "filter" => "date"
    )
)

show_table(table, column_settings = settings, resize=true, out_file="./filter_example.html")
```

```@raw html
    <iframe src="filter_example.html" style="height:400px;width:100%;"></iframe>
```

### Formatter settings

```@example
using TableView #hide
headers = (:default_col, :short_col, :decimal_col, :usd_col, :eur_col, :percent_col, :separator_col)
table = (
    NamedTuple{headers}((1.0e6, 1.0e6, 1.0e6, 1.0e6, 1.0e6, 1.0e6, 1.0e6)),
    NamedTuple{headers}((1.0e3, 1.0e3, 1.0e3, 1.0e3, 1.0e3, 1.0e3, 1.0e3)),
    NamedTuple{headers}((1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0)),
    NamedTuple{headers}((1.0e-2, 1.0e-2, 1.0e-2, 1.0e-2, 1.0e-2, 1.0e-2, 1.0e-2)),
)

settings = Dict(
    "short_col" => Dict(
        "formatter" => Dict(
            "short" => true,
        )
    ),
    "decimal_col" => Dict(
        "formatter" => Dict(
            "style" => "decimal",
        )
    ),
    "usd_col" => Dict(
        "formatter" => Dict(
            "style" => "currency",
            "currency" => "USD",
        )
    ),
    "eur_col" => Dict(
        "formatter" => Dict(
            "style" => "currency",
            "currency" => "EUR",
        )
    ),
    "percent_col" => Dict(
        "formatter" => Dict(
            "style" => "percent",
        )
    ),
    "separator_col" => Dict(
        "formatter" => Dict(
            "separator" => true,
        )
    ),
)

show_table(table, column_settings = settings, resize=false, out_file="./formatter_example.html")
```

```@raw html
    <iframe src="formatter_example.html" style="height:250px;width:100%;"></iframe>
```

# Style settings

```@example
using TableView #hide
headers = (:color_col, :equals_col, :threshold_col)
table = (
    NamedTuple{headers}((1, 1, 1)),
    NamedTuple{headers}((2, 2, 2)),
    NamedTuple{headers}((3, 3, 3)),
    NamedTuple{headers}((4, 4, 4)),
    NamedTuple{headers}((5, 5, 5)),
)

settings = Dict(
    "color_col" => Dict(
        "style" => Dict(
            "color" => "cyan",
            "background" => "#34abeb",
            "text-align" => "left",
        )
    ),
    "equals_col" => Dict(
        "style" => Dict(
            "color" => "rgb(250, 100, 100)",
            "equals" => 3,
            "text-align" => "center",
        )
    ),
    "threshold_col" => Dict(
        "style" => Dict(
            "threshold" => 3.0,
            "colorUp" =>  "green",
            "colorDown" => "red",
        )
    ),
)

show_table(table, column_settings = settings, resize=false, out_file="./style_example.html")
```

```@raw html
    <iframe src="style_example.html" style="height:265px;width:100%;"></iframe>
```
