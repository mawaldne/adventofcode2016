defmodule AbbaFinder do
  def find(input) do
    captures = Regex.named_captures(~r/(?<first>.*)\[(?<second>.+)\](?<third>.*)/, encrypted_sector)
  end
end

System.argv
|> hd
|> File.read!
|> AbbaFinder.find
|> IO.inspect(limit: :infinity)

