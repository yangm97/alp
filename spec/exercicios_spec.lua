_G.TEST = true
local exercicios = require "exercicios"
local u = exercicios.u
-- local ex = exercicios.ex
describe("User interaction", function()
	describe("Number input message", function()
		it("should be different for the first input", function()
			local fake_output = assert(io.tmpfile("w+"))
			io.output(fake_output)
			fake_output:seek("set", 0)
			u.insert_msg(1)
			fake_output:seek("set", 0)
			local result = fake_output:read()
			assert.equals("Insira o primeiro número", result)
		end)
		it("should be generic in any other case", function()
			local fake_output = assert(io.tmpfile("w+"))
			io.output(fake_output)
			fake_output:seek("set", 0)
			u.insert_msg(2)
			fake_output:seek("set", 0)
			local result = fake_output:read()
			assert.equals("Insira o próximo número", result)
		end)
	end)
end)

