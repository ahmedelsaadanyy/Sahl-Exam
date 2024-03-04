import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import 'package:sahl_exam_app/screens/admins/review_questions.dart';
import 'package:sahl_exam_app/shared/components/components.dart';
import '../../models/exam_model.dart';
import '../../models/question_model.dart';


class CreateNewExamScreen extends StatefulWidget {
  const CreateNewExamScreen({super.key});

  @override
  State<CreateNewExamScreen> createState() => _CreateNewExamScreenState();
}

class _CreateNewExamScreenState extends State<CreateNewExamScreen> {
  late ExamModel examModel;
  late AppCubit cubit;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _passDegreeController = TextEditingController();
  final TextEditingController _examDegreeController = TextEditingController();
  final TextEditingController _questionDegreeController = TextEditingController();
  final List<TextEditingController> _answerControllers = [];
  final List<bool> _selectedRadio = [];
  final List<Question> _questions = [];
  final formKey = GlobalKey<FormState>();
  int indexOfAnswers = 2;
  @override
  void initState() {
    super.initState();
    examModel = ExamModel();
    _answerControllers.addAll(List.generate(5, (_) => TextEditingController()));
    _selectedRadio.addAll(List.generate(5, (_) => false));
    cubit = AppCubit.get(context);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _questionController.dispose();
    _passDegreeController.dispose();
    _examDegreeController.dispose();
    _questionDegreeController.dispose();
    _answerControllers.clear();
    _selectedRadio.clear();
    _questions.clear();
  }




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create New Exam'),
              toolbarHeight: 50,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Exam Title',
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (v) {
                          if (v != null && v.isEmpty) {
                            return 'The title can not be empty.';
                          } else {
                            if (v!.startsWith(" ")) {
                              return 'The title can not start with spaces.';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _examDegreeController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: 'Exam Degree',
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              validator: (v) {
                                if (v != null && v.isEmpty) {
                                  return 'The exam degree can not be empty.';
                                } else {
                                  if (v!.startsWith(" ")) {
                                    return 'The exam degree can not start with spaces.';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _passDegreeController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                labelText: 'Pass Degree',
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              validator: (v) {
                                if (v != null && v.isEmpty) {
                                  return 'The pass degree can not be empty.';
                                } else {
                                  if (v!.startsWith(" ")) {
                                    return 'The pass degree can not start with spaces.';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _questionDegreeController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Question Marks',
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (v) {
                          if (v != null && v.isEmpty) {
                            return 'The Question marks can not be empty.';
                          } else {
                            if (v!.startsWith(" ")) {
                              return 'The Question marks can not start with spaces.';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _questionController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Question',
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        validator: (v) {
                          if (v != null && v.isEmpty) {
                            return 'The Question can not be empty.';
                          } else {
                            if (v!.startsWith(" ")) {
                              return 'The Question can not start with spaces.';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: indexOfAnswers,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _answerControllers.length > i ? _answerControllers[i] : TextEditingController(),
                                    maxLines: 1,
                                    decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
                                  ),
                                ),
                                Radio<bool>(
                                  value: true,
                                  groupValue: _selectedRadio[i],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRadio[i] = value!;
                                    });
                                  },
                                ),
                                const Text('Correct'),
                                Radio<bool>(
                                  value: false,
                                  groupValue: _selectedRadio[i],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRadio[i] = value!;
                                    });
                                  },
                                ),
                                const Text('Wrong'),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                indexOfAnswers = cubit.addAnswer(indexOfAnswers);
                              },
                              child: const Text('Add Answer'),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                indexOfAnswers = cubit.removeAnswer(indexOfAnswers);
                              },
                              child: const Text('Remove Answer'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          cubit.addQuestion(formKey, _questionController, _answerControllers, _selectedRadio, _questions, indexOfAnswers, _questionDegreeController);
                        },
                        child: const Text('Add Question'),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          if (_questions.isNotEmpty) {
                            navigateTo(context, ReviewQuestions(questions: _questions, examDegree: double.parse(_examDegreeController.text)));
                          } else {
                            toast('No Questions to review!', ToastStates.error);
                          }
                        },
                        child: const Text('Review Questions'),
                      ),
                      ConditionalBuilder(
                        condition: state is! ExamCreateLoadingsState,
                        fallback: (context) => const Center(child: CircularProgressIndicator()),
                        builder: (context) => ElevatedButton(
                          onPressed: () {
                            cubit.createExam(_titleController, _questions, double.parse(_passDegreeController.text), double.parse(_examDegreeController.text));
                          },
                          child: const Text('Create Exam'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
