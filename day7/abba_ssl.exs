defmodule AbbaFinder do
  def find(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn ip -> ssl?(ip) end)
    |> Enum.count(fn is_tls -> is_tls end)
  end

  defp ssl?(ip) do
    sequences = ip |> String.trim |> String.split(~r{[\[\]]})

    supernets = Enum.take_every(sequences, 2)
    hypernets = sequences |> Enum.drop(1) |> Enum.take_every(2)

    supernets_aba =
      supernets
      |> Enum.flat_map(fn ip -> aba_list(ip, []) end)

    hypernets_bab =
      hypernets
      |> Enum.flat_map(fn ip -> aba_list(ip, []) end)
      |> Enum.map(fn aba -> bab_to_aba(aba) end)

    length(supernets_aba -- (supernets_aba -- hypernets_bab)) > 0
  end

  # Super cool string pattern matching from JEG2
  defp aba_list(sequence, list) when byte_size(sequence) < 3, do: list
  defp aba_list(<<a::utf8, b::utf8, a::utf8, sequence::binary>>, list) when a != b do
    aba_list(<<b::utf8, a::utf8, sequence::binary>>, list ++ [<<a::utf8, b::utf8, a::utf8>>])
  end
  defp aba_list(<<_char::utf8, sequence::binary>>, list), do: aba_list(sequence, list)

  defp bab_to_aba(<<b::utf8, a::utf8, b::utf8>>) do
    <<a::utf8, b::utf8, a::utf8>>
  end
end

System.argv
|> hd
|> File.read!
|> AbbaFinder.find
|> IO.inspect(limit: :infinity)

