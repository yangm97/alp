_G.TEST = true
local exercicios = require "exercicios"
local u = exercicios.u
-- local ex = exercicios.ex

local function test_whole_output(f, ...)
   local fake_output = assert(io.tmpfile("w+"))
   io.output(fake_output)
   f(...)
   fake_output:seek("set", 0)
   return fake_output:read("*all")
end

describe("User interaction", function()
   describe("display message", function()
      describe("number input", function()
         it("should be different for the first input", function()
            local result = test_whole_output(u.insert_msg, 1)
            assert.equals("Insira o primeiro número\n", result)
         end)
         it("should be generic in any other case", function()
            local result = test_whole_output(u.insert_msg, 2)
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
end)
