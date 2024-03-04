import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class ResetPasswordByEmailScreen extends StatelessWidget {
  const ResetPasswordByEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailCont = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(title: const Text("Reset Password"),centerTitle: true,),
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

                          const SizedBox(
                            height: 25,
                          ),
                          ConditionalBuilder(
                            builder: (BuildContext context) => defaultButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  cubit.resetPassword(email: emailCont.text);

                                }
                              },
                              text: 'Send',
                              radius: 10,
                              backgroundColor: Colors.blue,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            fallback: (BuildContext context) => const Center(
                                child: CircularProgressIndicator()),
                            condition: state is! LoginLoadingState,
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
