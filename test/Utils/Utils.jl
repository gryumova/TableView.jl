#test/Utils/Utils.jl
include("../../src/Utils.jl")
include("utils-test-constants.jl")

@testset "getFilterColumns test" begin
    columnsDictCols= Dict(
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

    @test getFilterColumns(columnsDictCols, "text") === "[\"b\",\"cols\"]"
    @test getFilterColumns(columnsDictCols, "number") === "[\"c\",\"a\"]"
    @test getFilterColumns(columnsDictCols, "date") === "[\"date\"]"
    @test getFilterColumns(Dict(), "date") === "[]"
end

@testset "getStyleDefs test" begin
    columnsDictCols= Dict(
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

    columnsDictEqual = Dict(
        "c" => Dict(
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "equals" => 7
            )
    ))
    columnsDictThreshold = Dict(
        "b" => Dict(
            "style" => Dict(
                "colorUp" => "rgb(134, 208, 134)",
                "colorDown" => "rgb(226, 73, 73)",
                "threshold" => 35
            )
    )) 

    @test getStyleDefs("", columnsDictEqual["c"], "c") === test3 
    @test getStyleDefs("", columnsDictCols["a"], "a") === (
        "cellRenderer: cellRenderer, cellClass: ['styled-row-box', 'styled-row-box-a'], ", 
        ".styled-row-box-a span {background-color: green; color: red; }; "
    )
    @test getStyleDefs("", columnsDictThreshold["b"], "b") === test4
    @test getStyleDefs("", "", "") === ("", "")

end

@testset "getFilterDefs test" begin
    columnsDictCols= Dict(
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
    @test getFilterDefs(columnsDictCols["a"]) == "valueParser: numberParser, filter: 'agNumberColumnFilter', "
    @test getFilterDefs(columnsDictCols["date"]) == test1
    @test getFilterDefs(Dict()) == ""
end

@testset "getColumnDefs test" begin
    columnsDictCols= Dict(
        "a" => Dict(
            "filter" => "number"
        ),
        "b" => Dict(
            "filter" => "text",
        ),
        "cols" => Dict(),
    ) 
    @test getColumnDefs((), Dict(), ()) == ("[]", "")
    @test getColumnDefs(("a", "b", "c", "date", "cols"), columnsDictCols, ("a", "b", "cols")) == test2
end

@testset "MethodError test" begin
    settings = (
        a = (
            filter = "text"
        )
    ) 
    @test_throws MethodError getFilterColumns(settings, "test")
    @test_throws MethodError getStyleDefs("", settings[:a], "")
    @test_throws MethodError getFilterDefs(settings[:a])
    @test_throws MethodError getColumnDefs((), settings, ())
end