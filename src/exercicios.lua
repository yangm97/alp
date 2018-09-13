#!/usr/bin/env lua

-- "Constantes" de mentirinha porque lua não tem constantes
local YEAR_DAYS = 365

local u = {}

local function set_default(t, d)
	local mt = {__index = function() return d end}
	setmetatable(t, mt)
end

function u.insert_msg(i)
	if i == 1 then
		print("Insira o primeiro número")
		return
	end
	print("Insira o próximo número")
end

function u.result_msg(operation, result, err)
	operation = operation or "cálculo"
	err = err or ""
	if not result then
		print("Não foi possível realizar a operação ("..operation.."). "..err)
		return false
	end
	print("O resultado da operação ("..operation..") é: "..result)
	return true
end

function u.read_bool_reply(msg)
	if msg then
		print(msg)
	end
	local input = io.read():lower()
	local reply = {
		s = true,
		sim = true,
		y = true,
		yes = true,
		si = true,
		["sí"] = true,
		["true"] = true,
		[true] = true,
		[1] = true,
		v = true,
		t = true,
	} set_default(reply, false)
	return reply[input]
end

function u.to_number(v)
	return tonumber(v:match("%d+"))
end

function u.read_num(msg)
	if msg then
		print(msg)
	end
	local num = u.to_number(io.read())
	if not num then
		return false, "O valor inserido não é numérico."
	end
	return num
end

function u.read_multiple_num(n)
	if not n then
		print("Insira um valor não numérico a qualquer momento para realizar o cálculo.")
	end
	-- local i = 1 -- Lua indexes/arrays start at 1
	local values = {}
	-- while true do
	-- 	if n and i == n+1 then
	-- 		break
	-- 	end
	-- 	u.insert_msg(i)
	-- 	local input = u.read_num()
	-- 	if not input then
	-- 		i = i-1 -- See comment above
	-- 		break
	-- 	end
	-- 	values[i] = input
	-- 	i = i+1
	-- end

	local i = 0
	repeat
		if n and i == n then
			break
		end
		i = i+1
		u.insert_msg(i)
		local input = u.read_num()
		if input then
			values[i] = input
		end
	until not input

	return values, i-1
end

function u.sum_(t, ans, i)
	if i == 0 then
		return ans
	end
	local v = tonumber(t[i])
	if not v then
		return false, "Não é possível somar com valores não numéricos."
	end
	return u.sum_(t, ans+v, i-1)
end

