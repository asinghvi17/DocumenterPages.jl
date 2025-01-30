# # AbstractTrees interface definitions
# This is mainly useful for the `show` method,
# but it's also useful for testing,
# as well as general tree traversal.

AbstractTrees.children(pn::PageNode) = pn.children
AbstractTrees.nodevalue(pn::PageNode) = pn.page
AbstractTrees.ParentLinks(::Type{PageNode}) = AbstractTrees.ImplicitParents()
AbstractTrees.SiblingLinks(::Type{PageNode}) = AbstractTrees.ImplicitSiblings()
AbstractTrees.ChildIndexing(::Type{PageNode}) = AbstractTrees.IndexedChildren()
