defmodule HackPasswordPosition do
  def haxxor(input) do
    input
    |> find_password(0, [nil, nil,nil,nil,nil,nil,nil,nil])
    |> Enum.join
    |> String.downcase
  end

  defp find_password(input, index, password) do
    if rem(index, 250_000) == 0 do
      IO.puts index
    end

    hash = md5("#{input}#{index}")
    new_password = if String.match?(hash, ~r"\A0{5}[0-7]") do
      position = String.to_integer(String.at(hash, 5))
      char = String.at(hash, 6)
      if Enum.at(password, position) == nil do
        List.replace_at(password, position, char)
        |> IO.inspect
      else
        password
      end
    else
      password
    end

    cond do
      Enum.member?(new_password, nil) -> find_password(input, index + 1, new_password)
      true -> new_password
    end
  end

  defp md5(input) do
    :crypto.hash(:md5, input) |> Base.encode16()
  end
end

System.argv
|> hd
|> HackPasswordPosition.haxxor
|> IO.inspect(limit: :infinity)

