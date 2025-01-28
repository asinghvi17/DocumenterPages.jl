
struct PageNode
    # page contents
    page::Union{String, Nothing}
    children::Vector{PageNode}
    # metadata
    title_override::Union{String, Nothing}
    visible::Union{Bool, Nothing}
    collapsed::Union{Bool, Nothing} # nothing here indicates that we follow the global spec
end
# TODO: kwarg constructor, setfield constructor, better show
# tree like show
# define AbstractTree interface on PageNode

PageNode(input::Pair; kw...) = PageNode(input[1], input[2]; kw...)
PageNode(input::String; visible = nothing, collapsed = nothing) = PageNode(input, PageNode[], nothing, visible, collapsed)
PageNode(title::String, source::String; visible = nothing, collapsed = nothing) = PageNode(source, PageNode[], title, visible, collapsed)

function PageNode(input::Vector; kw...)

	children = PageNode.(input; kw...)

	return PageNode(nothing, children, nothing, visible, collapsed)

end

function PageNode(titlechildren::Pair{String, Vector}; kw...)

	children = PageNode.(titlechildren[2]; kw...)

	return PageNode(nothing, children, titlechildren[1], visible, collapsed)
end

function PageNode(original_page, children::Vector; kw...)
	pn1 = PageNode(original_page; kw...)

	@assert isempty(pn1.children) "You can't specify multiple children!  Look at the type of the first argument to this function."

	return PageNode(pn1.page, PageNode.(children; kw...), pn1.title_override, pn1.visible, pn1.collapsed)
end


function Documenter.walk_navpages(page::PageNode, parent, doc)
    # parent can also be nothing (for top-level elements)
    parent_visible = isnothing(parent) || parent.visible
    if !isnothing(page.page)
        src = normpath(page.page)
        src in keys(doc.blueprint.pages) || error("'$src' is not an existing page!")
    end

    title = page.title_override
    visible = isnothing(page.visible) ? parent_visible : page.visible
    collapsed = page.collapsed # TODO we need NavNode support for this
    children = page.children

    nn = Documenter.NavNode(src, title, parent)
    (src === nothing) || push!(doc.internal.navlist, nn)
    nn.visible = parent_visible && visible
    nn.children = Documenter.walk_navpages(children, nn, doc)
    return nn
end