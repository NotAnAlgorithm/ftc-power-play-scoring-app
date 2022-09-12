import 'dart:math';

import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FTC Power Play Scoring App',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 69),
          bodyText2: TextStyle(fontSize: 16, overflow: TextOverflow.visible),
        ),
        iconTheme: const IconThemeData(
          color: Colors.cyan,
          size: 25,
        ),
      ),
      home: const Scorer(),
    );
  }
}


class Scorer extends StatefulWidget {
  const Scorer({super.key});

  @override
  State<Scorer> createState() => _ScorerState();
}

class _ScorerState extends State<Scorer> {
  /// 0 = Preview
  ///
  /// 1 = Auton
  ///
  /// 2 = TeleOp
  ///
  /// 3 = Overview
  int state = 0;

  Score autonTerminalCone = Score(maximum: 10);
  Score autonGroundCone = Score(maximum: 10);
  Score autonLowCone = Score(maximum: 10);
  Score autonMidCone = Score(maximum: 10);
  Score autonHighCone = Score(maximum: 10);
  bool terminalSubstationPark1 = false;
  bool signalPark1 = false;
  bool signalSleeveUsed1 = false;
  bool terminalSubstationPark2 = false;
  bool signalPark2 = false;
  bool signalSleeveUsed2 = false;
  late Score terminalCone = Score(value: autonTerminalCone.value, maximum: 30);
  late Score groundCone = Score(value: autonGroundCone.value, maximum: 30);
  late Score lowCone = Score(value: autonLowCone.value, maximum: 30);
  late Score midCone = Score(value: autonMidCone.value, maximum: 30);
  late Score highCone = Score(value: autonHighCone.value, maximum: 30);
  Score coneOwn = Score(maximum: 25);
  Score beaconOwn = Score(maximum: 2);
  Score terminalPark = Score(maximum: 2);
  bool circuitComplete = false;

