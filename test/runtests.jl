using Test

@testset "TriplotRecipes.jl tests" begin
  @testset "dolphin.jl" begin
    @test_nowarn include(joinpath(dirname(@__DIR__), "examples", "dolphin.jl"))
  end

  @testset "dolphin_dg.jl" begin
    @test_nowarn include(joinpath(dirname(@__DIR__), "examples", "dolphin_dg.jl"))
  end
end
