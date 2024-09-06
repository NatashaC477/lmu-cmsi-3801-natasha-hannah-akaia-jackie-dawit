from dataclasses import dataclass
from collections.abc import Callable
from dataclasses import dataclass
from typing import Tuple


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here
def first_then_lower_case(lst, predicate):
    for item in lst:
        if predicate(item):
            return item.lower()
    return None

# Write your powers generator here
def powers_generator(base: int, limit: int):
    power = 1
    while power <= limit:
        yield power
        power *= base


# Write your say function here
def say(word=None):
    words = []
    
    def inner(new_word=None):
        if new_word is not None:
            words.append(new_word)
            return inner
        return ' '.join(words)
    
    if word is not None:
        words.append(word)
        return inner
    return inner()




# Write your line count function here
def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r') as file:
            count = 0
            for line in file:
                line = line.strip()
                if line and not line.startswith('#'):
                    count += 1
            return count
    except FileNotFoundError as e:
        raise FileNotFoundError(f'No such file: {filename}') from e



# Write your Quaternion class here
from dataclasses import dataclass
from typing import Tuple

@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float
    @property
    def coefficients(self) -> Tuple[float, float, float, float]:
        return (self.a, self.b, self.c, self.d)
    @property
    def conjugate(self) -> 'Quaternion':
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d
        )
    def __mul__(self, other: 'Quaternion') -> 'Quaternion':
        if not isinstance(other, Quaternion):
            return NotImplemented
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        )
    def __eq__(self, other: 'Quaternion') -> bool:
        if not isinstance(other, Quaternion):
            return NotImplemented
        return (self.a, self.b, self.c, self.d) == (other.a, other.b, other.c, other.d)
    def __str__(self) -> str:
        parts = []
        if self.a != 0 or not any([self.b, self.c, self.d]):
            parts.append(f"{self.a}")
        if self.b != 0:
            if self.b == 1:
                parts.append("i")
            elif self.b == -1:
                parts.append("-i")
            else:
                parts.append(f"{self.b}i")
        if self.c != 0:
            if self.c == 1:
                parts.append("+j" if parts else "j")
            elif self.c == -1:
                parts.append("-j")
            else:
                parts.append(f"+{self.c}j" if self.c > 0 else f"{self.c}j")
        if self.d != 0:
            if self.d == 1:
                parts.append("+k" if parts else "k")
            elif self.d == -1:
                parts.append("-k")
            else:
                parts.append(f"+{self.d}k" if self.d > 0 else f"{self.d}k")
        if not parts:
            return "0"
        result = ''.join(parts)
        result = result.lstrip('+')

        return result