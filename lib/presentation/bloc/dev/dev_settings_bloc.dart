import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/dev_settings_storage.dart';
import '../../../core/storage/secret_storage.dart';
import '../../../core/routes/route_tracker.dart';
import '../../../core/network/api_client.dart';
import 'dev_settings_event.dart';
import 'dev_settings_state.dart';

class DevSettingsBloc extends Bloc<DevSettingsEvent, DevSettingsState> {
  final SecretStorage _secretStorage;
  final ApiClient _apiClient;

  DevSettingsBloc({
    required SecretStorage secretStorage,
    required ApiClient apiClient,
  }) : _secretStorage = secretStorage,
       _apiClient = apiClient,
       super(const DevSettingsState()) {
    on<LoadDevSettings>(_onLoadDevSettings);
    on<UpdateSetting>(_onUpdateSetting);
    on<RefreshCounters>(_onRefreshCounters);
    on<FlushStorage>(_onFlushStorage);
    on<RefreshFcmToken>(_onRefreshFcmToken);
    on<TestApiCall>(_onTestApiCall);
  }

  Future<void> _onLoadDevSettings(
    LoadDevSettings event,
    Emitter<DevSettingsState> emit,
  ) async {
    final isEnabled = await DevSettingsStorage.isEnabled();
    final showFloatingDevTools = await DevSettingsStorage.getBool(
      DevSettingsStorage.floatingDevToolsKey,
    );
    final useChucker = await DevSettingsStorage.getBool(
      DevSettingsStorage.useChuckerKey,
      defaultValue: true,
    );
    final showDebugInfo = await DevSettingsStorage.getBool(
      DevSettingsStorage.showDebugInfoKey,
    );
    final showDebugButtons = await DevSettingsStorage.getBool(
      DevSettingsStorage.showDebugButtonsKey,
    );
    final envString = await DevSettingsStorage.getString(
      DevSettingsStorage.apiEnvironmentKey,
      defaultValue: 'demo',
    );
    final showChuckerNotification = await DevSettingsStorage.getBool(
      DevSettingsStorage.showChuckerNotificationKey,
      defaultValue: true,
    );
    final showChuckerOnRelease = await DevSettingsStorage.getBool(
      DevSettingsStorage.showChuckerOnReleaseKey,
      defaultValue: true,
    );
    final language = await DevSettingsStorage.getString(
      DevSettingsStorage.languageKey,
      defaultValue: 'id',
    );
    final useMockAi = await DevSettingsStorage.getBool(
      DevSettingsStorage.mockAiFeaturesKey,
    );

    final env = ApiEnvironment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => ApiEnvironment.demo,
    );

    emit(
      state.copyWith(
        isDevModeEnabled: isEnabled,
        showFloatingDevTools: showFloatingDevTools,
        useChucker: useChucker,
        showDebugInfo: showDebugInfo,
        showDebugButtons: showDebugButtons,
        apiEnvironment: env,
        showChuckerNotification: showChuckerNotification,
        showChuckerOnRelease: showChuckerOnRelease,
        language: language,
        useMockAi: useMockAi,
        totalRegisteredPages: RouteTracker.instance.totalRegisteredPages,
        uniquePagesVisited: RouteTracker.instance.uniquePagesVisitedCount,
        currentRoute: RouteTracker.instance.currentRoute,
      ),
    );
  }

  Future<void> _onUpdateSetting(
    UpdateSetting event,
    Emitter<DevSettingsState> emit,
  ) async {
    if (event.value is bool) {
      await DevSettingsStorage.setBool(event.key, event.value);
    } else if (event.value is String) {
      await DevSettingsStorage.setString(event.key, event.value);
    }

    // Special case for enabled/disabled
    if (event.key == 'dev_mode_enabled') {
      await DevSettingsStorage.setEnabled(event.value);
    }

    // Update Base URL if environment changed
    if (event.key == DevSettingsStorage.apiEnvironmentKey) {
      await _apiClient.refreshBaseUrl();
    }

    add(LoadDevSettings());
  }

  Future<void> _onRefreshCounters(
    RefreshCounters event,
    Emitter<DevSettingsState> emit,
  ) async {
    RouteTracker.instance.resetCounters();
    emit(
      state.copyWith(
        uniquePagesVisited: RouteTracker.instance.uniquePagesVisitedCount,
        currentRoute: RouteTracker.instance.currentRoute,
      ),
    );
  }

  Future<void> _onFlushStorage(
    FlushStorage event,
    Emitter<DevSettingsState> emit,
  ) async {
    await _secretStorage.clearTokens();
    // In a real app, you might also want to clear shared preferences,
    // but maybe not the dev settings themselves?
    // Let's just clear tokens for now as it's the safest way to "logout".
  }

  Future<void> _onRefreshFcmToken(
    RefreshFcmToken event,
    Emitter<DevSettingsState> emit,
  ) async {
    // Implement FCM token refresh logic here
    emit(
      state.copyWith(
        fcmToken: 'TOKEN_${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  Future<void> _onTestApiCall(
    TestApiCall event,
    Emitter<DevSettingsState> emit,
  ) async {
    // Implement test API call logic here
  }
}
