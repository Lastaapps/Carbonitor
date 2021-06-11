import 'package:carbonitor/src/constants/concencrations.dart';
import 'package:carbonitor/src/constants/time.dart';
import 'package:carbonitor/src/data/concentration.dart';
import 'package:timezone/browser.dart';

class Measurement {
  final TZDateTime time;
  final double temperature;
  final double signal;
  final double humidity;
  final double carbon;
  final int bat;
  
  const Measurement(this.time, this.temperature, this.signal, this.humidity, this.carbon, this.bat);

  TZDateTime toCETTime() => TZDateTime.from(time, CET);

  Concentration toConcentration() {
    for(var concentration in Concentrations.concentrations) {
      if (carbon <= concentration.concentration)
        return concentration;
    }
    return Concentrations.danger;
  }

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
  int get hashCode =>
      time.hashCode ^
      temperature.hashCode ^
      signal.hashCode ^
      humidity.hashCode ^
      carbon.hashCode ^
      bat.hashCode;
}