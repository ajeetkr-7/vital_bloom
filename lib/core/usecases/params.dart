
import 'package:equatable/equatable.dart';

abstract class Param extends Equatable {
  const Param();
  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson() => {};
}

class NoParam extends Param {}