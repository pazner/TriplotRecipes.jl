module TriplotRecipes

using PlotUtils,RecipesBase,TriplotBase

export tricontour,tricontour!,tripcolor,tripcolor!,trimesh,trimesh!

function append_with_nan!(a,b)
    append!(a,b)
    push!(a,NaN)
end

@recipe function f(contours::Vector{TriplotBase.Contour{T}}) where {T}
    color = get(plotattributes, :seriescolor, :auto)
    set_line_z = (color == :auto || plot_color(color) isa ColorGradient)
    for c=contours
        x = T[]
        y = T[]
        z = T[]
        for polyline=c.polylines
            append_with_nan!(x,first.(polyline))
            append_with_nan!(y,last.(polyline))
            append!(z,fill(c.level,length(polyline)))
        end
        @series begin
            label := nothing
            if set_line_z
                line_z := z
            end
            x,y
        end
    end
end

tricontour(x,y,z,t,levels;kw...) = RecipesBase.plot(TriplotBase.tricontour(x,y,z,t,levels);kw...)
tricontour!(x,y,z,t,levels;kw...) = RecipesBase.plot!(TriplotBase.tricontour(x,y,z,t,levels);kw...)

struct TriPseudocolor{X,Y,Z,T} x::X; y::Y; z::Z; t::T; end

@recipe function f(p::TriPseudocolor;px=512,py=512,ncolors=256)
    cmap = range(extrema(p.z)...,length=ncolors)
    x = range(extrema(p.x)...,length=px)
    y = range(extrema(p.y)...,length=py)
    z = TriplotBase.tripcolor(p.x,p.y,p.z,p.t,cmap;bg=NaN,px=px,py=py)
    seriestype := :heatmap
    x,y,z'
end

tripcolor(x,y,z,t;kw...) = RecipesBase.plot(TriPseudocolor(x,y,z,t);kw...)
tripcolor!(x,y,z,t;kw...) = RecipesBase.plot!(TriPseudocolor(x,y,z,t);kw...)

struct TriMesh{X,Y,T} x::X; y::Y; t::T; end

@recipe function f(m::TriMesh)
    x = Vector{eltype(m.x)}()
    y = Vector{eltype(m.y)}()
    for t=eachcol(m.t)
        append_with_nan!(x,[m.x[t];m.x[t[1]]])
        append_with_nan!(y,[m.y[t];m.y[t[1]]])
    end
    seriestype := :shape
    seriescolor --> RGB(0.7,1.0,0.8)
    label --> nothing
    x,y
end

trimesh(x,y,t;kw...) = RecipesBase.plot(TriMesh(x,y,t);kw...)
trimesh!(x,y,t;kw...) = RecipesBase.plot!(TriMesh(x,y,t);kw...)

end
