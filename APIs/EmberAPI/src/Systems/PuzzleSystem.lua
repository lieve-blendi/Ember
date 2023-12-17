local Puzzle = {}

function Puzzle.ClearPuzzleButtons()
    for k,v in pairs(buttons) do
        if k:sub(1,#"topuzzle") == "topuzzle" then
            EmberAPI.Button.DeleteButton(k)
        end
    end
end

function Puzzle.RebuildPuzzleButtons()
    CreateLevelMenu() -- same as the cellbar one lol, just calls the real one
end

function Puzzle.AddPuzzle(difficulty, code)
    table.insert(levels, {difficulty, code})
end

function Puzzle.AddInteractivePuzzle(difficulty, code)
    table.insert(plevels, {difficulty, code})
end

return Puzzle