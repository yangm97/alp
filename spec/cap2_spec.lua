_G.TEST = true
local test = require "spec.test"
local ex = require "alp.cap2"

describe("Exercise", function()
   describe("1", function()
      it("should sum 10 and 5", function()
         local result = test.whole_output(ex[1])
         assert.truthy((result):find("15"))
      end)
   end)
   describe("2", function()
      it("should say Fatec", function()
         local result = test.whole_output(ex[2])
         assert.truthy((result):find("Fatec"))
      end)
   end)
   describe("3", function()
      it("should multiply two values from user input", function()
         local input = {
            14,
            3,
         }
         local result = test.output_from_t(ex[3], input)
         assert.truthy((result):find("42"))
      end)
   end)
   describe("4", function()
      it("should sum three values from user input", function()
         local input = {
            10,
            9,
            23,
         }
         local result = test.output_from_t(ex[4], input)
         assert.truthy((result):find("42"))
      end)
   end)
   describe("5", function()
      it("should calculate salary raises", function()
         local input = {
            "R$ 900",
            "10%",
         }
         local result = test.output_from_t(ex[5], input)
         assert.truthy((result):find("990"))
         assert.truthy((result):find("90"))
      end)
   end)
   describe("6", function()
      it("should convert hours into minutes", function()
         local input = {
            "42h",
         }
         local result = test.output_from_t(ex[6], input)
         assert.truthy((result):find("2520"))
      end)
   end)
   describe("7", function()
      it("should convert kilometers in meters", function()
         local input = {
            "42km",
         }
         local result = test.output_from_t(ex[7], input)
         assert.truthy((result):find("42000"))
      end)
   end)
   describe("8", function()
      it("should calculate salary minus INSS tax", function()
         local input = {
            "R$ 900",
            "R$ 200",
         }
         local result = test.output_from_t(ex[8], input)
         assert.truthy((result):find("1012"))
      end)
   end)
   describe("9", function()
      it("should calculate ICMS tax", function()
         local input = {
            "42 kw",
         }
         local result = test.output_from_t(ex[9], input)
         assert.truthy((result):find("5.94"))
      end)
   end)
end)
