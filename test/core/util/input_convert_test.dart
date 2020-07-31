import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddcleanarch/core/util/input_convert.dart';

void main() {
  InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('shold return an integer when the string represents an unsigned integer', 
    () async {
      final str = '123';

      final result = inputConverter.stringToUsingnedInteger(str);

      expect(result, Right(123));
    });

    test('shold return Faiulure when the string is not an integer', 
    () async {
      final str = '1.23';

      final result = inputConverter.stringToUsingnedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('shold return Faiulure when the string is a negative integer', 
    () async {
      final str = '-123';

      final result = inputConverter.stringToUsingnedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
