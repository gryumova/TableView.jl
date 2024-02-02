@testset "URL Encoding" begin
    @testset "URL Query Parameter Encoding" begin
        @test EasyCurl.urlencode_query_params(Dict{String,Any}()) == ""
        @test EasyCurl.urlencode_query_params(Dict{String,Any}("a" => "b")) == "a=b"
    end
end