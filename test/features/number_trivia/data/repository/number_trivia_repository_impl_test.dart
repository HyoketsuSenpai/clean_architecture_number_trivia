import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body){
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body){
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
      'should return remote data when the call to remote data source is successful',
              () async {
                //arrange
                when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
                //act
                final result = await repository.getConcreteNumberTrivia(tNumber);
                //assert
                verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
                verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
                expect(result, equals(Right(tNumberTrivia)));
              });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenThrow(ServerException());
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
            verifyZeroInteractions(mockNumberTriviaLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });

      test(
          'should cache the data locally when the call to remote data source is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          });

    });

    runTestsOffline(() {

      test(
          'should return last locally chached data when the cached data is present',
          () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          }
      );

    });

    test(
        'should return CacheFailure when there is no cached data present',
            () async {
          //arrange
          when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
          verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
    );

  });


  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel(text: 'test trivia', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
            verifyZeroInteractions(mockNumberTriviaLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });

      test(
          'should cache the data locally when the call to remote data source is successful',
              () async {
            //arrange
            when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            await repository.getRandomNumberTrivia();
            //assert
            verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
            verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          });

    });

    runTestsOffline(() {

      test(
          'should return last locally chached data when the cached data is present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = await repository.getRandomNumberTrivia();
            //assert
            verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          }
      );

    });

    test(
        'should return CacheFailure when there is no cached data present',
            () async {
          //arrange
          when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
          verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
    );

  });
}
