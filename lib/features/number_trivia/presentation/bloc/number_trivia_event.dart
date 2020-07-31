part of 'number_trivia_bloc.dart';


abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class getTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  getTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
  
}

class getTriviaForRandomNumber extends NumberTriviaEvent {
  final String numberString;

  getTriviaForRandomNumber(this.numberString);

  @override
  List<Object> get props => [numberString];
  
}
