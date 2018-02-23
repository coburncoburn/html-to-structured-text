defmodule HtmlToPrismic do

  @moduledoc ~s"""
  turn a parsed floki html document into the structured tex
  format used by prismic
  """
  @type html_tree :: tuple | list
  @spec get(html_tree, binary) :: binary


  def get(html_tree, sep \\ "") do
    get_text(html_tree, {"", []}, sep)
  end

  defp get_text(text, {"", starts}, _sep) when is_binary(text), do: {text, starts}

  defp get_text(text, {acc, starts}, sep) when is_binary(text) do
    {Enum.join([acc, text], sep), starts}
  end

  defp get_text(nodes, acc, sep) when is_list(nodes) do
    Enum.reduce nodes, acc, fn(child, {acc1, starts}) ->
      get_text(child, {acc1, starts}, sep)
    end
  end

  defp get_text({tag, attrs}, nodes, acc = {first_text, startss}, sep) when is_list(nodes) do
    {new_text, things} = Enum.reduce nodes, acc, fn(child, {acc1, starts}) ->
      get_text(child, {acc1, starts}, sep)
    end


    start = String.length(first_text)
    endd = String.length(new_text)
    data = %{start: start, end: endd, tag: tag, attrs: attrs, content: new_text}

    {new_text, [data | things]}
  end

  defp get_text({:comment, _}, acc, _), do: acc

  defp get_text({"br", _, _}, {acc, starts}, _), do: {acc <> "\n", starts}

  defp get_text({tag, attrs, nodes}, {acc, starts}, sep) do
    get_text({tag, attrs}, nodes, {acc, starts}, sep)
  end

  def parse_html(html) do
    paragraphs =
      html
      |> String.split(~r{(\r\n\|\r|\n)})
      |> Enum.map(&paragraph_to_rich/1)
      |> IO.inspect
  end

  def paragraph_to_rich(html)do
    {text, spans} =
      html
      |> Floki.parse()
      |> get()

    spans =
      spans
      |> Enum.map(&parse_span/1)
      |> Enum.reject(&is_nil/1)

     %{
       text: text,
       type: "paragraph",
       spans: spans
     }
  end

  def parse_span(%{tag: "a", attrs: attrs, end: endd, start: start}) do
    {"href", url} = Enum.find(attrs, fn (attr) -> match?({"href", _}, attr) end)
    blank_target = Enum.any?(attrs, fn attr  -> match?({"target", "_blank"}, attr) end)
    value = if blank_target do
      %{
        url: url,
        targe: "_blank"
      }
    else
      %{
        url: url
      }
    end

    %{
      data: %{
        type: "Link.web",
        value: value
      },
      end: endd,
      start: start,
      type: "hyperlink"
    }
  end

  def parse_span(_), do: nil
end

HtmlToPrismic.paragraph_to_rich("<a href='dog'>bone</a>")
HtmlToPrismic.parse_html(~s"""

  The Florence-founded label has been creating sumptuous leather goods and cutting-edge fashion pieces since 1921. Known for its sex appeal almost as much as its craftsmanship under the creative direction of Tom Ford and Frida Giannini, with Alessandro Michele newly at the helm, Gucci is set to enter a new chapter.

Look to our women’s collection for iconic Gucci <a href="https://www.therealreal.com/designers/gucci/women/handbags" target="_blank">handbags</a>, <a href="https://www.therealreal.com/designers/gucci/women/shoes" target="_blank">shoes</a> and <a href="https://www.therealreal.com/designers/gucci/women/accessories/sunglasses" target="_blank">sunglasses</a>.

For men, shop <a href="https://www.therealreal.com/designers/gucci/men/mens-shoes" target="_blank">shoes</a>, <a href="https://www.therealreal.com/designers/gucci/men/mens-accessories/belts" target="_blank">belts</a>, <a href="https://www.therealreal.com/designers/gucci/men/mens-accessories/sunglasses">sunglasses</a>, and more.
""")
