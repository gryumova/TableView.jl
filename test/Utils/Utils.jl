#test/Utils/Utils.jl
include("../../src/Utils.jl")
include("utils_test_constants.jl")

@testset "get_filter_columns test" begin
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
        "cols" => Dict(),
    ) 

    @test get_filter_columns(columns_dict_cols, "text") === "[\"b\",\"cols\"]"
    @test get_filter_columns(columns_dict_cols, "number") === "[\"c\",\"a\"]"
    @test get_filter_columns(columns_dict_cols, "date") === "[\"date\"]"
    @test get_filter_columns(Dict(), "date") === "[]"
end

@testset "get_style_defs test" begin
    columns_dict_cols= Dict(
        "a" => Dict(
            "filter" => "number",
            "style" => Dict(
                "color" => "red",
                "background" => "green",
            )
        ),
        "b" => Dict(
            "filter" => "text",
        )
    ) 

    columns_dict_equal = Dict(
        "c" => Dict(
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "equals" => 7
            )
    ))
    columns_dict_threshold = Dict(
        "b" => Dict(
            "style" => Dict(
                "colorUp" => "rgb(134, 208, 134)",
                "colorDown" => "rgb(226, 73, 73)",
                "threshold" => 35
            )
    )) 

    @test get_style_defs("", columns_dict_equal["c"], "c") === test3 
    @test get_style_defs("", columns_dict_cols["a"], "a") === (
        "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-a'], ", 
        ".styled-row-box-a span {background-color: green; color: red; }; "
    )
    @test get_style_defs("", columns_dict_threshold["b"], "b") === test4
    @test get_style_defs("", "", "") === ("", "")

end

@testset "get_filter_defs test" begin
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
        "cols" => Dict(),
    ) 
    @test get_filter_defs(columns_dict_cols["a"]) == "valueParser: numberParser, filter: 'agNumberColumnFilter', "
    @test get_filter_defs(columns_dict_cols["date"]) == test1
    @test get_filter_defs(Dict()) == ""
end

@testset "get_column_defs test" begin
    columns_dict_cols= Dict(
        "a" => Dict(
            "filter" => "number"
        ),
        "b" => Dict(
            "filter" => "text",
        ),
        "cols" => Dict(),
    ) 
    @test get_column_defs((), Dict(), ()) == ("[]", "")
    @test get_column_defs(("a", "b", "c", "date", "cols"), columns_dict_cols, ("a", "b", "cols")) == test2
end

@testset "MethodError test" begin
    settings = (
        a = (
            filter = "text"
        )
    ) 
    @test_throws MethodError get_filter_columns(settings, "test")
    @test_throws MethodError get_style_defs("", settings[:a], "")
    @test_throws MethodError get_filter_defs(settings[:a])
    @test_throws MethodError get_column_defs((), settings, ())
end