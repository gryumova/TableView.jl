# TableView.jl
TableView is a Julia package for generating an html file with a table based on [AgGrid](https://www.ag-grid.com). You can set the configuration for filters and customize the display of column cells.

## Usage
Simple example:
```julia
using TableView


data = (
    (a = 0, b = 1, c = 6),
    (a = 1, b = 35, c = 7),
    (a = 2, b = 134, c = 6),
    (a = 3, b = 868, c = 7),
    (a = 4, b = 34, c = 0),
)

# 'table' argument can be 'number', 'text', 'date'
# 'style' argument can include 'color' and 'background'. You can change text color depending of a value of cell.
#       style => Dict(
#           colorUp => "red",
#           colorDown => "green",
#           threshold => 10,
#       )
#       or
#       style => Dict(
#           color => "red",
#           equals => 10,
#       )

settings = Dict(
    a => Dict(
        filter => "number",
        style => (
            color => "red",
            background => "#FFFF79"
        )
    ),
    c => Dict(
        filter = "text",
    ),
    cols => Dict()
)

# first argument specifies the data to be displayed in the table

# 'column_settings' argument specifies the columns to filter, the type of filtering, and the styling of the columns. 
# If you want to filter by columns, specify the key 'cols'

# 'resize' argument indicates the ability to change the width of the columns. 
# If resize=false, you cannot reduce the column size to less than 150px.

showTable(data, column_settings=settings, resize=false, out_file="./index.html")
```

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