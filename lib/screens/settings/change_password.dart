import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/cubit/cubit.dart';

import '../../cubit/states.dart';
import '../../shared/components/components.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
final TextEditingController currentPasswordController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confirmNewPasswordController = TextEditingController();
final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit =AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(listener: (context,state){}, builder: (context,state){
      return Scaffold(
        appBar: AppBar(title: const Text("Change Password"),centerTitle: true,),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const SizedBox(height: 20,),
                    TextFormField(
                      controller: currentPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: cubit.isPasswordHiding,
                      onChanged: (v) {
                        formKey.currentState!.validate();
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Password must not be empty!';
                        }else{
                          if (value!.length < 6){
                            return 'Password must be at least 6 characters';
                          }
                        }

                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.black.withOpacity(0.8) ,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle:  TextStyle(color: Colors.blue.shade900),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelText: 'Current Password',
                        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                        suffixIcon: IconButton(
                            icon: Icon(cubit.suffix,
                                color: Colors.black.withOpacity(0.8)),
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        prefixIcon:  Icon(Icons.password,color: Colors.black.withOpacity(0.8),),

                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: newPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: cubit.isPasswordHiding,
                      onChanged: (v) {
                        formKey.currentState!.validate();
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Password must not be empty!';
                        }else{
                          if (value!.length < 6){
                            return 'Password must be at least 6 characters';
                          }
                        }

                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.black.withOpacity(0.8) ,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle:  TextStyle(color: Colors.blue.shade900),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelText: 'New Password',
                        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                        suffixIcon: IconButton(
                            icon: Icon(cubit.suffix,
                                color: Colors.black.withOpacity(0.8)),
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        prefixIcon:  Icon(Icons.password,color: Colors.black.withOpacity(0.8),),

                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: confirmNewPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: cubit.isPasswordHiding,
                      onChanged: (v) {
                        formKey.currentState!.validate();
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Password must not be empty!';
                        }else{
                        if(value != newPasswordController.text){
                        return 'Passwords does not match';
                         }
                        }

                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.black.withOpacity(0.8) ,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle:  TextStyle(color: Colors.blue.shade900),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelText: 'Confirm Password',
                        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                        suffixIcon: IconButton(
                            icon: Icon(cubit.suffix,
                                color: Colors.black.withOpacity(0.8)),
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        prefixIcon:  Icon(Icons.password,color: Colors.black.withOpacity(0.8),),

                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 25,),
                    ConditionalBuilder(
                      builder: (BuildContext context) => Center(
                        child: defaultButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              cubit.changePassword(currentPassword: currentPasswordController.text, newPassword: newPasswordController.text);

                            }
                          },
                          text: 'Change Password',
                          radius: 10,
                          backgroundColor: Colors.blue,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                      fallback: (BuildContext context) => const Center(
                          child: CircularProgressIndicator()),
                      condition: state is !ChangePasswordLoadingState,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
