local test = {}

function test.whole_output(f, fake_input, ...)
   if fake_input then
      io.input(fake_input)
   end
   local fake_output = assert(io.tmpfile("w+"))
   io.output(fake_output)
   f(...)
   fake_output:seek("set", 0)
   return fake_output:read("*all")
end

function test.new_fake_input(...)
   local fake_input = assert(io.tmpfile("w+"))
   local args = {...}
   for i=1, #args do
      fake_input:write(args[i])
   end
   fake_input:seek("set", 0)
   return fake_input
end

function test.return_from_input(f, fake_input, ...)
   io.input(fake_input)
   return f(...)
end

function test.output_from_t(f, t, ...)
   local input = {}
   for i=1,#t do
      input[i] = t[i].."\n"
   end
   local fake_input = test.new_fake_input(unpack(input))
   return test.whole_output(f, fake_input, ...)
end

return test
