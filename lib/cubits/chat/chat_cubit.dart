import 'package:bloc/bloc.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(DiscryptorUserWithRelationship user) : super(ChatState(user));
}
