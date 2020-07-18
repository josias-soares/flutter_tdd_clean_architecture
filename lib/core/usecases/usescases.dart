import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertddcleanarch/core/error/failures.dart';

// Os parâmetros devem ser colocados em um objeto contêiner para que possam ser
// incluído nesta definição abstrata do método da classe base.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Isso será usado pelo código que chama o caso de uso sempre que o caso de uso
// não aceitar nenhum parâmetro.
class NoParams extends Equatable {}
