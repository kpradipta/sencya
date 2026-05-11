import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../../domain/entities/ai_recommendation.dart';
import '../../bloc/ai/ai_bloc.dart';
import '../../bloc/ai/ai_event.dart';
import '../../bloc/ai/ai_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class AIAnalysisResultPage extends StatefulWidget {
  final AIAnalysis analysis;

  const AIAnalysisResultPage({super.key, required this.analysis});

  @override
  State<AIAnalysisResultPage> createState() => _AIAnalysisResultPageState();
}

class _AIAnalysisResultPageState extends State<AIAnalysisResultPage> {
  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    if (widget.analysis.requestId != null) {
      final authState = context.read<AuthBloc>().state;
      String userId = 'default_user';
      if (authState is Authenticated) {
        userId = authState.user.id;
      }
      
      context.read<AIBloc>().add(FetchGeneratedPhotosRequested(
        userId: userId,
        requestId: widget.analysis.requestId!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANALYSIS RESULT'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<AIBloc, AIState>(
        builder: (context, state) {
          final List<GeneratedPhoto> photos = (state is GeneratedPhotosLoaded) ? state.photos : [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.elegantGold.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Text('YOUR FACE SHAPE', style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 8),
                      Text(
                        widget.analysis.faceShape.toUpperCase(),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32, color: AppColors.elegantGold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text('EXPERT OBSERVATION', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 16),
                Text(
                  widget.analysis.faceAnalysisResult,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.6),
                ),
                const SizedBox(height: 32),
                if (widget.analysis.hairAnalysisResult.containsKey('hair_type'))
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.elegantGold.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.elegantGold.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.style_outlined, color: AppColors.elegantGold),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('HAIR TYPE', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                              const SizedBox(height: 4),
                              Text(
                                widget.analysis.hairAnalysisResult['hair_type']['type'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 48),
                Text('RECOMMENDED LOOKS', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.analysis.recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = widget.analysis.recommendations[index];
                    
                    // Try to find the photo for this style
                    GeneratedPhoto? photo;
                    if (photos.isNotEmpty) {
                      try {
                        photo = photos.firstWhere(
                          (p) => p.styleName?.toLowerCase() == rec.haircutName.toLowerCase(),
                          orElse: () => photos.length > index ? photos[index] : photos.first, // Fallback to index or first
                        );
                      } catch (_) {
                        // Ignore if not found
                      }
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (photo != null)
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                image: DecorationImage(
                                  image: NetworkImage(photo.url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else if (state is AILoading)
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.elegantGold.withOpacity(0.05),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: AppColors.elegantGold),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        rec.haircutName.toUpperCase(),
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.elegantGold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.elegantGold.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        rec.rating,
                                        style: const TextStyle(color: AppColors.elegantGold, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  rec.analysis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 16),
                                Text('STYLING TIP', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                                const SizedBox(height: 4),
                                Text(
                                  rec.styling,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('TRY ANOTHER PHOTO'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/ai-generate', extra: {
                      'styleName': 'All Recommended Styles',
                      'requestId': widget.analysis.requestId,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('VIEW FULL-SCREEN PREVIEWS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
