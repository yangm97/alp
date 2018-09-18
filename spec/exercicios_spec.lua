_G.TEST = true
local unpack = unpack or table.unpack -- luacheck: ignore 143
local exercicios = require "exercicios"
local u = exercicios.u
local ex = exercicios.ex

local function test_whole_output(f, fake_input, ...)
   if fake_input then
      io.input(fake_input)
   end
   local fake_output = assert(io.tmpfile("w+"))
   io.output(fake_output)
   f(...)
   fake_output:seek("set", 0)
   return fake_output:read("*all")
end

local function new_fake_input(...)
   local fake_input = assert(io.tmpfile("w+"))
   local args = {...}
   for i=1, #args do
      fake_input:write(args[i])
   end
   fake_input:seek("set", 0)
   return fake_input
end

local function test_return_from_input(f, fake_input, ...)
   io.input(fake_input)
   return f(...)
end

local function test_output_from_t(f, t)
   local input = {}
   for i=1,#t do
      input[i] = t[i].."\n"
   end
   local fake_input = new_fake_input(unpack(input))
   return test_whole_output(f, fake_input)
end

describe("Utility", function()
   describe("to_number", function()
      it("should extract numeric values from strings", function()
         local str = {
            [28] = "28 ºC",
            [100] = "100%",
            [99] = "abc 99 ",
            -- [50.12] = "R$ 50.12",
         }
         for k,v in pairs(str) do
            assert.equals(k, u.to_number(v))
         end
      end)
      it("should return falsy when no input is given", function()
         assert.falsy(u.to_number())
      end)
      it("should return falsy when input has no number to extract", function()
         assert.falsy(u.to_number("abc"))
      end)
   end)

   describe("check_sum_n", function()
      it("should fail when n is not a number", function()
         local ok, err = u.check_sum_n("a")
         assert.is_false(ok)
         assert.equals("A quantidade de números a serem somadados deve ser um valor numérico.", err)
      end)
      it("should fail when n < 2", function()
         local ok, err = u.check_sum_n(1)
         assert.is_false(ok)
         assert.equals("É necessário no mínimo dois valores numéricos para se realizar uma soma.", err)
      end)
   end)

   describe("sum", function()
      it("should fail when not enough elements are given", function()
         local t = {1}
         local ok, err = u.sum(t)
         assert.is_false(ok)
         assert.equals("É necessário no mínimo dois valores numéricos para se realizar uma soma.", err)
      end)
      it("should fail when one of the elements is not a number", function()
         local t = {32, "a", 11}
         local ok, err = u.sum(t)
         assert.is_false(ok)
         assert.equals("Não é possível somar com valores não numéricos.", err)
      end)
      it("should sum two elements", function()
         local t = {22, 11}
         assert.equals(33, u.sum(t))
      end)
      it("should sum multiple elements", function()
         local t = {22, 11, 41, 107, 6}
         assert.equals(187, u.sum(t))
      end)
   end)

   describe("percent_to_decimal", function()
      it("should convert numeric percentage into decimal representations", function()
         assert.equals(0.49, u.percent_to_decimal(49))
      end)
   end)
end)

describe("User interaction", function()
   describe("display message", function()
      describe("number input", function()
         it("should be different for the first input", function()
            local result = test_whole_output(u.insert_msg, nil, 1)
            assert.equals("Insira o primeiro número\n", result)
         end)
         it("should be generic in any other case", function()
            local result = test_whole_output(u.insert_msg, nil, 2)
            assert.equals("Insira o próximo número\n", result)
         end)
      end)

      describe("result", function()
         it("should return false when result is non truthy", function()
            assert.is_false(u.result_msg())
         end)
         it("should return true when result is truthy", function()
            assert.is_true(u.result_msg(nil, 1))
         end)
      end)
   end)

   describe("read input", function()
      describe("boolean", function()
         it("should display a friendly message, when set", function()
            local msg = "Você deseja continuar?"
            local fake_input = new_fake_input("1")
            local result = test_whole_output(u.read_bool_reply, fake_input, msg)
            assert.equals(msg.."\n", result)
         end)
         it("should return true when input is positive", function()
            local input = {
               "s",
               "sim",
               "y",
               "yes",
               "si",
               "sí",
               "true",
               "1",
               "v",
               "t",
               "OK",
            }
            for i=1, #input do
               local fake_input = new_fake_input(input[i])
               local result = test_return_from_input(u.read_bool_reply, fake_input)
               assert.is_true(result)
            end
         end)
      end)

      describe("number", function()
         it("should display a friendly message, when set", function()
            local msg = "Insira um número:"
            local fake_input = new_fake_input("1")
            local result = test_whole_output(u.read_num, fake_input, msg)
            assert.equals(msg.."\n", result)
         end)
         it("should return given numeric values", function()
            local fake_input = new_fake_input("42")
            local result = test_return_from_input(u.read_num, fake_input)
            assert.equals(42, result)
         end)
         it("should return falsy when input is not a number", function()
            local fake_input = new_fake_input("invalid")
            local result = test_return_from_input(u.read_num, fake_input)
            assert.falsy(result)
         end)
      end)

      describe("multiple number", function()
         local input = {
            "1\n",
            "32\n",
            "9\n",
            "47\n",
            "14\n",
            "a\n",
         }
         it("should read indefinitely, when n is unknown", function()
            local fake_input = new_fake_input(unpack(input))
            local result, n = test_return_from_input(u.read_multiple_num, fake_input)
            local expected = {
               1,
               32,
               9,
               47,
               14,
            }
            assert.are.same(expected, result)
            assert.equals(#expected, n)
         end)
         it("should read n numbers", function()
            local fake_input = new_fake_input(unpack(input))
            local expected = {
               1,
               32,
            }
            local result, n = test_return_from_input(u.read_multiple_num, fake_input, #expected)
            assert.are.same(expected, result)
            assert.equals(#expected, n)
         end)
      end)
   end)
end)

describe("Exercise", function()
   describe("1", function()
      it("should sum two values from user input", function()
         local input = {
            19,
            23,
         }
         local result = test_output_from_t(ex[1], input)
         assert.truthy((result):find("42"))
      end)
      it("should handle invalid input", function()
         local input = {
            "a",
            23,
         }
         local result = test_output_from_t(ex[1], input)
         assert.truthy((result):find("Não foi possível"))
      end)
   end)
end)
