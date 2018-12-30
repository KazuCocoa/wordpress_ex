defmodule WordpressExTest do
  use ExUnit.Case

  alias WordpressEx

  test "run command" do
    result = WordpressEx.my_posts_markdown()
    assert result
    IO.puts(result)
  end
end
