import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/chat_list/chat_list_cubit.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.chatListCubit) : super(const AuthState());

  final ChatListCubit chatListCubit;

  Future<void> onAuthenticated() async {
    chatListCubit.loadChats();
  }
}
