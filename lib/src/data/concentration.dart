import 'package:carbonitor/src/data/measurement.dart';

class Concentration {
  final double concentration;
  final int color;
  final String name;
  final ConcentrationDanger severity;

  const Concentration(
      {required this.concentration,
      required this.color,
      required this.name,
      required this.severity});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Concentration &&
          runtimeType == other.runtimeType &&
          concentration == other.concentration &&
          color == other.color &&
          name == other.name &&
          severity == other.severity;

  @override
  int get hashCode =>
      concentration.hashCode ^
      color.hashCode ^
      name.hashCode ^
      severity.hashCode;
}

enum ConcentrationDanger { fine, limit, danger }
