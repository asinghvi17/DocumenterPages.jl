
struct PageNode
    # page contents
    page::Union{String, Nothing}
    children::Vector{PageNode}
    # metadata
    title_override::Union{String, Nothing}
    visible::Union{Bool, Nothing}
    collapsed::Union{Bool, Nothing} # nothing here indicates that we follow the global spec
end

# TODO: kwarg constructor, setfield constructor,

PageNode(input::Pair; kw...) = PageNode(input[1], input[2]; kw...)
PageNode(input::String; visible = nothing, collapsed = nothing) = PageNode(input, PageNode[], nothing, visible, collapsed)
PageNode(title::String, source::String; visible = nothing, collapsed = nothing) = PageNode(source, PageNode[], title, visible, collapsed)

function PageNode(input::Vector; visible = nothing, collapsed = nothing, kw...)

	children = PageNode.(input; kw...)
	return PageNode(nothing, children, nothing, visible, collapsed)

end

function PageNode(titlechildren::Pair{String, Vector}; visible = nothing, collapsed = nothing, kw...)

	children = PageNode.(titlechildren[2]; kw...)

	return PageNode(nothing, children, titlechildren[1], visible, collapsed)
end

function PageNode(original_page, children::Vector; kw...)
	pn1 = PageNode(original_page; kw...)

	@assert isempty(pn1.children) "You can't specify multiple children!  Look at the type of the first argument to this function."

	return PageNode(pn1.page, PageNode.(children; kw...), pn1.title_override, pn1.visible, pn1.collapsed)
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
