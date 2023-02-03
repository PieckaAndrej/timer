import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/models/timer_model.dart';
import 'package:timer/models/timer_container.dart';
import 'package:timer/widgets/timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int run = -1;
  TimerContainer timerContainer = TimerContainer();
  Timer? countdownTimer;

  void startTimer() {
    run = timerContainer.nextIndex();

    if (run != -1) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (!timerContainer.decrement(run)) {
            run = timerContainer.nextIndex();

            if (run == -1) {
              stopTimer();
            }
          }
        });
      });
    }
  }

  void stopTimer() {
    setState(() {
      run = -1;
      countdownTimer?.cancel();
    });
  }

  void addTimer() {
    setState(() {
      timerContainer.timers.add(TimerModel("Label", 0));
    });
  }

  void deleteTimer(int index) {
    setState(() {
      timerContainer.timers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: ListView.separated(
            itemCount: timerContainer.timers.length + 1,
            itemBuilder: ((context, index) {
              if (index < timerContainer.timers.length) {
                return TimerWidget(
                  model: timerContainer.timers[index],
                  delete: () => deleteTimer(index),
                );
              } else {
                return IconButton(
                  onPressed: (() {
                    addTimer();
                  }),
                  icon: const Icon(Icons.add),
                );
              }
            }),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.large(
          onPressed: (() {
            run == -1 ? startTimer() : stopTimer();
          }),
          child: run == -1
              ? const Icon(Icons.play_arrow_outlined)
              : const Icon(Icons.pause),
        ),
      ),
    );
  }
}
