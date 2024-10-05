import java.util.List;
import java.util.Objects;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.util.ArrayList;  
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
                   .map(String::toLowerCase); // Fix: Add closing brace here
    }
    // SayBuilder class
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

record Quaternion(double a, double b, double c, double d) {
    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);
    private static final double EPSILON = 1e-9;
    // check for NaN
    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }
    // add this quaternion to another quaternion
    public Quaternion plus(Quaternion other) {
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }
    // * this quaternion by another quaternion
    public Quaternion times(Quaternion other) {
        return new Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        );
    }
    // return the conjugate of this quaternion
    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }
    // retune the coefficients
    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }
    // custom equality to handle floating-point precision
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Quaternion that = (Quaternion) o;
        return Math.abs(this.a - that.a) < EPSILON &&
               Math.abs(this.b - that.b) < EPSILON &&
               Math.abs(this.c - that.c) < EPSILON &&
               Math.abs(this.d - that.d) < EPSILON;
    }
    @Override
    public int hashCode() {
        return Objects.hash(a, b, c, d);
    }
    //  toString() 
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        if (a != 0) {
            sb.append(a);
        }
        appendTerm(sb, b, "i");
        appendTerm(sb, c, "j");
        appendTerm(sb, d, "k");
        return sb.length() == 0 ? "0" : sb.toString();
    }
    // helpr method to append terms and formatiing
    private void appendTerm(StringBuilder sb, double value, String letter) {
        if (value == 0) return;

        if (sb.length() > 0 && value > 0) {
            sb.append("+");
        }

        if (value == 1) {
            sb.append(letter);
        } else if (value == -1) {
            sb.append("-").append(letter);
        } else {
            sb.append(value).append(letter);
        }
    }
}

// sealed interface that allows only two implementing classes: 
sealed interface BinarySearchTree permits Empty, Node {
    int size(); // 
    boolean contains(String value); 
    BinarySearchTree insert(String value); 
}

// class representing an empty tree (base case)
final record Empty() implements BinarySearchTree {
    @Override
    public int size() {
        return 0; 
    }
    @Override
    public boolean contains(String value) {
        return false;
    }
    @Override
    public BinarySearchTree insert(String value) {
        // Inserting into an empty tree creates a new node with the value
        return new Node(value, this, this); 
    }
    @Override
    public String toString() {
        return "()"; 
    }
}
// class representing teh non-empty node i
final class Node implements BinarySearchTree {
    private final String value; 
    private final BinarySearchTree left; 
    private final BinarySearchTree right; 
    // constructor which initializex
    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }
    @Override
    public int size() {
        return 1 + left.size() + right.size(); 
    }
    @Override
    public boolean contains(String value) {
        if (value.equals(this.value)) {
            return true;
        } else if (value.compareTo(this.value) < 0) {
            return left.contains(value); // check the left 
        } else {
            return right.contains(value); // check the right 
        }
    }
    @Override
    public BinarySearchTree insert(String value) {
        if (value.equals(this.value)) {
            return this; // if the value is already present, return the current node 
        } else if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right); // instyt into the left subtree
        } else {
            return new Node(this.value, left, right.insert(value)); // inesert into the right subtree
        }
    }
    @Override
    public String toString() {
        String leftStr = left.toString().equals("()") ? "" : left.toString();
        String rightStr = right.toString().equals("()") ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")"; 
    }
}
