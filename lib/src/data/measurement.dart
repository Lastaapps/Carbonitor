import 'package:carbonitor/src/constants/concentrations.dart';
import 'package:carbonitor/src/constants/time.dart';
import 'package:carbonitor/src/data/concentration.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

class Measurement {
  // UTC time
  final TZDateTime time;
  final double temperature;
  final double signal;
  final double humidity;
  final double carbon;
  final double bat;

  const Measurement({
    required this.time,
    required this.temperature,
    required this.signal,
    required this.humidity,
    required this.carbon,
    required this.bat,
  });

  TZDateTime toCETTime() => TZDateTime.from(time, CET);

  Concentration toConcentration() {
    for (var concentration in Concentrations.concentrations) {
      if (carbon <= concentration.concentration) return concentration;
    }
    return Concentrations.danger;
  }

  double toPercent() {
    return carbon / Concentrations.tiredness.concentration * 100;
  }

  Map<String, dynamic> toDatabaseMap(String classId) {
    return {
      "classId": classId,
      "time": time.millisecondsSinceEpoch / 1000,
      "temp": temperature,
      "signal": signal,
      "hum": humidity,
      "co2": carbon,
      "bat": bat,
    };
  }

  Measurement.fromDatabaseMap(Map<String, dynamic> map)
      : time = TZDateTime.fromMillisecondsSinceEpoch(
            tz.UTC, (map["time"] as int) * 1000),
        temperature = map["temp"],
        signal = map["signal"],
        humidity = map["hum"],
        carbon = map["co2"],
        bat = map["bat"];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Measurement &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          temperature == other.temperature &&
          signal == other.signal &&
          humidity == other.humidity &&
          carbon == other.carbon &&
          bat == other.bat;

  @override
  String toString() {
    return 'Measurement{time: $time, temperature: $temperature, signal: $signal, humidity: $humidity, carbon: $carbon}';
  }

  @override
  int get hashCode =>
      time.hashCode ^
      temperature.hashCode ^
      signal.hashCode ^
      humidity.hashCode ^
      carbon.hashCode ^
      bat.hashCode;
}
