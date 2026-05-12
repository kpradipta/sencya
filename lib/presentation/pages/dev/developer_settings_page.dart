import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import '../../../core/storage/dev_settings_storage.dart';
import '../../bloc/dev/dev_settings_bloc.dart';
import '../../bloc/dev/dev_settings_event.dart';
import '../../bloc/dev/dev_settings_state.dart';

class DeveloperSettingsPage extends StatelessWidget {
  const DeveloperSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeveloperSettingsView();
  }
}

class DeveloperSettingsView extends StatelessWidget {
  const DeveloperSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<DevSettingsBloc, DevSettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPagesCounter(context, state),
              const SizedBox(height: 24),
              _buildSwitches(context, state),
              const SizedBox(height: 24),
              _buildEnvironmentSelector(context, state),
              const SizedBox(height: 16),
              _buildActions(context, state),
              const SizedBox(height: 24),
              _buildLanguageSelector(context, state),
              // const SizedBox(height: 24),
              // _buildApiFeatureSwitches(context, state),
              const SizedBox(height: 24),
              _buildFcmTokenSection(context, state),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPagesCounter(BuildContext context, DevSettingsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Pages Counter',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildCounterRow(
            'Total Registered Pages:',
            '${state.totalRegisteredPages}',
          ),
          _buildCounterRow(
            'Unique Pages Visited (session):',
            '${state.uniquePagesVisited}',
          ),
          _buildCounterRow('Current Route:', state.currentRoute),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  context.read<DevSettingsBloc>().add(RefreshCounters()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Refresh Counters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSwitches(BuildContext context, DevSettingsState state) {
    return Column(
      children: [
        _buildSwitchRow(
          context,
          'Show Floating Dev Tools:',
          state.showFloatingDevTools,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.floatingDevToolsKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Use Chucker Network Inspector:',
          state.useChucker,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.useChuckerKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Show Chucker Notification:',
          state.showChuckerNotification,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.showChuckerNotificationKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Show Chucker On Release Mode:',
          state.showChuckerOnRelease,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.showChuckerOnReleaseKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Show Debug Info:',
          state.showDebugInfo,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.showDebugInfoKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Show Debug Buttons (Detail Hasil Diklat):',
          state.showDebugButtons,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.showDebugButtonsKey, val),
          ),
        ),
        _buildSwitchRow(
          context,
          'Use Mock AI Features:',
          state.useMockAi,
          (val) => context.read<DevSettingsBloc>().add(
            UpdateSetting(DevSettingsStorage.mockAiFeaturesKey, val),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue[800],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentSelector(
    BuildContext context,
    DevSettingsState state,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Rest API Environment:', style: TextStyle(fontSize: 14)),
        DropdownButton<ApiEnvironment>(
          value: state.apiEnvironment,
          items: ApiEnvironment.values.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.name[0].toUpperCase() + e.name.substring(1)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              context.read<DevSettingsBloc>().add(
                UpdateSetting(DevSettingsStorage.apiEnvironmentKey, val.name),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, DevSettingsState state) {
    return Column(
      children: [
        _buildActionButton(context, 'Test Base URL Update', () {}),
        const SizedBox(height: 12),
        _buildActionButton(context, 'Flush all storage services', () {
          context.read<DevSettingsBloc>().add(FlushStorage());
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Storage flushed!')));
        }),
        const SizedBox(height: 12),
        _buildActionButton(context, 'Open Chucker Inspector Screen', () {
          ChuckerFlutter.showChuckerScreen();
        }),
        const SizedBox(height: 12),
        _buildActionButton(context, 'Check Chucker Status', () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Chucker is ${state.useChucker ? 'active' : 'inactive'}',
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'Test API Call',
          () => context.read<DevSettingsBloc>().add(TestApiCall()),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, DevSettingsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bahasa', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLangButton(
                  context,
                  'Bahasa Indonesia',
                  state.language == 'id',
                  () => context.read<DevSettingsBloc>().add(
                    const UpdateSetting('dev_language', 'id'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLangButton(
                  context,
                  'English',
                  state.language == 'en',
                  () => context.read<DevSettingsBloc>().add(
                    const UpdateSetting('dev_language', 'en'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButton(context, 'Test Localization', () {}),
        ],
      ),
    );
  }

  Widget _buildLangButton(
    BuildContext context,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.blue[800] : Colors.white,
        foregroundColor: active ? Colors.white : Colors.grey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: active ? Colors.blue[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Text(label),
    );
  }

  // Widget _buildApiFeatureSwitches(
  //   BuildContext context,
  //   DevSettingsState state,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Center(
  //         child: Text(
  //           'API Feature Switches',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       const Padding(
  //         padding: EdgeInsets.symmetric(vertical: 8.0),
  //         child: Divider(),
  //       ),
  //       _buildSwitchRow(
  //         context,
  //         'Get Corps, Pangkat by type:',
  //         state.getCorpsPangkat,
  //         (val) => context.read<DevSettingsBloc>().add(
  //           UpdateSetting(DevSettingsStorage.getCorpsPangkatKey, val),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFcmTokenSection(BuildContext context, DevSettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'FCM Token',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  state.fcmToken ?? 'Not available',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          context,
          'Refresh FCM Token',
          () => context.read<DevSettingsBloc>().add(RefreshFcmToken()),
        ),
      ],
    );
  }
}
