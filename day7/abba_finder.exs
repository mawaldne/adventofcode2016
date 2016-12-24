defmodule AbbaFinder do
  def find(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn ip -> tls?(ip) end)
    |> Enum.count(fn is_tls -> is_tls end)
  end

  defp tls?(ip) do
    sequences = ip |> String.trim |> String.split(~r{[\[\]]})

    ip_parts = Enum.take_every(sequences, 2)
    hypernets = sequences |> Enum.drop(1) |> Enum.take_every(2)

    ip_contains_abba =
      ip_parts
      |> Enum.map(fn ip -> abba?(ip) end)
      |> Enum.any?

    hypernets_contains_abba =
      hypernets
      |> Enum.map(fn ip -> abba?(ip) end)
      |> Enum.any?

    ip_contains_abba and not hypernets_contains_abba
  end

  # Super cool string pattern matching from JEG2
  defp abba?(sequence) when byte_size(sequence) < 4, do: false
  defp abba?(<<a::utf8, b::utf8, b::utf8, a::utf8, _sequence::binary>>) when a != b, do: true
  defp abba?(<<_char::utf8, sequence::binary>>), do: abba?(sequence)
end

System.argv
|> hd
|> File.read!
|> AbbaFinder.find
|> IO.inspect(limit: :infinity)

