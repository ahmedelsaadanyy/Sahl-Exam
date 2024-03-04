import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late AppCubit cubit ;

  @override
  void initState()  {
    super.initState();
    cubit = AppCubit.get(context);
    cubit.changeIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {


        return Scaffold(
          appBar:AppBar(
            title:Text(cubit.adminsTitles[cubit.currentIndex]),
         ),

          body: ConditionalBuilder(
            condition:state is !GetUserLoadingState ,builder:(context){
            return cubit.adminScreens[cubit.currentIndex];},
            fallback: (BuildContext context) {  return const Center(child: CircularProgressIndicator(),); }, ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,

            currentIndex: cubit.currentIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.red,
            unselectedIconTheme: const IconThemeData(size: 20),
            unselectedFontSize: 12,
            selectedFontSize: 14  ,
            selectedIconTheme: const IconThemeData(size: 25),
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.penSquare),
                label: 'Results',
              ),

              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.personBooth),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

