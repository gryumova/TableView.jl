import JSON
import Base: getindex

function getColumnDefs(keys, filter, numeric)
    columnDefs = "["
    for i in keys
        if i in numeric
            columnDefs = columnDefs * "{field: '$i', filter: 'agNumberColumnFilter'}, "
        elseif i in filter
            columnDefs = columnDefs * "{field: '$i', filter: 'agSetColumnFilter'}, "
        else
            columnDefs = columnDefs * "{field: '$i'},"
        end
    end
    columnDefs = columnDefs * "]"
   
    columnDefs
end

function getKeys(table)
    keys(table[1])
end

function checkTextFilter(keys, filter, row) 
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

function saveHTML(str, outFile)
    io = open(outFile, "w");
    write(io, str);
    close(io);

    outFile
end

function readData(fileName)
    io = open(fileName, "r")
    s = read(io, String)
    close(io)

    return s
end

function showTable(table, filter=[], numericFilter=[], resize=true, outFile="./result/index.html")
    rowData = JSON.json(table)
    keys = getKeys(table)

    if !checkNumericFilter(keys, numericFilter, table[1]) || !checkTextFilter(keys, filter, table[1])
        return ErrorException("Check filters name!")
    end

    columnDefs = getColumnDefs(keys, filter, numericFilter)

    if !resize
        minWidth = "minWidth: 150"
    else
        minWidth = ""
    end
    
    style = readData("./tableview/style.txt")
    
    if size(filter)!= 0 || size(numericFilter) != 0
        customPanel = readData("./tableview/customPanel.txt")
    else
        customPanel = ""
    end

    filter = JSON.json(filter)
    numeric = JSON.json(numericFilter)

    html = "<!DOCTYPE html>
