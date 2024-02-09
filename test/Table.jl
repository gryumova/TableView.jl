# Scripts

function read_file(file::String)
    io = open(file, "r");
    str = read(io, String);
    close(io);

    return str
end

@testset "Scripts" begin
    @testset "Case №1: Generating HTML test" begin
        data = (
            (a = 0, b = 1, c = 6),
            (a = 1, b = 35, c = 7),
            (a = 2, b = 134, c = 6),
            (a = 3, b = 868, c = 7),
            (a = 4, b = 34, c = 0),
        )

        settings = Dict(
            "a" => Dict(
                "filter" => "number",
                "style" => Dict(
                    "color" => "red",
                    "background" => "#FFFF79"
                ),
                "formatter" => Dict(
                    "short" => true,
                    "style" => "percent",
                    "separator" => true,
                ),
            ),
            "c" => Dict(
                "filter" => "text",
                "style" => Dict(
                "text-align" => "center",
                )
            ),
            "cols" => Dict()
        )

        TableView.show_table(data, column_settings=settings, resize=false, out_file="./index.html")

        @test read_file("./index.html") == read_file("templates/example.html")
    end

    @testset "Case №2: MethodError test and empty table" begin
        data = ()
        settings = (a = (filter = "text"))
        @test TableView.show_table(data, column_settings=Dict()) == ""
        @test_throws MethodError TableView.show_table(data, column_settings=settings)
    end
end
