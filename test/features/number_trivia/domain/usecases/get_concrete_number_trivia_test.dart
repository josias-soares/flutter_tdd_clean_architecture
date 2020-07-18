
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber =1;
  final tNumberTrivia = NumberTrivia(text: 'text', number: 1);

  test(
    'should get trivia for the number from repository',
    () async {
      // arrange
      // Implementação "On the fly" do Repositório usando o pacote Mockito.
      // Quando getConcreteNumberTrivia é chamado com qualquer argumento, sempre responda com
      // o "lado" direito de Ou contendo um objeto NumberTrivia de teste.
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
      .thenAnswer((_) async => Right(tNumberTrivia));

      // A fase "act" do teste. Chame o método ainda não existente.
      final result = await usecase(Params(number: tNumber));

      // UseCase deve simplesmente retornar o que foi retornado do Repositório
      expect(result, Right(tNumberTrivia));
      // Verifique se o método foi chamado no Repositório
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
       // Apenas o método acima deve ser chamado e nada mais.
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
