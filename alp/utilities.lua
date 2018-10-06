local utilities = {}

function utilities.set_default(t, d)
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
   } utilities.set_default(reply, false)
   return reply[input]
end

function utilities.to_number(v)
   if type(v) == "number" then return v end
   if type(v) ~= "string" then return false end
   local res = ""
   v = v:gsub(",",".")
   for i = 1, #v do
      local letter = v:sub(i,i)
      if letter:byte() > 44 and letter:byte() < 58 then
         res = res..letter
      end
   end
   return tonumber(res)
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

function utilities.run_ex(exercises, n)
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

function utilities.menu(exercises, option)
   local num = utilities.to_number(option)
   if num then
      utilities.run_ex(exercises, num)
      return
   end
   local text = option:lower()
   if text == "todos" then
      for i in ipairs(exercises) do
         utilities.run_ex(exercises, i)
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

function utilities.main(exercises, option)
   local should_exit
   repeat
      if not option then
         io.write([[Digite o número do exercício que você deseja executar.
Você também pode digitar "todos" para executar todos em sequência.
Digite "sair" para sair.
]])
         option = io.read()
      end
      should_exit = utilities.menu(exercises, option)
      option = nil
   until should_exit
end

return utilities
