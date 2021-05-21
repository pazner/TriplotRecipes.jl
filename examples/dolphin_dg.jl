using Plots,DelimitedFiles,TriplotRecipes

f(x,y) = exp(0.1*sin(5.1*x + -6.2*y) + 0.3*cos(4.3*x + 3.4*y))

x,y = eachcol(readdlm(joinpath(@__DIR__,"dolphin.xy")))
t = readdlm(joinpath(@__DIR__,"dolphin.t"),Int)' .+ 1
z = f.(x,y)
z_dg = similar(t, eltype(z))

for it=1:size(t,2)
    z_dg[:,it] .= z[t[:,it]] .+ 0.05*(rand() - 0.5)
end

plot(aspect_ratio=:equal,size=(800,720))
dgtripcolor!(x,y,z_dg,t,color=:magma)
trimesh!(x,y,t,fillalpha=0.0,linecolor=:white)
savefig("dolphin_dg.png")
