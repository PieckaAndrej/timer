import 'package:timer/models/timer_model.dart';

class TimerContainer {
  List<TimerModel> timers = [];

  /// Returns index of a first timer that has time more than 0 seconds
  int nextIndex() {
    int retVal = -1;
    bool found = false;

    for (int i = 0; i < timers.length && !found; i++) {
      if (timers[i].seconds != 0) {
        retVal = i;
        found = true;
      }
    }

    return retVal;
  }

  /// Decrements timer with [index] by one second
  bool decrement(int index) {
    bool retVal = false;

    if (timers[index].seconds > 0) {
      timers[index].seconds -= 1;
      retVal = true;
    }

    return retVal;
  }

  /// Returns true if all timers have value of 0 seconds
  bool zeros() {
    return !timers.any((element) => element.seconds != 0);
  }
}
