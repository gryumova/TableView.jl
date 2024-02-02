# test/unit

@testset "empty table" begin
    @test TableView.showtable(()) isa Nothing
end

@testset "named tuple table" begin
    table = [
        (a = 2.0, b = 3),
        (a = 3.0, b = 12)
    ]
    @test TableView.showtable(table) isa String
end

@testset "array" begin
    table = [
        (a = Inf, b = NaN, c = missing),
        (a = 3.0, b = 12, c = nothing)
    ]
    @test TableView.showtable(table) isa String
end

@testset "resize argument" begin
    data = (
        (a = 0, b = 1, c = 6),
        (a = 1, b = 35, c = 7),
        (a = 2, b = 134, c = 6),
        (a = 3, b = 868, c = 7),
        (a = 4, b = 34, c = 0),
    )
    @test TableView.showtable(data, resize=false) isa String
    @test TableView.showtable(data, resize=true) isa String
end

@testset "columnSettings argument" begin
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
            "style" => ( "color" => "red", "background" => "#FFFF79" )
    ))
    columnsDictText = Dict(
        "b" => Dict(
            "filter" => "text",
            "style" => ( "color" => "red", "background" => "#FFFF79" )
    ))
    columnsDictDate = Dict(
        "date" => Dict(
            "filter" => "date",
    )) 
    @test TableView.showTable(data, columnSettings=columnsDictDate) isa String
    @test TableView.showTable(data, columnSettings=columnsDictNumber) isa String
    @test TableView.showTable(data, columnSettings=columnsDictText) isa String
end
