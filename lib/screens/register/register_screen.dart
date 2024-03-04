import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../../shared/components/components.dart';
import '../login/login_screen.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_states.dart';


class RegisterScreen extends StatefulWidget {


  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          RegisterCubit cubit =RegisterCubit.get(context);
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child:  Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                     Padding(
                                      padding: const EdgeInsets.only(top:60,bottom:10),
                                      child: Center(
                                        child: Container(
                                          width:double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.03),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            'Register',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 30, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: nameController,
                                          onChanged: (v) {
                                            formKey.currentState!.validate();
                                          },
                                          onEditingComplete: () =>
                                              FocusScope.of(context).nextFocus(),
                                          validator: (String? value) {
                                            if (value != null && value.isEmpty) {
                                              return 'Username must not be empty!';
                                            }
                                            return null;
                                          },
                                          cursorColor:Colors.black ,
                                          decoration:  const InputDecoration(
                                            floatingLabelAlignment: FloatingLabelAlignment.center,
                                            labelText: 'Username',
                                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                            prefixIcon: Icon(Icons.drive_file_rename_outline,color: Colors.black,),
                                          ),
                                        ),
                                      const SizedBox(
                                         height: 20,),
                                        TextFormField(

                                          keyboardType: TextInputType.emailAddress,
                                          controller: emailController,
                                          onChanged: (v) {
                                            formKey.currentState!.validate();
                                          },
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                                          cursorColor:Colors.black ,
                                          decoration:  const InputDecoration(

                                            floatingLabelAlignment: FloatingLabelAlignment.center,
                                            labelText: 'Email Address',
                                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                            prefixIcon: Icon(Icons.email,color: Colors.black,),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: passwordController,
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: cubit.isPasswordHiding,
                                          onChanged: (v) {
                                            formKey.currentState!.validate();
                                          },
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                                          decoration: InputDecoration(
                                            floatingLabelAlignment: FloatingLabelAlignment.center,
                                            labelText: 'Password',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                                icon: Icon(RegisterCubit
                                                    .get(context)
                                                    .visibilityIcon,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  cubit
                                                      .changePasswordVisibility();
                                                }),
                                            prefixIcon:  const Icon(Icons.password,color: Colors.black,),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: rePasswordController,
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: cubit.isPasswordHiding,
                                          onChanged: (v) {
                                            formKey.currentState!.validate();
                                          },
                                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'Confirm Password must not be empty';
                                            }else{
                                              if(value != passwordController.text){
                                                return 'Passwords does not match';
                                              }
                                            }
                                            return null;


                                          },
                                          decoration: InputDecoration(
                                            floatingLabelAlignment: FloatingLabelAlignment.center,
                                            labelText: 'Confirm Password',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                                icon: Icon(RegisterCubit
                                                    .get(context)
                                                    .visibilityIcon,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  cubit.changePasswordVisibility();
                                                }),
                                            prefixIcon:  const Icon(Icons.password,color: Colors.black,),
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
                                        Center(
                                            child: Conditional.single(
                                              context: context,
                                              conditionBuilder: (context) => state is  RegisterLoadingState || state is CreateUserLoadingState ,
                                              widgetBuilder: (context) =>
                                              const CircularProgressIndicator(),
                                              fallbackBuilder: (context) =>
                                                  defaultButton(
                                                    width: MediaQuery.of(context).size.width * 0.5,
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        if (rePasswordController.text ==
                                                            passwordController.text) {
                                                          cubit.registerUser(
                                                            context: context,
                                                            email: emailController.text.trim(),
                                                            password: passwordController.text.trim(),
                                                            name: nameController.text,
                                                            phone: '',
                                                            isAdmin: cubit.isAdminChecked,
                                                          );
                                                        } else {
                                                          toast('password is not match',
                                                              ToastStates.error);
                                                          if (kDebugMode) {
                                                            print(
                                                                'password is not match');
                                                          }
                                                        }
                                                      }
                                                    },
                                                    text: 'Register',
                                                    context: context,
                                                    radius: 15,
                                                  ),
                                            )),

                                      ],
                                    ),

                                    const SizedBox(
                                      height: 25,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.04),
                                      ),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Already have an account?',
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 14),
                                            ),

                                            TextButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                  const EdgeInsets.all(5.0), // Set the padding here
                                                ),
                                              ),
                                              onPressed: () {
                                                navigateToAndFinish(context, const LoginScreen());
                                                if (kDebugMode) {
                                                  print('Register txt button clicked');
                                                }
                                              },
                                              child:  const Text('Login Now',style: TextStyle(color:Colors.blue),
                                              ),
                                            ),

                                          ]),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

          );
        },
      ),
    );
  }
}