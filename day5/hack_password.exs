defmodule HackPassword do
  def haxxor(input) do
    input
    |> find_password("", 0)
    |> String.downcase
  end

  defp find_password(input, password, index) do
    {char, new_index} = find_00000(input, md5(input <> Integer.to_string(index)), index)
    new_password = password <> char
    IO.inspect new_password

    cond do
      String.length(new_password) == 8 -> new_password
      true -> find_password(input, new_password, new_index)
    end
  end

  defp find_00000(_input, "00000" <> tl, index) do
    {String.first(tl), index}
  end

  defp find_00000(input, _hash, index) do
    if rem(index, 200_000) == 0 do
      IO.puts index
    end
    find_00000(input, md5(input <> Integer.to_string(index)), index + 1)
  end

  defp md5(input) do
    :crypto.hash(:md5, input) |> Base.encode16()
  end
end

System.argv
|> hd
|> HackPassword.haxxor
|> IO.inspect(limit: :infinity)

