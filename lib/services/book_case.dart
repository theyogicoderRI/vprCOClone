String capitalizeOnlyFirstLetter(String s) {
  if (s.trim().isEmpty) return "";

  return "${s[0].toUpperCase()}${s.substring(1)}";
}
