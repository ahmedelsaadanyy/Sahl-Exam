
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahl_exam_app/screens/login/reset_email_screen.dart';

import '../../shared/components/components.dart';
import '../register/register_screen.dart';

import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCont = TextEditingController();

  final passCont = TextEditingController();

  final formKey = GlobalKey<FormState>();

// var passCont = TextEditingController();

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(

              color: Colors.white,
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.05),
                            ),
                            child:  Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(

                          keyboardType: TextInputType.emailAddress,
                          controller: emailCont,
                          onChanged: (v) {},
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Email address must not be empty!';
                            }else{
                              if (!value!.contains("@") || !value.contains(".")){
                                return 'Email address not valid!';
                              }
                            }
                            return null;
                          },
                          cursorColor:LoginCubit.loginTextColor ,
                          decoration:  InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: LoginCubit.loginTextColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            labelStyle:  TextStyle(color: Colors.blue.shade900),
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: LoginCubit.loginTextColor),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            prefixIcon: Icon(Icons.email,color: LoginCubit.loginTextColor,),
                          ),
                          style:  const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passCont,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: LoginCubit.get(context).isPasswordHiding,
                          onChanged: (v) {
                            formKey.currentState!.validate();
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'Password must not be empty!';
                            }

                            return null;
                          },
                          onFieldSubmitted: (v) async {
                            if (formKey.currentState!.validate()) {
                             await LoginCubit.get(context).userLogin(
                                  emailCont.text, passCont.text, context);
                              if (kDebugMode) {
                                print('login button clicked');
                              }
                            }
                          },
                          cursorColor:LoginCubit.loginTextColor ,
                          decoration: InputDecoration(

                            fillColor: Colors.white,
                            filled: true,
                            labelStyle:  TextStyle(color: Colors.blue.shade900),
                            floatingLabelAlignment: FloatingLabelAlignment.center,
                            labelText: 'Password',
                            border:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),),
                            suffixIcon: IconButton(
                                icon: Icon(LoginCubit.get(context).suffix,
                                    color: LoginCubit.loginTextColor),
                                onPressed: () {
                                  LoginCubit.get(context)
                                      .changePasswordVisibility();
                                }),
                            prefixIcon:  Icon(Icons.password,color: LoginCubit.loginTextColor,),

                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            decorationColor: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CheckboxListTile(title:const Text("I'm Admin"),value: cubit.isAdminChecked, onChanged: (value) {
                          cubit.changeAdminCheckValue(value!);
                        }),
                        const SizedBox(
                          height: 25,
                        ),
                        ConditionalBuilder(
                          builder: (BuildContext context) => defaultButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                               await LoginCubit.get(context).userLogin(
                                    emailCont.text, passCont.text, context);

                              }
                            },
                            text: 'Login',
                            radius: 10,
                            backgroundColor: Colors.blue,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          fallback: (BuildContext context) => const Center(
                              child: CircularProgressIndicator()),
                          condition: state is! LoginLoadingState,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.06),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                TextButton(
                                    onPressed: () {
                                      navigateTo(context, const RegisterScreen());
                                      if (kDebugMode) {
                                        print('Register txt button clicked');
                                      }
                                    },
                                    child: const Text('Register Now',style: TextStyle(color:Colors.blue,),
                                    ),
                                ),

                              ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.06),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                TextButton(
                                    onPressed: () {
                                      navigateTo(context,const ResetPasswordByEmailScreen());

                                    },
                                    child: const Text('Reset',style: TextStyle(color:Colors.blue,),
                                    ),
                                ),

                              ]),
                        ),

                        // const  SizedBox(height: 150,),
                      ]),
                ),
              ),
            ),
                ),

        );
        },
      ),
    );
  }
}
