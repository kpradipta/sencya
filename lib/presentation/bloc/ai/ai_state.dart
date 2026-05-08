import 'package:equatable/equatable.dart';
import '../../../domain/entities/ai_recommendation.dart';

abstract class AIState extends Equatable {
  const AIState();

  @override
  List<Object?> get props => [];
}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class AIAnalysisLoaded extends AIState {
  final AIAnalysis analysis;

  const AIAnalysisLoaded(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

class HaircutGenerated extends AIState {
  final HaircutRecommendation recommendation;

  const HaircutGenerated(this.recommendation);

  @override
  List<Object?> get props => [recommendation];
}

class AIError extends AIState {
  final String message;

  const AIError(this.message);

  @override
  List<Object?> get props => [message];
}
