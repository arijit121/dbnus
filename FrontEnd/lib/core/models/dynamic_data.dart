import 'package:equatable/equatable.dart';

class DynamicBlocData<T> extends Equatable {
  final Status status;
  final T? value;
  final String? message;
  final Object? error;

  const DynamicBlocData.init({this.value})
      : status = Status.init,
        message = null,
        error = null;

  const DynamicBlocData.loading()
      : status = Status.loading,
        value = null,
        message = null,
        error = null;

  const DynamicBlocData.success({required this.value})
      : status = Status.success,
        message = null,
        error = null;

  const DynamicBlocData.error({this.error, this.message})
      : status = Status.error,
        value = null;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $value";
  }

  @override
  List<Object?> get props => [status];
}

enum Status {
  init,
  loading,
  success,
  error,
}
