# Templates/MainStyle

#  CSS script with basic styles for classes and attributes HTML files.
const MAIN_STYLE = """
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
        padding-bottom: 5px;
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
    .date-filter {
        position: relative;
        border-top: 1px solid #e0e0e0;
        text-align: start;

        padding: 10px;
    }
    .name-numeric-filter {
        font-size: 14px;
        font-weight: 900;
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
        margin: 0;
        top: 0;
        bottom: 0;

        background-color: transparent;
        pointer-events: none;
    } 
    .slider-track{
        width: calc(100% - 12px);
        height: 4px;

        position: absolute;
        margin: 0;
        left: 6px;
        top: 5.5px;
        bottom: 0;

        background: #d8d8d8;
        border-radius: 3px;

        cursor: pointer;
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
    .input-slider1::-webkit-slider-thumb{
        -webkit-appearance: none;
        height: 14px;
        width: 10px;

        cursor: pointer;

        border: 1px solid #666666;
        border-radius: 60% 0 0 60% / 50% 0 0 50%;
        background: #ffffff;

        pointer-events: auto;
        cursor: e-resize;
    }
    .input-slider2::-webkit-slider-thumb{
        -webkit-appearance: none;
        height: 14px;
        width: 10px;

        cursor: pointer;

        border: 1px solid #666666;
        border-radius: 0 60% 60% 0 / 0 50% 50% 0;
        background: #ffffff;

        pointer-events: auto;
        cursor: w-resize;
    }

    .input-slider2:active {
        background-color: transparent;
        border: none;
        outline: none;
    }

    .values {
        position: relative;
        margin: 5px 0px 5px 0px;

        display: flex;
        flex-direction: row;
        justify-content: space-between;

        border: none;

        text-align: center;
    }
    .input-numeric-slider {
        border: 1.5px solid transparent;
        background: transparent;
        outline: none;

        width: 45%;

        color: #383838;
        font-weight: 500;
        font-size: 14px;
        padding: 3px 0px 3px 0px;
        margin: 0;
    }

    .input-numeric-slider:focus {
        border: 1.5px solid #d0d0d0;
    }

    /* STYLED COMPONENT */
    .styled-row-box {
        text-align: right;
    }
    .styled-row-box span {
        padding: 5px 10px;
        border-radius: 4px;
    }
</style>
"""
