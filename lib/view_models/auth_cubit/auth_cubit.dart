import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await authServices.loginWithEmailAndPassword(email, password);
      if (result) {
        emit(const AuthDone());
      } else {
        emit(const AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await authServices.registerWithEmailAndPassword(email, password);
      if (result) {
        emit(const AuthDone());
      } else {
        emit(const AuthError('Register failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
