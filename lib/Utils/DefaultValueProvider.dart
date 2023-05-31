class DefaultValueProvider {
  static T checkForNull<T>(dynamic value, T defValue) {
    return value ?? defValue;
  }
}