local function sum(t)
	return u.sum_(t, 0, #t)
end

function u.sum_n(n)
	if not n then
		return false, "A quantidade de números a ser somada deve ser um valor numérico."
	end
	local t = {}
	for i = 1, n do
		u.insert_msg(i)
		local ok, err = u.read_num()
		if not ok then
			return false, err
		end
		t[i] = ok
	end
	return sum(t)
end

function u.percent_to_decimal(percent)
	return percent/100
end

local ex = {
	[1] = function()
		local continue
		repeat
			local result, err = u.sum_n(2)
			u.result_msg("soma", result, err)
			continue = u.read_bool_reply("Deseja somar novamente?")
		until not continue
	end,
	[2] = function()
		local n = u.read_num("Insira a quantidade de números que você deja somar:")
		local result = assert(u.sum_n(n))
		u.result_msg("soma", result)
		print("Você pediu para somar "..n.." números.")
	end,
	[3] = function()
		local values, i = u.read_multiple_num()
		local result = assert(sum(values))
		u.result_msg("soma", result)
		u.result_msg("média", result/i)
	end,
	[4] = function()
		local continue
		repeat
			for i=1,100 do
				print(i)
			end
			continue = u.read_bool_reply("Deseja ver os números de 1 a 100 novamente?")
		until not continue
	end,
	[5] = function()
		for i=500,100,-5 do
			print(i)
		end
	end,
	[6] = function()
		local f = assert(u.read_num("Insira a temperatura em Farenheit"))
		local c = 5/9 * (f - 32)
		print("A temperatura em Celsius é: "..c.."º")
	end,
	[7] = function()
		local RISE = u.percent_to_decimal(12)
		local salaries = u.read_multiple_num()
		local rises = {}
		assert(#salaries > 0, "É necessário inserir pelo menos um salário para realizar o cálculo.")
		for i in ipairs(salaries) do
			rises[i] = salaries[i] * RISE
		end
		local total_salaries = sum(salaries)
		local total_rise = sum(rises)
		local total = total_rise + total_salaries
		print("Total dos aumentos: R$"..total_rise)
		print("Total a ser pago com os aumentos: R$"..total)
	end,
	[8] = function()
		local PROFIT = u.percent_to_decimal(8)
		local materials = assert(u.read_num("Insira o valor (em R$) dos materiais:"))
		local worked_hours = assert(u.read_num("Insira o valor (em R$) das horas trabalhadas:"))
		local price = sum{materials, worked_hours} * (1+PROFIT)
		print("O preço é: R$"..price)
	end,
	[9] = function()
		local v = u.read_multiple_num(2)
		local result = assert(sum(v))
		u.result_msg("soma", result)
		if not result then
			return
		end
		u.result_msg("multiplicação", v[1]*v[2])
		u.result_msg("divisão", v[1]/v[2])
	end,
	[10] = function()
		local ICMS = u.percent_to_decimal(15)
		local cost = assert(u.read_num("Insira o custo de fabricação:"))
		local price = cost * (1+ICMS)
		local msg = "O preço com ICMS é: "
		print(msg..price)
	end,
	[11] = function()
		local WORK_HOUR = {
			builder = 10,
			painter = 8,
		}
		local builder_hours = assert(u.read_num("Insira a quantidade de horas que o pedreiro trabalhou:"))
		local painter_hours = assert(u.read_num("Insira a quantidade de horas que o pintor trabalhou:"))
		local cost = (builder_hours * WORK_HOUR.builder) + (painter_hours * WORK_HOUR.painter)
		print("O custo total da mão de obra é: R$"..cost)
	end,
	[12] = function()
		local years = assert(u.read_num("Insira a quantidade de anos:"))
		local days = years*YEAR_DAYS
		print("A quantidade de dias é: "..days)
	end,
	[13] = function()
		local years = u.read_multiple_num(2)
		assert(#years == 2, "É necessário inserir dois anos válidos.")
		local diff = years[1] - years[2]
		local diff_days = diff * YEAR_DAYS
		if diff_days < 0 then
			diff_days = diff_days * -1
		end
		print("A quantidade de dias existentes entre "..years[1].." e "..years[2].." é "..diff_days)
	end,
	[14] = function()
		local GRADE = {
			prova = {
				n = 4,
				weight = 65,
				grades = {},
			},
			trabalho = {
				n = 2,
				weight = 35,
				grades = {},
			},
		}
		local weights = {}
		local weighted_grades = {}
		for k,v in pairs(GRADE) do
			table.insert(weights, v.weight)
			print('Insira as notas do método de avaliação "'..k..'"')
			v.grades = u.read_multiple_num(v.n)
			local average = 0
			for i = 1, v.n do
				local weighted_grade = v.grades[i] * v.weight
				average = average + weighted_grade
			end
			average = average/v.n
			table.insert(weighted_grades, average)
		end
		local weighted_average = sum(weighted_grades)/sum(weights)
		print("A média final é: "..weighted_average)
	end,
} set_default(ex, function()
	print("Exercício não encontrado.")
end)

local function run_ex(n)
	print("Executando o exercício "..n)
	local ok, res = pcall(ex[n])
	if not ok then
		print(res)
	end
end

local function menu(option)
	local num = u.to_number(option)
	if num then
		run_ex(num)
	end
	local text = option:lower()
	if text == "todos" then
		for i in ipairs(ex) do
			run_ex(i)
			if not u.read_bool_reply("Você deseja continuar executando os exercícios?") then
				break
			end
		end
	end
	if text == "sair" then
		return true
	end
end

if _G.TEST then
	return {
		u = u,
		ex = ex,
	}
end

local option = arg[1]
while true do
	if not option then
		print([[Digite o número do exercício que você deseja executar.
Você também pode digitar "todos" para executar todos em sequência.
Digite "sair" para sair.]])
		option = io.read()
	end
	local should_exit = menu(option)
	if should_exit then
		break
	end
	option = nil
end
