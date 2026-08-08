extension NumExtensions on num? {
  bool isLessThan(int value) => (this ?? 0) < value;
  bool isGreaterThan(int value) => (this ?? 0) > value;
}
