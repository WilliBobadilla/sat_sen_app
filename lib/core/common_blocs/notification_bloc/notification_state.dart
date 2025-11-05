part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final AuthorizationStatus status;
  final List<Map<String, dynamic>> notifications;
  final String? tokenFCM;
  final bool? firebaseInitialized;

  const NotificationState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
    this.tokenFCM,
    this.firebaseInitialized,
  });

  NotificationState copyWith({
    AuthorizationStatus? status,
    List<Map<String, dynamic>>? notifications,
    String? tokenFCM,
    bool? firebaseInitialized,
  }) =>
      NotificationState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        tokenFCM: tokenFCM ?? this.tokenFCM,
        firebaseInitialized: firebaseInitialized ?? this.firebaseInitialized,
      );

  @override
  List<Object?> get props =>
      [status, notifications, tokenFCM, firebaseInitialized];
}
