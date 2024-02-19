## AgGrid customization

Custom Tool Panel Components can be included into the grid's SideBar. 
Implementing a Tool Panel Component:
```JavaScript
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
                // generating HTML scripts
            }
            calculateFilter(params, numeric, date, height) {
                // generating HTML scripts filter 
            }
        
            calculateDateItem(params, node, height) {
                // generating HTML scripts filter for date value
            }

            calculateNumericItem(params, node, height) {
                // generating HTML scripts filter for numeric value
            }
            calculateCols(params, len) {
                // generating HTML scripts filter for columns
            };

            calculateParams(params, node, len) {
                // generating HTML scripts filter for text value
            };
        }

```

Registering a Tool Panel component follows the same approach as any other custom components in the grid. 
Once the Tool Panel Component is registered with the grid it needs to be included into the SideBar. The following snippet illustrates this:
```JavaScript
const gridOptions: {
    sideBar: {
        toolPanels: [
            {
                id: 'customStats',
                labelDefault: 'Custom Stats',
                labelKey: 'customStats',
                iconKey: 'custom-stats',
                toolPanel: CustomFilterPanel,
                toolPanelParams: {
                    // can pass any custom params here
                },
            }
        ]
    }
    // other grid properties
}
```