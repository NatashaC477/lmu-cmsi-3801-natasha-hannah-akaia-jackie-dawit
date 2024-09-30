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
