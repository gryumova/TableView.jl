# test/unit

@testset "empty table" begin
    @test TableView.showTable(()) === ""
end

@testset "named tuple table" begin
    table = [
        (a = 2.0, b = 3),
        (a = 3.0, b = 12)
    ]
    @test TableView.showTable(table) isa String
end

@testset "array" begin
    table = [
        (a = Inf, b = NaN, c = missing),
        (a = 3.0, b = 12, c = nothing)
    ]
    @test TableView.showTable(table) isa String
end

@testset "resize argument" begin
    data = (
        (a = 0, b = 1, c = 6),
        (a = 1, b = 35, c = 7),
        (a = 2, b = 134, c = 6),
        (a = 3, b = 868, c = 7),
        (a = 4, b = 34, c = 0),
    )
    @test TableView.showTable(data, resize=false) isa String
    @test TableView.showTable(data, resize=true) isa String
end

@testset "columnSettings: filter type" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )
    columnsDictNumber = Dict(
        "a" => Dict(
            "filter" => "number",
    ))
    columnsDictText = Dict(
        "b" => Dict(
            "filter" => "text",
    ))
    columnsDictDate = Dict(
        "date" => Dict(
            "filter" => "date",
    )) 
    columnsDictCols= Dict(
        "a" => Dict(
                    "filter" => "number"
                ),
        "date" => Dict(
                    "filter" => "date",
                ),
        "cols" => Dict(),
    ) 
    @test TableView.showTable(data, columnSettings=columnsDictDate) isa String
    @test TableView.showTable(data, columnSettings=columnsDictNumber) isa String
    @test TableView.showTable(data, columnSettings=columnsDictCols) isa String
end

@testset "columnSettings: cell style" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )
    columnsDict= Dict(
        "a" => Dict(
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "background" => "rgb(226, 73, 73)",
            )
    ))
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
    @test TableView.showTable(data, columnSettings=columnsDict) isa String
    @test TableView.showTable(data, columnSettings=columnsDictEqual) isa String
    @test TableView.showTable(data, columnSettings=columnsDictThreshold) isa String
end
