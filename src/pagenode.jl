"""
    PageNode(input; visible, collapsed, navbar)
    PageNode(this_page, children; visible, collapsed, navbar)

Creates a `PageNode` object, which may have some children.

`input` can be anything that `pages` accepts in `Documenter.makedocs`,
for example a string, a pair of strings, a vector of strings or pairs, or any combination thereof.

You can also specify details for the toplevel page and its children separately in the two-argument constructor.

`navbar = false` hides this node from a writer's top-level navbar (e.g. DocumenterVitepress)
while keeping it in the sidebar. `visible = false` hides it everywhere, since it goes
through Documenter's own `NavNode` machinery.

## Examples

```julia
PageNode("index.md")
```

```julia
PageNode("Home" => "index.md")
```

```julia
PageNode(["index.md", "gallery.md"])
```

"""
struct PageNode
    # page contents
    page::Union{String, Nothing}
    children::Vector{PageNode}
    # metadata
    title_override::Union{String, Nothing}
    visible::Union{Bool, Nothing}
    collapsed::Union{Bool, Nothing} # nothing here indicates that we follow the global spec
    navbar::Union{Bool, Nothing} # false hides this node from a top-level navbar; nothing means shown
end

# TODO: kwarg constructor, setfield constructor,

PageNode(input::Pair; kw...) = PageNode(input[1], input[2]; kw...)
PageNode(input::String; visible = nothing, collapsed = nothing, navbar = nothing) = PageNode(input, PageNode[], nothing, visible, collapsed, navbar)
PageNode(title::String, source::String; visible = nothing, collapsed = nothing, navbar = nothing) = PageNode(source, PageNode[], title, visible, collapsed, navbar)
PageNode(pn::PageNode) = pn

function PageNode(input::Vector; visible = nothing, collapsed = nothing, navbar = nothing, kw...)

	children = PageNode.(input; kw...)
	return PageNode(nothing, children, nothing, visible, collapsed, navbar)

end

function PageNode(titlechildren::Pair{String, Vector}; visible = nothing, collapsed = nothing, navbar = nothing, kw...)

	children = PageNode.(titlechildren[2]; kw...)

	return PageNode(nothing, children, titlechildren[1], visible, collapsed, navbar)
end

function PageNode(original_page, children::Vector; kw...)
	pn1 = PageNode(original_page; kw...)

	@assert isempty(pn1.children) "You can't specify multiple children!  Look at the type of the first argument to this function."

	return PageNode(pn1.page, PageNode.(children; kw...), pn1.title_override, pn1.visible, pn1.collapsed, pn1.navbar)
end


function _show_page_node(io::IO, node::PageNode; kw...)
    if isnothing(node.page)
        print(io, node.title_override)
    else
        if isnothing(node.title_override)
            print(io, node.page)
        else
            print(io, node.title_override, " => ", node.page)
        end
    end
end

function Base.show(io::IO, ::MIME"text/plain", pn::PageNode)
    println(io, "PageNode $(pn.visible == false ? "(hidden) " : "")with $(length(pn.children)) children:")
    AbstractTrees.print_tree(_show_page_node, io, pn)
end
