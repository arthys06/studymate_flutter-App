/// Simple keyword-matched responses for the AI Doubt Chat screen.
/// No live AI call — this is rule-based, but structured so it can be
/// swapped for a real LLM API call later without changing the UI.
String getDoubtChatResponse(String userMessage) {
  final msg = userMessage.toLowerCase();

  final Map<List<String>, String> responses = {
    ['binary search']:
        'Binary search finds an item in a sorted list by repeatedly halving the search range: '
        'compare the middle element, then search the left or right half depending on the result. '
        'Time complexity: O(log n).',
    ['oop', 'object oriented']:
        'Object-Oriented Programming organizes code around objects — bundles of data (fields) '
        'and behavior (methods). Core ideas: Encapsulation, Inheritance, Polymorphism, Abstraction.',
    ['normalization']:
        'Normalization organizes database tables to reduce redundancy, done in stages (1NF, 2NF, '
        '3NF...), each removing a specific kind of duplicate/dependency issue.',
    ['recursion']:
        'Recursion is when a function calls itself to solve a smaller version of the same problem, '
        'until it hits a base case that stops the calls. Common in tree traversal, factorial, Fibonacci.',
    ['pointer', 'pointers']:
        'A pointer is a variable that stores the memory address of another variable, rather than a '
        'value directly. Used heavily in C/C++ for direct memory access and dynamic data structures.',
    ['api']:
        'An API (Application Programming Interface) is a defined way for one piece of software to '
        'talk to another — a set of rules for requests and responses, without exposing internal logic.',
    ['deadlock']:
        'A deadlock happens when two or more processes are stuck waiting on each other\'s resources, '
        'forming a cycle where none can proceed.',
    ['inheritance']:
        'Inheritance lets a class (child) reuse fields/methods from another class (parent), and '
        'optionally override or extend its behavior.',
  };

  for (final entry in responses.entries) {
    for (final keyword in entry.key) {
      if (msg.contains(keyword)) return entry.value;
    }
  }

  return "That's a good question! Here's a simple way to think about it: break the concept into "
      "smaller parts, look at one small example, and build up from there. Try asking about a "
      "specific topic (e.g. 'explain recursion' or 'what is normalization') and I'll walk you "
      "through it.";
}
