import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignup);
  }

  Future<void> _onSignup(
      SignupButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: event.email.trim(), password: event.password.trim());

      print("Signup successful: ${userCredential.user?.email}");
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(error: e.toString()));
    }
  }
}
