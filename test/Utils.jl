# Utils

function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

@testset "Utils" begin
    @testset "Case №1: get_filter_columns test" begin
        columns_dict_cols= Dict(
            "a" => Dict(
                "filter" => "number",
            ),
            "b" => Dict(
                "filter" => "text",
            ),
            "c" => Dict(
                "filter" => "number"
            ),
            "date" => Dict(
                "filter" => "date",
            ),
            "cols_filter" => true
        ) 

        @test TableView.get_filter_columns(columns_dict_cols, "text") == "[\"cols\",\"b\"]"
        @test TableView.get_filter_columns(columns_dict_cols, "number") == "[\"c\",\"a\"]"
        @test TableView.get_filter_columns(columns_dict_cols, "date") == "[\"date\"]"
        @test TableView.get_filter_columns(Dict(), "date") == "[]"
    end

    @testset "Case №2: get_style_defs test" begin
        STYLE_DEFS_EQUAL = ("""
cellClass: ['styled-row-box', 'styled-row-box-c'], cellStyle: params => {
                if (String(params.value) == '7') {
                    return {color: 'rgb(134, 208, 134)'};
                }

                return null;
            }, """, 
        ".styled-row-box-c span {} "
        )

        STYLE_DEFS_THRESHOLD = ("""
cellClass: ['styled-row-box', 'styled-row-box-b'], cellStyle: params => {
                if (params.value > 35) {
                    return {color: 'rgb(134, 208, 134)'};
                }

                return {color: 'rgb(226, 73, 73)'};
            }, """, 
    ".styled-row-box-b span {} "
)

        columns_dict_cols= Dict(
            "a" => Dict(
                "filter" => "number",
                "style" => Dict(
                    "color" => "red",
                    "background" => "green",
                ),
            ),
            "b" => Dict(
                "filter" => "text",
            ),
        ) 

        columns_dict_equal = Dict(
            "c" => Dict(
                "style" => Dict(
                    "color" => "rgb(134, 208, 134)",
                    "equals" => 7,
                ),
            ),
        )

        columns_dict_threshold = Dict(
            "b" => Dict(
                "style" => Dict(
                    "colorUp" => "rgb(134, 208, 134)",
                    "colorDown" => "rgb(226, 73, 73)",
                    "threshold" => 35,
                ),
            ),
        ) 

        @test TableView.get_style_defs("", "", columns_dict_equal["c"], "c") == STYLE_DEFS_EQUAL
        @test TableView.get_style_defs("", "", columns_dict_cols["a"], "a") == (
            "cellClass: ['styled-row-box', 'styled-row-box-a'], ", 
            ".styled-row-box-a span {background-color: green; color: red; } "
        )
        @test TableView.get_style_defs("", "", columns_dict_threshold["b"], "b") == STYLE_DEFS_THRESHOLD
        @test TableView.get_style_defs("", "", "", "") == ("", "")
    end

    @testset "Case №3: get_filter_defs test" begin

        FILTER_DEFS = read_file("./templates/filterDefs.txt")

        columns_dict_cols= Dict(
            "a" => Dict(
                "filter" => "number"
            ),
            "b" => Dict(
                "filter" => "text",
            ),
            "c" => Dict(
                "filter" => "number"
            ),
            "date" => Dict(
                "filter" => "date",
            ),
            "cols_filter" => true
        ) 
        @test TableView.get_filter_defs(columns_dict_cols["a"]) == "filter: 'agNumberColumnFilter', "
        @test TableView.get_filter_defs(columns_dict_cols["date"]) == FILTER_DEFS
        @test TableView.get_filter_defs(Dict()) == ""
    end

    @testset "Case №4: get_column_defs test" begin

        COLUMN_DEFS = """
[{ field: 'a', filter: 'agNumberColumnFilter', cellRenderer: cellRenderer, },
{ field: 'b', filter: 'agSetColumnFilter', cellRenderer: cellRenderer, },
{ field: 'c', },
{ field: 'date', },
]"""

        columns_dict_cols= Dict(
            "a" => Dict(
                "filter" => "number",
            ),
            "b" => Dict(
                "filter" => "text",
            ),
            "cols_filter" => true
        )

        @test TableView.get_column_defs((), Dict(), ()) == ("[]", "")
        @test TableView.get_column_defs(("a", "b", "c", "date"), columns_dict_cols, ("a", "b", "cols")) == (COLUMN_DEFS, "")
    end

    @testset "Case №5: MethodError test" begin
        settings = (a = (filter = "text"))

        @test_throws MethodError TableView.get_filter_columns(settings, "test")
        @test_throws MethodError TableView.get_style_defs("", settings[:a], "")
        @test_throws MethodError TableView.get_filter_defs(settings[:a])
        @test_throws MethodError TableView.get_column_defs((), settings, ())
    end
end