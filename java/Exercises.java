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

    // Write your first then lower case function here
    // Method to find the first string that matches a predicate and convert it to lowercase
    static Optional<String> firstThenLowerCase(List<String> list, Predicate<String> predicate) {
        if (list == null || list.isEmpty()) {
            return Optional.empty();
        }
        return list.stream()
                   .filter(predicate)
                   .findFirst()
                   .map(String::toLowerCase);

    // Write your say function here
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


    // Write your line count function here
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

// Write your Quaternion record class here

// Write your BinarySearchTree sealed interface and its implementations here
