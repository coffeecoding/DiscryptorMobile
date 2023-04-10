// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:discryptor/models/discryptor_user_with_relationship.dart';
import 'package:equatable/equatable.dart';

enum UserStatus { success, error }

class UserViewModel extends Equatable {
  final UserStatus status;
  final DiscryptorUserWithRelationship user;
  final String error;

  int get id => user.id;
  String get avatarUrl => user.getUsedAvatarUrl;
  String get fullname => user.fullname;
  String get hashDiscriminator => '#${user.discriminator}';
  bool get hasRelationship =>
      user.relationshipAcceptanceDate != null &&
      user.relationshipAcceptanceDate! > 0;

  const UserViewModel({
    this.status = UserStatus.success,
    required this.user,
    this.error = '',
  });

  UserViewModel copyWith({
    UserStatus? status,
    DiscryptorUserWithRelationship? user,
    String? error,
  }) {
    return UserViewModel(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'UserViewModel(status: $status, user: $user, error: $error)';
  }

  @override
  List<Object?> get props => [status, user, error];
}
