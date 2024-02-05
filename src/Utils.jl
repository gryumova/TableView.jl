# Utils

import JSON

"""
    getStyleDefs

Function parse style argument on settigns.
Returns a generated JS string that is concatenated with the item variable and a CSS script to style the cell.
"""

function getStyleDefs(item, settings, i)
    if length(keys(settings)) == 0
        return item, ""
    end

    styleClasses = ""
    if "style" in keys(settings)
        style = settings["style"] 
        item = item * "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-$i'], "
        
        styleClasses = styleClasses * ".styled-row-box-$i span {"

        if "background" in keys(style)
            background = style["background"]
            styleClasses = styleClasses * "background-color: $background; "
        end

        if "threshold" in keys(style)
            order = style["threshold"]

            if "colorUp" in keys(style)
                colorUp = style["colorUp"]
            else
                colorUp = "red"
            end

            if "colorDown" in keys(style)
                colorDown = style["colorDown"]
            else
                colorDown = "red"
            end

            item = item * "cellStyle: params => {
                if (params.value > $order) {
                    return {color: '$colorUp'};
                }

                return {color: '$colorDown'};
            }, "
            styleClasses = styleClasses * "colorDown: $colorDown; colorUp: $colorUp; "

        elseif "equals" in keys(style)
            equals = style["equals"]

            if "color" in keys(style)
                color = style["color"]
            else
                color = "red"
            end

            item = item * "cellStyle: params => {
                if (params.value == '$equals') {
                    return {color: '$color'};
                }

                return null;
            }, "

            styleClasses = styleClasses * "color: $color; "
        elseif "color" in keys(style)
            color = style["color"]
            styleClasses = styleClasses * "color: $color; "
        end

        styleClasses = styleClasses * "}; "
    end

    return item, styleClasses
end

"""
    getFilterDefs

Function parse filter argument on settigns. 
Returns a JS string with column filtering settings.
"""

function getFilterDefs(settings)
    if length(keys(settings)) == 0
        return ""
    end

    script = ""

    if "filter" in keys(settings)
        if settings["filter"] == "text"
            script = script * "filter: 'agSetColumnFilter', "
        elseif settings["filter"] == "number"
            script = script * "valueParser: numberParser, filter: 'agNumberColumnFilter', "
        elseif settings["filter"] == "date"
            script = script * "filter: 'agDateColumnFilter', filterParams: {
                comparator: (filterLocalDateAtMidnight, cellValue) => {
                    const dateAsString = cellValue;

                    let cellDate = new Date(Date.parse(dateAsString));
                    var dd = cellDate.getDate();
                    var mm = cellDate.getMonth();
                    var yy = cellDate.getFullYear();

                    cellDate = new Date(yy, mm, dd);

                    if (cellDate <= filterLocalDateAtMidnight) {
                        return -1;
                    }

                    if (cellDate >= filterLocalDateAtMidnight) {
                        return 1;
                    }

                    return 0;
                }
            }"
        end
    end

    return script
end

"""
    getColumnDefs

Function parse column filtering and column cell styling settings.
Returns parsed configuration for columns and css styles.
"""

function getColumnDefs(
            key, 
            columnSettings::Dict, 
            filtersName
        )
    key = JSON.parse(JSON.json(key))
    filtersName = JSON.parse(JSON.json(filtersName))

    styleClasses = ""
    columnDefs = "["

    for i in key
        item = "{ field: '$i', "

        if i in filtersName   
            settings = columnSettings[i]
            item = item * getFilterDefs(settings)
            item, styleClasses = getStyleDefs(item, settings, i)
        end
        item = item * "},\n"

        columnDefs = columnDefs * item
    end
    columnDefs = columnDefs * "]"

    return columnDefs, styleClasses
end

"""
    getFilterColumns

Returns a list of columns depending on the type of filtering.
"""

function getFilterColumns(columnSettings, type::String)
    if length(keys(columnSettings)) == 0
        return JSON.json([])
    end

    columnsName = []

    for i in keys(columnSettings)
        if "filter" in keys(columnSettings[i])
            if columnSettings[i]["filter"] == type
                push!(columnsName, i)
            end
        elseif i == "cols" && type == "text"
            push!(columnsName, i)
        end
    end

    return JSON.json(columnsName)
end
