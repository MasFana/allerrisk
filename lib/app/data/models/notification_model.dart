enum NotificationType { assessmentReminder, newArticle, highRiskAlert, general }

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String? deepLinkRoute;
  final Map<String, dynamic>? routeArgs;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.deepLinkRoute,
    this.routeArgs,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: NotificationType.values.byName(
          json['type'] as String? ?? NotificationType.general.name,
        ),
        deepLinkRoute: json['deep_link_route'] as String?,
        routeArgs: json['route_args'] as Map<String, dynamic>?,
        isRead: json['is_read'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'body': body,
    'type': type.name,
    'deep_link_route': deepLinkRoute,
    'route_args': routeArgs,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
  };

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      deepLinkRoute: deepLinkRoute,
      routeArgs: routeArgs,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
