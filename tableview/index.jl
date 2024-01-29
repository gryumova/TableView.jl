using .Styles
import JSON

function getColumnDefs(table)
    key = keys(table[1])
    println(key)

    columnDefs = "["
    for i in key
        columnDefs = columnDefs * "{field: '$i', filter: 'agSetColumnFilter'}, "
    end
    columnDefs = columnDefs * "]"
   
    columnDefs
end

function getStyle(style)
    if style == Styles.BINANCE
        Styles.binance
    elseif style == Styles.KRAKEN
        Styles.kraken
    elseif style == Styles.TABLE
        Styles.table
    else
        ""
    end
end

function getBGColor(theme)
    if theme == Styles.BINANCE
        "#1e2329"
    elseif theme == Styles.KRAKEN
        "#efedf8"
    elseif theme == Styles.TABLE
        "#f7fbfd"
    else
        "white"
    end
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

function getSideBar(bar)
    if bar
        "sideBar: {
            toolPanels: [
                {
                    id: 'columns',
                    labelDefault: 'Columns',
                    labelKey: 'columns',
                    iconKey: 'columns',
                    toolPanel: 'agColumnsToolPanel',
                    minWidth: 225,
                    maxWidth: 225,
                    width: 225
                },
                {
                    id: 'filters',
                    labelDefault: 'Filters',
                    labelKey: 'filters',
                    iconKey: 'filter',
                    toolPanel: 'agFiltersToolPanel',
                    minWidth: 180,
                    maxWidth: 400,
                    width: 250
                }
            ],
            position: 'left',
            defaultToolPanel: 'filters'
        }"
    else
        ""
    end
end

function showTable(table, filter=[], resize=true, outFile="./result/index.html")
    rowData = JSON.json(table)
    columnDefs = getColumnDefs(table)
    if !resize
        minWidth = "minWidth: 150"
    else
        minWidth = ""
    end
    
    style = readData("./tableview/style.txt")
    
    if size(filter) != 0
        customPanel = readData("./tableview/customPanel.txt")
        println(customPanel)
    else
        customPanel = ""
    end

    filter = JSON.json(filter)

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
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    if (elem.id !== id) {
                        updateFilter(elem.id);
                    }
                }));

                event.preventDefault();
            }

            function updateFilter(id) {
                if (id !== 'ag-cols') {
                    let result = [];
                    gridApi.getRenderedNodes().map(elem => {
                        result.push(elem.data[id.toLocaleLowerCase()].toLocaleLowerCase());
                    });
                    let list = [...new Set(result)];

                    \$(`#\${id} .column-filter-item`).hide().filter(function () {
                        if (\$(this).text().trim() === '(All)') 
                            return true;
                        
                        return list.indexOf(\$(this).text().trim().toLowerCase()) !== -1;
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
                    result.push(elem.data[id.toLocaleLowerCase()]);
                });
                let list = [...new Set(result)];

                gridApi.setColumnFilterModel(id.toLocaleLowerCase(), { 
                    values: list
                }).then(() => gridApi.onFilterChanged())
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));

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
    </body>
</html>"
    
    saveHTML(html, outFile)
end

row_table = [
    (a = 1, b = 2000),
    (a = 2, b = 2500),
    (a = 3, b = 3000),
    (a = 4, b = 1300) 
]

filters = ["Location","cols", "Company", "Rocket"]

bigData = readData("./tableview/data.txt")

showTable(JSON.parse(bigData), filters, false)

