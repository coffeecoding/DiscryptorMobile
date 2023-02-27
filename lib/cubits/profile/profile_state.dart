part of 'profile_cubit.dart';

enum ProfileStatus { changing, changed }

class ProfileState extends Equatable {
  const ProfileState({this.status = ProfileStatus.changed, this.user});

  final ProfileStatus status;
  final IDiscryptorUser? user;

  @override
  List<Object?> get props => [status, user];
}
