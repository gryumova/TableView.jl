include("../../src/Scripts.jl")
include("scripts_test_constants.jl")

@testset "empty dict" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )

    @test get_aggrid_scripts(Dict(), data, "") == test_2
    @test get_aggrid_scripts(Dict(), data, "minWidth: 150") == test_3
end

@testset "empty different style" begin
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
            ),
        ),
        "c" => Dict(
            "style" => Dict(
                "color" => "rgb(134, 208, 134)",
                "equals" => 7
            ),
        ),
        "b" => Dict(
            "style" => Dict(
                "colorUp" => "rgb(134, 208, 134)",
                "colorDown" => "rgb(226, 73, 73)",
                "threshold" => 35
            )
        )
    )


    @test get_aggrid_scripts(columns_dict, data, "") == test_1
end

@testset "empty different filter" begin
    data = (
        (a = 0, b = 1, c = 6, date = "2022-05-03"),
        (a = 1, b = 35, c = 7, date = "2022-06-02"),
        (a = 2, b = 134, c = 6, date = "2022-03-10"),
        (a = 3, b = 868, c = 7, date = "2022-01-08"),
        (a = 4, b = 34, c = 0, date = "2022-08-01"),
    )
    
    columns_dict_number = Dict(
        "a" => Dict(
            "filter" => "number",
        ),
        "b" => Dict(
            "filter" => "text",
        ),
        "date" => Dict(
            "filter" => "date",
        ),
        "cols" => Dict(),
    ) 


    @test get_aggrid_scripts(columns_dict_number, data, "") == test_4
end

@testset "MethodError test" begin
    data = ()
    settings = (
        a = (
            filter = "text"
        )
    ) 
    @test_throws MethodError get_aggrid_scripts(settings, data, "")
end