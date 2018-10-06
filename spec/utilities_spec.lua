_G.TEST = true
local unpack = unpack or table.unpack -- luacheck: ignore 143
local test = require "spec.test"
local u = require "alp.utilities"
local cap4 = require "alp.cap4"

describe("Utility", function()
   describe("to_number", function()
      it("should extract numeric values from strings", function()
         local str = {
            [28] = "28 ºC",
            [100] = "100%",
            [99] = "abc 99 ",
            [50.12] = "R$ 50,12",
            [-200] = " -200 ",
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
            local result = test.whole_output(u.insert_msg, nil, 1)
            assert.equals("Insira o primeiro número\n", result)
         end)
         it("should be generic in any other case", function()
            local result = test.whole_output(u.insert_msg, nil, 2)
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
            local fake_input = test.new_fake_input("1")
            local result = test.whole_output(u.read_bool_reply, fake_input, msg)
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
               local fake_input = test.new_fake_input(input[i])
               local result = test.return_from_input(u.read_bool_reply, fake_input)
               assert.is_true(result)
            end
         end)
      end)

      describe("number", function()
         it("should display a friendly message, when set", function()
            local msg = "Insira um número:"
            local fake_input = test.new_fake_input("1")
            local result = test.whole_output(u.read_num, fake_input, msg)
            assert.equals(msg.."\n", result)
         end)
         it("should return given numeric values", function()
            local fake_input = test.new_fake_input("42")
            local result = test.return_from_input(u.read_num, fake_input)
            assert.equals(42, result)
         end)
         it("should return falsy when input is not a number", function()
            local fake_input = test.new_fake_input("invalid")
            local result = test.return_from_input(u.read_num, fake_input)
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
            local fake_input = test.new_fake_input(unpack(input))
            local result, n = test.return_from_input(u.read_multiple_num, fake_input)
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
            local fake_input = test.new_fake_input(unpack(input))
            local expected = {
               1,
               32,
            }
            local result, n = test.return_from_input(u.read_multiple_num, fake_input, #expected)
            assert.are.same(expected, result)
            assert.equals(#expected, n)
         end)
      end)
   end)
end)

describe("Menu", function()
   it("should be able to exit", function()
      local input = {
         "sair",
      }
      local result = test.output_from_t(u.main, input, cap4)
      assert.equals([[Digite o número do exercício que você deseja executar.
Você também pode digitar "todos" para executar todos em sequência.
Digite "sair" para sair.
]], result)
   end)
   it("should be able to run the given exercise", function()
      local input = {
         "1",
         "1",
         "1",
         "n",
         "sair",
      }
      local result = test.output_from_t(u.main, input, cap4)
      assert.truthy((result):find("2"))
      assert.truthy((result):find("Deseja executar o exercício 1 novamente?"))
      assert.truthy((result):find('Digite "sair" para sair.'))
   end)
   it("should be able to, when given, jump into exercises", function()
      local input = {
         "1",
         "2",
         "n",
         "sair",
      }
      local result = test.output_from_t(u.main, input, cap4, "1")
      assert.truthy((result):find("3"))
      assert.truthy((result):find("Deseja executar o exercício 1 novamente?"))
      assert.truthy((result):find('Digite "sair" para sair.'))
   end)
   it("should be handle unknown exercises", function()
      local input = {
         "0",
         "n",
         "sair",
      }
      local result = test.output_from_t(u.main, input, cap4)
      assert.truthy((result):find("Exercício não encontrado."))
   end)
   it("should display the error message from failed runs", function()
      local input = {
         "2",
         "",
         "n",
         "sair",
      }
      local result = test.output_from_t(u.main, input, cap4)
      assert.truthy((result):find("É necessário no mínimo dois valores numéricos para se realizar uma soma."))
   end)
end)
