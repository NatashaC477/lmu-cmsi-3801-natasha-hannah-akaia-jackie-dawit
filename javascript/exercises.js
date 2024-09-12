import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here

// Write your powers generator here

// Write your say function here

// Write your line count function here

// Write your Quaternion class here

export class Quaternion {
  // constructor to initialize quaternion
  constructor(a, b, c, d) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    Object.freeze(this);
  }

  // return the coefficients of the quaternion as an array
  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  // return the conjugate of the quaternion
  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  // add another quaternion to this quaternion
  plus(q) {
    return new Quaternion(this.a + q.a, this.b + q.b, this.c + q.c, this.d + q.d);
  }

  // multiply this quaternion by another quaternion
  times(q) {
    return new Quaternion(
      this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d,
      this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c,
      this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b,
      this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a
    );
  }

  // return a string representation of the quaternion
  toString() {
    const parts = [];

    // Add real part if it's not zero
    if (this.a !== 0) {
      parts.push(`${this.a}`);
    }

    // add 'i' part if it's not zero
    if (this.b !== 0) {
      if (parts.length === 0) {
        if (Math.abs(this.b) === 1) {
          parts.push(`${this.b > 0 ? 'i' : '-i'}`);
        } else {
          parts.push(`${this.b}i`);
        }
      } else {
        if (Math.abs(this.b) === 1) {
          parts.push(`${this.b > 0 ? '+i' : '-i'}`);
        } else {
          parts.push(`${this.b > 0 ? `+${this.b}i` : `${this.b}i`}`);
        }
      }
    }

    // add 'j' part if it's not zero
    if (this.c !== 0) {
      if (parts.length === 0) {
        if (Math.abs(this.c) === 1) {
          parts.push(`${this.c > 0 ? 'j' : '-j'}`);
        } else {
          parts.push(`${this.c}j`);
        }
      } else {
        if (Math.abs(this.c) === 1) {
          parts.push(`${this.c > 0 ? '+j' : '-j'}`);
        } else {
          parts.push(`${this.c > 0 ? `+${this.c}j` : `${this.c}j`}`);
        }
      }
    }

    // add 'k' part if it's not zero
    if (this.d !== 0) {
      if (parts.length === 0) {
        if (Math.abs(this.d) === 1) {
          parts.push(`${this.d > 0 ? 'k' : '-k'}`);
        } else {
          parts.push(`${this.d}k`);
        }
      } else {
        if (Math.abs(this.d) === 1) {
          parts.push(`${this.d > 0 ? '+k' : '-k'}`);
        } else {
          parts.push(`${this.d > 0 ? `+${this.d}k` : `${this.d}k`}`);
        }
      }
    }

    // return '0' if no parts were added, otherwise join the parts into a string
    return parts.length === 0 ? '0' : parts.join('');
  }
  
}
