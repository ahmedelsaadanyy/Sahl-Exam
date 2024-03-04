import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';

import '../../models/question_model.dart';

class ReviewQuestions extends StatefulWidget {
  const ReviewQuestions({super.key, required this.questions, required this.examDegree});
  final List<Question> questions;
  final double examDegree;

  @override
  State<ReviewQuestions> createState() => _ReviewQuestionsState();
}

class _ReviewQuestionsState extends State<ReviewQuestions> {
  late AppCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = AppCubit.get(context);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state) {
     return Scaffold(
        appBar: AppBar(
          title: const Text("Review Questions"),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total questions: ${widget.questions.length}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              if(cubit.sumOfQuestionMarks(widget.questions) != widget.examDegree)
               Row(
                children: [
                  Icon(Icons.warning,color: Colors.yellow.shade800,size: 20,),
                  const SizedBox(width: 5),
                  const Text("Total question marks not equal to Exam degree.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text("Total question marks / Exam degree:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(" ${cubit.sumOfQuestionMarks(widget.questions)} /",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color:cubit.sumOfQuestionMarks(widget.questions) != widget.examDegree?Colors.red:Colors.green ),),
                  Text(" ${widget.examDegree}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              const Text('Questions: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              cubit.removeQuestion(widget.questions, index);
                            },
                            icon:  Icon(
                              Icons.remove_circle_outlined,
                              color: Colors.red.shade900,
                            )),
                        Card(
                          color:Colors.blueGrey ,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Question ${index + 1}",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text("Question Marks: ${widget.questions[index].questionMarks}",style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text(widget.questions[index].question!,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                for(int i=0; i < widget.questions[index].answers!.length;i++)
                                Text("Answer ${i+1}: ${widget.questions[index].answers!.keys.toList()[i]}: ${widget.questions[index].answers!.values.toList()[i] == true?'Correct':'Wrong'}",style:  TextStyle(fontSize: 16,color: widget.questions[index].answers!.values.toList()[i] == true? Colors.green.shade300:Colors.red.shade900)),

                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
