import 'package:fluttertddcleanarch/core/error/expections.dart';
import 'package:fluttertddcleanarch/core/network/network_info.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertddcleanarch/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final numberTriviaModel = await localDataSource.getLastNumberTrivia();
        return Right(numberTriviaModel);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
