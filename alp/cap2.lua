local utilities = require "alp.utilities"

local exercises = {
	[1] = function()
		io.write(10+5)
	end,
	[2] = function()
		io.write("Fatec\n")
	end,
} utilities.set_default(exercises, function()
   io.write("Exercício não encontrado.\n")
end)

return exercises
