defmodule Mix.Tasks.Gen do
  use Mix.Task
  require Logger

  @vsn "6.4.2"

  @intro """
  [Font Awesome](https://fontawesome.com) is the Internet's icon library and toolkit,
  used by millions of designers, developers, and content creators.

  This provides precompiled SVG icons from
  [Font Awesome Free #{@vsn}](https://fontawesome.com/search?o=r&m=free).\
  """

  @usage """
  ## Usage

  By default, the regular style is used. If that is not available, solid or brands is used.
  This could be changed by providing the `solid` or `brands` attributes.

  Arbitrary HTML attributes can also be passed and applied to the svg tag.

  ## Examples

  ```heex
  <FontAwesome.heart />
  <FontAwesome.heart solid />
  <FontAwesome.heart class="h-4 w-4" />
  ```\
  """

  @impl true
  def run(_command_line_args) do
    tmp_dir = Path.join(System.tmp_dir!(), "fontawesome_elixir")
    File.rm_rf!(tmp_dir)

    "https://github.com/FortAwesome/Font-Awesome/releases/download/#{@vsn}/fontawesome-free-#{@vsn}-desktop.zip"
    |> fetch_body!
    |> unzip!(tmp_dir)

    file_paths =
      [tmp_dir, "fontawesome-free-#{@vsn}-desktop", "svgs", "*", "*.svg"]
      |> Path.join()
      |> Path.wildcard()

    [attribution] =
      file_paths
      |> hd()
      |> File.read!()
      |> scan(~r/<!--.*?-->/)

    svgs =
      file_paths
      |> Enum.reduce(%{}, fn file_path, svgs ->
        [[_, view_box, path]] =
          file_path
          |> File.read!()
          |> scan(~r/viewBox="(.*?)".*?(<path .*?\/>)<\/svg>/)

        style = style(file_path)
        svg = %{view_box: view_box, path: path}
        Map.update(svgs, name(file_path), %{style => svg}, &Map.put(&1, style, svg))
      end)

    svgs =
      svgs
      |> Map.keys()
      |> Enum.sort()
      |> Enum.map(fn key -> {key, Map.fetch!(svgs, key)} end)

    __DIR__
    |> Path.join("fontawesome.eex")
    |> Mix.Generator.copy_template(
      "lib/fontawesome.ex",
      [attribution: attribution, intro: @intro, svgs: svgs, usage: @usage],
      force: true
    )

    app_vsn =
      :fontawesome
      |> Application.spec(:vsn)
      |> to_string()
      |> Version.parse!()
      |> then(fn %{major: major, minor: minor} -> "#{major}.#{minor}" end)

    __DIR__
    |> Path.join("README.eex")
    |> Mix.Generator.copy_template(
      "README.md",
      [intro: @intro, app_vsn: app_vsn, usage: @usage],
      force: true
    )

    Mix.Task.run("format")
  end

  defp fetch_body!(url) do
    Logger.debug("Downloading Font Awesome from #{url}")
    {:ok, _} = Application.ensure_all_started(:req)
    Req.get!(url).body
  end

  defp unzip!(zip, cwd) do
    case :zip.unzip(zip, cwd: to_charlist(cwd)) do
      {:ok, _} -> :ok
      other -> "couldn't unzip archive: #{inspect(other)}"
    end
  end

  defp scan(string, regex), do: Regex.scan(regex, string)

  defp name(file_path) do
    file_path
    |> Path.basename()
    |> Path.rootname()
    |> String.split("-")
    |> Enum.join("_")
    |> String.replace(~r/\A(\d)/, "_\\1")
  end

  defp style(file_path) do
    file_path |> Path.dirname() |> Path.basename() |> String.to_atom()
  end
end
