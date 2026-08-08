String convertTo12HourFormat(String time) {
  int hour = int.parse(time.split(":")[0]);
  String minute = time.split(":")[1];

  String period = hour >= 12 ? "PM" : "AM";

  if (hour > 12) {
    hour -= 12;
  } else if (hour == 0) {
    hour = 12;
  }

  return "${hour.toString().padLeft(2, '0')}:$minute $period";
}
