module DocumenterPages

using Documenter
using AbstractTrees

include("pagenode.jl")
include("documenter_integration.jl")
include("trees.jl")

export PageNode

end
