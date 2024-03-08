import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class DynamicBlocData<T> extends Equatable{
  Status status;
  T? value;
  String? message;
  Object? error;

  DynamicBlocData.init({this.value}) : status = Status.init;

  DynamicBlocData.loading() : status = Status.loading;

  DynamicBlocData.success({required this.value}) : status = Status.success;

  DynamicBlocData.error({this.error,this.message}) : status = Status.error;


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