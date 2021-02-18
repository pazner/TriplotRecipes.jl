module TriplotRecipes

using PlotUtils,RecipesBase,TriplotBase

export tricontour,tricontour!,tripcolor,tripcolor!

function append_with_nan!(a,b)
    append!(a,b)
    push!(a,NaN)
end

@recipe function f(contours::Vector{TriplotBase.Contour{T}}) where {T}
    for c=contours
        x = T[]
        y = T[]
        z = T[]
        for polyline=c.polylines
            append_with_nan!(x,first.(polyline))
            append_with_nan!(y,last.(polyline))
            push!(z,c.level)
        end
        @series begin
            label := nothing
            line_z := z
            x,y
        end
    end
end

tricontour(x,y,z,t,levels;kw...) = RecipesBase.plot(TriplotBase.tricontour(x,y,z,t,levels);kw...)
tricontour!(x,y,z,t,levels;kw...) = RecipesBase.plot!(TriplotBase.tricontour(x,y,z,t,levels);kw...)

struct TriPseudocolor{X,Y,Z,T}
    x::X
    y::Y
    z::Z
    t::T
end

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

end
