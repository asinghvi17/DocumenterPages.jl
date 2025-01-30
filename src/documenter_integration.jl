# Integrate page nodes with Documenter.jl

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