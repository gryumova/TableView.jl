function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

const FILTER_DEFS = read_file("./Utils/filterDefs.txt")
const COLUMN_DEFS = (
    "[{ field: 'a', valueParser: numberParser, filter: 'agNumberColumnFilter', },
{ field: 'b', filter: 'agSetColumnFilter', },
{ field: 'c', },
{ field: 'date', },
{ field: 'cols', },
]", "")

const STYLE_DEFS_EQUAL = (
    "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-c'], cellStyle: params => {
                if (params.value == '7') {
                    return {color: 'rgb(134, 208, 134)'};
                }

                return null;
            }, ", 
    ".styled-row-box-c span {color: rgb(134, 208, 134); }; "
)

const STYLE_DEFS_THRESHOLD = (
    "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-b'], cellStyle: params => {
                if (params.value > 35) {
                    return {color: 'rgb(134, 208, 134)'};
                }

                return {color: 'rgb(226, 73, 73)'};
            }, ", 
    ".styled-row-box-b span {colorDown: rgb(226, 73, 73); colorUp: rgb(134, 208, 134); }; "
)