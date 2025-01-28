# DocumenterPages

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://asinghvi17.github.io/DocumenterPages.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://asinghvi17.github.io/DocumenterPages.jl/dev/)
[![Build Status](https://github.com/asinghvi17/DocumenterPages.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/asinghvi17/DocumenterPages.jl/actions/workflows/CI.yml?query=branch%3Amain)

```julia-repl
julia> using DocumenterPages

julia> PageNode("src.md" => "notatitle")
PageNode("notatitle", PageNode[], "src.md", nothing, nothing)

julia> PageNode("Examples" => ["helk" => "helk.md", "park.md"])
PageNode("Examples", PageNode[PageNode("helk.md", PageNode[], "helk", nothing, nothing), PageNode("park.md", PageNode[], nothing, nothing, nothing)], nothing, nothing, nothing)

julia> PageNode("Examples" => "gallery.md", ["helk" => "helk.md", "park.md"])
PageNode("gallery.md", PageNode[PageNode("helk.md", PageNode[], "helk", nothing, nothing), PageNode("park.md", PageNode[], nothing, nothing, nothing)], "Examples", nothing, nothing)
```
