import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sahl_exam_app/cubit/states.dart';
import 'package:sahl_exam_app/models/results_model.dart';
import 'package:sahl_exam_app/screens/home/home_screen.dart';
import 'package:sahl_exam_app/screens/student/score_screen.dart';
import 'package:uuid/uuid.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import '../models/users_model.dart';
import '../screens/login/login_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/results/result_screen.dart';
import '../shared/components/components.dart';
import '../shared/network/local/cache_helper/cache_helper.dart';



String? currentUid =  CacheHelper.getData('uid');
bool userPrivileges = CacheHelper.getData("isAdmin");

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);



  Future<void> init() async {
    emit(LoadingState());
    if(!isUserDataFetched) await getUserData(isAdmin: userPrivileges);
    //await getExams();
   // userPrivileges? await  getAllResults() : await getMyResults();
    emit(InitializationCompletedState());
  }

  int currentIndex = 0;
  List<Widget> studentScreens = [
   const HomeScreen(),
    const ResultsScreen(),
    const SettingsScreen(),
    
  ];
  List<Widget> adminScreens = [
    const HomeScreen(),
    const ResultsScreen(),
    const SettingsScreen(),

  ];


  List<String> adminsTitles = ['Home','Student Results', 'Settings'];
  List<String> studentsTitles = ['Home','My Results', 'Settings'];

  void changeIndex(int index) {
    currentIndex = index;

    emit(AppBottomBarState());
  }



  UsersModel? userModel;
  bool isUserDataFetched = false;


  Future<void> getUserData({required bool isAdmin}) async {
    emit(GetUserLoadingState());
    debugPrint('current Cache Uid: $currentUid');
    if (currentUid != null && !isUserDataFetched ) {
      try {
        final value = await FirebaseFirestore.instance.collection(isAdmin? 'Admins':'Users').doc(currentUid).get();

        if (value.exists) {
          userModel = UsersModel.fromJson(value.data()!);

          debugPrint('userModel Username: ${userModel?.name}');


          isUserDataFetched = true;
          emit(GetUserSuccessState());
        } else {
          // Handle the case where the document does not exist

          emit(GetUserFailureState());
        }
      } catch (e) {
        debugPrint('Error while getting user data: ${e.toString()}');
        emit(GetUserFailureState());
      }
    }
  }
  bool isPasswordHiding = true;
  IconData suffix = Icons.visibility;
  void changePasswordVisibility() {
    isPasswordHiding = !isPasswordHiding;
    suffix = isPasswordHiding ? Icons.visibility : Icons.visibility_off;
    emit(ChangePasswordVisibilityState());
  }

  void signOut(BuildContext context) {

      CacheHelper.removeData('uid')?.then((value) {
        CacheHelper.removeData('isAdmin');
        if (value == true) {
          currentUid = null;
          isUserDataFetched = false;
          FirebaseAuth.instance.signOut();
          AppCubit.get(context).userModel = null;
          navigateToAndFinish(context, const LoginScreen());
          debugPrint('Logged out successfully');

          emit(SignOutState());
        }
      });

  }

  Future<void> changePassword({required String currentPassword,required String newPassword}) async{
    emit(ChangePasswordLoadingState());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        toast("The new password has been updated", ToastStates.success);
        emit(ChangePasswordSuccessState());
      } catch (e) {
        if(e.toString().contains("The supplied auth credential is incorrect")){
          toast("The current password is incorrect", ToastStates.error);
        }else{
          toast("Error while updating password: $e", ToastStates.error);
          debugPrint("Error changing password: $e");
        }
        emit(ChangePasswordErrorState());
      }
    }

  }
  int addAnswer(int indexOfAnswers){
    if(indexOfAnswers<5) {
      indexOfAnswers++;

    }
    emit(AddAnswerState());
    return indexOfAnswers;

  }

  int removeAnswer(int indexOfAnswers){
    if(indexOfAnswers>2) {
      indexOfAnswers--;

    }
    emit(RemoveAnswerState());
    return indexOfAnswers;
  }

  void removeQuestion(List<Question> questions,int index){
    questions.removeAt(index);
    emit(RemoveQuestionState());
  }

  String generateId() {
    var uuid = const Uuid();
    return uuid.v4(); // Generate a version 4 (random) UUID
  }

  double sumOfQuestionMarks(List<Question> questions){
    double sum = 0;
    for (var question in questions) {
      sum = sum + question.questionMarks!;
    }
    return sum;
  }

  void addQuestion(GlobalKey<FormState> formKey,TextEditingController questionController, List<TextEditingController> answerControllers, List<bool> selectedRadio, List<Question> questions, int indexOfAnswers,TextEditingController questionDegree) {
    try {
      if (formKey.currentState!.validate()) {
        List<MapEntry<String, bool>> answers = [];
        bool hasTrueAnswer = false; // boolean to check if any answer is true
        answerControllers.asMap().forEach((index, answerController) {
          if (answerController.text.isNotEmpty && questionDegree.text.isNotEmpty) {
            bool hasTrue = selectedRadio[index];
            answers.add(MapEntry<String, bool>(
              answerController.text,
              hasTrue,
            ));
            if (hasTrue) {
              hasTrueAnswer = true; // Set flag if any answer is true
            }
          }
        });

        if (answers.isNotEmpty) {
          if (answers.length > 1) {
            if (hasTrueAnswer) { // Check if any answer is true
              questions.add(Question(
                id: generateId(),
                questionMarks: double.parse(questionDegree.text),
                question: questionController.text,
                answers: Map.fromEntries(answers),
              ));
              questionController.clear();
              // Clear existing answer controllers
              answerControllers.clear();
              // Reinitialize answer controllers with desired count
              answerControllers.addAll(List.generate(5, (_) => TextEditingController()));
              // Reset selected radio values to default
              selectedRadio = List.generate(5, (_) => false);
              indexOfAnswers = 1; // Reset to initial count
              emit(AddQuestionSuccessState());
            } else {
              debugPrint("You can't add a Question without a true answer.");
              toast("You can't add a Question without a true answer.", ToastStates.error);
              emit(AddQuestionErrorState());
            }
          } else {
            debugPrint("You can't add a Question without at least two answers.");
            toast("You can't add a Question without at least two answers.", ToastStates.error);
            emit(AddQuestionErrorState());
          }
        }
      }
    } catch (e) {
      debugPrint("Error while adding questions: $e");
      emit(AddQuestionErrorState());
    }
  }

  void createExam(TextEditingController titleController, List<Question> questions,double passDegreeController ,double examDegreeController ) {
    if (questions.isNotEmpty && titleController.text.isNotEmpty) {
      String examID = generateId();
      emit(ExamCreateLoadingsState());
      ExamModel exams = ExamModel(
        id: examID,
        title: titleController.text,
        questions: questions,
        createdAt:DateTime.now().toString(),
        createdBy: userModel!.name,
        examDegree: examDegreeController,
        passDegree: passDegreeController,
        usersID: [],
      );
      debugPrint(exams.toMap().toString());

           FirebaseFirestore.instance.collection("Exams").doc(examID).set(exams.toMap()).then((value) {
             toast('The exam has been created successfully.', ToastStates.success);
             getExams();
             emit(ExamCreateSuccessState());
           }).catchError((e){
             toast("Error while creating exam: $e", ToastStates.error);
             debugPrint("Error while creating exam: $e");
             emit(ExamCreateErrorState());
           });

    }
  }

  ExamModel? examModel;
  List<ExamModel> exams = [];
  Future<void> getExams({RefreshController? refreshController}) async{
    if(refreshController !=null) refreshController.requestRefresh();
    emit(GetExamsLoadedState());
    FirebaseFirestore.instance.collection('Exams').orderBy('createdAt',descending: true).get().then((value) {
      exams.clear();
      for(var docs in value.docs){
        examModel = ExamModel.fromJson(docs.data());
        exams.add(examModel!);
        //print(docs.data());
      }
      debugPrint('Exams loaded successfully.');
      if(refreshController !=null) refreshController.refreshCompleted();
      emit(GetExamsSuccessState());
    }).catchError((e){
      debugPrint('Error while getting exams data: ${e.toString()}');
      if(refreshController !=null) refreshController.refreshFailed();
      emit(GetExamsErrorState());
    });
  }

  double myScore=0;
  List<String> studentAnswer=[];
  int qIndex = 0;
  void changeQuestionIndex(BuildContext context,{required int questionsLength,required ExamModel examModel}){
    if (answerIndex != -1){
    if(qIndex +1 < questionsLength) {
      studentAnswer.add(examModel.questions![qIndex].answers!.keys.toList()[answerIndex].toString());
      addScore(examModel: examModel);
    answerIndex =-1;
      qIndex++;
    }else{
      studentAnswer.add(examModel.questions![qIndex].answers!.keys.toList()[answerIndex].toString());
      addScore(examModel: examModel);
      saveAndUploadExamResults(context,examModel);
    }

    }else{
      toast("Please choose an answer!", ToastStates.error);
    }
    emit(ChangeQuestionIndexState());
  }

  int answerIndex =-1;
  void changeAnswerIndex(int index){
    answerIndex = index;
    debugPrint(answerIndex.toString());
    emit(AnswerIndexState());
  }

  Future<void> saveAndUploadExamResults(BuildContext context,ExamModel examModel) async{
    String iD = generateId();
    emit(SaveExamResultsLoadingState());
    ResultsModel results = ResultsModel(createdAt:DateTime.now().toString(),uid:userModel!.uid!,examData: examModel, id: iD,score: myScore,studentAnswers:studentAnswer,studentData: userModel);
    FirebaseFirestore.instance.collection('Exams').doc(examModel.id).update({'usersID':FieldValue.arrayUnion([userModel!.uid])}).then((value) {
      debugPrint('User ID uploaded to userID list in exam successfully.');
      FirebaseFirestore.instance.collection('Results').doc(iD).set(results.toMap()).then((value) {
        navigateToAndFinish(context, ScoreScreen(resultsModel: results,));
        debugPrint('User ID uploaded to userID list in exam successfully.');
        emit(SaveExamResultsSuccessState());
      }).catchError((e){

        debugPrint('Error while upload results data: $e');
        emit(SaveExamResultsErrorState());
      });
      emit(UpdateUserIDSuccessState());
    }).catchError((e){
      debugPrint('Error while upload to userID list in exam: $e');
      emit(UpdateUserIDErrorState());
    });
debugPrint(studentAnswer.toList().toString());
debugPrint(myScore.toString());

  }

  void addScore({required ExamModel examModel,}) {
    if(examModel.questions![qIndex].answers!.values.toList()[answerIndex] == true){
      myScore += examModel.questions![qIndex].questionMarks!;
      debugPrint('The Selected answer is correct your score is:$myScore');
    }else{
      debugPrint('The Selected answer is wrong your score is:$myScore');
    }
  }
  
  ResultsModel? myResultsModel;
  List<ResultsModel> myResultsList = [];
  Future<void> getMyResults({RefreshController? refreshController}) async{
    if(refreshController !=null) refreshController.requestRefresh();
    emit(MyResultsLoadingState());
   await FirebaseFirestore.instance.collection('Results').where('uid',isEqualTo: userModel!.uid).get().then((value) {
     myResultsList.clear();
     for(var docs in value.docs){
       myResultsModel = ResultsModel.fromJson(docs.data());
       myResultsList.add(myResultsModel!);
      // print('MyResults Data: ${docs.data()}');
     }
     debugPrint('MyResults loaded successfully.');
     if(refreshController !=null) refreshController.refreshCompleted();
     emit(MyResultsSuccessState());
    }).catchError((e){
     if(refreshController !=null) refreshController.refreshFailed();
      emit(MyResultsErrorState());
   });
  }

