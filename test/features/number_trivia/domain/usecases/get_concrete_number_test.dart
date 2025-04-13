import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
import 'get_concrete_number_test.mocks.dart';

void main(){
late GetConcreteNumberTrivia usecase;
late MockNumberTriviaRepository mockNumberTriviaRepository;

setUp((){
  mockNumberTriviaRepository = MockNumberTriviaRepository();
  usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
});

int tNumber = 1;
NumberTrivia tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

test('should get trivia for the number from the repository',
() async {
  //arrange
  when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
      .thenAnswer((_) async => Right(tNumberTrivia));

  //act
  final result = await usecase(Params(number: tNumber));

  //asse
  expect(result, Right(tNumberTrivia));
  verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
  verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

}