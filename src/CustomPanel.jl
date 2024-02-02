# CustomPanel

customPanelScript = "
    <script>
        class CustomFilterPunel {
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
                let len = text.length;
                if (numeric.length != 0 || date.length != 0)
                    len += 1;

                let textFilter = text.map((node) => {
                    if (node === 'cols')
                        return this.calculateCols(params, len);
                    else
                        return this.calculateParams(params, node, len);
                })
                let numericDateFilter = this.calculateFilter(params, numeric, date, 98 / (len));
                document.getElementById('ag-32').lastChild.style.width = '100%';
                
                return `
                    <div>
                        <div 
                            class='filter-wrapper'
                            style='grid-template-rows: repeat(\${text.length}, \${98 / (len)}vh)'
                        >
                            \${textFilter.join('')}
                        </div>
                        <div>
                            \${numericDateFilter}
                        </div>
                    </div>
                `
            }
            calculateFilter(params, numeric, date, height) {
                let len = numeric.length + date.length;
                let textHTML = numeric.map((node) => {
                    return this.calculateNumericItem(params, node, height/len);
                })

                let dateHTML = date.map((node) => {
                    return this.calculateDateItem(params, node, height/len);
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
                <div class='numeric-filter' style='height: \${height - 2}vh'>
                    <div style='overflow-y: scroll; height: calc(100% - 29px)'>
                        <span class='name-numeric-filter'>
                            \${node.toLocaleLowerCase()}
                        </span>
                        <div class='values values-\${node}'>
                            <span id='range1-\${node}'>
                                \${formatDate(minValue)}
                            </span>
                            <span id='range2-\${node}'>
                                \${formatDate(maxValue)}
                            </span>
                        </div><div class='container container-\${node}'>
                            <div 
                                class='slider-track slider-track-\${node}'
                                style='
                                    background: #3e3d3d;
                                '
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
                <div class='numeric-filter' style='height: \${height - 2}vh'>
                    <div style='overflow-y: scroll; height: calc(100% - 29px)'>
                        <span class='name-numeric-filter'>
                            \${node.toLocaleLowerCase()}
                        </span>
                        <div class='values values-\${node}'>
                            <span id='range1-\${node}'>
                                \${minValue}
                            </span>
                            <span id='range2-\${node}'>
                                \${maxValue}
                            </span>
                        </div>
                        <div class='container container-\${node}'>
                            <div 
                                class='slider-track slider-track-\${node}'
                                style='
                                    background: #3e3d3d;
                                '
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
            calculateCols(params, len) {
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
                    style='height: \${94 / len}vh;'
                >
                    <div style='height: calc(\${94 / len}vh - 32px);'>
                        <input 
                        type='text' 
                        id='searcherCols' 
                        class='title' 
                        placeholder='Search for cols...'
                        oninput='inputSearch(event, \"searchCols\")'
                        />
                        <div class='column-filter-wrapper' style='overflow-y: scroll; height: calc(100% - 32px);' id='searchCols'>
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

            calculateParams(params, node, len) {
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
                    <div class='column-filter' id='\${node}' style='height: \${94 / len}vh;'>
                        <div style='height: calc(\${94 / len}vh - 32px);'>
                            <input 
                            type='text' 
                            id='searcher\${node}' 
                            class='title' 
                            placeholder='Search for \${node}...' 
                            oninput='inputSearch(event, \"search\${node}\")'
                            />
                            <div class='column-filter-wrapper' style='overflow-y: scroll; height: calc(100% - 32px);' id='search\${node}'>
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
    </script>"
