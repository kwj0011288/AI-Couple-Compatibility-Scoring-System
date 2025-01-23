double convertValue(double value) {
  if (value < 0.0 || value > 1.0) {
    throw ArgumentError('Value must be between 0.0 and 1.0');
  }
  return double.parse((value * 10).toStringAsFixed(1));
}
