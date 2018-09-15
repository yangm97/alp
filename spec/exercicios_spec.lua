_G.TEST = true
local exercicios = require "exercicios"
local u = exercicios.u
-- local ex = exercicios.ex

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
   end)
end)
