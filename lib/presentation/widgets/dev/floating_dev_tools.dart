import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../bloc/dev/dev_settings_bloc.dart';
import '../../bloc/dev/dev_settings_state.dart';

class FloatingDevTools extends StatelessWidget {
  final Widget child;

  const FloatingDevTools({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevSettingsBloc, DevSettingsState>(
      builder: (context, state) {
        if (!state.isDevModeEnabled || !state.showFloatingDevTools) {
          return child;
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              child,
              Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height * 0.4,
                child: Material(
                  type: MaterialType.transparency,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        final String currentLocation = AppRouter
                            .router
                            .routerDelegate
                            .currentConfiguration
                            .last
                            .matchedLocation;

                        // Only push if we aren't already on the dev settings page
                        if (currentLocation != '/dev-settings') {
                          // Use the actual path for devSettingsRoute
                          AppRouter.router.pushNamed(
                            AppRouter.devSettingsRoute,
                          );
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(-2, 0),
                            ),
                          ],
                        ),
                        child: _buildTabContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent() {
    return const Center(
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
          'Dev Tools',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
