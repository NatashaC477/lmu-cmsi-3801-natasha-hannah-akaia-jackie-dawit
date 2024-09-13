from dataclasses import dataclass
from collections.abc import Callable
from typing import Tuple
import math


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
''' iterates over a string-- and checks if the item satisfies the predicate function'''
def first_then_lower_case(lst, predicate):
    for item in lst:
        if predicate(item):
            return item.lower()
        ''' if not, return none'''
    return None

# Write your powers generator here
''' generator function  yields powers of a base up to a specified limit '''
def powers_generator(base: int, limit: int):
    power = 1  
    while power <= limit:  
        yield power  
        '''multiply the current power by the base to get the next power'''
        power *= base 



# Write your say function here
# Function that accumulates words and returns them as a single space-separated string
def say(word=None):
    '''initialize an empty list to store the words'''
    words = [] 
    '''handle adding new words or returning the result'''
    def inner(new_word=None):
        if new_word is not None: 
            ''' add the new word to the list '''
            words.append(new_word)  
            return inner  
        '''check for new word if not return the accumulated words as a space-separated string'''
        return ' '.join(words)  
    
    if word is not None:  
        '''add initial word to list'''
        words.append(word)  
        return inner  
    '''if no initial word is provided, return the result of the inner function immediately'''
    return inner()  





# Write your line count function here
def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r') as file:
            '''initialize a counter for meaningful lines'''
            count = 0  
            for line in file:
                '''remove front and end whitespace'''
                line = line.strip()  
                if line and not line.startswith('#'): 
                    count += 1  
                    '''' Return the final count of meaningful lines'''
            return count  
    except FileNotFoundError as e:  
        raise FileNotFoundError(f'No such file: {filename}') from e



# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, other: 'Quaternion') -> 'Quaternion':
        """
        Adds two quaternions, 
        returns sum
        """
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d
        )

    def __mul__(self, other: 'Quaternion') -> 'Quaternion':
        """
        Multiplies two quaternions, 
        returns product
        """
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        )

    def __eq__(self, other: object) -> bool:
        """
        Checks if two quaternions are equal
        returns true if both quaternions are equal, false otherwise
        """
        if not isinstance(other, Quaternion):
            return NotImplemented
        return (
            math.isclose(self.a, other.a) and
            math.isclose(self.b, other.b) and
            math.isclose(self.c, other.c) and
            math.isclose(self.d, other.d)
        )

    def __str__(self) -> str:
        """
        Returns a string representation of the quaternion in the form 'a + bi + cj + dk'
        """
        parts = []

        def format_term(value: float, letter: str) -> str:
            """
            Formats a term of the quaternion for string representation, and returns it
            """
            if math.isclose(value, 0):
                return ''
            if math.isclose(value, 1):
                return letter
            if math.isclose(value, -1):
                return '-' + letter
            return f"{value}{letter}"

        if not math.isclose(self.a, 0):
            parts.append(f"{self.a}")

        if not math.isclose(self.b, 0):
            parts.append(format_term(self.b, 'i'))

        if not math.isclose(self.c, 0):
            parts.append(format_term(self.c, 'j'))

        if not math.isclose(self.d, 0):
            parts.append(format_term(self.d, 'k'))

        if len(parts) == 0:
            return "0"

        result = parts[0]
        for part in parts[1:]:
            if part.startswith('-'):
                result += part
            else:
                result += '+' + part

        return result

    @property
    def coefficients(self) -> Tuple[float, float, float, float]:
        """
        Returns the coefficients of the quaternion as a tuple
        """
        return self.a, self.b, self.c, self.d

    @property
    def conjugate(self) -> 'Quaternion':
        """
        Returns the conjugate of the quaternion
        """
        return Quaternion(self.a, -self.b, -self.c, -self.d)
