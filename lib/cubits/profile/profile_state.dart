part of 'profile_cubit.dart';

enum ProfileStatus { changing, changed }

enum RelationshipStatus {
  self,
  none,
  initiatedBySelf,
  initiatedByOther,
  accepted
}

class ProfileState extends Equatable {
  const ProfileState({this.status = ProfileStatus.changed, this.user});

  final ProfileStatus status;
  final IDiscryptorUser? user;

  RelationshipStatus getRelationshipStatus() {
    if (user is DiscryptorUser) return RelationshipStatus.self;
    final duwr = user as DiscryptorUserWithRelationship;
    return duwr.relationshipInitiationDate != null &&
            duwr.relationshipInitiationDate! > 0
        ? RelationshipStatus.accepted
        : duwr.isInitiatorOfRelationship &&
                (duwr.relationshipAcceptanceDate == null ||
                    duwr.relationshipAcceptanceDate == 0)
            ? RelationshipStatus.initiatedByOther
            : duwr.relationshipInitiationDate != null &&
                    duwr.relationshipInitiationDate! > 0
                ? RelationshipStatus.initiatedBySelf
                : RelationshipStatus.none;
  }

  @override
  List<Object?> get props => [status, user];
}
