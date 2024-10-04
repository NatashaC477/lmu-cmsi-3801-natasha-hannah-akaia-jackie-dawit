import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // Method to find the first string that matches a predicate and convert it to lowercase
    static Optional<String> firstThenLowerCase(List<String> list, Predicate<String> predicate) {
        if (list == null || list.isEmpty()) {
            return Optional.empty();
        }
        return list.stream()
                   .filter(predicate)
                   .findFirst()
                   .map(String::toLowerCase);

    public static class SayBuilder {
        private final List<String> words;

        // Constructor for an empty phrase
        public SayBuilder() {
            this.words = new ArrayList<>();
        }

        // Constructor with initial words
        public SayBuilder(List<String> initialWords) {
            this.words = new ArrayList<>(initialWords);
        }

        // Method to add a word and return a new SayBuilder with updated words list
        public SayBuilder and(String word) {
            List<String> newWords = new ArrayList<>(words);
            newWords.add(word);
            return new SayBuilder(newWords);
        }

        // Method to generate the full phrase
        public String phrase() {
            return String.join(" ", words);
        }
    }

    // Method to create a SayBuilder with optional initial words
    public static SayBuilder say(String... words) {
        if (words == null || words.length == 0) {
            return new SayBuilder();
        } else {
            return new SayBuilder(List.of(words));
        }
    }

    // Method to count meaningful lines in a file
    static int meaningfulLineCount(String filePath) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            return (int) reader.lines()
                               .map(String::trim) // Trim each line
                               .filter(line -> !line.isEmpty() && !line.startsWith("#")) // Check for meaningful lines
                               .count();
        }
    }
}

record Quaternion(double a, double b, double c, double d){
    // Define commonly used Quaternions as constant values
    public final static Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public final static Quaternion I = new Quaternion(0, 1, 0, 0);
    public final static Quaternion J = new Quaternion(0, 0, 1, 0);
    public final static Quaternion K = new Quaternion(0, 0, 0, 1);
    // Adds this quaternion to another quaternion
    public Quaternion plus(Quaternion other) {
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }

    // Multiplies this quaternion by another quaternion
    public Quaternion times(Quaternion other) {
        return new Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        );
    }

    // Returns the conjugate of this quaternion
    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }
    // Returns the coefficients of this quaternion as a list
    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    @Override
    public String toString() {
        var sb = new StringBuilder();
        // Add the real part to the string if it's not zero
        if (a != 0) {
            sb.append(a);
        }
        if (b != 0) {
            if (sb.length() > 0) {
                sb.append(b > 0 ?  "+" : "");
            }
            sb.append(b).append("i");
        }
        if (c != 0) {
            if (sb.length() > 0) {
                sb.append(c > 0 ?  "+" : "");
            }
            sb.append(c).append("j");
        }
        if (d != 0) {
            if (sb.length() > 0) {
                sb.append(d > 0 ?  "+" : "");
            }
            sb.append(d).append("k");
        }
        return sb.length() == 0 ? "0" : sb.toString();
    }
}


// Sealed interface that allows only two implementing classes: Empty and Node
sealed interface BinarySearchTree permits Empty, Node {
    int size(); // Method to return the number of nodes in the tree
    boolean contains(String value); // Method to check if the tree contains a given value
    BinarySearchTree insert(String value); // Method to insert a value into the tree
}

// Class representing an empty tree (base case)
final record Empty() implements BinarySearchTree {
    @Override
    public int size() {
        return 0; // An empty tree has no nodes
    }

    @Override
    public boolean contains(String value) {
        return false; // An empty tree cannot contain any values
    }

    @Override
    public BinarySearchTree insert(String value) {
        // Inserting into an empty tree creates a new node with the value
        return new Node(value, this, this); 
    }

    @Override
    public String toString() {
        return "()"; // String representation of an empty tree
    }
}

// Class representing a non-empty node in the tree
final class Node implements BinarySearchTree {
    private final String value; // Value stored in the current node
    private final BinarySearchTree left; // Left subtree
    private final BinarySearchTree right; // Right subtree

    // Constructor to initialize the node with a value and subtrees
    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        // Size of the tree is 1 (this node) plus the size of the left and right subtrees
        return 1 + left.size() + right.size();
    }

    @Override
    public boolean contains(String value) {
        // Check if this node or its subtrees contain the value
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }

    @Override
    public BinarySearchTree insert(String value) {
        // Insert a new value, maintaining binary search tree properties
        if (value.compareTo(this.value) < 0) {
            // If the new value is smaller, insert it in the left subtree
            return new Node(this.value, left.insert(value), right);
        } else {
            // If the new value is larger or equal, insert it in the right subtree
            return new Node(this.value, left, right.insert(value));
        }
    }

    @Override
    public String toString() {
        // String representation of the tree, showing left and right subtrees
        return "(" + left + value + right + ")";
    }
}
