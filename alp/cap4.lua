local utilities = require "alp.utilities"

local exercises = {
   [1] = function()
      local result, err = utilities.sum(utilities.read_multiple_num(2))
      utilities.result_msg("soma", result, err)
   end,
   [2] = function()
      local t, n = utilities.read_multiple_num()
      local result = assert(utilities.sum(t))
      utilities.result_msg("soma", result)
      io.write("Você pediu para somar "..n.." números.\n")
   end,
   [3] = function()
      local values, i = utilities.read_multiple_num()
      local result = assert(utilities.sum(values))
      utilities.result_msg("soma", result)
      utilities.result_msg("média", result/i)
   end,
   [4] = function()
      for i=1,100 do
         io.write(i.."\n")
      end
   end,
   [5] = function()
      for i=500,100,-5 do
         io.write(i.."\n")
      end
   end,
   [6] = function()
      local f = assert(utilities.read_num("Insira a temperatura em Farenheit"))
      local c = 5/9 * (f - 32)
      io.write("A temperatura em Celsius é: "..c.."º\n")
   end,
   [7] = function()
      local RISE = utilities.percent_to_decimal(12)
      local salaries = utilities.read_multiple_num()
      local rises = {}
      assert(#salaries > 0, "É necessário inserir pelo menos um salário para realizar o cálculo.")
      for i in ipairs(salaries) do
         rises[i] = salaries[i] * RISE
      end
      local total_salaries = utilities.sum_(salaries, 0, #salaries)
      local total_rise = utilities.sum_(rises, 0, #rises)
      local total = total_rise + total_salaries
      io.write("Total dos aumentos: R$"..total_rise.."\n")
      io.write("Total a ser pago com os aumentos: R$"..total.."\n")
   end,
   [8] = function()
      local PROFIT = utilities.percent_to_decimal(8)
      local materials = assert(utilities.read_num("Insira o valor (em R$) dos materiais:"))
      local worked_hours = assert(utilities.read_num("Insira o valor (em R$) das horas trabalhadas:"))
      local price = utilities.sum{materials, worked_hours} * (1+PROFIT)
      io.write("O preço é: R$"..price)
   end,
   [9] = function()
      local v = utilities.read_multiple_num(2)
      local result = assert(utilities.sum(v))
      utilities.result_msg("soma", result)
      utilities.result_msg("multiplicação", v[1]*v[2])
      utilities.result_msg("divisão", v[1]/v[2])
   end,
   [10] = function()
      local ICMS = utilities.percent_to_decimal(15)
      local cost = assert(utilities.read_num("Insira o custo de fabricação:"))
      local price = cost * (1+ICMS)
      local msg = "O preço com ICMS é: R$"
      io.write(msg..price.."\n")
   end,
   [11] = function()
      local WORK_HOUR = {
         builder = 10,
         painter = 8,
      }
      local builder_hours = assert(utilities.read_num("Insira a quantidade de horas que o pedreiro trabalhou:"))
      local painter_hours = assert(utilities.read_num("Insira a quantidade de horas que o pintor trabalhou:"))
      local cost = (builder_hours * WORK_HOUR.builder) + (painter_hours * WORK_HOUR.painter)
      io.write("O custo total da mão de obra é: R$"..cost.."\n")
   end,
   [12] = function()
      local years = assert(utilities.read_num("Insira a quantidade de anos:"))
      local days = years * 365
      io.write("A quantidade de dias é: "..days.."\n")
   end,
   [13] = function()
      local years = utilities.read_multiple_num(2)
      assert(#years == 2, "É necessário inserir dois anos válidos.")
      local diff = years[1] - years[2]
      local diff_days = diff * 365
      if diff_days < 0 then
         diff_days = diff_days * -1
      end
      io.write("A quantidade de dias existentes entre "..years[1].." e "..years[2].." é "..diff_days.."\n")
   end,
   [14] = function()
      local GRADE = {
         {
            name = "Prova",
            n = 4,
            weight = 65,
            grades = {},
         },
         {
            name = "Trabalho",
            n = 2,
            weight = 35,
            grades = {},
         },
      }
      local weights = {}
      local grades = {}
      for i=1,#GRADE do
         table.insert(weights, GRADE[i].weight*GRADE[i].n)
         io.write('Insira as notas do método de avaliação "'..GRADE[i].name..'"\n')
         GRADE[i].grades = utilities.read_multiple_num(GRADE[i].n)
         for j = 1, GRADE[i].n do
            local weighted_grade = GRADE[i].grades[j] * GRADE[i].weight
            table.insert(grades, weighted_grade)
         end
      end
      local weighted_average = utilities.sum(grades)/utilities.sum(weights)
      io.write("A média final é: "..weighted_average.."\n")
   end,
} utilities.set_default(exercises, function()
   io.write("Exercício não encontrado.\n")
end)

return exercises