  int score() {
    return autonTerminalCone.value * 1
           + autonGroundCone.value * 2
           + autonLowCone.value * 3
           + autonMidCone.value * 4
           + autonHighCone.value * 5
           + (signalPark1 ? (signalSleeveUsed1 ? 20 : 10) : (terminalSubstationPark1 ? 2 : 0))
           + (signalPark2 ? (signalSleeveUsed2 ? 20 : 10) : (terminalSubstationPark2 ? 2 : 0))
           + (state == 1 ? 0 :
             terminalCone.value * 1
             + groundCone.value * 2
             + lowCone.value * 3
             + midCone.value * 4
             + highCone.value * 5
             + coneOwn.value * 3
             + beaconOwn.value * 10
             + terminalPark.value * 2
             + (circuitComplete ? 20 : 0));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;

    FloatingActionButton nextButton = FloatingActionButton(
      onPressed: () => setState(() => state++),
      child: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
    switch (state) {
      case 0:
        return Scaffold(
            appBar: AppBar(
              title: const Text('FTC Power Play Scorer'),
            ),
            bottomNavigationBar: const BottomAppBar(
              child: Text('Total points: '),
            ),
            floatingActionButton: nextButton,
            body: const Text('hi'),
        );
      case 1:
        return Scaffold(
          appBar: AppBar(
            title: const Text('FTC Power Play Scorer'),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Text('Total points: ${score()}'),
          ),
          floatingActionButton: nextButton,
          body: ListView(
            children: [
              const Text('Autonomous'),
              Incrementable(
                onDecrement: () => setState(() => autonTerminalCone.decrement()),
                onIncrement: () => setState(() => autonTerminalCone.increment()),
                value: Text('${autonTerminalCone.value}'),
                child: const Text('Cones placed in terminal'),
              ),
              Incrementable(
                onDecrement: () => setState(() => autonGroundCone.decrement()),
                onIncrement: () => setState(() => autonGroundCone.increment()),
                value: Text('${autonGroundCone.value}'),
                child: const Text('Cones placed in ground junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => autonLowCone.decrement()),
                onIncrement: () => setState(() => autonLowCone.increment()),
                value: Text('${autonLowCone.value}'),
                child: const Text('Cones placed in low junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => autonMidCone.decrement()),
                onIncrement: () => setState(() => autonMidCone.increment()),
                value: Text('${autonMidCone.value}'),
                child: const Text('Cones placed in medium junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => autonHighCone.decrement()),
                onIncrement: () => setState(() => autonHighCone.increment()),
                value: Text('${autonHighCone.value}'),
                child: const Text('Cones placed in high junction'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => terminalSubstationPark1 = !terminalSubstationPark1),
                            value: terminalSubstationPark1,
                            child: const Flexible(
                              child: Text('Robot 1 parked in terminal or substation', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => signalPark1 = !signalPark1),
                            value: signalPark1,
                            child: const Flexible(
                              child: Text('Robot 1 parked in the signal zone', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => signalSleeveUsed1 = !signalSleeveUsed1),
                            value: signalSleeveUsed1,
                            child: const Flexible(
                              child: Text('Robot 1 used custom signal sleeve', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => terminalSubstationPark2 = !terminalSubstationPark2),
                            value: terminalSubstationPark2,
                            child: const Flexible(
                              child: Text('Robot 2 parked in terminal or substation', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => signalPark2 = !signalPark2),
                            value: signalPark2,
                            child: const Flexible(
                              child: Text('Robot 2 parked in the signal zone', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Toggleable(
                            onToggle: () => setState(() => signalSleeveUsed2 = !signalSleeveUsed2),
                            value: signalSleeveUsed2,
                            child: const Flexible(
                              child: Text('Robot 2 used custom signal sleeve', textAlign: TextAlign.center,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      case 2:
        return Scaffold(
          appBar: AppBar(
            title: const Text('FTC Power Play Scorer'),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Text('Total points: ${score()}'),
          ),
          floatingActionButton: nextButton,
          body: ListView(
            children: [
              const Text('TeleOp'),
              Incrementable(
                onDecrement: () => setState(() => terminalCone.decrement()),
                onIncrement: () => setState(() => terminalCone.increment()),
                value: Text('${terminalCone.value} (+${autonTerminalCone.value})'),
                child: const Text('Cones placed in terminal'),
              ),
              Incrementable(
                onDecrement: () => setState(() => groundCone.decrement()),
                onIncrement: () => setState(() => groundCone.increment()),
                value: Text('${groundCone.value} (+${autonGroundCone.value})'),
                child: const Text('Cones placed in ground junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => lowCone.decrement()),
                onIncrement: () => setState(() => lowCone.increment()),
                value: Text('${lowCone.value} (+${autonLowCone.value})'),
                child: const Text('Cones placed in low junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => midCone.decrement()),
                onIncrement: () => setState(() => midCone.increment()),
                value: Text('${midCone.value} (+${autonMidCone.value})'),
                child: const Text('Cones placed in medium junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => highCone.decrement()),
                onIncrement: () => setState(() => highCone.increment()),
                value: Text('${highCone.value} (+${autonHighCone.value})'),
                child: const Text('Cones placed in high junction'),
              ),
              Incrementable(
                onDecrement: () => setState(() => coneOwn.decrement()),
                onIncrement: () => setState(() => coneOwn.increment()),
                value: Text('${coneOwn.value}'),
                child: const Text('Junctions owned by cones'),
              ),
              Incrementable(
                onDecrement: () => setState(() => beaconOwn.decrement()),
                onIncrement: () => setState(() => beaconOwn.increment()),
                value: Text('${beaconOwn.value}'),
                child: const Text('Junctions owned by beacons'),
              ),
              Incrementable(
                onDecrement: () => setState(() => terminalPark.decrement()),
                onIncrement: () => setState(() => terminalPark.increment()),
                value: Text('${terminalPark.value}'),
                child: const Text('Robots parked in terminal'),
              ),
              Toggleable(
                onToggle: () => setState(() => circuitComplete = !circuitComplete),
                value: circuitComplete,
                child: const Text('Completed a circuit'),
              ),
            ],
          ),
        );
      case 3:
        return Scaffold(
          appBar: AppBar(
            title: const Text('FTC Power Play Scorer'),
          ),
          bottomNavigationBar: const BottomAppBar(
            child: Text('Total points: '),
          ),
          // floatingActionButton: nextButton,
          body: const Text('bye'),
        );
      default:
        return const Text('Error');
    }
  }
}

class Score {
  Score({
    value = 0,
    this.minimum = 0,
    this.maximum = 99,
  }) : assert(minimum <= value && value <= maximum),
       _value = value;

  int _value;
  set value(int val) => _value = min(max(val, minimum), maximum);
  int get value => _value;
  final int minimum;
  final int maximum;

  void increment() {
    if (value < maximum) value++;
  }

  void decrement() {
    if (value > minimum) value--;
  }
}

class Toggleable extends StatelessWidget {
  const Toggleable({
    super.key,
    required this.onToggle,
    required this.value,
    required this.child,
  });

  final void Function() onToggle;
  final bool value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        IconButton(
          icon: Icon(
            // apparently IconButton.selectedIcon doesn't work, so this is all I got.
            value ? Icons.check_box : Icons.check_box_outline_blank,
          ),
          onPressed: onToggle,
        )
      ],
    );
  }
}


class Incrementable extends StatelessWidget {
  const Incrementable({
    super.key,
    required this.onDecrement,
    required this.onIncrement,
    required this.value,
    required this.child,
  });

  final void Function() onDecrement;
  final void Function() onIncrement;
  final Widget value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          onPressed: onDecrement,
        ),
        value,
        IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_up,
          ),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}

