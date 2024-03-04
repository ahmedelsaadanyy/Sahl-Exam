import 'package:flutter/material.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/models/exam_model.dart';
import 'package:sahl_exam_app/screens/exams/start_exam.dart';
import 'package:sahl_exam_app/shared/components/components.dart';

class ViewExam extends StatefulWidget {
  const ViewExam({super.key, required this.exam});
final ExamModel exam;
  @override
  State<ViewExam> createState() => _AdminViewExamState();
}

class _AdminViewExamState extends State<ViewExam> {
 late AppCubit cubit;
 @override
  void initState() {
    cubit= AppCubit.get(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title!,style: const TextStyle(fontSize: 26,),),
        centerTitle: false,
        clipBehavior: Clip.antiAlias,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Created by: ${widget.exam.createdBy}',style: const TextStyle(fontSize: 18,)),
          const SizedBox(height:5),
          Text('Total questions: ${widget.exam.questions!.length}',style: const TextStyle(fontSize: 18,)),
            const SizedBox(height:5),
          Text('Exam total marks: ${widget.exam.examDegree}',style: const TextStyle(fontSize: 18,)),
            const SizedBox(height:5),
          Text('Pass from: ${widget.exam.passDegree}',style: const TextStyle(fontSize: 18,)),
            const SizedBox(height:5),
          Text('Total students : ${widget.exam.usersID!.length}',style: const TextStyle(fontSize: 18,)),
            const SizedBox(height:5),
          Text('Created at : ${DateTime.parse(widget.exam.createdAt.toString()).toString().substring(0,11)}',style: const TextStyle(fontSize: 18,)),
            const SizedBox(height:35),
            Center(child:cubit.userModel!.isAdmin!? const Text('Login as student to start answering the exam',style:TextStyle(fontSize: 18,color: Colors.red)) :ElevatedButton(onPressed: () async {
              bool userStatus = await cubit.isUserIDInExamList(examID:widget.exam.id!);
              if(!userStatus) {
                if (context.mounted)  navigateTo(context, StartExamScreen(examModel: widget.exam,));
              }else{
                toast('You have already answered the exam.', ToastStates.error);
              }
              },style:ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.green), ),
              child: const Text('Start', style:TextStyle(fontSize: 20,color: Colors.white)),)),
        ],),
      ),);
  }
}
