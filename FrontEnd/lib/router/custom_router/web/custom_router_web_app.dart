class CustomRouterWeb {
  /// Go To name page and Replace Current Page
  ///
  ///
  void goToNameAndOff(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {}

  /// open the Page in same tab
  ///
  ///
  void openPageSameTab(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {}

  void reDirect(String url) {}

  /// Pop and remove the state from stack
  ///
  ///
  void popAndOff([dynamic result]) {}

  /// Html Back
  ///
  ///
  void back() {}

  /// Number of Html Back
  ///
  ///
  void numBack(int index) {}

  /// Html SecBack
  ///
  ///
  void secBack() {}

  bool canBack() {
    return false;
  }

  int historyIndex() {
    return 0;
  }
}
