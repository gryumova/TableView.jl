# Templates/AgGridStilization

#  CSS script for AgGrid table styling.
const AG_GRID_STILIZATION = """
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
"""