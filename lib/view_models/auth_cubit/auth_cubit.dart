import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/user_data.dart';
import 'package:flutter_ecommerce_app/services/auth_services.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_paths.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final result =
          await authServices.loginWithEmailAndPassword(email, password);
      if (result) {
        emit(const AuthDone());
      } else {
        emit(const AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String username) async {
    emit(AuthLoading());
    try {
      final result =
          await authServices.registerWithEmailAndPassword(email, password);
      if (result) {
        await _saveUserData(email, username);
        emit(const AuthDone());
      } else {
        emit(const AuthError('Register failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _saveUserData(String email, String username) async {
    final currentUser = authServices.currentUser();
    final userData = UserData(
      id: currentUser!.uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
    );

    await firestoreServices.setData(
      path: ApiPaths.users(userData.id),
      data: userData.toMap(),
    );
  }

  void checkAuth() {
    final user = authServices.currentUser();
    if (user != null) {
      emit(const AuthDone());
    }
  }

  Future<void> logout() async {
    emit(const AuthLoggingOut());
    try {
      await authServices.logout();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthLogOutError(e.toString()));
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(const GoogleAuthenticating());
    try {
      final result = await authServices.authenticateWithGoogle();
      if (result) {
        emit(const GoogleAuthDone());
      } else {
        emit(const GoogleAuthError('Google authentication failed'));
      }
    } catch (e) {
      emit(GoogleAuthError(e.toString()));
    }
  }

  Future<void> authenticateWithFacebook() async {
    emit(const FacebookAuthenticating());
    try {
      final result = await authServices.authenticateWithFacebook();
      if (result) {
        emit(const FacebookAuthDone());
      } else {
        emit(const FacebookAuthError('Facebook authentication failed'));
      }
    } catch (e) {
      emit(FacebookAuthError(e.toString()));
    }
  }
}
