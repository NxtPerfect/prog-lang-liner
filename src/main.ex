# Don't use unix commands
# Go to directory passed as absolute path
# then count each file that has .go as golang
# and how many lines it has as added to total
defmodule Liner do
  def run() do
    # Return programming language + how many lines of code
  end

  def getFiles(path) do
    if !File.exists?(path) || !File.dir?(path) do
      false
    else
      Path.wildcard("#{Path.expand(path)}/*") |> Enum.map(&Path.basename/1) |> Enum.join("\n")
    end
  end

  # defp addLanguage() do
  #   1
  # end
  # defp countLinesOfCode() do
  #   1
  # end
  # defp addLinesOfCodeToTotal() do
  #   1
  # end
end

IO.puts(Liner.getFiles("../"))
