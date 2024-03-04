import 'package:sahl_exam_app/models/question_model.dart';

class ExamModel {
  String? id;
  String? title;
  String? createdBy;
  String? createdAt;
  double? examDegree;
  double? passDegree;
  List<String>? usersID;
  List<Question>? questions;

  ExamModel({
    this.id,
    this.title,
    this.createdBy,
    this.createdAt,
    this.examDegree,
    this.passDegree,
    this.usersID,
    this.questions,
  });

  ExamModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    createdBy = json["createdBy"];
    createdAt = json["createdAt"];
    examDegree = json["examDegree"]?.toDouble();
    passDegree = json["passDegree"]?.toDouble();
    usersID = List<String>.from(json["usersID"]);
    questions = List.from(json['questions']).map((e)=>Question.fromJson(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'examDegree': examDegree,
      'passDegree': passDegree,
      'usersID':usersID,
      'questions': questions?.map((question) => question.toMap()).toList(),
    };
  }
}


