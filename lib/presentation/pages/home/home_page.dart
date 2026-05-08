import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import 'package:intl/intl.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/review/review_bloc.dart';
import '../../bloc/review/review_event.dart';
import '../../bloc/review/review_state.dart';
import '../../../core/di/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(FetchHomeData()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MODERN GENTLEMAN'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.textSecondary),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.elegantGold),
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.error),
              ),
            );
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Exclusive\nGrooming.',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => context.push('/rewards'),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.elegantGold.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: AppColors.elegantGold,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YOUR REWARDS',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Check balance & vouchers',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.push('/ai-upload'),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.elegantGold.withOpacity(0.3),
                        ),
                        gradient: LinearGradient(
                          colors: [AppColors.surface, AppColors.matteBlack],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppColors.elegantGold,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI PHOTO ANALYZER',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Find your perfect haircut',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'OUR SERVICES',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.services.length,
                    itemBuilder: (context, index) {
                      final service = state.services[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            service.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subtitle: Text(
                            'Rp ${service.price} • ${service.duration} Mins',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.elegantGold),
                          ),
                          trailing: OutlinedButton(
                            onPressed: () {
                              if (state.capsters.isNotEmpty) {
                                context.push(
                                  '/booking',
                                  extra: {
                                    'service': service,
                                    'capster': state.capsters[0],
                                  },
                                );
                              }
                            },
                            child: const Text('BOOK'),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'MASTER BARBERS',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.capsters.length,
                      itemBuilder: (context, index) {
                        final capster = state.capsters[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: InkWell(
                              onTap: () => _showReviews(
                                context,
                                capster.id,
                                capster.name,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 32,
                                      backgroundColor: AppColors.borderStroke,
                                      child: Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      capster.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: AppColors.elegantGold,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          capster.rating.toString(),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showReviews(
    BuildContext context,
    String capsterId,
    String capsterName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: BlocProvider.value(
            value: sl<ReviewBloc>()..add(GetCapsterReviewsRequested(capsterId)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'REVIEWS FOR $capsterName',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      if (state is ReviewLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.elegantGold,
                          ),
                        );
                      } else if (state is ReviewError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: AppColors.error),
                          ),
                        );
                      } else if (state is CapsterReviewsLoaded) {
                        if (state.reviews.isEmpty) {
                          return Center(
                            child: Text(
                              'No reviews yet.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return ListView.separated(
                          controller: scrollController,
                          itemCount: state.reviews.length,
                          separatorBuilder: (_, _) => const Divider(
                            color: AppColors.borderStroke,
                            height: 32,
                          ),
                          itemBuilder: (context, index) {
                            final review = state.reviews[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 14,
                                        color: i < review.rating
                                            ? AppColors.elegantGold
                                            : AppColors.textSecondary
                                                  .withOpacity(0.3),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(review.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.comment,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
