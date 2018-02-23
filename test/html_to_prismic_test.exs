defmodule HtmlToPrismicTest do
  use ExUnit.Case
  doctest HtmlToPrismic
  @goal [
    %{
      spans: [],
      text: "  The Florence-founded label has been creating sumptuous leather goods and cutting-edge fashion pieces since 1921. Known for its sex appeal almost as much as its craftsmanship under the creative direction of Tom Ford and Frida Giannini, with Alessandro Michele newly at the helm, Gucci is set to enter a new chapter. ",
      type: "paragraph"
    },
    %{
      spans: [
        %{
          data: %{
            type: "Link.web",
            value: %{
              target: "_blank",
              url: "https://www.therealreal.com/designers/gucci/women/shoes"
            }
          },
          end: 352,
          start: 342,
          type: "hyperlink"
        }
      ],
      text: "Look to our women’s collection for iconic Gucci <a href=\"https://www.therealreal.com/designers/gucci/women/handbags\" target=\"_blank\">handbags</a>, <a href=\"https://www.therealreal.com/designers/gucci/women/shoes\" target=\"_blank\">shoes</a> and <a href=\"https://www.therealreal.com/designers/gucci/women/accessories/sunglasses\" target=\"_blank\">sunglasses</a>. ",
      type: "paragraph"
    },
    %{
      spans: [],
      text: "For men, shop <a href=\"https://www.therealreal.com/designers/gucci/men/mens-shoes\" target=\"_blank\">shoes</a>, <a href=\"https://www.therealreal.com/designers/gucci/men/mens-accessories/belts\" target=\"_blank\">belts</a>, <a href=\"https://www.therealreal.com/designers/gucci/men/mens-accessories/sunglasses\" target=\"_blank\">sunglasses</a>, and more. ",
      type: "paragraph"
    }
  ]

  @sample ~s"""
  The Florence-founded label has been creating sumptuous leather goods and cutting-edge fashion pieces since 1921. Known for its sex appeal almost as much as its craftsmanship under the creative direction of Tom Ford and Frida Giannini, with Alessandro Michele newly at the helm, Gucci is set to enter a new chapter.

Look to our women’s collection for iconic Gucci <a href="https://www.therealreal.com/designers/gucci/women/handbags" target="_blank">handbags</a>, <a href="https://www.therealreal.com/designers/gucci/women/shoes" target="_blank">shoes</a> and <a href="https://www.therealreal.com/designers/gucci/women/accessories/sunglasses" target="_blank">sunglasses</a>.

For men, shop <a href="https://www.therealreal.com/designers/gucci/men/mens-shoes" target="_blank">shoes</a>, <a href="https://www.therealreal.com/designers/gucci/men/mens-accessories/belts" target="_blank">belts</a>, <a href="https://www.therealreal.com/designers/gucci/men/mens-accessories/sunglasses" target="_blank">sunglasses</a>, and more.
"""

  test "greets the world" do
    parsed =
      @sample
      |> HtmlToPrismic.parse_html

    assert parsed == @goal
  end
end
