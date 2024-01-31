module CustomPanel

customPanelScript = "
    <script>
        class CustomFilterPunel {
            eGui;
            init(params) {
                this.eGui = document.createElement('div');
                this.eGui.style.textAlign = 'center';
            
                const renderStats = () => {
                    this.eGui.innerHTML = this.calculateHTML(params, filter, numeric)
                };
                const updateStat = () => {
                    this.eGui.innerHTML = this.updateHTML(params, filter, node); 
                }
                params.api.addEventListener('gridReady', renderStats);
            }
            getGui() {
                return this.eGui;
            }
        
            setUpdated(value) {
            this.updated = value;
            }
        
            refresh() {}
        
            calculateHTML(params, nodes) {
                let textFilter = nodes.map((node) => {
                    if (node === 'cols')
                        return this.calculateCols(params, nodes.length + 1);
                    else
                        return this.calculateParams(params, node, nodes.length + 1);
                })
                let numericFulter = this.calculateNumericFilter(params, numeric, 99.5 / (nodes.length + 1));
                document.getElementById('ag-32').lastChild.style.width = '100%';
        
                return `
                <div>
                    <div 
                        class='filter-wrapper'
                        style='grid-template-rows: repeat(\${nodes.length}, \${99.5 / (nodes.length + 1)}vh)'
                    >
                        \${textFilter.join('')}
                    </div>
                    <div>
                        \${numericFulter}
                    </div>
                </div>
                `
            }
        calculateNumericFilter(params, nodes, height) {
            let textFilter = nodes.map((node) => {
                return this.calculateNumericItem(params, node, height/nodes.length);
            })
        
            return textFilter.join('');
        }
        
        calculateNumericItem(params, node, height) {
            let result = [];
        
            gridApi.forEachNode(elem => {
                result.push(elem.data[node.toLocaleLowerCase()]);
            });
        
            let maxValue = Math.max(...result);
            let minValue = Math.min(...result);
        
            return `
            <div class='numeric-filter' style='height: \${height - 1.5}vh'>
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
                <div class='column-filter' id='ag-cols'>
                    <div>
                        <input 
                        type='text' 
                        id='searcherCols' 
                        class='title' 
                        placeholder='Search for cols...'
                        oninput='inputSearch(event, \"searchCols\")'
                        />
                        <div class='column-filter-wrapper' style='height: calc(\${90 / len}vh - 50px);' id='searchCols'>
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
                    <div class='column-filter' id='\${node}'>
                        <div>
                            <input 
                            type='text' 
                            id='searcher\${node}' 
                            class='title' 
                            placeholder='Search for \${node}...' 
                            oninput='inputSearch(event, \"search\${node}\")'
                            />
                            <div class='column-filter-wrapper' style='height: calc(\${90 / len}vh - 50px);' id='search\${node}'>
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

end