import 'dart:ffi';

import 'package:fluttertddcleanarch/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  
  Future <Void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}
