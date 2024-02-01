module Utils

export checkTextFilter, checkNumericFilter
import JSON

function checkTextFilter(row) 
    for i in filter
        if i != "cols" && i ∉ keys && !row[i] isa String
            return false
        end
    end

    return true
end

function checkNumericFilter(keys, filter, row) 
    for i in filter
        if i ∉ keys && !row[i] isa Number
            return false
        end
    end

    return true
end

function getColumnDefs(key, columnSettings, filtersName)
    key = JSON.parse(JSON.json(key))
    filtersName = JSON.parse(JSON.json(filtersName))
    columnSettings = JSON.parse(JSON.json(columnSettings))

    styleClasses = ""

    columnDefs = "["

    for i in key
        item = "{ field: '$i', "

        if i in filtersName   
            if haskey(columnSettings[i], "filter")
                if columnSettings[i]["filter"] == "text"
                    item = item * "filter: 'agSetColumnFilter', "
                elseif columnSettings[i]["filter"] == "number"
                    item = item * "valueParser: numberParser, filter: 'agNumberColumnFilter', "
                elseif columnSettings[i]["filter"] == "date"
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

            if haskey(columnSettings[i], "style")
                style = columnSettings[i]["style"] 
                item = item * "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-$i'], "
                
                styleClasses = styleClasses * ".styled-row-box-$i span {"

                if haskey(style, "background") 
                    background = style["background"]
                    styleClasses = styleClasses * "background-color: $background; "
                end

                if haskey(style, "threshold")
                    order = style["threshold"]

                    if (haskey(style, "colorUp"))
                        colorUp = style["colorUp"]
                    else
                        colorUp = "red"
                    end

                    if (haskey(style, "colorDown"))
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

                elseif haskey(style, "equals")
                    equals = style["equals"]

                    if (haskey(style, "color"))
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
                elseif haskey(style, "color") 
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

function getFilterColumns(columnSettings, type)
    columnSettings = JSON.parse(JSON.json(columnSettings))
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

end

