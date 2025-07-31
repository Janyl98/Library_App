import '../../../authentication/models/user_model.dart';

class AccountState {
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  AccountState({this.user, this.errorMessage, this.isLoading = false});

  AccountState copyWith({User? user, String? errorMessage, bool? isLoading}) {
    return AccountState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserInitial extends AccountState {}

class UserLoading extends AccountState {}

class UserLoaded extends AccountState {
  final User user;

  UserLoaded(this.user);
}

class UserError extends AccountState {
  final String message;

  UserError(this.message);
}
