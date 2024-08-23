# Don't use unix commands
# Go to directory passed as absolute path
# then count each file that has .go as golang
# and how many lines it has as added to total
defmodule Liner do
  def run(path) do
    # Return programming language + how many lines of code
    getFiles(path)
  end

  defp getFiles(path) do
    if File.exists?(path) && File.dir?(path) do
      Path.wildcard("#{Path.expand(path)}/*") |> Enum.map(&getFiles/1)
    else
      IO.puts(path)

      addLanguage(path, [])
    end
  end

  def addLanguage(file, languages) do
    if !File.exists?(file) || File.dir?(file) do
      IO.puts("File doesn't exist or is a directory.")
      false
    else
      if !String.contains?(file, ".") do
        IO.puts("File name is invalid.")
        false
      else
        IO.puts("Parsing #{file}")
        [fileExtension | _] = Enum.reverse(String.split(file, "."))

        if Enum.member?(languages, fileExtension) && !Enum.empty?(languages) do
          IO.puts("Already in the list #{fileExtension}.")
          languages
        else
          IO.puts("Adding to list #{fileExtension}.")
          [fileExtension | languages]
        end
      end
    end
  end

  # defp countLinesOfCode(file) do
  #   1
  # end
  #
  # defp addLinesOfCodeToTotal(linesCount) do
  #   1
  # end
end

Liner.run("../")

IO.puts(
  Liner.addLanguage(Path.expand("./src/main.ex"), [
    "go"
  ]) == ["ex", "go"]
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main.sex"),
    ["go"]
  ) == false
)

IO.puts(
  Liner.addLanguage(
    "/Path/That/Doesnt/Exist",
    []
  ) == false
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main_ex"),
    []
  ) == false
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main.ex"),
    []
  ) == ["ex"]
)

IO.puts(
  Liner.addLanguage(Path.expand("./src/main.ex"), [
    "ex"
  ]) == ["ex"]
)
