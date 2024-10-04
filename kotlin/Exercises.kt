import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import java.io.File


fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// Write your first then lower case function here
fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? { 
    return string.firstOrNull(predicate)?.lowercase() // returns possible String, ?. operator which handles null cases
}

// Write your say function here
class say(val sentence: String = "") { // set original sentence to "" for empty string cases
    fun and(nextWord: String): say {
        return say("${this.sentence} $nextWord") 
    }

    val phrase: String 
        get() = this.sentence
}

// Write your meaningfulLineCount function here
fun meaningfulLineCount(filename: String): Long {
    return try {
        // open file with buffered reader
        BufferedReader(FileReader(File(filename))).use { reader ->
            var count: Long = 0 // counter to track lines
            reader.forEachLine { line ->
                // remove white space 
                val trimmedLine = line.trim()
                if (trimmedLine.isNotEmpty() && !trimmedLine.startsWith("#")) {
                    count++
                }
            }
            // return total count
            count
        }
    } catch (e: IOException) {
        // if not found or opened throw
        throw IOException("No such file: $filename", e)
    }
}

// Write your Quaternion data class here
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) { 

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
    operator fun plus(other: Quaternion): Quaternion { // using operator fun to overload + operator (addition)
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion { // using operator fun to overload * operator (multiplication)
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }

    override fun toString(): String {
        val parts = mutableListOf<String>() // mutable so that the list's strings can be modified

        fun formatTerm(value: Double, letter: String): String {
            return when {
                value == 0.0 -> ""
                value == 1.0 -> letter
                value == -1.0 -> "-$letter"
                else -> "$value$letter"
            }
        }

        if (a != 0.0) parts.add("$a")
        if (b != 0.0) parts.add(formatTerm(b, "i"))
        if (c != 0.0) parts.add(formatTerm(c, "j"))
        if (d != 0.0) parts.add(formatTerm(d, "k"))

        if (parts.isEmpty()) return "0"

        var result = parts[0]
        for (part in parts.drop(1)) {
            result += if (part.startsWith("-")) part else "+$part"
        }

        return result

    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is Quaternion) return false

        return this.a == other.a &&
               this.b == other.b &&
               this.c == other.c &&
               this.d == other.d
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)

    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)
}



// Write your Binary Search Tree interface and implementing classes here
sealed interface BinarySearchTree {
    // method to insert a new value into the tree, returning a new instance 
    fun insert(value: String): BinarySearchTree
    // method to check if a value is contained in the tree
    fun contains(value: String): Boolean
    // methof to get the size of the tree (number of elements)
    fun size(): Int
    // method to get the size of the tree (number of elements)
    override fun to
    String(): String

//  representing an empty Binary Search Tree
    object Empty : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree {
            return Node(value, Empty, Empty)
        }

        override fun contains(value: String): Boolean = false

        override fun size(): Int = 0

        override fun toString(): String = "()"
    }
    // data class representing a node in the Binary Search Tree

    data class Node(
        val value: String,
        val left: BinarySearchTree = Empty,
        val right: BinarySearchTree = Empty
    ) : BinarySearchTree {
          // insert a new value into the tree, maintaining binary search tree props

        override fun insert(newValue: String): BinarySearchTree {
            return when {
                newValue < value -> Node(value, left.insert(newValue), right)
                newValue > value -> Node(value, left, right.insert(newValue))
                else -> this // Prevent duplicates
            }
        }

        override fun contains(value: String): Boolean {
            return when {
                value < this.value -> left.contains(value)
                value > this.value -> right.contains(value)
                else -> true // Value found
            }
        }
       // calc the size of the tree, counting this node and its children

        override fun size(): Int = 1 + left.size() + right.size()
        // str representation of the tree in the expected format

        override fun toString(): String {
            val leftStr = left.toString().takeIf { it != "()" } ?: ""
            val rightStr = right.toString().takeIf { it != "()" } ?: ""
            return "$leftStr$value$rightStr".let { if (it.isNotEmpty()) "($it)" else it }
        }
    }
}
