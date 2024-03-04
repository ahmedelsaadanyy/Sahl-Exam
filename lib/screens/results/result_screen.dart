import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import 'package:sahl_exam_app/screens/results/review_results.dart';
import 'package:sahl_exam_app/shared/components/components.dart';


class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late AppCubit cubit;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
   cubit = AppCubit.get(context);
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
      builder:(context,state) {
        return Scaffold(
          body:  SmartRefresher(
            header: const WaterDropHeader(waterDropColor: Colors.blue),
            onRefresh: (){
              cubit.userModel!.isAdmin! ? cubit.getAllResults(refreshController: refreshController):cubit.getMyResults(refreshController: refreshController);

              },
            controller: refreshController,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ConditionalBuilder(
                condition: !cubit.userModel!.isAdmin! ? cubit.myResultsList.isNotEmpty : cubit.allResultsList.isNotEmpty ,
                fallback: (context)=>const Center(child: Text('No Results.',style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold)),),
                builder:(context)=> ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount:cubit.userModel!.isAdmin! ? cubit.allResultsList.length :cubit.myResultsList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          navigateTo(context, ReviewResultsScreen(resultsModel: cubit.userModel!.isAdmin! ? cubit.allResultsList[index] :cubit.myResultsList[index],));
                        },
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.black,
                          color: Colors.cyan.withOpacity(0.5),
                          child: ListTile(
                            title: Text(cubit.userModel!.isAdmin! ? cubit.allResultsList[index].examData!.title! :cubit.myResultsList[index].examData!.title!,maxLines: 5),
                            subtitle: Text(
                                cubit.userModel!.isAdmin! ?'Student: ${cubit.allResultsList[index].studentData!.name!}' :'Created by:  ${cubit.myResultsList[index].examData!.createdBy!}'),

                          ),
                        ),
                      );
                    }, ),
              ),
            ),
          ),

        );

      }
    );
  }
}
