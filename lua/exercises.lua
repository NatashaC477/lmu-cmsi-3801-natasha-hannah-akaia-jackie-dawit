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

-- Write your first then lower case function here

-- Write your powers generator here

-- Write your say function here

-- Write your line count function here

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

function Quaternion.__eq(q1, q2)
  local epsilon = 1e-10
  return math.abs(q1.a - q2.a) < epsilon and
         math.abs(q1.b - q2.b) < epsilon and
         math.abs(q1.c - q2.c) < epsilon and
         math.abs(q1.d - q2.d) < epsilon
end

function Quaternion.__tostring(q)
  local parts = {}
  if q.a ~= 0 then
    table.insert(parts, string.format("%.1f", q.a))
  end
  if q.b ~= 0 then
    table.insert(parts, string.format("%+.1fi", q.b))
  end
  if q.c ~= 0 then
    table.insert(parts, string.format("%+.1fj", q.c))
  end
  if q.d ~= 0 then
    table.insert(parts, string.format("%+.1fk", q.d))
  end

  if #parts == 0 then
    return "0"
  end

  return table.concat(parts):gsub("^%+", "")
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end
