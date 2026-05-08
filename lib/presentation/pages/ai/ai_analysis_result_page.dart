import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../bloc/ai/ai_bloc.dart';
import '../../bloc/ai/ai_event.dart';
import '../../bloc/ai/ai_state.dart';
import '../../../domain/entities/ai_recommendation.dart';

class AIAnalysisResultPage extends StatelessWidget {
  final AIAnalysis analysis;

  const AIAnalysisResultPage({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANALYSIS RESULT'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                    analysis.faceShape.toUpperCase(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32, color: AppColors.elegantGold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Text('EXPERT OBSERVATION', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 16),
            Text(
              analysis.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 48),
            Text('RECOMMENDED STYLES', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: analysis.recommendedStyles.length,
              itemBuilder: (context, index) {
                final style = analysis.recommendedStyles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(style, style: Theme.of(context).textTheme.titleSmall),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.elegantGold),
                    onTap: () {
                      context.push('/ai-generate', extra: {'styleName': style});
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('TRY ANOTHER PHOTO'),
            ),
          ],
        ),
      ),
    );
  }
}
