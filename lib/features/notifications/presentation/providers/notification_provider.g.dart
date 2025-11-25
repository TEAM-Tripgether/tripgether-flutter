// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationListHash() => r'd5f3bf1f4a4b9b05feacdb717262cedfd3702d5a';

/// 알림 목록을 관리하는 Provider
///
/// HomeScreen과 NotificationScreen에서 공유하여 사용합니다.
/// - HomeScreen: URL 분석 요청 후 알림 추가
/// - NotificationScreen: 알림 목록 표시 및 상태 업데이트
///
/// Copied from [NotificationList].
@ProviderFor(NotificationList)
final notificationListProvider =
    AutoDisposeNotifierProvider<
      NotificationList,
      List<NotificationItem>
    >.internal(
      NotificationList.new,
      name: r'notificationListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationList = AutoDisposeNotifier<List<NotificationItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
