defmodule WordpressEx do
  @period_before "2016-01-01T00:00:00"

  defp url(site, item, query) do
    %URI{ %URI{} | host: "public-api.wordpress.com",
                   path: "/rest/v1.1/sites/#{site}.wordpress.com/#{item}",
                   query: URI.encode_query(query), scheme: "https"}
  end

  defp get_posts(site, query) do
    posts = url(site, "posts", query) |> URI.to_string |> HTTPoison.get!
    posts.body |> Poison.decode
  end

  defp get_titles(site, query) do
    case get_posts(site, query) do
      {:ok, posts} ->
        posts["posts"]
        |> Enum.reduce([], fn p, acc ->
          Enum.into acc, [{p["title"], p["URL"]}]
        end)
      {:error, message} ->
        IO.puts(message)
    end
  end

  def my_posts_markdown do
    get_titles("kazucocoa", [{"tag", "book"}, {"after", @period_before}, {"number", 100}])
    |> Enum.reduce("", fn {title, url}, acc ->
      acc <> "- [#{title}](#{url})\n\r"
    end)
    |> IO.puts
  end
end