ResultsModel? allResultsModel;
  List<ResultsModel> allResultsList = [];
  Future<void> getAllResults({RefreshController? refreshController}) async{
    if(refreshController !=null) refreshController.requestRefresh();
    emit(GetAllResultsLoadingState());
    FirebaseFirestore.instance.collection('Results').get().then((value) {
      allResultsList.clear();
      for(var docs in value.docs){
        allResultsModel = ResultsModel.fromJson(docs.data());
        allResultsList.add(allResultsModel!);
       // print(docs.data());
      }
      debugPrint('All results loaded successfully.');
      if(refreshController !=null) refreshController.refreshCompleted();
      emit(GetAllResultsSuccessState());
    }).catchError((e){
      if(refreshController !=null) refreshController.refreshFailed();
      emit(GetAllResultsErrorState());
    });
  }
  Future<bool> isUserIDInExamList({required String examID}) async{
    bool userStatus = false;
    await FirebaseFirestore.instance.collection('Exams').doc(examID).get().then((value) {
      if(value.exists) {

        if (value['usersID'].toString().contains(userModel!.uid!)) {
          debugPrint('user ID in exam list');
          userStatus =true;
        }else{
          debugPrint('user ID not in exam list');
          userStatus =false;
        }
      }
    }).catchError((e){
      debugPrint(e.message);
      userStatus =false;
    });
    return userStatus;
  }
}
