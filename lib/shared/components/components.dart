import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  Color backgroundColor = Colors.blue,
  double width = double.infinity,
  double radius = 0,
  required Function onPressed,
  required String text,
  BuildContext? context,
  bool isUpperCase = true,
}) => Container(
width: width,

decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius),color: backgroundColor,),
child:  MaterialButton(
onPressed: (){onPressed();},
child: Text(isUpperCase? text.toUpperCase() : text,style: const TextStyle(color: Colors.white,),),


),
);


void navigateTo(context,widget) => Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));
void navigateToAndFinish(context,widget) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> widget),(Route<dynamic> route)=>false);

Future toast(dynamic msg,ToastStates state,{bool isShort = true,int timeInSecondForIosWeb = 5,Color backgroundColor = Colors.red,Color textColor = Colors.white,double fontSize=18}) => Fluttertoast.showToast(
    msg: msg,
    toastLength:isShort == true? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: timeInSecondForIosWeb,
    backgroundColor: toastColor(state),
    textColor: toastColor(state) == Colors.yellow?Colors.black : textColor,
    fontSize: fontSize,

);
enum ToastStates {success,warning,error}

Color? color;

Color? toastColor(ToastStates state){
  switch(state){
    case ToastStates.success: color = Colors.green;
 break;
    case ToastStates.warning: color = Colors.yellow;
 break;
    case ToastStates.error: color = Colors.red;
    break;

  }
  return color;
}




