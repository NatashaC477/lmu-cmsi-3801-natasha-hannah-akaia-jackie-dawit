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

function first_then_lower_case(array, predicate)
  for _, value in pairs(array) do
    if predicate(value) then
      return string.lower(value)
    end
  end
  return nil
end

function powers_generator(base, limit)
  local power = 1
  return coroutine.create(function()
    while power <= limit do
      coroutine.yield(power)
      power = power * base
    end
  end)
end

function say(word)
  if word == nil then
      return ""
  end
  return function(next)
      if next == nil then
          return word
      else
          return say(word .. " " .. next)
      end
  end
end
-- Write your line count function here

-- Write your Quaternion table here

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
      return string.format("%.1f%s", value, letter)
    end
  end

   -- add real part if not zero
  if math.abs(q.a) >= 1e-10 then
    table.insert(parts, string.format("%.1f", q.a))
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
