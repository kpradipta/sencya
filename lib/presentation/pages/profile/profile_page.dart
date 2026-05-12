import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/auth/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.surface,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.elegantGold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    user?.name ?? 'Gentleman',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 24),
                  ),
                ),
                Center(
                  child: Text(
                    user?.email ?? 'gentleman@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _buildOption(
                  context,
                  icon: Icons.calendar_month_outlined,
                  title: 'MY BOOKINGS',
                  onTap: () => context.push('/my-bookings'),
                ),
                _buildOption(
                  context,
                  icon: Icons.stars_rounded,
                  title: 'MY REWARDS',
                  onTap: () => context.push('/rewards'),
                ),
                _buildOption(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'SETTINGS',
                  onTap: () {},
                ),
                const SizedBox(height: 48),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    context.go('/login');
                  },
                  child: const Text(
                    'LOGOUT',
                    style: TextStyle(color: AppColors.error, letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: AppColors.elegantGold),
        title: Text(title, style: Theme.of(context).textTheme.labelSmall),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
