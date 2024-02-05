module TableView

import JSON
include("Scripts.jl")
include("Style.jl")
include("CustomPanel.jl")
include("File.jl")


export show_table

"""
    TableView.show_table(
                    table; 
                    column_settings::Dict = Dict(), 
                    resize::Bool = true, 
                    out_file::String = "./index.html"
                ) -> String
Generate html file with a table based on [AgGrid](https://www.ag-grid.com).

## Fields
- `table`: Table for display.
- `column_settings::Dict`: Configuration for table filters in the form of a dictionary.
- `resize::Bool`: Checkbox for changing column widths.
- `out_file::String`: Path for the output file.

## Examples

```julia-repl
julia> data = ((a = 0, b = 1),(a = 1, b = 35))
((a = 0, b = 1), (a = 1, b = 35))

julia> settings = Dict( "a" => Dict("filter" => "number"))
"a" => ("filter" => "number")

julia> TableView.showTable(data, column_settings=settings)
"./index.html"
```
"""
function show_table(
                    table; 
                    column_settings::Dict = Dict(), 
                    resize::Bool = true, 
                    out_file::String = "./index.html"
                )::String
    if length(table) == 0
        return ""
    end

    if !resize
        min_width = "minWidth: 150"
    else
        min_width = ""
    end

    if length(keys(column_settings)) != 0
        custom_panel = CUSTOM_PANEL_SCRIPT
    else
        custom_panel = ""
    end

    side_bar = get_aggrid_scripts(column_settings, table, min_width)
    side_bar_functions = FUNCTIONS_SCRIPT

    html = "<!DOCTYPE html>
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
</html>"

    return save_HTML(html, out_file)
end

end
