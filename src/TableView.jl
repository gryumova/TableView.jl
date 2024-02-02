module TableView
import JSON

function showTable(
                    table, 
                    columnSettings=(), 
                    resize=true, 
                    outFile::String="./index.html"
                )

    if !resize
        minWidth = "minWidth: 150"
    else
        minWidth = ""
    end

    if length(keys(columnSettings)) != 0
        customPanel = CustomPanel.customPanelScript
    else
        customPanel = ""
    end

    sideBar = Scripts.getAgGridScripts(columnSettings, table, minWidth)
    sideBarFunctions = Scripts.getFunctionsScripts()

    html = "<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charSet='UTF-8'/>
    <meta name='viewport' content='width=device-width, initial-scale=1'/>
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js'></script>
    $(Style.mainStyle)
</head>
<body>
    <div id='grid-container' class='ag-theme-quartz'></div>
    $(Style.agGridStilization)
    $customPanel
    <script src='https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.0.2/dist/ag-grid-enterprise.min.js'></script>
    $sideBar
    $sideBarFunctions
</body>
</html>"

    File.saveHTML(html, outFile)
end

include("scripts.jl")
include("style.jl")
include("customPanel.jl")
include("file.jl")
include("utils.jl")

end