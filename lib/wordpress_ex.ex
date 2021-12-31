defmodule WordpressEx do
  alias Jason
  alias HTTPoison
  alias DateTime

  @period_before ~N[2021-01-01 00:00:00]

  @spec start_date() :: %NaiveDateTime{}
  def start_date do
    @period_before
  end

  defp url(site, item, query) do
    %URI{
      %URI{}
      | host: "public-api.wordpress.com",
        path: "/rest/v1.1/sites/#{site}.wordpress.com/#{item}",
        query: URI.encode_query(query),
        scheme: "https"
    }
  end

  defp get_posts(site, query) do
    posts_query =
      site
      |> url("posts", query)
      |> URI.to_string()

    case HTTPoison.get(posts_query) do
      {:ok, posts} ->
        posts.body
        |> Jason.decode()

      {:error, message} ->
        IO.puts("error: #{message}")
        {:error, message}
    end
  end

  defp get_titles(site, query) do
    case get_posts(site, query) do
      {:ok, posts} ->
        posts["posts"]
        |> Enum.reduce([], fn p, acc ->
          Enum.into(acc, [{p["title"], p["URL"]}])
        end)

      {:error, message} ->
        IO.puts(message)
    end
  end

  @spec my_posts_markdown() :: [String.t()]
  def my_posts_markdown do
    get_titles("kazucocoa", [
      {"tag", "book"},
      {"after", @period_before |> NaiveDateTime.to_iso8601()},
      {"number", 100}
    ])
    |> Enum.reduce([], fn {title, url}, acc ->
      new_item =
        "- [#{title}](#{url})\n"
        |> String.replace("&#8220;", "“")
        |> String.replace("&#8221;", "”")

      [new_item | acc]
    end)
    |> Enum.reverse()
  end
end
