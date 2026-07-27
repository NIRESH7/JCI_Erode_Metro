class JciString {
  static String powered_by = "Powered By";
  static String co_powered_by = "Co-Powered By";
}

String caps(String? data) {
  if (data?.isNotEmpty ?? false) {
    return "${data![0].toUpperCase()}${data.substring(1)}";
  }
  return '';
}
