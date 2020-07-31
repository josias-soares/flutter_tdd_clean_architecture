import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:fluttertddcleanarch/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUsingnedInteger(String str) {
    try {
      var integer = int.parse(str);
      
      if (integer < 0) throw FormatException();

      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
