import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/ai_repository.dart';
import 'ai_event.dart';
import 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final AIRepository aiRepository;

  AIBloc({required this.aiRepository}) : super(AIInitial()) {
    on<AnalyzePhotoRequested>(_onAnalyzePhotoRequested);
    on<GenerateHaircutRequested>(_onGenerateHaircutRequested);
  }

  Future<void> _onAnalyzePhotoRequested(AnalyzePhotoRequested event, Emitter<AIState> emit) async {
    emit(AILoading());
    final result = await aiRepository.analyzePhoto(event.photo);
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (analysis) => emit(AIAnalysisLoaded(analysis)),
    );
  }

  Future<void> _onGenerateHaircutRequested(GenerateHaircutRequested event, Emitter<AIState> emit) async {
    emit(AILoading());
    final result = await aiRepository.generateHaircut(
      styleName: event.styleName,
      addOns: event.addOns,
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (recommendation) => emit(HaircutGenerated(recommendation)),
    );
  }
}
