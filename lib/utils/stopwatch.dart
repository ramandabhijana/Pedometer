import 'dart:async';


class StopWatch {

  static Stream<int> get stream {
    StreamController<int> controller;
    Timer timer;
    int counter = 0;
    Duration timerInterval = Duration(seconds: 1);

    void tick(_) {
      counter++;
      controller.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        controller.close();
      }
    }

    controller = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onPause: stopTimer,
    );

    return controller.stream;
  }

}