import 'package:dartz/dartz.dart';
import 'package:fluttertddcleanarch/core/error/expections.dart';
import 'package:fluttertddcleanarch/core/error/failures.dart';
import 'package:fluttertddcleanarch/core/network/network_info.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:fluttertddcleanarch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:fluttertddcleanarch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: 'test trivia',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check is the device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);

      repository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(
      () {
        test(
            'should remote data when the call to remote data source is successfull',
            () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        });

        test(
          'should cahce the data locally when the call to remote data source is successfull',
          () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((realInvocation) async => tNumberTriviaModel);

            final result = await repository.getConcreteNumberTrivia(tNumber);

            // assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));

            //expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
            'should return server failure then the call to remote data source is unsuccessfull',
            () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      },
    );

    runTestsOffline(() {
      test('should return last loacally cached data when the cached is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: 'test trivia',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check is the device is online', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);

      repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(
      () {
        test(
            'should remote data when the call to remote data source is successfull',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);

            await repository.getRandomNumberTrivia();

            // assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));

            //expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
            'should return server failure then the call to remote data source is unsuccessfull',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      },
    );

    runTestsOffline(() {
      test('should return last loacally cached data when the cached is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
