# Scripts

import JSON
include("Utils.jl")

function getSidebar()
    return "sideBar: {
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
        }"
end

function getAgGridScripts(
                    columnSettings::Dict, 
                    data::Any, 
                    minWidth::String
                )
    rowData = JSON.json(data)
    columns = keys(data[1])

    columnDefs, styleClasses = getColumnDefs(columns, columnSettings, keys(columnSettings))
    filter = getFilterColumns(columnSettings, "text")
    numeric =  getFilterColumns(columnSettings, "number")
    date =  getFilterColumns(columnSettings, "date")

    if length(keys(columnSettings))!= 0 
        SideBar =  getSidebar()
    else 
        SideBar = ""
    end

    script = "
    <style>
        $styleClasses
    </style>
    <script type='text/javascript'>
        filter=$filter
        numeric=$numeric
        date=$date
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
            $SideBar
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
          
    </script>"

    return script
end


function getFunctionsScripts() 
    return "
    <script>
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
                            result.push(String(elem.data[id.toLocaleLowerCase()]).toLocaleLowerCase());
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
                let block = document.getElementById(id);
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

                console.log(id)
                \$(`#ag-cols input[type='text']`).val('');
                \$(`#\${id} .column-filter-item`).show();
            }

            function slideOne(node, type=''){
                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let displayValOne = document.getElementById(`range1-\${node}`);

                if (Number(sliderOne.value) >= Number(sliderTwo.value)) {
                    sliderOne.value = sliderTwo.value;
                }

                if (type == 'date')
                    displayValOne.innerHTML = formatDate(Number(sliderOne.value)); 
                else
                    displayValOne.innerHTML = sliderOne.value;
                fillColor(node);
            }
            function slideTwo(node, type=''){
                let sliderOne = document.getElementById(`slider-1-\${node}`);
                let sliderTwo = document.getElementById(`slider-2-\${node}`);
                let displayValTwo = document.getElementById(`range2-\${node}`);

                if (Number(sliderTwo.value) <= Number(sliderOne.value)) {
                    sliderTwo.value = sliderOne.value;
                }

                if (type == 'date')
                    displayValTwo.innerHTML = formatDate(Number(sliderTwo.value)); 
                else
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

            function clickResetDate(node) {
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

                displayValOne.innerHTML = formatDate(Number(sliderMinValue));
                displayValTwo.innerHTML = formatDate(Number(sliderMaxValue));

                gridApi.setColumnFilterModel(node.toLocaleLowerCase(), null)
                .then(() => gridApi.onFilterChanged())
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));
            }

            function clickApplyDate(node) {
                let sliderOne = document.getElementById(`slider-1-\${node}`).value;
                let sliderTwo = document.getElementById(`slider-2-\${node}`).value;

                gridApi.setColumnFilterModel(node.toLocaleLowerCase(), {
                    operator: 'AND',
                    conditions: [
                        {
                            filterType: 'date',
                            type: 'greaterThan',
                            dateFrom: formatDate(Number(sliderOne))
                        },
                        {
                            filterType: 'date',
                            type: 'lessThan',
                            dateFrom: formatDate(Number(sliderTwo))
                        }
                ]}).then(() => {
                    gridApi.onFilterChanged();
                })
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
                            type: 'greaterThan',
                            filter: Number(sliderOne)
                        },
                        {
                            filterType: 'number',
                            type: 'lessThan',
                            filter: Number(sliderTwo)
                        }
                ]}).then(() => gridApi.onFilterChanged())
                .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                    updateFilter(elem.id);
                }));
            }

            function formatDate(date) {
                date = new Date(date)


                var dd = date.getDate();
                if (dd < 10) dd = '0' + dd;

                var mm = date.getMonth() + 1;
                if (mm < 10) mm = '0' + mm;

                var yy = date.getFullYear();

                return yy + '-' + mm + '-' + dd;
            }
    </script>"
    
end
