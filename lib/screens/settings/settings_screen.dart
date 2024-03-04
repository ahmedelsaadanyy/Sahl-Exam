import 'package:flutter/material.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';
import 'package:sahl_exam_app/screens/settings/change_password.dart';
import 'package:sahl_exam_app/shared/components/components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
late AppCubit cubit;

@override
  void initState() {
    cubit = AppCubit.get(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
     body: Padding(
       padding: const EdgeInsets.all(15.0),
       child: Column(
         children: [
           Center(child: Text("Welcome ${cubit.userModel?.name??" "}",style: const TextStyle(fontSize: 24),),),
           Expanded(
             child: SingleChildScrollView(
               child: Column(
                 children: [

                   const SizedBox(height:25),
                   Center(
                     child: ElevatedButton(
                         onPressed: (){
                       cubit.isUserDataFetched=false;
                       cubit.getUserData(isAdmin: cubit.userModel!.isAdmin!);
                       navigateTo(context, const ChangePasswordScreen());
                       },
                         child:const Text("Change Password")),
                   ),

                 ],
               ),
             ),
           ),
           Center(
             child: ElevatedButton(onPressed: (){cubit.signOut(context);},child:const Text("Sign-out")),
           ),
           const SizedBox(height:20),
         ],
       ),
     ),
    );
  }
}
