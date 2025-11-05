part of 'notification_bloc.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationStatusChanged extends NotificationEvent {
  final AuthorizationStatus status;

  const NotificationStatusChanged({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}

class NotificationTokenFcmRequested extends NotificationEvent {
  const NotificationTokenFcmRequested();

  @override
  List<Object?> get props => [];
}

class NotificationListenerInitialized extends NotificationEvent {
  const NotificationListenerInitialized();

  @override
  List<Object?> get props => [];
}

class NotificationReceived extends NotificationEvent {
  const NotificationReceived();

  @override
  List<Object> get props => [];
}

class NotificationRequestedPermission extends NotificationEvent {
  final VoidCallback? onComplete;

  const NotificationRequestedPermission({this.onComplete});

  @override
  List<Object?> get props => [onComplete];
}

class NotificationStatusCheck extends NotificationEvent {
  const NotificationStatusCheck();

  @override
  List<Object?> get props => [];
}

class NotificationInitializeListeners extends NotificationEvent {
  const NotificationInitializeListeners();

  @override
  List<Object?> get props => [];
}
