// A class for an expandable stack. There is already a stack class in the
// Standard C++ Library; this class serves as an exercise for students to
// learn the mechanics of building generic, expandable, data structures
// from scratch with smart pointers.

#include <stdexcept>
#include <string>
#include <memory>
using namespace std;

// A stack object wraps a low-level array indexed from 0 to capacity-1 where
// the bottommost element (if it exists) will be in slot 0. The member top is
// the index of the slot above the top element, i.e. the next available slot
// that an element can go into. Therefore if top==0 the stack is empty and
// if top==capacity it needs to be expanded before pushing another element.
// However for security there is still a super maximum capacity that cannot
// be exceeded.

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
  unique_ptr<T[]> elements;
  size_t capacity;
  size_t top;

  void reallocate(size_t new_capacity) {
    if (new_capacity > MAX_CAPACITY) throw overflow_error("Stack has reached maximum capacity");
    if (new_capacity < INITIAL_CAPACITY) new_capacity = INITIAL_CAPACITY;
    unique_ptr<T[]> new_elements = make_unique<T[]>(new_capacity);
    copy(elements.get(), elements.get() + top, new_elements.get());
    elements = move(new_elements);
    capacity = new_capacity;
  }

  // Prohibit copying and assignment
  Stack(const Stack&) = delete;
  Stack& operator=(const Stack&) = delete;

public:
  Stack() : elements(make_unique<T[]>(INITIAL_CAPACITY)), capacity(INITIAL_CAPACITY), top(0) {}

  size_t size() const { return top; }

  bool is_empty() const { return top == 0; }

  bool is_full() const { return top == capacity; }

  void push(const T& value) {
    if (is_full()) reallocate(capacity * 2);
    elements[top++] = value;
  }

  T pop() {
    if (is_empty()) throw underflow_error("cannot pop from empty stack");
    T value = elements[--top];
    if (top < capacity / 4 && capacity > INITIAL_CAPACITY) reallocate(capacity / 2);
    return value;
  }
};
