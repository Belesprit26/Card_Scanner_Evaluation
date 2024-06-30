abstract class Failure {
  final String message;
  Failure(this.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
