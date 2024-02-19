module TableView

export show_table

using  JSON

include("Templates/Templates.jl")
include("Utils.jl")

"""
    show_table(table::NTuple; kw...)

Generate html file based on [AgGrid](https://www.ag-grid.com).
The `table` passed to the function must be a `NTuple` whose elements are `NamedTuple` objects.
Thus, each element of the `table` will represent its row.
    
## Keyword arguments
- `column_settings::Dict = Dict()`: Configuration for table filters. There you can specify following settings:
    - Column names as a string key and their parameters using another dictionary, which may contain the following pairs:
    - `"filter" => ...`: This parameter specifies how the current column should be filtered.\n
        `"text"`: Filter by text using list of values.\n
        `"number"`: Filter by number using range of values.\n
        `"date"`: Filter by date using range of values.\n
    - `"formatter" => Dict(...)`: Here you can specify the desired formatting style of the columns.
        - `"short" => true`: Enables short form of the large numbers, like 4K (4,000) or 23M (23,000,000). By deafult is `false`.
        - `"style" => ...`: Pre-built styles for displaying numeric values.\n
            `"decimal"`: Default, plain number formatting.\n
            `"currency"`: Displays numeric values with corresponding currency symbol. Default used "USD" currency symbol, but you can change it by specifying a different currency `"currency" => ...` like `"EUR"`, `"CNY"`, etc. See the [Current currency & funds code list](https://en.wikipedia.org/wiki/ISO_4217#List_of_ISO_4217_currency_codes).\n
            `"percent"`: Turn numeric values from interval [0.0, 1.0] to 0-100% percents.\n
            `"minimumFractionDigits" => ...`: Specifies the minimum number of decimal places to display. Default is `0`.\n
            `"maximumFractionDigits" => ...`: Specifies the maximum number of decimal places to display. Default is `3`.\n
        - `"separator" => true`: Enables grouping separators, such as thousands separators or thousand/lakh/crore separators.\n
    - `"style" => Dict(...)`: Here, you can specify columns style
        - `"text-align" => ...`: Specifies the horizontal alignment of text in cell. Can be `"left"`, `"right"` or `"center"`.
        - `"color" => ...`: Change color of the text in cells. May be specifying by names of color (`"red"`, `"blue"`, etc.), hex codes (`"#FFFFEE"`, `"#3d85c6"`, etc.) or RGB values (`"rgb(230, 230, 250)"`, `"rgb(65, 10, 178)"`, etc.).
        - `"background" => ...`: Setting up the text background color.
        - `"equals" => ...`: Enables highlighting of the specified numeric value by `color`.
        - `"threshold" => ...`: Enables a separating border for highlight values that are greater or less than it. Colors of these values must be specified by `"colorUp"` or/and `"ColorDown"` parameters.
        - `"colorUp" => ...`: Color of the text that is less than `"threshold"` value.
        - `"colorDown" => ...`: Color of the text that is greater than `"threshold"` value.
    - Here, you can also specify a pair `"cols" => true` to enable the column filter on the right sidebar.
- `resize::Bool = true`: Determines whether the column width can be changed by less than 150px.
- `out_file::String = "./index.html"`: Output file name.

## Examples

```julia-repl
julia> data = ((a = 0, b = 1),(a = 1, b = 35));

julia> settings = Dict("a" => Dict("filter" => "number"));

julia> TableView.showTable(data, column_settings=settings)
"./index.html"
```
"""
function show_table(table; 
    column_settings::Dict = Dict(), 
    resize::Bool = true, 
    out_file::String = "./index.html",
)::String
    isempty(table) && return ""

    min_width = resize ? "" : "minWidth: 150"
    custom_panel = isempty(column_settings) ? "" : CUSTOM_PANEL_SCRIPT
    side_bar = get_aggrid_scripts(column_settings, table, min_width)
    side_bar_functions = FUNCTIONS_SCRIPT

    html = """
    <!DOCTYPE html>
    <html lang='en'>
    <head>
        <meta charSet='UTF-8'/>
        <meta name='viewport' content='width=device-width, initial-scale=1'/>
        <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
        <script src='https://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js'></script>
        $MAIN_STYLE
    </head>
    <body>
        <div id='grid-container' class='ag-theme-quartz'></div>
        $AG_GRID_STILIZATION
        $custom_panel
        <script src='https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.0.2/dist/ag-grid-enterprise.min.js'></script>
        $side_bar
        $side_bar_functions
    </body>
    </html>
    """

    return save_HTML(html, out_file)
end

end
