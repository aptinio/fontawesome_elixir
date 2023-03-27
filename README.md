# FontAwesome

[Font Awesome](https://fontawesome.com) is the Internet's icon library and toolkit,
used by millions of designers, developers, and content creators.

This provides precompiled SVG icons from
[Font Awesome Free 6.3.0](https://fontawesome.com/search?o=r&m=free).

## Installation

Add FontAwesome to your `mix.exs`:

```elixir
defp deps do
  [
    {:fontawesome, "~> 0.1.0"}
  ]
end
```

After that, run `mix deps.get`.

## Usage

By default, the regular style is used. If that is not available, solid or brands is used.
This could be changed by providing the `solid` or `brands` attributes.

Arbitrary HTML attributes can also be passed and applied to the svg tag.

## Examples

```heex
<FontAwesome.heart />
<FontAwesome.heart solid />
<FontAwesome.heart class="h-4 w-4" />
```

The docs can be read at <https://hexdocs.pm/fontawesome>.

This was inspired by the [Heroicons](https://hex.pm/packages/heroicons) library.
Huge thanks to its [contributors](https://github.com/mveytsman/heroicons_elixir/graphs/contributors).

This work was supported by [Webformix](https://www.webformix.com). Huge thanks to them.
