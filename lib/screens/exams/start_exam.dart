import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import '../../models/exam_model.dart';

class StartExamScreen extends StatefulWidget {
  const StartExamScreen({super.key, required this.examModel});
  final ExamModel examModel;
  @override
  State<StartExamScreen> createState() => _StartExamScreenState();
}

class _StartExamScreenState extends State<StartExamScreen> {

  late AppCubit cubit;


  @override
  void initState() {
    cubit = AppCubit.get(context);
    cubit.answerIndex =-1;
    cubit.myScore=0;
    cubit.qIndex=0;
    cubit.studentAnswer=[];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder:(context,state) {
       return Scaffold(
          appBar: AppBar(
            title: Text('Question ${cubit.qIndex +1}/${widget.examModel.questions!
                .length}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                         const Spacer(),
                          Text(
                            'Marks:${widget.examModel.questions![cubit.qIndex ].questionMarks}' , style: const TextStyle(fontSize: 14,),
                            maxLines: 5,),
                        ],
                      ),
                      Text(
                        widget.examModel.questions![cubit.qIndex ].question
                            .toString(), style: const TextStyle(fontSize: 26,fontWeight:FontWeight.bold),
                        maxLines: 5,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                            physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                            itemCount: widget.examModel.questions![cubit.qIndex ].answers!.length,
                            itemBuilder: (context,index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  cubit.changeAnswerIndex(index);
                                },
                                child: Card(
                                  elevation: 2,
                                  color: cubit.answerIndex == index? Colors.brown.withOpacity(0.5) :Colors.white,
                                  shadowColor: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${index + 1}-) ${widget.examModel.questions![cubit.qIndex].answers!.keys.toList()[index]}',style:  TextStyle(fontSize:20,color: cubit.answerIndex == index? Colors.white:Colors.black)),
                                    ),

                                ),
                              ),
                            ],
                          );
                        }),
                      )

                    ],
                  ),
                ),
                const Spacer(),
                Center(child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:widget.examModel.questions!.length == cubit.qIndex +1? const MaterialStatePropertyAll(Colors.blue) : const MaterialStatePropertyAll(Colors.green),
                  ),
                    onPressed: () {
                  cubit.changeQuestionIndex(context,questionsLength: widget.examModel.questions!.length,examModel: widget.examModel);
                },
                    child: Text(
                        widget.examModel.questions!.length > cubit.qIndex +1
                            ? 'Next'
                            : 'Submit',style: const TextStyle(color: Colors.white,fontSize: 20),),
                )),

              ],
            ),
          ),
        );

      }
    );
  }
}
