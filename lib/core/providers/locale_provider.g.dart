// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 언어 설정 상태 관리 Provider
///
/// 사용자가 선택한 언어를 SharedPreferences에 저장하고
/// 앱 전체에서 언어 설정을 관리합니다.

@ProviderFor(LocaleNotifier)
const localeProvider = LocaleNotifierProvider._();

/// 언어 설정 상태 관리 Provider
///
/// 사용자가 선택한 언어를 SharedPreferences에 저장하고
/// 앱 전체에서 언어 설정을 관리합니다.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale?> {
  /// 언어 설정 상태 관리 Provider
  ///
  /// 사용자가 선택한 언어를 SharedPreferences에 저장하고
  /// 앱 전체에서 언어 설정을 관리합니다.
  const LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeNotifierHash() => r'1d75264c9ca7f234a1a44c2c39809bc5a4367f11';

/// 언어 설정 상태 관리 Provider
///
/// 사용자가 선택한 언어를 SharedPreferences에 저장하고
/// 앱 전체에서 언어 설정을 관리합니다.

abstract class _$LocaleNotifier extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
