import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/layouts/admin_layout.dart';
import 'package:sahl_exam_app/layouts/student_layout.dart';
import 'package:sahl_exam_app/screens/register/cubit/register_states.dart';
import '../../../cubit/cubit.dart';
import '../../../models/users_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper/cache_helper.dart';



class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isAdminChecked = false;

  void changeAdminCheckValue(bool isAdminCheckedValue){
    isAdminChecked = isAdminCheckedValue;
    emit(AdminCheckState());
  }
  //late LoginModel registerModel;
  void registerUser({
    required String email,
    required String password,
    required String phone,
    required String name,
    required bool isAdmin,
    required BuildContext context,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,).then((value) {

        debugPrint('Value: $value Registered successfully');

      toast('Registered successfully', ToastStates.success);
      emit(RegisterSuccessState());
      createUser(name: name,email: email, phone: phone, context: context, uid: value.user!.uid,isAdmin: isAdmin);


    }).catchError((e){
      if (kDebugMode) {
        print(e.toString());
      }
      toast(e.toString(), ToastStates.error);
      emit(RegisterErrorState());
    }
    );
  }

  Future<void> createUser({
    required String email,
    required String phone,
    required String name,
    String? image = 'https://student.valuxapps.com/storage/assets/defaults/user.jpg',
    required String uid,
    required bool isAdmin,
    BuildContext? context,
  }) async {
    emit(CreateUserLoadingState());

      final regModel = UsersModel(
        name: name,
        email: email,
        phone: phone,
        uid: uid,
        image: image,
        isAdmin: isAdmin,
      );

      await createUserInFirebase(uid, regModel,isAdmin,context!).then((value) async {
        await saveUidInCache(uid,isAdmin, context).then((value) async {
          AppCubit.get(context).isUserDataFetched = false;
          await AppCubit.get(context).getUserData(isAdmin: isAdmin).then((value) => navigateToAndFinish(context,isAdmin?const AdminMainScreen():const StudentMainScreen()));
        });

        emit(CreateUserSuccessState());


          debugPrint('User created successfully');


      }).catchError((e){
        debugPrint("Error while creating user: $e");
        emit(CreateUserErrorState());

      });




    }




  Future<void> createUserInFirebase(String uid, UsersModel? regModel,bool isAdmin,BuildContext context) async {
    if (isAdmin){
      await FirebaseFirestore.instance.collection('Admins').doc(uid).set(regModel!.toMap()!);
    }else{
      await FirebaseFirestore.instance.collection('Users').doc(uid).set(regModel!.toMap()!);
    }
  }

  Future<void> saveUidInCache(String uid,bool isAdmin, BuildContext? context) async {
    await CacheHelper.saveData('uid', uid);
    await CacheHelper.saveData("isAdmin", isAdmin);

      debugPrint('Uid: $uid Saved successfully');

    currentUid = uid;


  }



  bool isPasswordHiding = true;
  IconData visibilityIcon = Icons.visibility;
  void changePasswordVisibility() {
    isPasswordHiding = !isPasswordHiding;
    isPasswordHiding
        ? visibilityIcon = Icons.visibility
        : visibilityIcon = Icons.visibility_off;
    emit(RegisterChangeVisibilityState());
  }


}