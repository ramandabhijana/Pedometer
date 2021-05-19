import 'package:intl/intl.dart';

extension DurationFormatter on Duration {
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  get toHourMinuteSecondFormat {
    return "${_twoDigits(this.inHours)}:"
        "${_twoDigits(this.inMinutes.remainder(60))}:"
        "${_twoDigits(this.inSeconds.remainder(60))}";
  }

  String toHHMMSS() {
    return DateFormat.jm().format(
        DateFormat("hh:mm:ss").parse(this.toHourMinuteSecondFormat)
    );
  }
}