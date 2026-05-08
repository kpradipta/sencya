import 'package:equatable/equatable.dart';
import '../../../domain/entities/review.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewCreated extends ReviewState {
  final Review review;

  const ReviewCreated(this.review);

  @override
  List<Object?> get props => [review];
}

class CapsterReviewsLoaded extends ReviewState {
  final List<Review> reviews;

  const CapsterReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
