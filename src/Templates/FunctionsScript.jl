# Templates/FunctionsScript

const FUNCTIONS_SCRIPT = """
<script>
    function inputNumeric(event, node, side) {
        if (event.code == \"Enter\") {
            let number = Number(event.target.value);
            
            if (!isNaN(number)) {
                if (side == \"one\") 
                    setNumberInputOne(node);
                else if (side == \"two\")
                    setNumberInputTwo(node);
            }
        }
    }

    function inputDate(event, node, side) {
        if (event.code == \"Enter\") {
            let regex = /[0-9]{4}-[0-9]{2}-[0-9]{2}/
            let result = regex.test(event.target.value);
            if (result) {
                if (side == \"one\") 
                    setDateInputOne(node);
                else if (side == \"two\")
                    setDateInputTwo(node);
            }
        }
    }

    function clickTrack(event, node, type) {
        let div = event.target
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);
        let displayValOne = document.getElementById(`range1-\${node}`);
        let displayValTwo = document.getElementById(`range2-\${node}`);

        let dt = (Number(sliderOne.max) - Number(sliderOne.min)) / sliderOne.getBoundingClientRect().width;
        let range = Number(sliderTwo.value) - Number(sliderOne.value);        
        let xStart = event.clientX;

        var onMouseMove = function (evtMove){
            evtMove.preventDefault();
            var xNew = xStart - evtMove.clientX;
            xStart = evtMove.clientX;

            if (sliderOne.value - dt * xNew > sliderOne.min &&
                    sliderTwo.value - dt * xNew < sliderOne.max) {
                sliderOne.value -= dt * xNew;
                sliderTwo.value -= dt * xNew;
            } else {
                if (sliderOne.value - dt * xNew < sliderOne.min) {
                    let delta = sliderOne.value - sliderOne.min;
                    sliderOne.value = sliderOne.min;
                    sliderTwo.value -= delta;
                } else if (sliderTwo.value - dt * xNew > sliderOne.max){
                    let delta = sliderTwo.value - sliderOne.max;
                    sliderTwo.value = sliderOne.max;
                    sliderOne.value -= delta;
                }
            }

            if (type === \"date\") {
                displayValOne.value = formatDate(Number(sliderOne.value));
                displayValTwo.value = formatDate(Number(sliderTwo.value));
            } else {
                displayValOne.value = sliderOne.value;
                displayValTwo.value = sliderTwo.value;
            }
            fillColor(node, type);
        }
        var onMouseUp = function (evtUp){
            document.removeEventListener('mousemove', onMouseMove);
            document.removeEventListener('mouseup', onMouseUp);
            if (type == \"date\")
                clickApplyDate(`\${node}`)
            else clickApplyNumeric(`\${node}`)
        }


        document.addEventListener('mousemove', onMouseMove)
        document.addEventListener('mouseup', onMouseUp)
    }

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

        gridApi.setColumnFilterModel(id, { 
            values: list
        }).then(() => gridApi.onFilterChanged())
        .then(() => {
            \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                if (elem.id !== id) {
                    updateFilter(elem.id);
                }
            })
            \$(`.numeric-filter`).map((item, elem) => {
                if (elem.id !== id) {
                    updateSlider(elem.id, \"number\");
                }
            })
            \$(`.date-filter`).map((item, elem) => {
                if (elem.id !== id) {
                    updateSlider(elem.id, \"date\");
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
                    result.push(String(elem.data[id]).toLocaleLowerCase());
            })
            let list = [...new Set(result)];

            \$(`#\${id} .column-filter-item`).hide().filter(function () {
                if (\$(this).text().trim() === '(All)') 
                    return true;

                return list.indexOf(\$(this).text().trim().toLocaleLowerCase()) !== -1;
            }).show();
        } 
    }

    function updateSlider(id, type) {
        let sliderOne = document.getElementById(`slider-1-\${id}`);
        let sliderTwo = document.getElementById(`slider-2-\${id}`);

        let displayValOne = document.getElementById(`range1-\${id}`);
        let displayValTwo = document.getElementById(`range2-\${id}`);
        
        if (type != 'date') {
            let result = [];

            gridApi.forEachNode(elem => {
                if (elem.displayed)
                    result.push(Number(elem.data[id]));
            });
        
            let maxValue = Math.max(...result);
            let minValue = Math.min(...result);

            sliderOne.min = minValue;
            sliderOne.max = maxValue;
            sliderTwo.min = minValue;
            sliderTwo.max = maxValue;

            sliderOne.value = minValue;
            sliderTwo.value = maxValue;

            displayValOne.value = minValue;
            displayValTwo.value = maxValue;
        } else {
            let result = [];

            gridApi.forEachNode(elem => {
                if (elem.displayed)
                    result.push(Date.parse(elem.data[id]));
            });
        
            let maxValue = Math.max(...result) + 24*60*60*1000;
            let minValue = Math.min(...result) - 24*60*60*1000;

            sliderOne.min = minValue;
            sliderOne.max = maxValue;
            sliderTwo.min = minValue;
            sliderTwo.max = maxValue;

            sliderOne.value = minValue;
            sliderTwo.value = maxValue;

            displayValOne.value = formatDate(Number(sliderOne.min)); 
            displayValTwo.value = formatDate(Number(sliderOne.max)); 
        }

        fillColor(id, type);
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

    function setNumberInputOne(node) {
        let displayValOne = document.getElementById(`range1-\${node}`);
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);

        if (Number(displayValOne.value) >= Number(sliderTwo.value)) {
            sliderOne.value = sliderTwo.value;
            displayValOne.value = sliderTwo.value;
        } else {
            sliderOne.value = displayValOne.value;
        }
        clickApplyNumeric(node);
        fillColor(node, \"number\");
    }

    function setNumberInputTwo(node) {
        let displayValTwo = document.getElementById(`range2-\${node}`);
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);

        if (Number(displayValTwo.value) <= Number(sliderOne.value)) {
            sliderTwo.value = sliderTwo.value;
            displayValTwo.value = sliderTwo.value;
        } else {
            sliderTwo.value = displayValTwo.value;
        }
        clickApplyNumeric(node);
        fillColor(node, \"number\");
    }

    function setDateInputOne(node) {
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);
        let displayValOne = document.getElementById(`range1-\${node}`);

        let display_value = Date.parse(displayValOne.value)

        if (display_value >= Number(sliderTwo.value)) {
            sliderOne.value = sliderTwo.value;
            displayValOne.value = formatDate(Number(sliderTwo.value)); 
        } else {
            sliderOne.value = display_value; 
        }
        clickApplyDate(node);
        fillColor(node, \"date\");
    }

    function setDateInputTwo(node) {
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);
        let displayValTwo = document.getElementById(`range2-\${node}`);

        let display_value = Date.parse(displayValTwo.value)

        if (display_value <= Number(sliderOne.value)) {
            sliderTwo.value = sliderOne.value;
            displayValTwo.value = formatDate(Number(sliderOne.value)); 
        } else {
            sliderTwo.value = display_value; 
        }
        clickApplyDate(node);
        fillColor(node, \"date\");
    }

    function clickResetRow(id) {
        let result = [];
        gridApi.forEachNode(elem => {
            result.push(String(elem.data[id]));
        });

        let list = [...new Set(result)];

        gridApi.setColumnFilterModel(id, { 
            values: list
        }).then(() => gridApi.onFilterChanged()).then(() => {
            \$(`.filter-wrapper .column-filter`).map((item, elem) => {
                updateFilter(elem.id);
            })
            \$(`.numeric-filter`).map((item, elem) => {
                clickResetNumeric(elem.id);
            })
            \$(`.date-filter`).map((item, elem) => {
                clickResetDate(elem.id);
            })
        });

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
            displayValOne.value = formatDate(Number(sliderOne.value)); 
        else
            displayValOne.value = sliderOne.value;
        fillColor(node, type);
    }
    function slideTwo(node, type=''){
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);
        let displayValTwo = document.getElementById(`range2-\${node}`);

        if (Number(sliderTwo.value) <= Number(sliderOne.value)) {
            sliderTwo.value = sliderOne.value;
        }

        if (type == 'date')
            displayValTwo.value = formatDate(Number(sliderTwo.value)); 
        else
            displayValTwo.value = sliderTwo.value;
        fillColor(node, type);
    }
    function fillColor(node, type) {
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);
        let sliderTrack = document.querySelector(`.slider-track-\${node}`);
        let sliderMaxValue = sliderOne.max;
        let sliderMinValue = sliderOne.min;

        percent1 = ((sliderOne.value - sliderMinValue) / (sliderMaxValue - sliderMinValue)) * 100;
        percent2 = ((sliderTwo.value - sliderMinValue) / (sliderMaxValue - sliderMinValue)) * 100;

        if (type === \"date\")
            sliderTrack.style.background = `linear-gradient(to right, #e5e5e5 \${percent1}% , #bababa \${percent1}% , #bababa \${percent2}%, #e5e5e5 \${percent2}%)`;
        else sliderTrack.style.background = `linear-gradient(to right, #e5e5e5 \${percent1}% , #666666 \${percent1}% , #666666 \${percent2}%, #e5e5e5 \${percent2}%)`;
    }

    function clickResetNumeric(node) {
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);

        let displayValOne = document.getElementById(`range1-\${node}`);
        let displayValTwo = document.getElementById(`range2-\${node}`);

        let result = [];

        gridApi.forEachNode(elem => {
            result.push(Number(elem.data[node]));
        });

        let maxValue = Math.max(...result);
        let minValue = Math.min(...result);

        sliderOne.min = minValue;
        sliderOne.max = maxValue;
        sliderTwo.min = minValue;
        sliderTwo.max = maxValue;

        sliderOne.value = minValue;
        sliderTwo.value = maxValue;

        displayValOne.value = minValue;
        displayValTwo.value = maxValue;
        gridApi.setColumnFilterModel(node, {
            operator: 'AND',
            conditions: [
                {
                    filterType: 'number',
                    type: 'greaterThanOrEqual',
                    filter: Number(minValue)
                },
                {
                    filterType: 'number',
                    type: 'lessThanOrEqual',
                    filter: Number(maxValue)
                }
        ]}).then(() => gridApi.onFilterChanged())
        .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
            updateFilter(elem.id);
        }));

        let sliderTrack = document.querySelector(`.slider-track-\${node}`);
        sliderTrack.style.background = `#3e3d3d`;
    }

    function clickResetDate(node) {
        let sliderOne = document.getElementById(`slider-1-\${node}`);
        let sliderTwo = document.getElementById(`slider-2-\${node}`);

        let displayValOne = document.getElementById(`range1-\${node}`);
        let displayValTwo = document.getElementById(`range2-\${node}`);
        
        let result = [];

        gridApi.forEachNode(elem => {
            result.push(Date.parse(elem.data[node]));
        });

        let maxValue = Math.max(...result) + 24*60*60*1000;
        let minValue = Math.min(...result) - 24*60*60*1000;

        sliderOne.min = minValue;
        sliderOne.max = maxValue;
        sliderTwo.min = minValue;
        sliderTwo.max = maxValue;

        sliderOne.value = minValue;
        sliderTwo.value = maxValue;

        displayValOne.value = formatDate(Number(sliderOne.min)); 
        displayValTwo.value = formatDate(Number(sliderOne.max)); 

        gridApi.setColumnFilterModel(node, {
            operator: 'AND',
            conditions: [
                {
                    filterType: 'number',
                    type: 'greaterThanOrEqual',
                    filter: formatDate(Number(minValue))
                },
                {
                    filterType: 'number',
                    type: 'lessThanOrEqual',
                    filter: formatDate(Number(maxValue))
                }
        ]}).then(() => gridApi.onFilterChanged())
        .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
            updateFilter(elem.id);
        }));

        let sliderTrack = document.querySelector(`.slider-track-\${node}`);
        sliderTrack.style.background = `#3e3d3d`;
    }

    function clickApplyDate(node) {
        let sliderOne = document.getElementById(`slider-1-\${node}`).value;
        let sliderTwo = document.getElementById(`slider-2-\${node}`).value;

        gridApi.setColumnFilterModel(node, {
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
        
        console.log(sliderOne, sliderTwo)
        gridApi.setColumnFilterModel(node, {
            operator: 'AND',
            conditions: [
                {
                    filterType: 'number',
                    type: 'greaterThanOrEqual',
                    filter: parseFloat(sliderOne) - 0.0001
                },
                {
                    filterType: 'number',
                    type: 'lessThanOrEqual',
                    filter: parseFloat(sliderTwo) + 0.0001
                }
        ]}).then(() => gridApi.onFilterChanged())
        .then(() => \$(`.filter-wrapper .column-filter`).map((item, elem) => {
            updateFilter(elem.id);
        }));
    }
</script>
"""