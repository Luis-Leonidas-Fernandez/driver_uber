

class Configuration {

  Configuration._();

  static String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  static String getFormattedTime() {
  final now = DateTime.now().toLocal(); // 👈 muy importante
  return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
}

}