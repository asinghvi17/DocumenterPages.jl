```@meta
CurrentModule = DocumenterPages
```

# DocumenterPages

Documentation for [DocumenterPages](https://github.com/asinghvi17/DocumenterPages.jl).
DocumenterPages.jl provides a flexible way to define page structures in Documenter.jl documentation.

When building documentation with Documenter.jl, you typically need to specify the pages and their hierarchy in the `pages` keyword argument of `makedocs`. However, the default syntax can become unwieldy for complex documentation structures with many nested pages and sections.

This package introduces the `PageNode` type that makes it easier to:

- Define hierarchical page structures in a more natural way
- Control page visibility and collapsing behavior

For example, it's impossible to have a page that is also a section in Documenter.jl.  Let's say I have an example gallery, and other individual example pages.

Currently, I would have to structure it so that the gallery is a separate toplevel section, and the individual examples are children of some other toplevel section:

```julia
pages = [
    "Home" => "index.md",
    "Gallery" => "gallery.md",
    "Examples" => [
        "helk.md",
        "park.md"
    ]
]
```


But what if I want a user to be able to click on the "Examples" section, and have it take them to the gallery page?

With DocumenterPages.jl, I can do this:

```julia
pages = [
    "Home" => "index.md",
    "Examples" => PageNode("gallery.md", ["helk" => "helk.md", "park" => "park.md"])
]
```

and now the "Examples" page is clickable (as you can see in this documentation), **and** it has children that are also clickable.

That's the idea behind DocumenterPages!

