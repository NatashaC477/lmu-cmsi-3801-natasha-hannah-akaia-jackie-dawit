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

// Write your say function here

// Write your meaningfulLineCount function here
fun meaningfulLineCount(filename: String): Long {
    return try {
        //open file with buffered reader
        BufferedReader(FileReader(File(filename))).use { reader ->
            var count: Long = 0 //counter to track lines
            reader.forEachLine { line ->
                //remove white space 
                val trimmedLine = line.trim()
                if (trimmedLine.isNotEmpty() && !trimmedLine.startsWith("#")) {
                    count++
                }
            }
            //return total count
            count
        }
    } catch (e: IOException) {
        //if not found or opened throw
        throw IOException("No such file: $filename", e)
    }
}


// Write your Quaternion data class here

// Write your Binary Search Tree interface and implementing classes here
sealed interface BinarySearchTree {
    // method to insert a new value into the tree, returning a new instance 
    fun insert(value: String): BinarySearchTree
    // method to check if a value is contained in the tree
    fun contains(value: String): Boolean
    //methof to get the size of the tree (number of elements)
    fun size(): Int
    //method to get the size of the tree (number of elements)
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
