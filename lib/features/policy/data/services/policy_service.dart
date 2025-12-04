import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/policy_model.dart';

part 'policy_service.g.dart';

/// 약관/정책 JSON 로딩 서비스
///
/// **사용처**:
/// - 온보딩 약관 동의 페이지 (terms_page.dart)
/// - 마이페이지 "정책 & 안전" 섹션
///
/// **사용 예시**:
/// ```dart
/// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
/// policyAsync.when(
///   data: (policy) => PolicyDetailScreen(policy: policy),
///   loading: () => CircularProgressIndicator(),
///   error: (e, _) => Text('오류: $e'),
/// );
/// ```
class PolicyService {
  const PolicyService();

  /// JSON 파일에서 약관 데이터 로드
  ///
  /// [type] 약관 타입 (termsOfService, privacyPolicy 등)
  /// 반환: PolicyModel 또는 파싱 실패 시 예외
  Future<PolicyModel> loadPolicy(PolicyType type) async {
    try {
      // assets/terms/{fileName}.json 경로에서 로드
      final jsonString = await rootBundle.loadString(
        'assets/terms/${type.fileName}.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return PolicyModel.fromJson(jsonMap);
    } on FormatException catch (e) {
      throw PolicyLoadException('JSON 파싱 오류: ${e.message}', type);
    } catch (e) {
      throw PolicyLoadException('파일 로드 오류: $e', type);
    }
  }

  /// 모든 약관 데이터 로드 (캐시용)
  Future<Map<PolicyType, PolicyModel>> loadAllPolicies() async {
    final results = <PolicyType, PolicyModel>{};
    for (final type in PolicyType.values) {
      try {
        results[type] = await loadPolicy(type);
      } catch (_) {
        // 개별 실패는 무시하고 계속 진행
        continue;
      }
    }
    return results;
  }
}

/// 약관 로드 예외
class PolicyLoadException implements Exception {
  const PolicyLoadException(this.message, this.policyType);

  final String message;
  final PolicyType policyType;

  @override
  String toString() =>
      'PolicyLoadException: $message (type: ${policyType.displayName})';
}

/// PolicyService Provider
@riverpod
PolicyService policyService(Ref ref) {
  return const PolicyService();
}

/// 특정 약관 데이터 Provider
///
/// **사용 예시**:
/// ```dart
/// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
/// ```
@riverpod
Future<PolicyModel> policy(Ref ref, PolicyType type) async {
  final service = ref.watch(policyServiceProvider);
  return service.loadPolicy(type);
}
