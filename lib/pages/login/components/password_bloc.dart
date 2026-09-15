import 'package:ekidzee/pages/login/components/password_event.dart';
import 'package:ekidzee/pages/login/components/password_repository.dart';
import 'package:ekidzee/pages/login/components/password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository passwordRepository;

  PasswordBloc({required this.passwordRepository})
      : super(PasswordInitialState());

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    //debugPrint("Map event ==============");
    if (event is ChangePasswordEvent) {
      if (event.currentPassword.trim().isEmpty) {
        yield EmptyCurrentPasswordState();
      } else if (event.newPassword.trim().isEmpty) {
        yield EmptyNewPasswordState();
      } else if (event.repeatNewPassword.trim().isEmpty) {
        yield EmptyRepeatPasswordState();
      } else if (event.newPassword.trim() != event.repeatNewPassword.trim()) {
        yield PasswordMismatchState();
      } else if (event.newPassword.length < 6) {
        yield InvalidNewPasswordState();
      } else {
        try {
          var currentPassword = await passwordRepository.getCurrentPassword();
          if (event.currentPassword != currentPassword) {
            yield IncorrectCurrentPasswordState();
          } else {
            try {
              await passwordRepository.changePassword(event.newPassword);
              yield PasswordChangedState();
            } catch (error) {
              yield ChangePasswordErrorState(errorMessage: error.toString());
            }
          }
        } catch (error) {
          yield ChangePasswordErrorState(errorMessage: error.toString());
        }
      }
    }
  }
}
