import 'package:bloc/bloc.dart';
import 'package:discryptor/models/discryptor_user.dart';
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
}
