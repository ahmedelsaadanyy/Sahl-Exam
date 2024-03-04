import 'package:sahl_exam_app/models/exam_model.dart';
import 'package:sahl_exam_app/models/users_model.dart';

class ResultsModel{
  String? id;
  String? uid;
  String? createdAt;
  double? score;
  List<String>? studentAnswers;
  ExamModel? examData;
  UsersModel? studentData;

  ResultsModel({
      this.id,
    this.uid,
    this.createdAt,
      this.score,
      this.studentAnswers,
      this.examData,
      this.studentData
      });

  ResultsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    createdAt = json["createdAt"];
    score = json["score"];
    studentAnswers = List<String>.from(json["studentAnswers"]);
    examData = ExamModel.fromJson(json["examData"]);
    studentData = UsersModel.fromJson(json["studentData"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'uid':uid,
      'createdAt':createdAt,
      'score':score,
      'studentAnswers': studentAnswers,
      'examData': examData?.toMap(),
      'studentData': studentData?.toMap(),
    };
  }
}