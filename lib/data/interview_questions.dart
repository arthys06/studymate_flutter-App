/// Mock interview question bank. Each question has a sample answer and a
/// short tip — this is built-in logic (no live AI call), designed to look
/// and feel like real interview coaching.
class InterviewQuestion {
  final String question;
  final String sampleAnswer;
  final String tip;

  const InterviewQuestion({
    required this.question,
    required this.sampleAnswer,
    required this.tip,
  });
}

const Map<String, List<InterviewQuestion>> interviewBank = {
  'Java': [
    InterviewQuestion(
      question: 'What is the difference between JDK, JRE, and JVM?',
      sampleAnswer:
          'JVM runs the bytecode. JRE = JVM + libraries needed to run Java apps. '
          'JDK = JRE + development tools (compiler, debugger) needed to build apps.',
      tip: 'Structure it as three short definitions, then say how they relate (JDK contains JRE contains JVM).',
    ),
    InterviewQuestion(
      question: 'What is the difference between an interface and an abstract class?',
      sampleAnswer:
          'An interface only declares method signatures (a contract); a class implementing '
          'it must define all methods. An abstract class can have both implemented and '
          'unimplemented methods, and supports single inheritance only.',
      tip: 'Give one line on each, then one line on when you would choose one over the other.',
    ),
    InterviewQuestion(
      question: 'Explain exception handling in Java.',
      sampleAnswer:
          'Java uses try-catch-finally blocks. Code that might throw an error goes in try, '
          'the specific error type is caught in catch, and cleanup code goes in finally, '
          'which always runs.',
      tip: 'Mention try/catch/finally explicitly — interviewers listen for these exact keywords.',
    ),
  ],
  'Flutter': [
    InterviewQuestion(
      question: 'What is the difference between StatelessWidget and StatefulWidget?',
      sampleAnswer:
          'A StatelessWidget is immutable — it can\'t change once built. A StatefulWidget '
          'holds mutable state via a State object, and calling setState() rebuilds the UI.',
      tip: 'Give a concrete example: a static icon (Stateless) vs. a counter button (Stateful).',
    ),
    InterviewQuestion(
      question: 'What is the widget tree and how does Flutter rendering work?',
      sampleAnswer:
          'Flutter builds a tree of widgets describing the UI. Each widget produces an '
          'Element, which maps to a RenderObject that handles actual layout and painting.',
      tip: 'You don\'t need deep internals — mention widget → element → render object as the flow.',
    ),
    InterviewQuestion(
      question: 'How would you manage state in a mid-sized Flutter app?',
      sampleAnswer:
          'For small apps, setState is enough. For medium apps, Provider or Riverpod keeps '
          'state separate from UI and easy to share across screens.',
      tip: 'Naming a specific solution (Provider/Riverpod/Bloc) shows you\'ve actually built something.',
    ),
  ],
  'DBMS': [
    InterviewQuestion(
      question: 'What is normalization and why is it used?',
      sampleAnswer:
          'Normalization organizes data to reduce redundancy and avoid update/insert/delete '
          'anomalies, by splitting tables based on functional dependencies.',
      tip: 'Mention at least 1NF/2NF/3NF by name — interviewers often ask a follow-up on one of them.',
    ),
    InterviewQuestion(
      question: 'What is the difference between a primary key and a foreign key?',
      sampleAnswer:
          'A primary key uniquely identifies each row in its own table. A foreign key is a '
          'column in one table that references a primary key in another, enforcing referential integrity.',
      tip: 'Use the word "referential integrity" — it signals you understand why foreign keys matter.',
    ),
    InterviewQuestion(
      question: 'Explain ACID properties in databases.',
      sampleAnswer:
          'Atomicity (all-or-nothing), Consistency (valid state to valid state), Isolation '
          '(concurrent transactions don\'t interfere), Durability (committed data survives a crash).',
      tip: 'Say the acronym expansion first, then one short phrase per letter — very easy to memorize this way.',
    ),
  ],
  'OS': [
    InterviewQuestion(
      question: 'What is a process vs a thread?',
      sampleAnswer:
          'A process is an independent program in execution with its own memory space. A '
          'thread is a lighter unit within a process, sharing memory with other threads in that process.',
      tip: 'Emphasize "shared memory" for threads — that\'s the key distinction interviewers listen for.',
    ),
    InterviewQuestion(
      question: 'What is a deadlock and how can it be prevented?',
      sampleAnswer:
          'A deadlock happens when processes wait on each other\'s resources in a cycle, so '
          'none can proceed. Prevention: avoid circular wait, use resource ordering, or timeouts.',
      tip: 'Naming the 4 deadlock conditions (mutual exclusion, hold and wait, no preemption, circular wait) is a strong answer.',
    ),
  ],
  'Data Structures': [
    InterviewQuestion(
      question: 'What is the difference between an array and a linked list?',
      sampleAnswer:
          'An array has fixed size and contiguous memory with O(1) access by index. A linked '
          'list grows dynamically, with O(1) insertion/deletion but O(n) access.',
      tip: 'Give one clear tradeoff: arrays = fast access, linked lists = fast insert/delete.',
    ),
    InterviewQuestion(
      question: 'When would you use a stack vs a queue?',
      sampleAnswer:
          'Stack is LIFO — used for undo functionality, expression evaluation, backtracking. '
          'Queue is FIFO — used for task scheduling, printer queues, breadth-first search.',
      tip: 'Give one real example per structure — concrete examples read as strong answers.',
    ),
  ],
};
