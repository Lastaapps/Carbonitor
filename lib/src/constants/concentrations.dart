import 'package:carbonitor/src/data/concentration.dart';

//TODO resolve colors
class Concentrations {
  Concentrations._init();

  static const outside = Concentration(
      concentration: 500,
      color: 0xff000000,
      name: "Like outside",
      severity: ConcentrationDanger.fine);
  static const indoor = Concentration(
      concentration: 800,
      color: 0xff000000,
      name: "Indoor average",
      severity: ConcentrationDanger.fine);
  static const acceptable = Concentration(
      concentration: 1000,
      color: 0xff000000,
      name: "Still OK",
      severity: ConcentrationDanger.fine);
  static const tiredness = Concentration(
      concentration: 1500,
      color: 0xff000000,
      name: "Children are tired",
      severity: ConcentrationDanger.limit);
  static const disruptive = Concentration(
      concentration: 2500,
      color: 0xff000000,
      name: "They can't pay attention",
      severity: ConcentrationDanger.danger);
  static const healthRisk = Concentration(
      concentration: 5000,
      color: 0xff000000,
      name: "It's hart to breath",
      severity: ConcentrationDanger.danger);
  static const danger = Concentration(
      concentration: 1000000,
      color: 0xff000000,
      name: "Get out, fast!",
      severity: ConcentrationDanger.danger);
  static final concentrations = List.of(
      [outside, indoor, acceptable, tiredness, disruptive, healthRisk, danger]);
}
