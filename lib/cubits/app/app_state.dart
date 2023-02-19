part of 'app_cubit.dart';

enum AppStatus { busy, notbusy }

/// Todo: Reconsider this, but for now:
/// AppState is only intended to really aggregate states (cubits) of
/// chats, users, messages etc.
/// Thus, its is not directly modified or listened to, hence AppState unneeded.
class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}
