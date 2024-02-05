# Scripts

function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

@testset "Scripts" begin
    @testset "Case №1: Empty dict" begin

        EMPTY_DICT_RESIZE = read_file("templates/emptyDictResize.html")
    
        EMPTY_DICT_NOT_RESIZE = read_file("templates/emptyDictNotResize.html")
    
        data = (
            (a = 0, b = 1, c = 6, date = "2022-05-03"),
            (a = 1, b = 35, c = 7, date = "2022-06-02"),
            (a = 2, b = 134, c = 6, date = "2022-03-10"),
            (a = 3, b = 868, c = 7, date = "2022-01-08"),
            (a = 4, b = 34, c = 0, date = "2022-08-01"),
        )
    
        @test TableView.get_aggrid_scripts(Dict(), data, "") == EMPTY_DICT_RESIZE
        @test TableView.get_aggrid_scripts(Dict(), data, "minWidth: 150") == EMPTY_DICT_NOT_RESIZE
    end
    
    @testset "Case №2: Different style" begin
    
        DIFFERENT_STYLE = read_file("templates/differentStyle.html")
    
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
    
        @test TableView.get_aggrid_scripts(columns_dict, data, "") == DIFFERENT_STYLE
    end
    
    @testset "Case №3: Different filter" begin
    
        DIFFERENT_FILTER = read_file("templates/differentFiter.html")
    
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
    
        @test TableView.get_aggrid_scripts(columns_dict_number, data, "") == DIFFERENT_FILTER
    end
    
    @testset "Case №4: MethodError test" begin
        data = ()
        settings = (a = (filter = "text"))
    
        @test_throws MethodError TableView.get_aggrid_scripts(settings, data, "")
    end
end
