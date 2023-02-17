import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/chat_list/chat_list_cubit.dart';
import 'package:discryptor/models/auth_result.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/network_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.prefsRepo, this.networkService, this.chatListCubit)
      : super(const AuthState());

  final ChatListCubit chatListCubit;
  final NetworkService networkService;
  final PreferenceRepo prefsRepo;

  Future<void> onAuthenticated(AuthResult authResult) async {
    chatListCubit.loadChats();
    networkService.setAuthHeader(authResult.token);
  }
}