<html lang='en'>
    <head>
        <meta charSet='UTF-8'/>
        <meta name='viewport' content='width=device-width, initial-scale=1'/>
        <script src='http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js'></script>
        <style>
            $style
        </style>
    </head>
    <body>
        <div id='grid-container' class='ag-theme-quartz'></div>
        <style>
            .ag-theme-quartz,
            .ag-theme-quartz-dark {
                --ag-foreground-color: #343434;
                --ag-background-color: #ffffff;

                --ag-header-foreground-color: #808080;
                --ag-header-background-color: #ffffff;   
                
                --ag-data-color: #636363;
                
                --ag-row-border-width: 1px;
                --ag-row-border-color: #e0e0e0;
            
                --ag-header-column-resize-handle-display: block;
                --ag-header-column-resize-handle-height: 100%;
                --ag-header-column-resize-handle-width: 1px;
                --ag-header-column-resize-handle-color: #dddddd;

                --ag-header-column-separator-display: block;
                --ag-header-column-separator-height: 100%;
                --ag-header-column-separator-width: 1px;
                --ag-header-column-separator-color: #dddddd;
            }
            .ag-theme-quartz .ag-header-cell-label {
                font-weight: 600;
            }
            .ag-header-cell-text {
                text-align: center;
                margin-left: auto;
                margin-right: auto;
            }
            .ag-theme-quartz .ag-cell-value {
                font-weight: 600;
            }
            #ag-32 {
                border: none;
            }
            .ag-root-wrapper.ag-layout-normal.ag-ltr {
                border-radius: 0;
            }
            .ag-header-cell-menu-button {
                display: none;
            }
        </style>
        <script>
            $customPanel
        </script>
        <script src='https://cdn.jsdelivr.net/npm/ag-grid-enterprise@31.0.2/dist/ag-grid-enterprise.min.js'>
		</script>
        <script type='text/javascript'>
            filter=$filter
            numeric=$numeric
            let gridApi;
            const gridOptions = {
                rowData: $rowData,
                defaultColDef: {
                    flex: 1,
                    filter: true,
                    editable: true,
                    enableValue: true,
                    enableRowGroup: true,
                    enablePivot: true,
                    $minWidth
                },
                columnDefs: $columnDefs,
                sideBar: {
                    toolPanels: [
                        {
                            id: 'customStats',
                            labelDefault: 'Custom Stats',
                            labelKey: 'customStats',
                            iconKey: 'custom-stats',
                            toolPanel: CustomFilterPunel,
                            toolPanelParams: {
                            title: 'Custom Stats',
                            },
                        },
                    ],
                    position: 'right',
                    defaultToolPanel: 'customStats',
                },
                onCellValueChanged: (params) => {
                    params.api.refreshClientSideRowModel();
                }
            }
            const myGridElement = document.querySelector('#grid-container');
            gridApi = agGrid.createGrid(myGridElement, gridOptions);

            
            function clickHandleCols(event) {
                let block = document.getElementById('ag-cols')
                let check = \$(block).find('input[type=checkbox]:checked');
                
                let cols = check && check.map(element => {
                    if (check[element].value !== 'All')
                        return  check[element].value;
                })

                cols = Array.from(cols);

                const columnDefs = gridApi.getColumnDefs()
                columnDefs.forEach((colDef) => {
                    if (cols.includes(colDef.field)) {
                        colDef.hide = false;
                    } else {
                        colDef.hide = true;
                    }
                });

                gridApi.setGridOption('columnDefs', columnDefs);

                event.preventDefault();
            }

            function clickHandleFilter(event, id) {
                let block = document.getElementById(id)
                let check = \$(block).find('input[type=checkbox]:checked');

                let list = [];
                check.each((index, node) => {
                    if (node.value !== 'All')
                        list.push(node.value) ;
                })

                gridApi.setColumnFilterModel(id.toLocaleLowerCase(), { 
                    values: list
                }).then(() => gridApi.onFilterChanged())
                .then(() => {
                    \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                        if (elem.id !== id) {
                            updateFilter(elem.id);
                        }
                    })
                });
                event.preventDefault();
            }

            function updateFilter(id) {
                if (id !== 'ag-cols') {
                    let result = [];
                    gridApi.forEachNode((elem) => {
                        if (elem.displayed)
                            result.push(String(elem.data[id.toLocaleLowerCase()]));
                    })
                    let list = [...new Set(result)];

                    \$(`#\${id} .column-filter-item`).hide().filter(function () {
                        if (\$(this).text().trim() === '(All)') 
                            return true;

                        return list.indexOf(\$(this).text().trim().toLocaleLowerCase()) !== -1;
                    }).show();
                } 
            }

            function clickAll(id) {
                let block = document.getElementById(id)
                let check = \$(block).find('input[type=checkbox]');

                if (check[0].checked === true) {
                    check.each((index, node) => {
                        node.checked = true;
                    })
                } else {
                    check.each((index, node) => {
                        node.checked = false;
                    });
                }
            }

            function clickItem(event, id) {
                let AllCheckbox = document.getElementById(id);
                if (!event.target.checked) {
                    AllCheckbox.checked = false;
                } 
            }

            function inputSearch(event, id) {
                if (event.target.value.length > 0) {
                    \$(`#\${id} .column-filter-item`).hide().filter(function () {
                        return \$(this).text().toLowerCase().indexOf(event.target.value.toLowerCase()) != -1;
                    }).show();
                }
                else {
                    \$(`#\${id} .column-filter-item`).show();
                }
            }

            function clickResetRow(id) {
                let result = [];
                gridApi.forEachNode(elem => {
                    result.push(String(elem.data[id.toLocaleLowerCase()]));
                });
                let list = [...new Set(result)];

                gridApi.setColumnFilterModel(id.toLocaleLowerCase(), { 
                    values: list
                }).then(() => gridApi.onFilterChanged()).then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));

                \$(`#\${id} input[type='text']`).val('');

                \$(`#\${id} .column-filter-item input`).each((index, elem) => {
                    elem.checked = true;
                });
            }

            function clickResetCols(id) {
                event.preventDefault();

                const columnDefs = gridApi.getColumnDefs();
                columnDefs.forEach((colDef) => {
                    colDef.hide = false;
                });

                gridApi.setGridOption('columnDefs', columnDefs);

                \$(`#\${id} .column-filter-item input`).each((index, elem) => {
                    elem.checked = true;
                });
            }
        </script>
        <script>
            function slideOne(node){
                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let displayValOne = document.getElementById(`range1-\${node}`);

                displayValOne.innerHTML = sliderOne.value;
                fillColor(node);
            }
            function slideTwo(node){
                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let displayValTwo = document.getElementById(`range2-\${node}`);

                displayValTwo.innerHTML = sliderTwo.value;
                fillColor(node);
            }
            function fillColor(node){
                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let sliderTrack = document.querySelector(`.slider-track-\${node}`);
                let sliderMaxValue = sliderOne.max;
                let sliderMinValue = sliderOne.min;

                percent1 = ((sliderOne.value - sliderMinValue) / (sliderMaxValue - sliderMinValue)) * 100;
                percent2 = ((sliderTwo.value - sliderMinValue) / (sliderMaxValue - sliderMinValue)) * 100;
                sliderTrack.style.background = `linear-gradient(to right, #dadae5 \${percent1}% , #3e3d3d \${percent1}% , #3e3d3d \${percent2}%, #dadae5 \${percent2}%)`;
            }

            function clickResetNumeric(node) {
                let sliderTrack = document.querySelector(`.slider-track-\${node}`);
                sliderTrack.style.background = `#3e3d3d`;

                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let sliderMaxValue = sliderOne.max;
                let sliderMinValue = sliderOne.min;

                let displayValOne = document.getElementById(`range1-\${node}`);
                let displayValTwo = document.getElementById(`range2-\${node}`);

                sliderOne.value = sliderMinValue;
                sliderTwo.value = sliderMaxValue;
                displayValOne.innerHTML = sliderMinValue;
                displayValTwo.innerHTML = sliderMaxValue;

                gridApi.setColumnFilterModel(node.toLocaleLowerCase(), {
                    operator: 'AND',
                    conditions: [
                        {
                            filterType: 'number',
                            type: 'greaterThanOrEqual',
                            filter: Number(sliderOne)
                        },
                        {
                            filterType: 'number',
                            type: 'lessThanOrEqual',
                            filter: Number(sliderTwo)
                        }
                ]}).then(() => gridApi.onFilterChanged())
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));
            }

            function clickApplyNumeric(node) {
                let sliderOne = document.getElementById(`slider-1-\${node}`).value;
                let sliderTwo = document.getElementById(`slider-2-\${node}`).value;


                gridApi.setColumnFilterModel(node.toLocaleLowerCase(), {
                    operator: 'AND',
                    conditions: [
                        {
                            filterType: 'number',
                            type: 'greaterThanOrEqual',
                            filter: Number(sliderOne)
                        },
                        {
                            filterType: 'number',
                            type: 'lessThanOrEqual',
                            filter: Number(sliderTwo)
                        }
                ]}).then(() => gridApi.onFilterChanged())
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));
            }
        </script>
    </body>
</html>"
    
    saveHTML(html, outFile)
end

row_table = [
    (a = 1, b = 2000, c = 351),
    (a = 2, b = 2500, c = 621),
    (a = 3, b = 3000, c = 6211),
    (a = 4, b = 1300, c = 71) 
]

bigData = readData("./tableview/data.txt")
filters = ["location","cols", "company", "rocket"]


columns = [
    {
        name: "location",
        filter: "text",
        style: {
            color: "red",
            background: "greeen"
        }
    },
    {
        name: "cols",
    },
    {
        name: "company",
        filter: "text",
    },
    {
        name: "price",
        filter: "number",
        style: {
            background: "red",
            color: "green"
        }
    },
]

showTable(JSON.parse(bigData), filters, ["price"], false)
showTable(JSON.parse(JSON.json(row_table)), ["a"], ["b", "c"], false)
