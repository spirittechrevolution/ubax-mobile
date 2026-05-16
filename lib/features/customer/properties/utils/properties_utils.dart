bool isNetworkImage(String path) {
  return path.startsWith('http://') || path.startsWith('https://');
}

String formatFcfa(num value) {
  final s = value.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return buf.toString();
}
