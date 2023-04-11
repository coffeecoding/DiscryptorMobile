import 'package:bloc/bloc.dart';
import 'package:discryptor/cubits/chat_list/chat_list_cubit.dart';
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:discryptor/models/idiscryptor_user.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void selectUser(IDiscryptorUser user) {
    emit(const ProfileState(status: ProfileStatus.changing));
    emit(ProfileState(status: ProfileStatus.changed, user: user));
  }

  Future<void> updateRelationship(ChatListCubit clc) async {
    final status = getRelationshipStatus(state.user!);
    emit(ProfileState(status: ProfileStatus.changing, user: state.user));
    IDiscryptorUser? updatedUser;
    switch (status) {
      case RelationshipStatus.none:
        updatedUser = await clc.updateRelationshipById(
            state.user!.getId, RelationshipStatus.initiatedBySelf);
        break;
      case RelationshipStatus.initiatedBySelf:
        updatedUser = await clc.updateRelationshipById(
            state.user!.getId, RelationshipStatus.none);
        break;
      case RelationshipStatus.initiatedByOther:
        updatedUser = await clc.updateRelationshipById(
            state.user!.getId, RelationshipStatus.accepted);
        break;
      case RelationshipStatus.accepted:
        updatedUser = await clc.updateRelationshipById(
            state.user!.getId, RelationshipStatus.none);
        break;
      default:
        break;
    }
    emit(ProfileState(
        status: ProfileStatus.changed, user: updatedUser ?? state.user));
  }
}
