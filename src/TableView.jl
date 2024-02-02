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
                )::String

Function accepts 
    - table for display, 
    - configuration for table filters in the form of a dictionary
    - checkbox for changing column widths 
    - name for the output file.
Returns the path to the generated html file.

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
        return 
    end

    if !resize
        minWidth = "minWidth: 150"
    else
        minWidth = ""
    end

    if length(keys(columnSettings)) != 0
        customPanel = customPanelScript
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
    $(mainStyle)
</head>
<body>
    <div id='grid-container' class='ag-theme-quartz'></div>
    $(agGridStilization)
    $customPanel
    <script src='https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.0.2/dist/ag-grid-enterprise.min.js'></script>
    $sideBar
    $sideBarFunctions
</body>
</html>"

    return saveHTML(html, outFile)
end

end
