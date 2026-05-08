import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, Review>> createReview({
    required String bookingId,
    required num rating,
    required String comment,
  });
  Future<Either<Failure, List<Review>>> getCapsterReviews(String capsterId);
}
