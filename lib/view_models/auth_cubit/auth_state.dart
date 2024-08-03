part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthDone extends AuthState {
  const AuthDone();
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

final class AuthLoggingOut extends AuthState {
  const AuthLoggingOut();
}

final class AuthLogOutError extends AuthState {
  final String message;

  const AuthLogOutError(this.message);
}

final class GoogleAuthenticating extends AuthState {
  const GoogleAuthenticating();
}

final class GoogleAuthError extends AuthState {
  final String message;

  const GoogleAuthError(this.message);
}

final class GoogleAuthDone extends AuthState {
  const GoogleAuthDone();
}

final class FacebookAuthenticating extends AuthState {
  const FacebookAuthenticating();
}

final class FacebookAuthError extends AuthState {
  final String message;

  const FacebookAuthError(this.message);
}

final class FacebookAuthDone extends AuthState {
  const FacebookAuthDone();
}