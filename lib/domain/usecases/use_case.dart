// ignore: dangling_library_doc_comments
/// Base class for use cases.
///
/// Use cases encapsulate business logic and coordinate repository calls
/// They should be stateless and focused on a single business operation.

abstract class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// For use cases that don't require parameters
class NoParams {
  const NoParams();
}
