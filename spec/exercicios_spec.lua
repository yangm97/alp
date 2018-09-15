_G.TEST = true
local exercicios = require "exercicios"
local u = exercicios.u
-- local ex = exercicios.ex

local function test_single_output(f, ...)
	local fake_output = assert(io.tmpfile("w+"))
	io.output(fake_output)
	f(...)
	fake_output:seek("set", 0)
	return fake_output:read()
end

describe("User interaction", function()
	describe("Number input message", function()
		it("should be different for the first input", function()
			local result = test_single_output(u.insert_msg, 1)
			assert.equals("Insira o primeiro número", result)
		end)
		it("should be generic in any other case", function()
			local result = test_single_output(u.insert_msg, 2)
			assert.equals("Insira o próximo número", result)
		end)
	end)
end)

