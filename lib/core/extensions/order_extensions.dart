extension OrderExtensions on String {
  String get last6 {
    return substring(length - 6);
  }

  // convert {LARGE, regular, no syrup, extra hot} to {Large, Regular, No Syrup, Extra Hot}
  String toLarge() {
    if (isEmpty) return this;

    return split(',')
        .map((part) {
          final trimmed = part.trim();

          return trimmed
              .split(' ')
              .map(
                (word) => word.isEmpty
                    ? word
                    : word[0].toUpperCase() + word.substring(1).toLowerCase(),
              )
              .join(' ');
        })
        .join(', ');
  }
}
