_G.TEST = true
local test = require "spec.test"
local ex = require "alp.cap4"

describe("Exercise", function()
   describe("1", function()
      it("should sum two values from user input", function()
         local input = {
            19,
            23,
         }
         local result = test.output_from_t(ex[1], input)
         assert.truthy((result):find("42"))
      end)
      it("should handle invalid input", function()
         local input = {
            "a",
            23,
         }
         local result = test.output_from_t(ex[1], input)
         assert.truthy((result):find("Não foi possível"))
      end)
   end)

   describe("2", function()
      it("should sum n values from user input and show n", function()
         local input = {
            19,
            18,
            5,
            "",
         }
         local result = test.output_from_t(ex[2], input)
         assert.truthy((result):find("42"))
         assert.truthy((result):find("3"))
      end)
   end)

   describe("3", function()
      it("should sum n values from user input and show the average", function()
         local input = {
            19,
            18,
            5,
            "",
         }
         local result = test.output_from_t(ex[3], input)
         assert.truthy((result):find("42"))
         assert.truthy((result):find("14"))
      end)
   end)

   describe("4", function()
      it("should print values from 1-100", function()
         local expected = ""
         for i=1,100 do
            expected = expected..i.."\n"
         end
         local result = test.whole_output(ex[4])
         assert.equals(expected, result)
      end)
   end)

   describe("5", function()
      it("should print values from 500 to 100 in 5 steps", function()
         local expected = ""
         for i=500,100,-5 do
            expected = expected..i.."\n"
         end
         local result = test.whole_output(ex[5])
         assert.equals(expected, result)
      end)
   end)

   describe("6", function()
      it("should convert Farenheit to Celsius", function()
         local input = {
            100,
         }
         local result = test.output_from_t(ex[6], input)
         -- assert.truthy((result):find("37.78"))
         assert.truthy((result):find("37.7"))
      end)
   end)

   describe("7", function()
      it("should work with a single salary", function()
         local input = {
            1000,
            "",
         }
         local result = test.output_from_t(ex[7], input)
         -- assert.truthy((result):find("R$120.00"))
         assert.truthy((result):find("R$120"))
         -- assert.truthy((result):find("R$1120.00"))
         assert.truthy((result):find("R$1120"))
      end)
      it("should work with multiple salaries", function()
         local input = {
            1000,
            2000,
            3000,
            "",
         }
         local result = test.output_from_t(ex[7], input)
         -- assert.truthy((result):find("R$720.00"))
         assert.truthy((result):find("R$720"))
         -- assert.truthy((result):find("R$6720.00"))
         assert.truthy((result):find("R$6720"))
      end)
   end)

   describe("8", function()
      it("should calculate prices", function()
         local input = {
            "R$550",
            "R$950",
         }
         local result = test.output_from_t(ex[8], input)
         assert.truthy((result):find("R$1620"))
      end)
   end)

   describe("9", function()
      it("should sum, multiply and divide two values from user input", function()
         local input = {
            19,
            23,
         }
         local result = test.output_from_t(ex[9], input)
         assert.truthy((result):find("42"))
         assert.truthy((result):find("437"))
         assert.truthy((result):find("0.82608695652174"))
      end)
   end)

   describe("10", function()
      it("should print price + ICMS tax", function()
         local input = {
            "R$100",
         }
         local result = test.output_from_t(ex[10], input)
         assert.truthy((result):find("R$115"))
      end)
   end)

   describe("11", function()
      it("should print building cost", function()
         local input = {
            "42h",
            "11h",
         }
         local result = test.output_from_t(ex[11], input)
         assert.truthy((result):find("R$508"))
      end)
   end)

   describe("12", function()
      it("should convert years to days", function()
         local input = {
            "42 anos",
         }
         local result = test.output_from_t(ex[12], input)
         assert.truthy((result):find("15330"))
      end)
   end)

   describe("13", function()
      it("should print the difference between two years in days", function()
         local input = {
            "2018",
            "0",
         }
         local result = test.output_from_t(ex[13], input)
         assert.truthy((result):find("736570"))
      end)
      it("should not display difference as a negative value", function()
         local input = {
            "0",
            "2018",
         }
         local result = test.output_from_t(ex[13], input)
         assert.falsy((result):find("-736570"))
         assert.truthy((result):find("736570"))
      end)
   end)

   describe("14", function()
      it("should print weighted grades from user input", function()
         local input = {
            "10",
            "10",
            "10",
            "10",
            "0",
            "0",
         }
         local result = test.output_from_t(ex[14], input)
         assert.truthy((result):find("7.8"))
      end)
   end)
end)
