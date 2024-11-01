import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<A, B>(
  array: A[],
  predicate: (value: A) => boolean,
  transform: (value: A) => B
): B | undefined {
  const firstMatch = array.find(predicate);
  return firstMatch !== undefined ? transform(firstMatch) : undefined;
}

interface PowersConfig {
  ofBase: bigint;
}

export function* powersGenerator({ ofBase }: PowersConfig): Generator<bigint> {
  let power = BigInt(1); // Converted 1n to BigInt(1)
  while (true) {
    yield power;
    power = power * ofBase;
  }
}

import { createReadStream } from 'fs';
import { createInterface } from 'readline';

export async function meaningfulLineCount(filename: string): Promise<number> {
  let count = 0;
  
  const fileStream = createReadStream(filename);
  const rl = createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  try {
    for await (const line of rl) {
      const trimmedLine = line.trim();
      if (trimmedLine && !trimmedLine.startsWith('#')) {
        count++;
      }
    }
    return count;
  } catch (error: any) {
    if (error.code === 'ENOENT') {
      throw new Error(`No such file: ${filename}`);
    }
    throw error;
  } finally {
    rl.close();
    fileStream.destroy();
  }
}

interface Sphere {
  kind: "Sphere"
  radius: number
}
interface Box { 
  kind: "Box"
  width: number
  length: number
  depth: number
}
//a union type 'Shape' that can either be a Sphere or a Box.
export type Shape = Sphere | Box
// calculate the surface area of a shape
export function surfaceArea(shape: Shape): number {
  if (shape.kind === "Sphere") {
    return 4 * Math.PI * Math.pow(shape.radius, 2);
  } else {
    const { width, length, depth } = shape;
    return 2 * (width * length + length * depth + depth * width); 
  }
}
// calculate the volume of a shape
export function volume(shape: Shape): number {
  if (shape.kind === "Sphere") {
    return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
  } else {
    const { width, length, depth } = shape;
    return width * length * depth;
  }
}

export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
  toString(): string;
} 
// empty binary search tree
class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }
  insert(value: T): BinarySearchTree<T> {
    return new Node(value, new Empty<T>(), new Empty<T>());
  }
  contains(value: T): boolean {
    return false;
  }
  *inorder(): Iterable<T> {
  }
  toString(): string {
    return "()";
  }
} 
class Node<T> implements BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T> = new Empty<T>(),
    private right: BinarySearchTree<T> = new Empty<T>()
  ) {}
  // return the number of nodes in the tree
  size(): number {
    return 1 + this.left.size() + this.right.size();
  }
  // insert a value into the tree
  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.value, this.left.insert(value), this.right);
    } else if (value > this.value) {
      return new Node(this.value, this.left, this.right.insert(value));
    } else {
      return this; 
    }
  } 
  contains(value: T): boolean {
    if (value < this.value) {
      return this.left.contains(value);
    } else if (value > this.value) {
      return this.right.contains(value);
    } else {
      return true;
    }
  }
  // return an iterator that yields the values in order
  *inorder(): Iterable<T> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  } 
  // return a string representation of the tree
  toString(): string {
    const leftStr = this.left.toString().replace("()", "");
    const rightStr = this.right.toString().replace("()", "");
    if (!leftStr && !rightStr) {
      return `(${this.value})`;
    } else if (!leftStr) {
      return `(${this.value}${rightStr})`;
    } else if (!rightStr) {
      return `(${leftStr}${this.value})`;
    } else {
      return `(${leftStr}${this.value}${rightStr})`;
    }
  }
}
export { Empty };
