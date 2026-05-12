import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/authenticated_image.dart';
import '../../../theme/colors.dart';
import '../../bloc/ai/ai_bloc.dart';
import '../../bloc/ai/ai_event.dart';
import '../../bloc/ai/ai_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class AIGenerationPage extends StatefulWidget {
  final String? styleName;
  final String? requestId;
  final String? originalImageUrl;

  const AIGenerationPage({
    super.key,
    this.styleName,
    this.requestId,
    this.originalImageUrl,
  });

  @override
  State<AIGenerationPage> createState() => _AIGenerationPageState();
}

class _AIGenerationPageState extends State<AIGenerationPage> {
  @override
  void initState() {
    super.initState();
    if (widget.requestId != null) {
      _fetchPhotos();
    }
  }

  void _fetchPhotos() {
    final authState = context.read<AuthBloc>().state;
    String userId = 'default_user';
    if (authState is Authenticated) {
      userId = authState.user.id;
    }

    context.read<AIBloc>().add(
      FetchGeneratedPhotosRequested(
        userId: userId,
        requestId: widget.requestId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.styleName?.toUpperCase() ?? 'GENERATING PREVIEW'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<AIBloc, AIState>(
        builder: (context, state) {
          if (state is AILoading) {
            return const Center(child: StylingTipsCarousel());
          } else if (state is AIError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _fetchPhotos,
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          } else if (state is GeneratedPhotosLoaded) {
            if (state.photos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hourglass_empty,
                      color: AppColors.primaryRed,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'STILL PROCESSING...',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _fetchPhotos,
                      child: const Text('CHECK AGAIN'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      photo.styleName?.toUpperCase() ?? 'OPTION ${index + 1}',
                      style: const TextStyle(
                        color: AppColors.elegantGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Original',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AspectRatio(
                                aspectRatio: 1,
                                child: AuthenticatedImage(
                                  imageUrl: widget.originalImageUrl ?? '',
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => GoRouter.of(
                              context,
                            ).push('/active-service-timer'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Generated',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: AuthenticatedImage(
                                    imageUrl: photo.url,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            );
          }

          return const Center(
            child: Text(
              'READY TO GENERATE',
              style: TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: ElevatedButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('BACK TO RESULTS'),
          ),
        ),
      ),
    );
  }
}

class StylingTipsCarousel extends StatefulWidget {
  const StylingTipsCarousel({super.key});

  @override
  State<StylingTipsCarousel> createState() => _StylingTipsCarouselState();
}

class _StylingTipsCarouselState extends State<StylingTipsCarousel> {
  int _currentIndex = 0;
  final List<String> _tips = [
    "Matte pomade is great for a natural, textured look.",
    "Use a sea salt spray for extra volume and grip.",
    "Blow dry your hair in the direction you want it to stay.",
    "A French Crop works best with a bit of texture on top.",
    "Keep your sides tight to make your face shape look sharper.",
    "Beard oil isn't just for hair; it hydrates the skin underneath.",
  ];

  late final Stream<int> _timer;

  @override
  void initState() {
    super.initState();
    _timer = Stream.periodic(
      const Duration(seconds: 4),
      (i) => (i + 1) % _tips.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timer,
      initialData: 0,
      builder: (context, snapshot) {
        _currentIndex = snapshot.data ?? 0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryRed),
            const SizedBox(height: 48),
            Text(
              'OUR AI IS CRAFTING YOUR LOOK...',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 2,
                color: AppColors.elegantGold,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Padding(
                key: ValueKey(_currentIndex),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Icon(
                      Icons.tips_and_updates_outlined,
                      color: AppColors.elegantGold,
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _tips[_currentIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
