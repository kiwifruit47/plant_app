class Scan {
  final int? id;
  final String imagePath;
  final String label;
  final String confidence;
  final DateTime timestamp;

  Scan({
    this.id,
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'label': label,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Scan.fromMap(Map<String, dynamic> map) {
    return Scan(
      id: map['id'],
      imagePath: map['image_path'],
      label: map['label'],
      confidence: map['confidence'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
