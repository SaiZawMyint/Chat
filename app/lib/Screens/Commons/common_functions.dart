class CommonFunctions{
  static String? validate(String? value, [String? label]) {
    String prefix = label ?? "Text";
    if (value == null) return "$prefix cannot be empty!";
    if (value.length < 4) return "$prefix must be at least 4 characters";
    return null;
  }
}