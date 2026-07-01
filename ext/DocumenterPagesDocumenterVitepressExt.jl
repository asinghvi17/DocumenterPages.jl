module DocumenterPagesDocumenterVitepressExt

# DocumenterVitepress renders its sidebar/navbar via `pagelist2str`, which only
# dispatches on `String`/`Pair`; these methods teach it to render a `PageNode`.

using DocumenterPages: PageNode
import DocumenterVitepress

# Escape single quotes for the JS string literals in the generated config.
_esc(s) = replace(String(s), "'" => "\\'")

# Source path -> VitePress link: "/foo/bar" (no extension, forward slashes).
_link(page) = "/" * replace(splitext(page)[1], "\\" => "/")

# Display title: the explicit override, else the page's first heading.
function _title(doc, node::PageNode)
    isnothing(node.title_override) || return node.title_override
    isnothing(node.page) || return DocumenterVitepress.get_title(doc, node.page)
    return ""
end

# Wrap each child as a VitePress sidebar/navbar item object.
_items(doc, node, sidenav) =
    join(map(c -> "{" * DocumenterVitepress.pagelist2str(doc, c, sidenav) * "}", node.children), ",\n")

# Sidebar: a leaf renders as a link; with children it renders as a collapsible
# group whose header is itself a link whenever the node has a page.
function DocumenterVitepress.pagelist2str(doc, node::PageNode, sidenav::Val{:sidebar})
    name = _esc(_title(doc, node))
    linkpart = isnothing(node.page) ? "" : ", link: '$(_link(node.page))'"
    isempty(node.children) && return "text: '$(name)'$(linkpart)"
    # `collapsed === nothing` means "follow the default"; VitePress' default is expanded.
    collapsed = isnothing(node.collapsed) ? false : node.collapsed
    return "text: '$(name)'$(linkpart), collapsed: $(collapsed), items: [\n$(_items(doc, node, sidenav))\n]"
end

# Navbar: prefer a direct link; otherwise a dropdown of children; else plain text.
# `navbar === false` drops the node (the :sidebar method above doesn't check it).
function DocumenterVitepress.pagelist2str(doc, node::PageNode, sidenav::Val{:navbar})
    node.navbar === false && return ""
    name = _esc(_title(doc, node))
    if !isnothing(node.page)
        return "text: '$(name)', link: '$(_link(node.page))'"
    elseif !isempty(node.children)
        return "text: '$(name)', items: [\n$(_items(doc, node, sidenav))\n]"
    else
        return "text: '$(name)'"
    end
end

end
