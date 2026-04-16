class ScreenConfig {
  final String id;
  final Map<String, dynamic> data;

  ScreenConfig({
    required this.id,
    this.data = const {},
  });

  factory ScreenConfig.fromJson(Map<String, dynamic> json) {
    return ScreenConfig(
      id: json['screen_id'] as String? ?? json['id'] as String? ?? 'unknown',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }
}

class ActionConfig {
  final String type; // navigate, api_call
  final String? target;
  final Map<String, dynamic>? params;

  ActionConfig({required this.type, this.target, this.params});

  factory ActionConfig.fromJson(Map<String, dynamic> json) {
    return ActionConfig(
      type: json['type'] as String,
      target: json['target'] as String?,
      params: json['params'] as Map<String, dynamic>?,
    );
  }
}
