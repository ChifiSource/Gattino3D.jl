module Gattino3D
using Gattino
using Gattino.ToolipsSVG
using Gattino.Toolips
using Gattino: AbstractContext, axes!, Servable, draw!, randstring
import Gattino: axes!, points!, gridlabels!, grid!, AbstractContext, context, line!

mutable struct Context3D <: AbstractContext
    window::Component{:svg}
    uuid::String
    dim::Tuple{Int64, Int64, Int64}
    margin::Tuple{Int64, Int64, Int64}
    Context3D(wind::Component{:svg}, depth::Int64, margin::Tuple{Int64, Int64, Int64}) = begin
        new(wind, randstring(), (wind[:width], wind[:height], depth),
            margin)::Context3D
    end
    Context3D(width::Int64 = 1280, height::Int64 = 720, depth::Int64 = 100,
        margin::Tuple{Int64, Int64, Int64} = (0, 0, 0)) = begin
        window::Component{:svg} = svg("window", width = width,
        height = height)
        Context3D(window, depth, margin)::Context3D
    end
end

function context(f::Function, width::Int64, height::Int64, depth::Int64; margin::Tuple{Int64, Int64, Int64} = (0, 0, 0))
    con = Context3D(width, height, depth, margin)
    f(con)
    con::Context3D
end

function axes!(con::Context3D, styles::Pair{String, <:Any} ...)
    if length(styles) == 0
        styles = ("fill" => "none", "stroke" => "black", "stroke-width" => "4")
    end
    depth = con.dim[3]
    line!(con, con.margin[1] => con.dim[2] + con.margin[2],
     con.dim[1] + con.margin[1] => con.dim[2] + con.margin[2], styles ...)
    line!(con, con.margin[1] => con.margin[2],
     con.margin[1] => con.dim[2] + con.margin[2], styles ...)
    otherangle = 180 - 90 - (90 - 45) 
    xside = Int64(round(sin(45) * depth / sin(90)))
    Gattino.line!(con, 0 => con.dim[2], 0 + xside => con.dim[2] - xside)
end

function grid!(con::Context3D, divisions::Int64 = 4, styles::Pair{String, String} ...)
    if length(styles) == 0
        styles = ("fill" => "none", "stroke" => "lightblue", "stroke-width" => "1", "opacity" => 80percent)
    end
    mx = con.margin[1]
    my = con.margin[2]
    division_amountx::Int64 = round((con.dim[1]) / divisions)
    division_amounty::Int64 = round((con.dim[2]) / divisions)
    division_amountz::Int64 = round(con.dim[3] / divisions)
    [begin
        line!(con, xcoord + mx => 0 + my, xcoord + mx => con.dim[2] + my, styles ...)
        line!(con, 0 + mx => ycoord + my, con.dim[1] + mx => ycoord + my, styles ...)
        otherangle = 180 - 90 - 45
        xside = Int64(round(sin(45) * zcoord / sin(90)))
        line!(con, 0 + mx + xside => con.dim[2] + my - xside, con.dim[2] + mx + xside => con.dim[2] + my - xside, styles ...)
        end for (xcoord, ycoord, zcoord) in zip(
    range(1, con.dim[1],
    step = division_amountx), range(1, con.dim[2], step = division_amounty), range(1, con.dim[3], step = division_amountz))]
end

function points!(con::Context3D, x::Vector{<:Number}, y::Vector{<:Number}, z::Vector{<:Number},
    styles::Pair{String, <:Any} ...)
   if length(styles) == 0
       styles = ("fill" => "orange", "stroke" => "lightblue", "stroke-width" => "0")
   end
   depth = con.dim[3]
   angle = 45
   xmax::Number, ymax::Number, zmax::Number = maximum(x), maximum(y), maximum(z)
    percvec_x = map(n::Number -> n / xmax, x)
    percvec_y = map(n::Number -> n / ymax, y)
   percvec_z = map(n::Number -> n / zmax, z)
   draw!(con, Vector{Servable}([begin
       c = circle(randstring(), cx = pointx * con.dim[1] + con.margin[1],
               cy = con.dim[2] - (con.dim[2] * pointy) + con.margin[2], r = 20 - (20 * pointz))
       style!(c, styles ...)
       xside = Int64(round(sin(angle) * (depth * pointz) / sin(90)))
       c[:cy] -= xside
       c[:cx] += xside
       c
end for (pointx, pointy, pointz) in zip(percvec_x, percvec_y, percvec_z)]))
end

function line!(con::AbstractContext, x::Vector{<:Number}, y::Vector{<:Number}, z::Vector{<:Number},
    styles::Pair{String, <:Any} ...)
if length(styles) == 0
    styles = ("fill" => "none", "stroke" => "black", "stroke-width" => "4")
end
if length(x) != length(y)
    throw(DimensionMismatch("x and y, of lengths $(length(x)) and $(length(y)) are not equal!"))
end
xmax::Number, ymax::Number, zmax::Number = maximum(x), maximum(y), maximum(z)
percvec_x = map(n::Number -> n / xmax, x)
percvec_y = map(n::Number -> n / ymax, y)
percvec_z = map(n::Number -> n / zmax, z)
line_data = join([begin
                xside = Int64(round(sin(45) * (con.dim[3] * zper) / sin(90)))
                scaled_x::Int64 = round(con.dim[1] * xper)  + con.margin[1] + xside
                scaled_y::Int64 = con.dim[2] - round(con.dim[2] * yper)  + con.margin[2] - xside
                "$(scaled_x)&#32;$(scaled_y),"
            end for (xper, yper, zper) in zip(percvec_x, percvec_y, percvec_z)])
line_comp = ToolipsSVG.polyline("newline", points = line_data)
style!(line_comp, styles ...)
draw!(con, [line_comp])
end


end # module Gattino3D
