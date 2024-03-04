import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import 'package:sahl_exam_app/models/results_model.dart';

class ReviewResultsScreen extends StatefulWidget {
  const ReviewResultsScreen({super.key, required this.resultsModel});
final ResultsModel resultsModel;
  @override
  State<ReviewResultsScreen> createState() => _ReviewResultsScreenState();
}

class _ReviewResultsScreenState extends State<ReviewResultsScreen> {
late AppCubit cubit;

@override
  void initState() {
   cubit=AppCubit.get(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state)=> Scaffold(
        appBar: AppBar(title: Text(widget.resultsModel.examData!.title!.toString()),centerTitle: false,),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created at: ${DateTime.parse(widget.resultsModel.createdAt.toString()).toString().substring(0,11)}',style: const TextStyle(fontSize: 18,)),
                if(cubit.userModel!.isAdmin!)
                const SizedBox(height:10),
                if(cubit.userModel!.isAdmin!)
                  Text('Student name: ${widget.resultsModel.studentData!.name!}',style: const TextStyle(fontSize: 18,)),
                if(cubit.userModel!.isAdmin!)
                const SizedBox(height:10),
                if(cubit.userModel!.isAdmin!)
                  Text('Exam created by: ${widget.resultsModel.examData!.createdBy!}',style: const TextStyle(fontSize: 18,)),
                if(cubit.userModel!.isAdmin!)
                  const SizedBox(height:10),
                if(cubit.userModel!.isAdmin!)
                  Text('Exam created at: ${DateTime.parse(widget.resultsModel.examData!.createdAt!).toString().substring(0,11)}',style: const TextStyle(fontSize: 18,)),
                if(cubit.userModel!.isAdmin!)
                const SizedBox(height:10),
                if(cubit.userModel!.isAdmin!)
                  Text('Student score: ${widget.resultsModel.score}',style: const TextStyle(fontSize: 18,)),
                if(cubit.userModel!.isAdmin!)
                  const SizedBox(height:10),
                if(cubit.userModel!.isAdmin!)
                  Text('Student ID: ${widget.resultsModel.studentData!.uid!}',style: const TextStyle(fontSize: 18,)),
                const SizedBox(height:15),
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(color: Colors.blueGrey,);
                  },
                  itemCount: widget.resultsModel.examData!.questions!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder:(context,qIndex)=> Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.resultsModel.examData!.questions![qIndex].question.toString(),
                        style: const TextStyle(fontSize: 26,fontWeight:FontWeight.bold),
                        maxLines: 5,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                            itemCount: widget.resultsModel.examData!.questions![qIndex].answers!.length,
                            itemBuilder: (context,aIndex){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border:widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex] == widget.resultsModel.studentAnswers![qIndex] ? Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ):null
                                        ),
                                        child: Card(
                                          elevation: 2,
                                          color: widget.resultsModel.studentAnswers![qIndex] == widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex] && widget.resultsModel.examData!.questions![qIndex].answers!.values.toList()[aIndex] == true ?
                                          Colors.green :widget.resultsModel.studentAnswers![qIndex] == widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex] && widget.resultsModel.examData!.questions![qIndex].answers!.values.toList()[aIndex] == false ? Colors.red :Colors.white,
                                          shadowColor: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${aIndex + 1}-) ${widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex]}',style:  TextStyle(fontSize:20,color: widget.resultsModel.studentAnswers![qIndex] == widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex]? Colors.white:Colors.black)),
                                          ),

                                        ),
                                      ),
                                      const Spacer(),
                                      if(widget.resultsModel.studentAnswers![qIndex] == widget.resultsModel.examData!.questions![qIndex].answers!.keys.toList()[aIndex] && widget.resultsModel.examData!.questions![qIndex].answers!.values.toList()[aIndex] == true)
                                        Text(
                                          'Marks: +${widget.resultsModel.examData!.questions![qIndex].questionMarks}' , style: const TextStyle(fontSize: 14,),
                                          maxLines: 5,),
                                    ],
                                  ),

                                ],
                              );
                            }),
                      ),
                      const SizedBox(height:15),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
