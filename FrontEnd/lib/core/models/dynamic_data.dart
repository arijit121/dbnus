enum Status { init, loading, success, error }

class DynamicBlocData<T> {
  final Status status;
  final T? value;
  final String? message;
  final String? error;

  const DynamicBlocData({
    required this.status,
    this.value,
    this.message,
    this.error,
  });

  factory DynamicBlocData.init({T? value}) {
    return DynamicBlocData(status: Status.init, value: value);
  }

  factory DynamicBlocData.loading() {
    return DynamicBlocData(status: Status.loading);
  }

  factory DynamicBlocData.success({T? value}) {
    return DynamicBlocData(status: Status.success, value: value);
  }

  factory DynamicBlocData.error({String? message, String? error}) {
    return DynamicBlocData(
      status: Status.error,
      message: message ?? error,
      error: error ?? message,
    );
  }
}
