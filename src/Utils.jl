# Utils

# Function parse style argument on settigns.
# Returns a generated JS string that is concatenated with the item variable and a CSS script to style the cell.
function get_style_defs(item, style_classes, settings, i)
    isempty(settings) && return item, ""

    if haskey(settings, "style")
        style = settings["style"] 
        item = item * "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-$i'], "
        
        style_classes = style_classes * ".styled-row-box-$i span {"

        if haskey(style, "background")
            background = style["background"]
            style_classes = style_classes * "background-color: $background; "
        end

        if haskey(style, "threshold")
            order = style["threshold"]

            colorUp = get(style, "colorUp", "red")
            colorDown = get(style, "colorDown", "red")

            item = item * "cellStyle: params => {
                if (params.value > $order) {
                    return {color: '$colorUp'};
                }

                return {color: '$colorDown'};
            }, "
            style_classes = style_classes * "colorDown: $colorDown; colorUp: $colorUp; "

        elseif haskey(style, "equals")
            equals = style["equals"]

            color = get(style, "color", "red")

            item = item * "cellStyle: params => {
                if (params.value == '$equals') {
                    return {color: '$color'};
                }

                return null;
            }, "

            style_classes = style_classes * "color: $color; "
        elseif haskey(style, "color")
            color = style["color"]
            style_classes = style_classes * "color: $color; "
        end

        style_classes = style_classes * "}; "
    end

    return item, style_classes
end

# Function parse filter argument on settigns. 
# Returns a JS string with column filtering settings.
function get_filter_defs(settings)
    isempty(settings) && return ""

    script = ""

    if haskey(settings, "filter")
        script = if settings["filter"] == "text"
            script * "filter: 'agSetColumnFilter', "
        elseif settings["filter"] == "number"
            script * "valueParser: numberParser, filter: 'agNumberColumnFilter', "
        elseif settings["filter"] == "date"
            script * """filter: 'agDateColumnFilter', filterParams: {
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
            }"""
        end
    end

    return script
end

# Function parse column filtering and column cell styling settings.
# Returns parsed configuration for columns and css styles.
function get_column_defs(key, column_settings::Dict, filters_name)
    key = JSON.parse(JSON.json(key))
    filters_name = JSON.parse(JSON.json(filters_name))

    style_classes = ""
    column_defs = "["

    for i in key
        item = "{ field: '$i', "

        if i in filters_name   
            settings = column_settings[i]
            item = item * get_filter_defs(settings)
            item, style_classes = get_style_defs(item, style_classes, settings, i)
        end
        item = item * "},\n"

        column_defs = column_defs * item
    end
    column_defs = column_defs * "]"

    return column_defs, style_classes
end

# Returns a list of columns depending on the type of filtering.
function get_filter_columns(column_settings, type::String)
    columns_name = String[]

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

# Generating a js script that creates a grid inside your container by calling the create Grid command in the grid package.
# Once the Panel Component is registered with the grid it needs to be included into the SideBar.  
function get_aggrid_scripts(column_settings::Dict, data::Tuple, min_width::String)
    row_data = JSON.json(data)
    columns = keys(data[1])

    column_defs, style_classes = get_column_defs(columns, column_settings, keys(column_settings))
    filter = get_filter_columns(column_settings, "text")
    numeric =  get_filter_columns(column_settings, "number")
    date =  get_filter_columns(column_settings, "date")
    side_bar = isempty(column_settings) ? "" : SIDE_BAR


    script = """
    <style>
        $style_classes
    </style>
    <script type='text/javascript'>
        filter=$filter
        numeric=$numeric
        date=$date
        let gridApi;
        const gridOptions = {
            rowData: $row_data,
            defaultColDef: {
                flex: 1,
                filter: true,
                editable: true,
                enableValue: true,
                enableRowGroup: true,
                enablePivot: true,
                $min_width
            },
            columnDefs: $column_defs,
            $side_bar
        }
        const myGridElement = document.querySelector('#grid-container');
        gridApi = agGrid.createGrid(myGridElement, gridOptions);

        function numberParser(params) {
            const newValue = params.newValue;
            let valueAsNumber;
            if (newValue === null || newValue === undefined || newValue === '') {
              valueAsNumber = null;
            } else {
              valueAsNumber = parseFloat(params.newValue);
            }
            return valueAsNumber;
        }

        function cellRenderer(params) {
            return params.value;
        }
          
    </script>
    """

    return script
end

function get_filter_columns(column_settings, type::String)
    columns_name = String[]

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

function save_HTML(str::String, outFile::String)
    io = open(outFile, "w");
    write(io, str);
    close(io);

    return outFile
end
