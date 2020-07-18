import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddcleanarch/core/usecases/usescases.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

  test(
    'should get trivia from repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      // Como o número aleatório não requer nenhum parâmetro, passamos o NoParams.
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
