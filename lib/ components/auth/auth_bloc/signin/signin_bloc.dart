import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tmaa/%20components/auth/auth_bloc/signin/signin_event.dart';
import 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInButtonPressed>(_onSignIn);
  }

  Future<void> _onSignIn(
      SignInButtonPressed event, Emitter<SignInState> emit) async {
    emit(SignInLoading());

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      print("Signed in user: ${userCredential.user!.email}");

      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }
}
