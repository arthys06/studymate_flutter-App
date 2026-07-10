/// Basic-level quiz questions grouped by topic. Used by the Quiz screen;
/// results get saved to the DB and read back by Weakness Detection.
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

const Map<String, List<QuizQuestion>> quizBank = {
  'Mathematics': [
    QuizQuestion(question: 'What is 12 x 8?', options: ['96', '86', '108', '92'], correctIndex: 0),
    QuizQuestion(question: 'Square root of 144?', options: ['10', '12', '14', '16'], correctIndex: 1),
    QuizQuestion(question: 'What is 15% of 200?', options: ['20', '25', '30', '35'], correctIndex: 2),
    QuizQuestion(question: '7 + 6 x 2 = ?', options: ['26', '19', '13', '20'], correctIndex: 1),
    QuizQuestion(question: 'What is the value of pi (approx)?', options: ['3.12', '3.14', '3.41', '3.24'], correctIndex: 1),
  ],
  'Programming': [
    QuizQuestion(question: 'Which keyword declares a constant in Dart?', options: ['var', 'final', 'const', 'both final and const'], correctIndex: 3),
    QuizQuestion(question: 'What does OOP stand for?', options: ['Object Oriented Programming', 'Order Of Priority', 'Object Order Process', 'None'], correctIndex: 0),
    QuizQuestion(question: 'Which data structure uses FIFO?', options: ['Stack', 'Queue', 'Tree', 'Graph'], correctIndex: 1),
    QuizQuestion(question: 'Time complexity of binary search?', options: ['O(n)', 'O(log n)', 'O(n^2)', 'O(1)'], correctIndex: 1),
    QuizQuestion(question: 'Which is not a programming paradigm?', options: ['Functional', 'Object-Oriented', 'Alphabetical', 'Procedural'], correctIndex: 2),
  ],
  'DBMS': [
    QuizQuestion(question: 'DBMS stands for?', options: ['Database Management System', 'Data Backup Management System', 'Digital Base Management Software', 'None'], correctIndex: 0),
    QuizQuestion(question: 'Which key uniquely identifies a row?', options: ['Foreign Key', 'Primary Key', 'Candidate Key', 'Composite Key'], correctIndex: 1),
    QuizQuestion(question: 'SQL stands for?', options: ['Structured Query Language', 'Simple Query Language', 'Sequential Query Language', 'None'], correctIndex: 0),
    QuizQuestion(question: 'Which normal form removes partial dependency?', options: ['1NF', '2NF', '3NF', 'BCNF'], correctIndex: 1),
    QuizQuestion(question: 'Which command removes a table entirely?', options: ['DELETE', 'DROP', 'TRUNCATE', 'REMOVE'], correctIndex: 1),
  ],
};
