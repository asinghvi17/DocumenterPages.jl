using DocumenterPages, AbstractTrees
using DocumenterVitepress  # activates DocumenterPagesDocumenterVitepressExt
using Test

@testset "DocumenterPages.jl" begin

    @testset "Basic construction" begin
        # Test basic PageNode construction
        pn1 = PageNode("test.md")
        @test pn1.page == "test.md"
        @test isempty(pn1.children)
        @test isnothing(pn1.title_override)
        @test isnothing(pn1.visible)
        @test isnothing(pn1.collapsed)

        # Test title override
        pn2 = PageNode("Title" => "test.md")
        @test pn2.page == "test.md" 
        @test pn2.title_override == "Title"

        # Test nested structure
        pn3 = PageNode([
            "page1.md",
            "Section" => [
                "page2.md",
                "page3.md"
            ]
        ])
        @test isnothing(pn3.page)
        @test length(pn3.children) == 2
        @test pn3.children[1].page == "page1.md"
        @test pn3.children[2].page === "Section"
        @test length(pn3.children[2].children) == 2

        # Test visibility and collapse settings
        pn4 = PageNode("test.md", visible=false, collapsed=true)
        @test pn4.visible === false
        @test pn4.collapsed === true
    end

    @testset "AbstractTrees interface" begin
        # Test basic PageNode construction and tree structure
        simple_page = PageNode("test.md")
        @test nodevalue(simple_page) == "test.md"
        @test isempty(children(simple_page))

        # Test nested structure from README example
        example_tree = PageNode("Examples" => "gallery.md", ["helk" => "helk.md", "park.md"])
        
        # Test structure
        @test nodevalue(example_tree) == "gallery.md"
        @test length(children(example_tree)) == 2
        @test nodevalue(children(example_tree)[1]) == "helk.md"
        @test nodevalue(children(example_tree)[2]) == "park.md"

        # Test tree traversal
        leaves = collect(Leaves(example_tree))
        @test length(leaves) == 2
        @test all(leaf -> isempty(children(leaf)), leaves)
        
        # Test tree printing matches expected structure
        printed_tree = sprint(print_tree, example_tree)
        @test occursin("gallery.md", printed_tree)
        @test occursin("helk.md", printed_tree)
        @test occursin("park.md", printed_tree)
    end

    @testset "DocumenterVitepress extension" begin
        # Every node carries a title override, so get_title (which needs a real
        # Documenter doc) is never reached and we can pass `nothing` for `doc`.
        node = PageNode("Platform Features" => "tutorials/index.md",
            ["Applications" => "tutorials/applications/index.md",
             "DataSets" => "tutorials/datasets/index.md"])

        # Sidebar: header is a link AND a collapsible parent of its children.
        side = DocumenterVitepress.pagelist2str(nothing, node, Val(:sidebar))
        @test occursin("text: 'Platform Features'", side)
        @test occursin("link: '/tutorials/index'", side)
        @test occursin("collapsed:", side)
        @test occursin("items:", side)
        @test occursin("link: '/tutorials/applications/index'", side)
        @test occursin("link: '/tutorials/datasets/index'", side)

        # Navbar: prefers the direct link over a dropdown.
        nav = DocumenterVitepress.pagelist2str(nothing, node, Val(:navbar))
        @test occursin("text: 'Platform Features'", nav)
        @test occursin("link: '/tutorials/index'", nav)
        @test !occursin("items:", nav)

        # A childless PageNode is a plain leaf link.
        leaf = PageNode("Solo" => "solo.md")
        @test DocumenterVitepress.pagelist2str(nothing, leaf, Val(:sidebar)) == "text: 'Solo', link: '/solo'"

        # collapsed=true is honoured; an apostrophe in the title is escaped.
        collapsed_node = PageNode("What's New" => "news.md", ["v1" => "v1.md"]; collapsed=true)
        cs = DocumenterVitepress.pagelist2str(nothing, collapsed_node, Val(:sidebar))
        @test occursin("collapsed: true", cs)
        @test occursin("text: 'What\\'s New'", cs)
    end

end
