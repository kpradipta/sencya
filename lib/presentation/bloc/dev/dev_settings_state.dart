import 'package:equatable/equatable.dart';

enum ApiEnvironment { prod, dev, demo }

class DevSettingsState extends Equatable {
  final bool isDevModeEnabled;
  final bool showFloatingDevTools;
  final bool useChucker;
  final bool showDebugInfo;
  final bool showDebugButtons;
  final ApiEnvironment apiEnvironment;
  final bool showChuckerNotification;
  final bool showChuckerOnRelease;
  final String language;
  final bool getCorpsPangkat;

  final int totalRegisteredPages;
  final int uniquePagesVisited;
  final String currentRoute;
  final String? fcmToken;

  const DevSettingsState({
    this.isDevModeEnabled = false,
    this.showFloatingDevTools = false,
    this.useChucker = false,
    this.showDebugInfo = false,
    this.showDebugButtons = false,
    this.apiEnvironment = ApiEnvironment.demo,
    this.showChuckerNotification = true,
    this.showChuckerOnRelease = true,
    this.language = 'id',
    this.getCorpsPangkat = false,
    this.totalRegisteredPages = 0,
    this.uniquePagesVisited = 0,
    this.currentRoute = '-',
    this.fcmToken,
  });

  DevSettingsState copyWith({
    bool? isDevModeEnabled,
    bool? showFloatingDevTools,
    bool? useChucker,
    bool? showDebugInfo,
    bool? showDebugButtons,
    ApiEnvironment? apiEnvironment,
    bool? showChuckerNotification,
    bool? showChuckerOnRelease,
    String? language,
    bool? getCorpsPangkat,
    int? totalRegisteredPages,
    int? uniquePagesVisited,
    String? currentRoute,
    String? fcmToken,
  }) {
    return DevSettingsState(
      isDevModeEnabled: isDevModeEnabled ?? this.isDevModeEnabled,
      showFloatingDevTools: showFloatingDevTools ?? this.showFloatingDevTools,
      useChucker: useChucker ?? this.useChucker,
      showDebugInfo: showDebugInfo ?? this.showDebugInfo,
      showDebugButtons: showDebugButtons ?? this.showDebugButtons,
      apiEnvironment: apiEnvironment ?? this.apiEnvironment,
      showChuckerNotification:
          showChuckerNotification ?? this.showChuckerNotification,
      showChuckerOnRelease: showChuckerOnRelease ?? this.showChuckerOnRelease,
      language: language ?? this.language,
      getCorpsPangkat: getCorpsPangkat ?? this.getCorpsPangkat,
      totalRegisteredPages: totalRegisteredPages ?? this.totalRegisteredPages,
      uniquePagesVisited: uniquePagesVisited ?? this.uniquePagesVisited,
      currentRoute: currentRoute ?? this.currentRoute,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [
    isDevModeEnabled,
    showFloatingDevTools,
    useChucker,
    showDebugInfo,
    showDebugButtons,
    apiEnvironment,
    showChuckerNotification,
    showChuckerOnRelease,
    language,
    getCorpsPangkat,
    totalRegisteredPages,
    uniquePagesVisited,
    currentRoute,
    fcmToken,
  ];
}
