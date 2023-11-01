<div align="center">
<img src="https://github.com/ChifiSource/image_dump/blob/main/gattino/gattino3D.png"></img>
<h6>gattino 3D</h6>
</div>

**Gattino3D** is an extension for [Gattino](https://github.com/ChifiSource/Gattino.jl) which adds the `Context3D` and several [context plotting]() methods for plotting with a Z axis. Both `Gattino` and `Gattino3D` are still **work-in-progress** modules, as of right now this module is especially limited. To create a 3D context, use
```julia
plt = context(500, 500, 200) do con::Context

end
```
As of right now, the scope of this package is limited to only a few functions.
- `grid!`
- `axes!`
- `line!`
- `scatter!`

```julia
mycon = Gattino3D.context(500, 500, 200) do con
    Gattino3D.axes!(con)
    Gattino3D.grid!(con, 6)
    Gattino3D.points!(con, [1, 5, 10], [1, 5, 10], [1, 5, 10])
    Gattino3D.points!(con, Vector(1:10), [1, 1, 1, 1, 1, 1, 1, 1, 1, 10], [3, 1, 3, 1, 6, 1, 3, 1, 2, 10], 
    "fill" => "blue")
    Gattino3D.line!(con, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10], [0, 1, 0, 1, 0, 1, 0, 1, 0, 10], "stroke" => "green", "fill" => "none", 
"stroke-width" => 10px)
end
```

<img src="https://github.com/ChifiSource/image_dump/blob/main/gattino/docsc/3dexample.png"></img>

For the most part, using this package is just using `Gattino`, but providing a **third z** `Vector`. For more information on this, there is a write-up on using `Gattino` [here](https://github.com/ChifiSource/Gattino.jl/tree/Unstable#visualizations)
