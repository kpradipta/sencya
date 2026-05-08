import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/review_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(ReviewInitial()) {
    on<CreateReviewRequested>(_onCreateReviewRequested);
    on<GetCapsterReviewsRequested>(_onGetCapsterReviewsRequested);
  }

  Future<void> _onCreateReviewRequested(CreateReviewRequested event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await reviewRepository.createReview(
      bookingId: event.bookingId,
      rating: event.rating,
      comment: event.comment,
    );
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewCreated(review)),
    );
  }

  Future<void> _onGetCapsterReviewsRequested(GetCapsterReviewsRequested event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await reviewRepository.getCapsterReviews(event.capsterId);
    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (reviews) => emit(CapsterReviewsLoaded(reviews)),
    );
  }
}
