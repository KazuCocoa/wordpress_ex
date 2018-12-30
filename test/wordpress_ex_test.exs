defmodule WordpressExTest do
  use ExUnit.Case

  alias WordpressEx

  test "run command" do
    result = WordpressEx.my_posts_markdown()
    assert result

    "You read below #{
      length(result)
    } books between #{
      WordpressEx.start_date() |> DateTime.from_naive!("Etc/UTC") |> Date.to_string()
    } and #{
      Date.utc_today()
    }"
    |> IO.puts()
    IO.puts("\n")
    IO.puts(result)
  end
end
