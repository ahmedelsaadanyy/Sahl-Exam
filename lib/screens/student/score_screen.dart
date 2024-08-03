import 'package:flutter/material.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/layouts/student_layout.dart';
import 'package:sahl_exam_app/models/results_model.dart';
import 'package:sahl_exam_app/screens/results/review_results.dart';
import 'package:sahl_exam_app/shared/components/components.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key, required this.resultsModel});
final ResultsModel resultsModel;
  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  late AppCubit cubit;

  @override
  void initState() {
    cubit = AppCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
appBar: AppBar(title: const Text('Your Score')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(widget.resultsModel.score! >= widget.resultsModel.examData!.passDegree!? 'Congratulations, you have passed the exam.' :'Unfortunately, You have failed to pass the exam.',style: (const TextStyle(fontSize: 18)),),
          Text('Your score: ${widget.resultsModel.score} || pass from: ${widget.resultsModel.examData!.passDegree!}',style: (const TextStyle(fontSize: 18))),
          const  Spacer(),
Center(child: ElevatedButton(onPressed: (){navigateTo(context, ReviewResultsScreen(resultsModel: widget.resultsModel));}, child: const Text('Results',style: TextStyle(fontSize: 20),))),
Center(child: ElevatedButton(onPressed: (){cubit.getExams();cubit.getUserData(isAdmin: false);navigateToAndFinish(context,const StudentMainScreen());}, child: const Text('Home',style: TextStyle(fontSize: 20),))),
          ],
        ),
      ),
    );
  }
}
