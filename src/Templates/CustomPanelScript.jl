# Templates/CustomPanelScript

#  CUSTOM_PANEL_SCRIPT is a JS script that defines the filter sidebar configuration for the AgGrid table.
#  Functions for generating HTML blocks with corresponding filters are written inside the class. 
#  The HTML code is displayed based on the columnsSettings argument to the showTable function.
const CUSTOM_PANEL_SCRIPT = """
<script>
    function formatDate(date) {
        date = new Date(date)


        var dd = date.getDate();
        if (dd < 10) dd = '0' + dd;

        var mm = date.getMonth() + 1;
        if (mm < 10) mm = '0' + mm;

        var yy = date.getFullYear();

        return yy + '-' + mm + '-' + dd;
    }

    class CustomFilterPanel {
        eGui;
        init(params) {
            this.eGui = document.createElement('div');
            this.eGui.style.textAlign = 'center';
        
            const renderStats = () => {
                this.eGui.innerHTML = this.calculateHTML(params, filter, numeric, date)
            };
            params.api.addEventListener('gridReady', renderStats);
        }
        getGui() {
            return this.eGui;
        }

        setUpdated(value) {
            this.updated = value;
        }

        refresh() {}

        calculateHTML(params, text, numeric, date) {
            let len = 0;
            if (numeric.length != 0 || date.length != 0) {
                len += numeric.length;
                len += date.length;
            }
            let textHeight = (99.3 - len * 12);

            let textFilter = text.map((node) => {
                if (node === 'cols')
                    return this.calculateCols(params, textHeight/text.length);
                else
                    return this.calculateParams(params, node, textHeight/text.length);
            })
            let numericDateFilter = this.calculateFilter(params, numeric, date);
            document.getElementById('ag-32').lastChild.style.width = '100%';
            
            return `
                <div style='overflow: hidden'>
                    <div 
                        class='filter-wrapper'
                        style='grid-template-rows: repeat(\${text.length}, calc(\${textHeight/text.length}vh-10px)); overflow: hidden'
                    >
                        \${textFilter.join('')}
                    </div>
                    <div>
                        \${numericDateFilter}
                    </div>
                </div>
            `
        }
        
        calculateFilter(params, numeric, date) {
            let textHTML = numeric.map((node) => {
                return this.calculateNumericItem(params, node);
            })

            let dateHTML = date.map((node) => {
                return this.calculateDateItem(params, node);
            })
        
            return textHTML.join('') + dateHTML.join('');
        }

        calculateDateItem(params, node, height) {
            let result = [];
        
            gridApi.forEachNode(elem => {
                result.push(Date.parse(elem.data[node.toLocaleLowerCase()]));
            });
        
            let maxValue = Math.max(...result) + 24*60*60*1000;
            let minValue = Math.min(...result) - 24*60*60*1000;

            return `
            <div 
                class='date-filter' 
                style='height: 12vh'
                id='\${node}'
            >
                <div style='overflow: hidden; height: calc(100% - 29px)'>
                    <span class='name-numeric-filter'>
                        \${node.toLocaleLowerCase()}
                    </span>
                    <div class='values values-\${node}'>
                        <input 
                            class='input-numeric-slider'
                            id='range1-\${node}'
                            value='\${formatDate(minValue)}'
                            onkeypress='inputDate(event, \"\${node}\", \"one\")'
                            type='text'
                        />
                        <input 
                            class='input-numeric-slider'
                            id='range2-\${node}'
                            value='\${formatDate(maxValue)}'
                            onkeypress='inputDate(event, \"\${node}\", \"two\")'
                            type ='text'
                            style=\"text-align: end\"
                        />
                    </div>
                    <div class='container container-\${node}'>
                        <div 
                            class='slider-track slider-track-\${node}'
                            style='
                                background: #3e3d3d;
                            '
                            onmousedown='clickTrack(event, \"\${node}\", \"date\")'
                        ></div>
                        <input 
                            type='range' 
                            min='\${minValue}' 
                            max='\${maxValue}' 
                            value='\${minValue}' 
                            id='slider-1-\${node}' 
                            oninput='slideOne(\"\${node}\", \"date\")'
                        >
                        <input 
                            type='range' 
                            min='\${minValue}' 
                            max='\${maxValue}' 
                            value='\${maxValue}' 
                            id='slider-2-\${node}' 
                            oninput='slideTwo(\"\${node}\", \"date\")'
                        >
                    </div>
                </div>
                <div class='apply-button-wrapper'>
                        <button class='apply-button' onclick='clickResetDate(\"\${node}\")'>Reset</button>
                        <button class='apply-button' onclick='clickApplyDate(\"\${node}\")'>Apply</button>
                </div>
            </div>
            `
        }
        calculateNumericItem(params, node, height) {
            let result = [];
        
            gridApi.forEachNode(elem => {
                result.push(elem.data[node.toLocaleLowerCase()]);
            });
        
            let maxValue = Math.max(...result);
            let minValue = Math.min(...result);
        
            return `
            <div 
                class='numeric-filter' 
                style='height: 12vh'
                id='\${node}'
            >
                <div style='overflow: hidden; height: calc(100% - 29px)'>
                    <span class='name-numeric-filter'>
                        \${node.toLocaleLowerCase()}
                    </span>
                    <div class='values values-\${node}'>
                        <input 
                            class='input-numeric-slider'
                            id='range1-\${node}'
                            value='\${minValue}'
                            onkeypress='inputNumeric(event, \"\${node}\", \"one\")'
                            type ='text'
                        >
                        </input>
                        <input 
                            class='input-numeric-slider'
                            style=\"text-align: end\"
                            id='range2-\${node}'
                            value='\${maxValue}'
                            onkeypress='inputNumeric(event, \"\${node}\", \"two\")'
                            type ='text'
                        >
                        </input>
                    </div>
                    <div class='container container-\${node}'>
                        <div 
                            class='slider-track slider-track-\${node}'
                            style='
                                background: #3e3d3d;
                            '
                            onmousedown='clickTrack(event, \"\${node}\", \"number\")'
                        ></div>
                        <input 
                            type='range' 
                            min='\${minValue}' 
                            max='\${maxValue}' 
                            value='\${minValue}' 
                            id='slider-1-\${node}' 
                            oninput='slideOne(\"\${node}\")'
                        >
                        <input 
                            type='range' 
                            min='\${minValue}' 
                            max='\${maxValue}' 
                            value='\${maxValue}' 
                            id='slider-2-\${node}' 
                            oninput='slideTwo(\"\${node}\")'
                        >
                    </div>
                </div>
                <div class='apply-button-wrapper'>
                        <button class='apply-button' onclick='clickResetNumeric(\"\${node}\")'>Reset</button>
                        <button class='apply-button' onclick='clickApplyNumeric(\"\${node}\")'>Apply</button>
                </div>
            </div>
            `
        }
        calculateCols(params, height) {
            let columns = params.api.getAllDisplayedColumns().map((item) => {
            return item.colId
            });

            let cols_thtml = columns.map((column) => {
                return `
                <div class='column-filter-item'>
                    <input 
                        class='input-cols-filter' 
                        onclick='clickItem(event, \"AllCols\")' 
                        type='checkbox' 
                        value='\${column}' 
                        checked
                        id='\${column}' 
                    />
                    <label class='input-column-name' for='\${column}'>\${column.toLocaleUpperCase()}</label>
                </div>`
            })


            return `
            <div 
                class='column-filter'
                id='ag-cols'
                style='height: calc(\${height}vh - 35px);'
            >
                <div style='overflow: hidden; height: calc(\${height}vh - 20px);'>
                    <input 
                        type='text' 
                        id='searcherCols' 
                        class='title' 
                        placeholder='Search for cols...'
                        oninput='inputSearch(event, \"searchCols\")'
                    />
                    <div class='column-filter-wrapper' style='height: calc(100% - 28px);' id='searchCols'>
                        <div class='column-filter-item'>
                            <input 
                                class='input-cols-filter' 
                                type='checkbox' 
                                value='All' 
                                onclick='clickAll(\"ag-cols\")' 
                                checked
                                id='AllCols' 
                            />
                            <label class='input-column-name' for='AllCols'>(All)</label>
                        </div>
                        \${cols_thtml.join('')}
                    </div>
                </div>
                <div class='apply-button-wrapper'>
                    <button class='apply-button' onclick='clickResetCols(\"searchCols\")'>Reset</button>
                    <button class='apply-button' onclick='clickHandleCols(event)'>Apply</button>
                </div>
            </div>`
        };

        calculateParams(params, node, height) {
            let result = [];
            params.api.forEachNode(elem => {
                if (elem.displayed === true) {
                    result.push(elem.data[node.toLocaleLowerCase()]);
                }
            });
            let values = [...new Set(result)];

            let values_html = values.map((value) => {
                return `
                    <div class='column-filter-item'>
                        <input 
                            class='input-cols-filter' 
                            onclick='clickItem(event, \"AllParams\${node}\")' 
                            type='checkbox' 
                            value='\${value}' 
                            checked
                            id='\${value}' 
                        />
                        <label for='\${value}' class='input-column-name'>\${value}</label>
                    </div>
                `
            })

            return `
                <div class='column-filter' id='\${node}' style='height: calc(\${height}vh - 35px)'>
                    <div style='overflow: hidden; height: calc(\${height}vh - 32px);'>
                        <input 
                        type='text' 
                        id='searcher\${node}' 
                        class='title' 
                        placeholder='Search for \${node}...' 
                        oninput='inputSearch(event, \"search\${node}\")'
                        />
                        <div class='column-filter-wrapper' style='height: calc(100% - 28px);' id='search\${node}'>
                            <div class='column-filter-item'>
                                <input 
                                    class='input-cols-filter' 
                                    type='checkbox' 
                                    value='All' 
                                    onclick='clickAll(\"search\${node}\")' 
                                    checked
                                    id='AllParams\${node}' 
                                />
                                <label 
                                    for='AllParams\${node}' 
                                    class='input-column-name'
                                >
                                    (All)
                                </label>
                            </div>
                            \${values_html.join('')}
                        </div>
                    </div>
                    <div class='apply-button-wrapper'>
                        <button class='apply-button' onclick='clickResetRow(\"\${node}\")'>Reset</button>
                        <button class='apply-button' onclick='clickHandleFilter(event, \"\${node}\")'>Apply</button>
                    </div>
                </div>
            `;
        };
    }
</script>
"""