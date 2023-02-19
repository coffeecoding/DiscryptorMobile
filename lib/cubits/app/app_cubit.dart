import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/cubits.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.chatListCubit) : super(const AppState());

  ChatListCubit chatListCubit;

  Future<void> retrieveData() async {
    try {
      chatListCubit.loadChats();
      // Todo: get other data (users, messages, ...)
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }
}
