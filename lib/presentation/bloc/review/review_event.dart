import 'package:equatable/equatable.dart';
import '../../../domain/entities/review.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class CreateReviewRequested extends ReviewEvent {
  final String bookingId;
  final num rating;
  final String comment;

  const CreateReviewRequested({
    required this.bookingId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object> get props => [bookingId, rating, comment];
}

class GetCapsterReviewsRequested extends ReviewEvent {
  final String capsterId;

  const GetCapsterReviewsRequested(this.capsterId);

  @override
  List<Object> get props => [capsterId];
}
