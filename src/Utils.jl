# Utils

import JSON

"""
    get_style_defs

Function parse style argument on settigns.
Returns a generated JS string that is concatenated with the item variable and a CSS script to style the cell.
"""

function get_style_defs(item, settings, i)
    if length(keys(settings)) == 0
        return item, ""
    end

    style_classes = ""
    if "style" in keys(settings)
        style = settings["style"] 
        item = item * "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-$i'], "
        
        style_classes = style_classes * ".styled-row-box-$i span {"

        if "background" in keys(style)
            background = style["background"]
            style_classes = style_classes * "background-color: $background; "
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
            style_classes = style_classes * "colorDown: $colorDown; colorUp: $colorUp; "

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

            style_classes = style_classes * "color: $color; "
        elseif "color" in keys(style)
            color = style["color"]
            style_classes = style_classes * "color: $color; "
        end

        style_classes = style_classes * "}; "
    end

    return item, style_classes
end

"""
    get_filter_defs

Function parse filter argument on settigns. 
Returns a JS string with column filtering settings.
"""

function get_filter_defs(settings)
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

function get_column_defs(
            key, 
            column_settings::Dict, 
            filters_name
        )
    key = JSON.parse(JSON.json(key))
    filters_name = JSON.parse(JSON.json(filters_name))

    style_classes = ""
    column_defs = "["

    for i in key
        item = "{ field: '$i', "

        if i in filters_name   
            settings = column_settings[i]
            item = item * get_filter_defs(settings)
            item, style_classes = get_style_defs(item, settings, i)
        end
        item = item * "},\n"

        column_defs = column_defs * item
    end
    column_defs = column_defs * "]"

    return column_defs, style_classes
end

"""
    get_filter_columns  

Returns a list of columns depending on the type of filtering.
"""

function get_filter_columns(column_settings, type::String)
    if length(keys(column_settings)) == 0
        return JSON.json([])
    end

    columns_name = []

    for i in keys(column_settings)
        if "filter" in keys(column_settings[i])
            if column_settings[i]["filter"] == type
                push!(columns_name, i)
            end
        elseif i == "cols" && type == "text"
            push!(columns_name, i)
        end
    end

    return JSON.json(columns_name)
end
