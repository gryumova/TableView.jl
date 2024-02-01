import JSON
include("scripts.jl")
include("style.jl")
include("customPanel.jl")
include("file.jl")
include("utils.jl")


function showTable(
                    table, 
                    columnSettings=(), 
                    resize=true, 
                    outFile::String="./result/index.html"
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


bigData = File.readData("./v2/data.txt")

columns = (
            location = (
                filter = "text",
                style = (
                    color = "rgb(226, 73, 73)",
                    equals = "SLC-4E, Vandenberg SFB, California, USA"
                )
            ),
            cols = (),
            company = (
                filter = "text",
            ),
            price = (
                filter = "number",
                style= (
                    colorUp = "rgb(134, 208, 134)",
                    colorDown = "rgb(226, 73, 73)",
                    equals = 12000000
                )
            ),
            date = (
                filter = "date",
            )
        )

data = (
    (a = 0, b = 1, c = 6),
    (a = 1, b = 35, c = 7),
    (a = 2, b = 134, c = 6),
    (a = 3, b = 868, c = 7),
    (a = 4, b = 34, c = 0),
    
)

columnsData = (
    a = (
        filter = "number",
        style = (
            color = "red",
            background = "#FFFF79"
        )
    ),
    b = (
        filter = "number",
    ),
    c = (
        filter = "number",
    ),
    cols = ()
)

showTable(data, columnsData, false)

showTable(JSON.parse(bigData), columns, false)
