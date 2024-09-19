function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- This function takes an array and a predicate function as arguments
-- It returns the first value that satisfies the predicate, converted to lowercase
-- If no value satisfies the predicate, it returns nil
function first_then_lower_case(array, predicate)
  -- Iterate through each value in the array
  for _, value in pairs(array) do
      -- Check if the current value satisfies the predicate function
      if predicate(value) then
          -- If it does, immediately return the lowercase version of this value
          return string.lower(value)
      end
  end
  -- If no value in the array satisfies the predicate, return nil
  return nil
end

-- This function creates a generator for powers of a given base up to a specified limit
-- It returns a coroutine that yields successive powers
function powers_generator(base, limit)
  -- Initialize the power to 1 (anything to the power of 0 is 1)
  local power = 1
  -- Create and return a new coroutine
  return coroutine.create(function()
      -- Continue generating powers while we're below or equal to the limit
      while power <= limit do
          -- Yield the current power value
          coroutine.yield(power)
          -- Calculate the next power by multiplying the current power by the base
          power = power * base
      end
  end)
end

-- This function creates a sentence builder
-- It takes a word as an argument and returns a function that can be used to build a sentence
function say(word)
  -- If no word is provided (nil), return an empty string
  if word == nil then
      return ""
  end
  
  -- Return a new function that takes the next word as an argument
  return function(next)
      -- If there's no next word, we've reached the end of the sentence
      if next == nil then
          -- Return the current word, effectively ending the sentence
          return word
      else
          -- If there is a next word, recursively call say() with the current word
          -- concatenated with a space and the next word
          return say(word .. " " .. next)
      end
  end
end

function meaningful_line_count(user_file)
  -- We open the file here
  local file = assert(io.open(user_file, "r"))
  -- Initialize a counter for meaningful lines
  local count = 0
  -- Read the file line by line
  for line in file:lines() do
      -- Trim leading and trailing whitespace
      line = line:match("^%s*(.-)%s*$")
      -- Check if the line is not empty and doesn't start with '#'
      if line ~= "" and line:sub(1, 1) ~= "#" then
          count = count + 1
      end
  end
  -- Close the file
  file:close()
  -- If count is 0, return an empty table, otherwise return the count
  return count > 0 and count or {}
end

-- quaternion class
Quaternion = {}
Quaternion.__index = Quaternion

-- constructor to create a new Quaternion
function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

-- overload the '+' operator for quaternion addition
function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

-- overload the '*' operator for quaternion multiplication
function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

-- overload the '==' operator for quaternion equality check
function Quaternion.__eq(q1, q2)
  local epsilon = 1e-10
  return math.abs(q1.a - q2.a) < epsilon and
         math.abs(q1.b - q2.b) < epsilon and
         math.abs(q1.c - q2.c) < epsilon and
         math.abs(q1.d - q2.d) < epsilon
end

-- convert quaternion to string representation
function Quaternion.__tostring(q)
  local parts = {}

   -- helper function to format a term for string representation
  local function format_term(value, letter)
    if math.abs(value) < 1e-10 then
      return ''
    elseif math.abs(value - 1) < 1e-10 then
      return letter
    elseif math.abs(value + 1) < 1e-10 then
      return '-' .. letter
    else
      return value .. letter
    end
  end

   -- add real part if not zero
  if math.abs(q.a) >= 1e-10 then
    table.insert(parts, q.a)
  end

    -- add 'i', 'j', 'k' parts if not zero
  if math.abs(q.b) >= 1e-10 then
    table.insert(parts, format_term(q.b, 'i'))
  end

  if math.abs(q.c) >= 1e-10 then
    table.insert(parts, format_term(q.c, 'j'))
  end

  if math.abs(q.d) >= 1e-10 then
    table.insert(parts, format_term(q.d, 'k'))
  end

  -- return '0' if no parts were added, otherwise join the parts into a string
  if #parts == 0 then
    return "0"
  end

  local result = parts[1]
  for i = 2, #parts do
    if parts[i]:sub(1, 1) == '-' then
      result = result .. parts[i]
    else
      result = result .. '+' .. parts[i]
    end
  end

  return result
end

-- get the coefficients of the quaternion
function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

-- get the conjugate of the quaternion
function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end
