import 'package:flutter/material.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';

class ExamsCard extends StatefulWidget {
  const ExamsCard({super.key, required this.index});
  final int index;
  @override
  State<ExamsCard> createState() => _ExamsCardState();
}

class _ExamsCardState extends State<ExamsCard> {

  late AppCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    cubit = AppCubit.get(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black,
      color: Colors.cyan.withOpacity(0.5),
      child: ListTile(
        title: Text(cubit.exams[widget.index].title!,maxLines: 5),

        subtitle:  Text('Created by: ${cubit.exams[widget.index].createdBy!}'),

      ),
    );
  }
}
