local utilities = require "alp.utilities"

local INSS_TAX = utilities.percent_to_decimal(8)
local KILLOWATT_PRICE = 0.12
local ICMS_TAX = utilities.percent_to_decimal(18)

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
		io.write("A quantidade em minutos é: "..m.."\n")
	end,
	[7] = function()
		local km = assert(utilities.read_num("Insira a quantidade em horas:"))
		local m = km * 1000
		io.write("A quantidade em metros é: "..m.."\n")
	end,
	[8] = function()
		local salary = assert(utilities.read_num("Insira o salário mensal em reais:"))
		local bonus = assert(utilities.read_num("Insira o valor das horas extras em reais:"))
		local res = (salary+bonus)*(1-INSS_TAX)
		io.write("O salário líquido é: R$"..res.."\n")
	end,
	[9] = function()
		local kw = assert(utilities.read_num("Insira o consumo em kW:"))
		local cost = (kw*KILLOWATT_PRICE)*(1+ICMS_TAX)
		io.write("O valor a ser pago é: R$"..cost.."\n")
	end,
} utilities.set_default(exercises, function()
   io.write("Exercício não encontrado.\n")
end)

return exercises
