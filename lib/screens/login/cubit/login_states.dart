

abstract class LoginStates{}

class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates {}
class LoginErrorState extends LoginStates{}
class ChangePasswordVisibilityState extends LoginStates{}
class AppSignInAnonymouslyLoadingState extends LoginStates {}
class AppSignInAnonymouslySuccessState extends LoginStates {}
class AppSignInAnonymouslyErrorState extends LoginStates {}
class SignInWithGoogleLoadingState extends LoginStates{}
class SignInWithGoogleSuccessState extends LoginStates{}
class SignInWithGoogleErrorState extends LoginStates{}
class AdminCheckState extends LoginStates{}
class ResetPasswordByEmail extends LoginStates{}
