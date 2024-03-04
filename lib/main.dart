import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/layouts/admin_layout.dart';
import 'package:sahl_exam_app/screens/login/login_screen.dart';
import 'package:sahl_exam_app/shared/components/constants.dart';
import 'package:sahl_exam_app/shared/network/local/cache_helper/cache_helper.dart';
import 'firebase_options.dart';
import 'layouts/student_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  late String? uid = CacheHelper.getData('uid');
  late bool isAdmin = CacheHelper.getData('isAdmin');


  Widget? widget;

  if(uid != null){
    if(isAdmin){
      widget = const AdminMainScreen();
    }else {
      widget = const StudentMainScreen();
    }
  }else{
    widget = const LoginScreen();
  }
  runApp( MyApp(widget: widget));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key,this.widget}) : super(key: key);
  final Widget? widget;




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => AppCubit()..init(),
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 3,
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            toolbarHeight: 45,
            centerTitle: true
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: widget!,
      ),
    );
  }
}



