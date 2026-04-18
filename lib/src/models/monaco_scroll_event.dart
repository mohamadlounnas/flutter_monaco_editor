class MonacoScrollEvent {
  const MonacoScrollEvent({
    required this.scrollTop,
    required this.scrollLeft,
    required this.scrollHeight,
    required this.scrollWidth,
    required this.scrollTopChanged,
    required this.scrollLeftChanged,
    required this.scrollHeightChanged,
    required this.scrollWidthChanged,
  });

  factory MonacoScrollEvent.fromJson(Map<String, Object?> json) =>
      MonacoScrollEvent(
        scrollTop: (json['scrollTop']! as num).toDouble(),
        scrollLeft: (json['scrollLeft']! as num).toDouble(),
        scrollHeight: (json['scrollHeight']! as num).toDouble(),
        scrollWidth: (json['scrollWidth']! as num).toDouble(),
        scrollTopChanged: json['scrollTopChanged'] as bool? ?? false,
        scrollLeftChanged: json['scrollLeftChanged'] as bool? ?? false,
        scrollHeightChanged: json['scrollHeightChanged'] as bool? ?? false,
        scrollWidthChanged: json['scrollWidthChanged'] as bool? ?? false,
      );

  final double scrollTop;
  final double scrollLeft;
  final double scrollHeight;
  final double scrollWidth;
  final bool scrollTopChanged;
  final bool scrollLeftChanged;
  final bool scrollHeightChanged;
  final bool scrollWidthChanged;

  @override
  String toString() =>
      'MonacoScrollEvent(top=$scrollTop, left=$scrollLeft, '
      'h=$scrollHeight, w=$scrollWidth)';
}
