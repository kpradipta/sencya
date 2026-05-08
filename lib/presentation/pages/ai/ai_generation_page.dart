import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../bloc/ai/ai_bloc.dart';
import '../../bloc/ai/ai_event.dart';
import '../../bloc/ai/ai_state.dart';

class AIGenerationPage extends StatefulWidget {
  final String styleName;

  const AIGenerationPage({super.key, required this.styleName});

  @override
  State<AIGenerationPage> createState() => _AIGenerationPageState();
}

class _AIGenerationPageState extends State<AIGenerationPage> {
  final List<String> _selectedAddOns = [];
  final List<String> _availableAddOns = [
    'Beard Trim',
    'Hair Coloring',
    'Hot Towel Shave',
    'Scalp Massage',
    'Eyebrow Shaping',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STYLE GENERATOR'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocConsumer<AIBloc, AIState>(
        listener: (context, state) {
          if (state is AIError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message, style: TextStyle(color: AppColors.background)), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is HaircutGenerated) {
            return _buildResult(context, state.recommendation.imageUrl, state.recommendation.styleName);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Customize Your Look',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Style: ${widget.styleName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.elegantGold),
                ),
                const SizedBox(height: 48),
                Text('CHOOSE ADD-ONS (OPTIONAL)', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableAddOns.map((addOn) {
                    final isSelected = _selectedAddOns.contains(addOn);
                    return FilterChip(
                      label: Text(addOn),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAddOns.add(addOn);
                          } else {
                            _selectedAddOns.remove(addOn);
                          }
                        });
                      },
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.elegantGold.withOpacity(0.2),
                      checkmarkColor: AppColors.elegantGold,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.elegantGold : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? AppColors.elegantGold : AppColors.borderStroke),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 64),
                if (state is AILoading)
                  const Center(child: CircularProgressIndicator(color: AppColors.elegantGold))
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<AIBloc>().add(GenerateHaircutRequested(
                        styleName: widget.styleName,
                        addOns: _selectedAddOns,
                      ));
                    },
                    child: const Text('GENERATE PREVIEW'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResult(BuildContext context, String imageUrl, String styleName) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.elegantGold.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image_outlined, size: 64, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text('Image preview not available\n(Local server only)', style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            styleName.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'This look is designed to perfectly complement your face shape.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to Booking with this style pre-selected
              context.go('/home');
            },
            child: const Text('BOOK THIS LOOK'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('TRY DIFFERENT ADD-ONS'),
          ),
        ],
      ),
    );
  }
}
