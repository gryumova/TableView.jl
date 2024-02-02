# Utils

import JSON

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
            if "filter" in keys(settings)
                if settings["filter"] == "text"
                    item = item * "filter: 'agSetColumnFilter', "
                elseif settings["filter"] == "number"
                    item = item * "valueParser: numberParser, filter: 'agNumberColumnFilter', "
                elseif settings["filter"] == "date"
                    item = item * "filter: 'agDateColumnFilter', filterParams: {
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
                elseif "color" in keys(style)
                    color = style["color"]
                    styleClasses = styleClasses * "color: $color; "
                end

                styleClasses = styleClasses * "}; "
            end

        end
        item = item * "},\n"

        columnDefs = columnDefs * item
    end
    columnDefs = columnDefs * "]"

    return columnDefs, styleClasses
end

function getFilterColumns(columnSettings::Dict, type::String)
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


