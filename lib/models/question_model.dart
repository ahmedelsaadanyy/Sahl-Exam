class Question {
  String? id;
  double? questionMarks;
  String? question;
  Map<String, bool>? answers;

  Question({
    this.id,
    this.questionMarks,
    this.question,
    this.answers,
  });

  Question.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    questionMarks = json["questionMarks"].toDouble();
    question = json["question"];
    answers = Map<String, bool>.from(json["answers"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionMarks': questionMarks,
      'question': question,
      'answers': answers,
    };
  }

}