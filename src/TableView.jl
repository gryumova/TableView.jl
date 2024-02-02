module TableView

import JSON
include("Scripts.jl")
include("Style.jl")
include("CustomPanel.jl")
include("File.jl")
include("Utils.jl")

function showTable(
                    table; 
                    columnSettings::Dict = Dict(), 
                    resize::Bool = true, 
                    outFile::String = "./index.html"
                )
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