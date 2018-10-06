-- "Constantes" de mentirinha porque lua não tem constantes
local YEAR_DAYS = 365

local utilities = {}

local function set_default(t, d)
   local mt = {__index = function() return d end}
   setmetatable(t, mt)
end

function utilities.insert_msg(i)
   if i == 1 then
      io.write("Insira o primeiro número\n")
      return
   end
   io.write("Insira o próximo número\n")
end

function utilities.result_msg(operation, result, err)
   operation = operation or "cálculo"
   err = err or ""
   if not result then
      io.write("Não foi possível realizar a operação ("..operation.."). "..err.."\n")
      return false
   end
   io.write("O resultado da operação ("..operation..") é: "..result.."\n")
   return true
end

function utilities.read_bool_reply(msg)
   if msg then
      io.write(msg.."\n")
   end
   local input = io.read():lower()
   local reply = {
      ["s"] = true,
      ["sim"] = true,
      ["y"] = true,
      ["yes"] = true,
      ["si"] = true,
      ["sí"] = true,
      ["true"] = true,
      ["1"] = true,
      ["v"] = true,
      ["t"] = true,
      ["ok"] = true,
   } set_default(reply, false)
   return reply[input]
end

function utilities.to_number(v) -- TODO: support decimals
   local type_v = type(v)
   if type_v == "number" then return v end
   if type_v ~= "string" then return false end
   return tonumber(v:match("%d+"))
end

function utilities.read_num(msg)
   if msg then
      io.write(msg.."\n")
   end
   local num = utilities.to_number(io.read())
   if not num then
      return false, "O valor inserido não é numérico."
   end
   return num
end

function utilities.read_multiple_num(n)
   if not n then
      io.write("Insira um valor não numérico a qualquer momento para realizar o cálculo.\n")
   end

   local values = {}
   local i = 0
   repeat
      i = i+1
      utilities.insert_msg(i)
      local input = utilities.read_num()
      if input then
         values[i] = input
      end
   until not input or (n and i == n)

   return values, #values
end

function utilities.check_sum_n(n)
   if type(n) ~= "number" then
      return false, "A quantidade de números a serem somadados deve ser um valor numérico."
   end
   if n < 2 then
      return false, "É necessário no mínimo dois valores numéricos para se realizar uma soma."
   end
   return true
end

function utilities.sum_(t, ans, i)
   if i == 0 then
      return ans
   end
   if type(t[i]) ~= "number" then
      return false, "Não é possível somar com valores não numéricos."
   end
   return utilities.sum_(t, ans+t[i], i-1)
end

function utilities.sum(t)
   local ok, err = utilities.check_sum_n(#t)
   if not ok then
      return false, err
   end
   return utilities.sum_(t, 0, #t)
end

function utilities.percent_to_decimal(percent)
   return percent/100
end

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
      local days = years*YEAR_DAYS
      io.write("A quantidade de dias é: "..days.."\n")
   end,
   [13] = function()
      local years = utilities.read_multiple_num(2)
      assert(#years == 2, "É necessário inserir dois anos válidos.")
      local diff = years[1] - years[2]
      local diff_days = diff * YEAR_DAYS
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
} set_default(exercises, function()
   io.write("Exercício não encontrado.\n")
end)

function utilities.run_ex(n)
   io.write("Executando o exercício "..n.."\n")
   local continue
   repeat
      local ok, res = pcall(exercises[n])
      if not ok then
         io.write(res)
      end
      continue = utilities.read_bool_reply("\nDeseja executar o exercício "..n.." novamente?")
   until not continue
end

function utilities.menu(option)
   local num = utilities.to_number(option)
   if num then
      utilities.run_ex(num)
      return
   end
   local text = option:lower()
   if text == "todos" then
      for i in ipairs(exercises) do
         utilities.run_ex(i)
         if i == #exercises then return end
         if not utilities.read_bool_reply("Você deseja continuar executando os exercícios?") then
            return
         end
      end
   end
   if text == "sair" then
      return true
   end
end

function utilities.main(option)
   local should_exit
   repeat
      if not option then
         io.write([[Digite o número do exercício que você deseja executar.
Você também pode digitar "todos" para executar todos em sequência.
Digite "sair" para sair.
]])
         option = io.read()
      end
      should_exit = utilities.menu(option)
      option = nil
   until should_exit
end

return {
   utilities = utilities,
   exercises = exercises,
}
