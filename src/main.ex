defmodule Liner do
  @spec run(bitstring) :: map
  def run(path) do
    getFiles(path)
  end

  @spec getFiles(bitstring) :: map
  defp getFiles(path) do
    if File.exists?(path) && File.dir?(path) do
      Path.wildcard("#{Path.expand(path)}/*")
      |> Enum.map(&getFiles/1)
      |> Enum.reduce(%{}, fn result, acc -> Map.merge(acc, result) end)
    else
      languages = File.stream!("data/languages.txt") |> Enum.map(&String.trim/1) |> Enum.to_list()

      addLanguage(path, languages, %{})
    end
  end

  @spec addLanguage(bitstring, list, map) :: map
  def addLanguage(filePath, languages, linesPerLanguage) do
    if !File.exists?(filePath) || File.dir?(filePath) do
      # IO.puts("File doesn't exist or is a directory.")
      %{}
    else
      if !String.contains?(filePath, ".") do
        # IO.puts("File name is invalid.")
        %{}
      else
        # IO.puts("Parsing #{filePath}")
        [fileExtension | _] = Enum.reverse(String.split(filePath, "."))

        if Enum.member?(languages, fileExtension) do
          # IO.puts("Known language in the list .#{fileExtension}.")
          linesOfCode = countLinesOfCode(filePath)

          newLinesPerLanguage =
            Map.update(linesPerLanguage, :"#{fileExtension}", linesOfCode, fn x ->
              x + linesOfCode
            end)

          newLinesPerLanguage
        else
          # IO.puts("Returning empty")
          %{}
        end
      end
    end
  end

  @spec countLinesOfCode(bitstring) :: integer
  defp countLinesOfCode(filePath) do
    File.stream!(filePath)
    |> Enum.count()
  end
end

Liner.run("../")

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main.ex"),
    [
      "go"
    ],
    %{}
  ) == %{}
)

IO.puts(
  Liner.addLanguage(
    "/Path/That/Doesnt/Exist",
    [],
    %{}
  ) == %{}
)

IO.puts(
  Liner.addLanguage(
    "/Path/That/Doesnt/Exist.x86",
    ["x86"],
    %{}
  ) == %{}
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main_ex"),
    [],
    %{}
  ) == %{}
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./src/main.ex"),
    [],
    %{}
  ) == %{}
)

IO.puts(
  Liner.addLanguage(
    Path.expand("./data/languages.txt"),
    [
      "txt"
    ],
    %{}
  ) == %{txt: 7}
)

IO.puts(Liner.run("./test_files") == %{c: 1, exs: 2, nasm: 4, py: 3})
