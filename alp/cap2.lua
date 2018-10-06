local utilities = require "alp.utilities"

local exercises = {
	[1] = function()
		io.write(10+5)
	end,
	[2] = function()
		io.write("Fatec\n")
	end,
	[3] = function()
		local v = utilities.read_multiple_num(2)
		assert(#v==2, "É preciso dois números para multiplicar.")
		utilities.result_msg("multiplicação", v[1]*v[2])
	end,
	[4] = function()
      local result, err = utilities.sum(utilities.read_multiple_num(3))
      utilities.result_msg("soma", result, err)
	end,
	[5] = function()
      local salary = assert(utilities.read_num("Insira o salário atual (R$):"))
      local rise_p = utilities.percent_to_decimal(assert(utilities.read_num("Insira o aumento (%):")))
      local rise = salary * rise_p

      io.write("O novo salário é: R$"..(salary+rise))
      io.write("O aumento foi de: R$"..rise)
	end,
	[6] = function()
		local h = assert(utilities.read_num("Insira a quantidade em horas:"))
		local m = h * 60
		io.write("A quantidade em minutos é "..m)
	end,
} utilities.set_default(exercises, function()
   io.write("Exercício não encontrado.\n")
end)

return exercises
