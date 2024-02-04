# Style

"""
        MAIN_STYLE

CSS script with basic styles for classes and attributes HTML files.
"""

const MAIN_STYLE = "
    <style>
        body {
            display: flex;
            flex-direction: row;

            margin: 0px;
            background: #ffffff;
        } 
        #grid-container {
            border: none;
            height: 100vh;
            width: 100%;
        }
        .ag-root-wrapper {
            border-radius: 0;
        }
        .ag-side-buttons {
            display: none;
        }
        .filter-wrapper {
            display: grid;
            width: 100%;

            overflow-x: hidden;
        }

        .column-filter {
            font-weight: 400;

            width: calc(100% - 20px);
            position: relative;

            display: flex;
            flex-direction: column;
            justify-content: stretch;
            align-items: stretch;

            overflow: hidden;
            padding: 10px;
        }
        .filter-wrapper .column-filter:not(:first-child) {
            border-top: 1px solid #e0e0e0;
        }
        .column-filter-wrapper {
            overflow-y: scroll;
        }
        .title {
            text-align: start;
            width: 100%;
            margin: 0px 5px 10px 5px;

            font-size: 14px;
            font-weight: 600;
            color: #808080;

            border:none;

            cursor: pointer;
        }
        .title:focus {
            border: none;
            outline: none;
        }
        .column-filter-item {
            margin: 7px 0px 0px 0px;
            width: 100%;

            display: flex;
            flex-direction: row;
            align-items: start;
            justify-content: start;

            position: relative;

            color: #3e3d3d;
            font-weight: 700;
        }
        .input-column-name {
            padding-top: 0px;
            padding-right: 5px;
            position: absolute;
            left: 25px;
            right: 0;

            text-align: start;

            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;

            cursor: default;
        }
        input[type='checkbox'] {
            margin-right: 15px;
            display: none;
        }

        input[type='checkbox']:checked, 
        input[type='checkbox']:not(:checked) {
            display: inline-block;
            position: relative;
            cursor: pointer;
        }

        input[type='checkbox']:checked:before, 
        input[type='checkbox']:not(:checked):before{
            content: '';
            position: absolute;
            left: -0.5px;
            top: -0.5px;
            width: 13px;
            height: 13px;
            border: 1px solid #b9bdc0;
            background-color: #ffffff;
        }

        input[type='checkbox']:checked:after, 
        input[type='checkbox']:not(:checked):after {
            content: '';
            position: absolute;
            -webkit-transition: all 0.2s ease;
            -moz-transition: all 0.2s ease;
            -o-transition: all 0.2s ease;
            transition: all 0.2s ease;
        }

        input[type='checkbox']:checked:after, 
        input[type='checkbox']:not(:checked):after {
            left: 2.5px;
            top: 2.5px;
            width: 9px;
            height: 9px;
            background-color: #b9bdc0;
        }
        input[type='checkbox']:not(:checked):after {
            opacity: 0;
        }

        input[type='checkbox']:checked:after {
            opacity: 1;
        }
        input[type='text'] {
            cursor: text;
        }
        .apply-button-wrapper {
            width: 100%;
            height: 29px;

            position: relative;
            margin: 0;
            margin-top: 5px;
        }
        .apply-button {
            position: relative;
            width: calc(50% - 5px);

            border: none;
            background-color: #eeeeee;
            color: #646464;

            font-size: 14px;
            font-weight: 500;
            padding: 5px;
            margin: 0;

            cursor: pointer;
        }

        .apply-button:hover {
            background: #cdcdcd;
        }

        .numeric-filter {
            position: relative;
            border-top: 1px solid #e0e0e0;
            text-align: start;

            padding: 10px;
        }
        .name-numeric-filter {
            font-size: 14px;
            font-weight: 600;
            text-align: start;

            color: #3e3d3d;
        }
        .container {
            position: relative;

            width: 100%;
            height: 6px;
        }
        input[type='range']{
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;

            width: 100%;
            outline: none;

            position: absolute;
            margin: 0px;
            left: 0px;
            top: 0;
            bottom: 0;

            background-color: transparent;
            pointer-events: none;
        }
        .slider-track{
            width: 100%;
            height: 3px;

            position: absolute;
            margin: auto;
            left: 0px;
            top: 0.6em;
            bottom: 0;

            background: #d8d8d8;
            border-radius: 5px;
        }
        input[type='range']::-webkit-slider-runnable-track{
            -webkit-appearance: none;
            height: 5px;
        }
        input[type='range']::-moz-range-track{
            -moz-appearance: none;
            height: 5px;
        }
        input[type='range']::-ms-track{
            appearance: none;
            height: 5px;
        }
        input[type='range']::-webkit-slider-thumb{
            -webkit-appearance: none;
            height: 1.2em;
            width: 1.2em;

            background-color: #636363;
            cursor: pointer;
            margin-top: 0px;

            pointer-events: auto;
            border-radius: 50%;
        }
        input[type='range']::-moz-range-thumb{
            -webkit-appearance: none;
            height: 1.2em;
            width: 1.2em;

            cursor: pointer;
            border-radius: 50%;

            background-color: #636363;
            pointer-events: auto;
        }
        input[type='range']::-ms-thumb{
            appearance: none;
            height: 1.2em;
            width: 1.2em;

            cursor: pointer;

            border-radius: 50%;
            background-color: #636363;
            pointer-events: auto;
        }
        input[type='range']:active::-webkit-slider-thumb{
            background-color: #ffffff;
            border: 3px solid #636363;
        }
        .values{
            position: relative;
            margin: 10px 0px 10px 0px;

            display: flex;
            flex-direction: row;
            justify-content: space-between;

            border: none;

            text-align: center;
            font-weight: 700;
            font-size: 12px;

            color: #3e3d3d;
        }


        /* STYLED COMPONENT */
        .styled-row-box {
            text-align: center;
        }
        .styled-row-box span {
            padding: 5px 10px;
            border-radius: 4px;
        }
    </style>"

"""
    AG_GRID_STILIZATION

CSS script for AgGrid table styling.
"""


const AG_GRID_STILIZATION = "
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
"