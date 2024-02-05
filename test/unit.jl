# test/unit

@testset "empty table" begin
    @test TableView.show_table(()) === ""
end

@testset "named tuple table" begin
    table = [
        (a = 2.0, b = 3),
        (a = 3.0, b = 12)
    ]
    @test TableView.show_table(table) isa String
end

@testset "array" begin
    table = [
        (a = Inf, b = NaN, c = missing),
        (a = 3.0, b = 12, c = nothing)
    ]
    @test TableView.show_table(table) isa String
end

@testset "resize argument" begin
    data = (
        (a = 0, b = 1, c = 6),
        (a = 1, b = 35, c = 7),
        (a = 2, b = 134, c = 6),
        (a = 3, b = 868, c = 7),
        (a = 4, b = 34, c = 0),
    )
    @test TableView.show_table(data, resize=false) isa String
    @test TableView.show_table(data, resize=true) isa String
end

@testset "column_settings: filter type" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )
    columns_number = Dict(
        "a" => Dict(
            "filter" => "number",
    ))  
    columns_date = Dict(
        "date" => Dict(
            "filter" => "date",
    )) 
    columns_cols= Dict(
        "a" => Dict(
                    "filter" => "number"
                ),
        "date" => Dict(
                    "filter" => "date",
                ),
        "cols" => Dict(),
    ) 
    @test TableView.show_table(data, column_settings=columns_date) isa String
    @test TableView.show_table(data, column_settings=columns_number) isa String
    @test TableView.show_table(data, column_settings=columns_cols) isa String
end

@testset "column_settings: cell style" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )
    columns_dict= Dict(
        "a" => Dict(
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "background" => "rgb(226, 73, 73)",
            )
    ))
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
    @test TableView.show_table(data, column_settings=columns_dict) isa String
    @test TableView.show_table(data, column_settings=columns_dict_equal) isa String
    @test TableView.show_table(data, column_settings=columns_dict_threshold) isa String
end

@testset "column_settings: cell style" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )

    columns_dict= Dict(
        "a" => Dict(
            "filter" => "number",
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "background" => "rgb(226, 73, 73)",
            )
        ),
        "c" => Dict(
            "filter" => "text",
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "equals" => 7
            )
        ),
        "b" => Dict(
            "style" => Dict(
                "colorUp" => "rgb(134, 208, 134)",
                "colorDown" => "rgb(226, 73, 73)",
                "threshold" => 35
            )
        ),
        "date" => Dict(
            "filter" => "date",
        )
    ) 


    io = open("./index.html", "r");
    expected = read(io, String);
    close(io);

    file = TableView.show_table(data, column_settings=columns_dict)
    io = open(file, "r");
    received = read(io, String);
    close(io);

    @test received == expected
end

@testset "MethodError test" begin
    settings = (
        a = (
            filter = "text"
        )
    ) 
    data = (
        (a = 0, b = 1),
    )
    @test_throws TypeError TableView.show_table((), column_settings=settings)
    @test_throws TypeError TableView.show_table(data, column_settings=())
end