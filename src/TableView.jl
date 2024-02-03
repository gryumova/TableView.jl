module TableView

import JSON
include("Scripts.jl")
include("Style.jl")
include("CustomPanel.jl")
include("File.jl")
include("Utils.jl")


export showTable

"""
    TableView.showTable(
                    table; 
                    columnSettings::Dict = Dict(), 
                    resize::Bool = true, 
                    outFile::String = "./index.html"
                ) -> String
Generate html file with a table based on [AgGrid](https://www.ag-grid.com).

## Fields
- `table`: Table for display.
- `columnSettings::Dict`: Configuration for table filters in the form of a dictionary.
- `resize::Bool`: Checkbox for changing column widths.
- `outFile::String`: Path for the output file.

## Examples

```julia-repl
julia> data = ((a = 0, b = 1),(a = 1, b = 35))
((a = 0, b = 1), (a = 1, b = 35))

julia> settings = ( "a" => ("filter" => "number"))
"a" => ("filter" => "number")

julia> TableView.showTable(data, settings)
"./index.html"
```
"""

function showTable(
                    table; 
                    columnSettings::Dict = Dict(), 
                    resize::Bool = true, 
                    outFile::String = "./index.html"
                )::String
    if length(table) == 0
        return ""
    end

    if !resize
        minWidth = "minWidth: 150"
    else
        minWidth = ""
    end

    if length(keys(columnSettings)) != 0
        customPanel = CUSTOM_PANEL_SCRIPT
    else
        customPanel = ""
    end

    sideBar = getAgGridScripts(columnSettings, table, minWidth)
    sideBarFunctions = getFunctionsScripts()

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
    $customPanel
    <script src='https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.0.2/dist/ag-grid-enterprise.min.js'></script>
    $sideBar
    $sideBarFunctions
</body>
</html>"

    return saveHTML(html, outFile)
end

end
