import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/layouts/admin_layout.dart';
import '../../../cubit/cubit.dart';
import '../../../layouts/student_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper/cache_helper.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPasswordHiding = true;
  IconData suffix = Icons.visibility;
  bool isAdminChecked = false;

  void changeAdminCheckValue(bool isAdminCheckedValue){
    isAdminChecked = isAdminCheckedValue;
    emit(AdminCheckState());
  }

  static Color loginTextColor = Colors.black.withOpacity(0.8);

  void changePasswordVisibility() {
    isPasswordHiding = !isPasswordHiding;
    suffix = isPasswordHiding ? Icons.visibility : Icons.visibility_off;
    emit(ChangePasswordVisibilityState());
  }

  Future<void> userLogin(String email, String password, context) async {
    emit(LoginLoadingState());

       await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((userCredentials) async {
            await FirebaseFirestore.instance.collection(isAdminChecked? "Admins":"Users").doc(
               userCredentials.user!.uid).get().then((value) async {
              if (value.exists) {
                final uid = userCredentials.user!.uid;
                await CacheHelper.saveData('uid', uid);
                debugPrint('Uid: $uid Saved successfully');
                currentUid = uid;
                userPrivileges =isAdminChecked;
                await CacheHelper.saveData("isAdmin", isAdminChecked);
                AppCubit.get(context).isUserDataFetched = false;
                await AppCubit.get(context).getUserData(isAdmin: isAdminChecked).then((value) async {
                  toast('Logged in successfully', ToastStates.success);
                  //AppCubit.get(context).getExams();
                  AppCubit.get(context).changeIndex(0);
                  navigateToAndFinish(context, isAdminChecked ? const AdminMainScreen(): const StudentMainScreen());
                  emit(LoginSuccessState());
                }).catchError((e){
                  debugPrint("Error while Login(userLogin): $e");
                  emit(LoginErrorState());
                });



              } else {
                debugPrint('This User is not found');
                toast('This User is not found try check if you are an admin!', ToastStates.error);
                emit(LoginErrorState());
              }
            }).catchError((e){
              debugPrint('Error while getting user data: ${e.toString()}');
              emit(LoginErrorState());
            });

       }).catchError((e){
         debugPrint('Error while Login: ${e.toString()}');

         if(e.toString().contains('The user account has been disabled by an administrator')){
           toast('Your account has been disabled or banned. Please try logging in with another account, or contact our support team for more information.', ToastStates.error,isShort: false);
         }else{
           toast(e.toString(), ToastStates.error);
         }

         emit(LoginErrorState());
       });

    }

  Future<void> resetPassword({required String email}) async {
    bool emailExists = await isEmailRegistered(email);
    if(emailExists) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((
          value) {
        toast("Password reset email sent successfully.", ToastStates.success);
        emit(ResetPasswordByEmail());
      }).catchError((e) {
        toast(e.toString(), ToastStates.error);
      });
    }else{
      toast("This email is not registered, try another email.", ToastStates.error);
    }
  }


  Future<bool> isEmailRegistered(String email) async {
    try {
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

      CollectionReference adminsCollection = FirebaseFirestore.instance.collection('Admins');

      QuerySnapshot usersSnapshot = await usersCollection.where('email', isEqualTo: email).get();

      if (usersSnapshot.docs.isNotEmpty) {
        return true;
      }

      QuerySnapshot adminsSnapshot = await adminsCollection.where('email', isEqualTo: email).get();

      return adminsSnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if email is registered: $e');
      return false;
    }
  }

}





