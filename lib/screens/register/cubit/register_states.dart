



abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {

}
class CreateUserLoadingState extends RegisterStates {}

class CreateUserSuccessState extends RegisterStates {}

class CreateUserErrorState extends RegisterStates {

}
class RegisterChangeVisibilityState extends RegisterStates {}
class ChangePasswordVisibilityRegisterState extends RegisterStates {}
class AdminCheckState extends RegisterStates {}