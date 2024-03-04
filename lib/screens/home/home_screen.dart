import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import 'package:sahl_exam_app/shared/components/components.dart';
import '../../shared/components/widgets/exams_card.dart';
import '../admins/create_exam.dart';
import '../exams/view_exam.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppCubit cubit;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    cubit =AppCubit.get(context);
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
      return Scaffold(
        floatingActionButton:FloatingActionButton(
          onPressed: (){navigateTo(context, const CreateNewExamScreen());},
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          child: const Icon(FontAwesomeIcons.plus,size: 20,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SmartRefresher(
            header: const WaterDropHeader(waterDropColor: Colors.blue),
            onRefresh: (){ cubit.getExams(refreshController: refreshController);},
            controller: refreshController,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Text("Exams",style:TextStyle(fontSize: 24,fontWeight:FontWeight.bold)),
                  const SizedBox(height: 10,),
                  ConditionalBuilder(
                      condition: cubit.examModel != null,
                      builder: (context){
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cubit.exams.length,
                            itemBuilder: (context,index){
                          return GestureDetector(onTap:(){navigateTo(context,  ViewExam(exam:cubit.exams[index]) );},child: ExamsCard(index:index));
                        });
                      },
                      fallback: (context)=> const Center(child: Text('No Exams.',style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}


