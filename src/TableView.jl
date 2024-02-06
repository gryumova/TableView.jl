module TableView

export show_table

using  JSON

include("Templates/Templates.jl")
include("Utils.jl")

"""
    show_table(table; kw...)

Generate html file with a `table` based on [AgGrid](https://www.ag-grid.com).

## Keyword arguments
- `column_settings::Dict`: Configuration for table filters in the form of a dictionary.
- `resize::Bool`: Checkbox for changing column widths.
- `out_file::String`: Path for the output file.

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
        <script src='http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js'></script>
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
