defmodule FontAwesomeTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  test "styles" do
    assert_svg(&FontAwesome.heart/1, :solid)
    assert_svg(&FontAwesome.font_awesome/1, :brands)
    assert_svg(&FontAwesome.font_awesome/1, :solid)
  end

  defp assert_svg(component, style) do
    svg = render_component(component)
    assert svg =~ ~s'<svg xmlns="http://www.w3.org/2000/svg"'
    assert svg =~ ~s'aria-hidden'
    assert svg =~ ~s'fill="currentColor"'
    assert svg =~ ~s'license'
    assert svg =~ ~s'<path '
    assert render_component(component, fill: "red") =~ ~s'fill="red"'

    styled = render_component(component, %{style => true})
    assert svg =~ ~s'<svg xmlns="http://www.w3.org/2000/svg"'
    assert svg =~ ~s'aria-hidden'
    assert svg =~ ~s'fill="currentColor"'
    assert svg =~ ~s'license'
    assert svg =~ ~s'<path '
    assert render_component(component, %{style => true, fill: "red"}) =~ ~s'fill="red"'

    assert svg != styled
  end

  test "raises on mixed styles" do
    assert_raise ArgumentError, "expected either brands or solid, but got both.", fn ->
      render_component(&FontAwesome.font_awesome/1, brands: true, solid: true)
    end
  end

  test "generated docs" do
    {:docs_v1, _annotation, _beam_language, _format, _module_doc, _metadata, docs} =
      Code.fetch_docs(FontAwesome)

    doc =
      Enum.find_value(docs, fn
        {{:function, :font_awesome, 1}, _annotation, _signature, doc, _metadata} -> doc
        _ -> nil
      end)

    assert doc["en"] == """
           Renders the `font-awesome` icon.

           ## Examples

           ```heex
           <FontAwesome.font_awesome />
           <FontAwesome.font_awesome class="h-4 w-4" />
           <FontAwesome.font_awesome brands />
           <FontAwesome.font_awesome solid />
           ```

           ## Attributes

           * `brands` (`:boolean`) - Defaults to `false`.
           * `solid` (`:boolean`) - Defaults to `false`.
           * `rest` (`:global`) - Supports all globals plus: `["fill"]`.
           """
  end
end
