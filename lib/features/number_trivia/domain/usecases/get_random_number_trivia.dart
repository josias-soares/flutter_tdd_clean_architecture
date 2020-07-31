import 'package:dartz/dartz.dart';
import 'package:fluttertddcleanarch/core/error/failures.dart';
import 'package:fluttertddcleanarch/core/usecases/usescases.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
