import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// 다이얼로그 관련 유틸리티 함수들
///
/// 앱 전체에서 사용되는 공통 다이얼로그들을 중앙에서 관리합니다.
/// 일관된 디자인과 사용자 경험을 제공합니다.
class DialogUtils {
  DialogUtils._();

  /// 기본 알림 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [title] 다이얼로그 제목 (기본값: '알림')
  /// [content] 다이얼로그 내용 (기본값: '현재 새로운 알림이 없습니다.')
  /// [confirmText] 확인 버튼 텍스트 (기본값: '확인')
  /// [onConfirm] 확인 버튼 클릭 시 실행될 콜백 (기본값: 다이얼로그 닫기)
  static Future<void> showNotificationDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? '알림'),
        content: Text(content ?? '현재 새로운 알림이 없습니다.'),
        actions: [
          TextButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            child: Text(confirmText ?? AppStrings.of(context).btnConfirm),
          ),
        ],
      ),
    );
  }

  /// 확인/취소 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [title] 다이얼로그 제목
  /// [content] 다이얼로그 내용
  /// [confirmText] 확인 버튼 텍스트 (기본값: '확인')
  /// [cancelText] 취소 버튼 텍스트 (기본값: '취소')
  /// [onConfirm] 확인 버튼 클릭 시 실행될 콜백
  /// [onCancel] 취소 버튼 클릭 시 실행될 콜백 (기본값: 다이얼로그 닫기)
  ///
  /// Returns: 사용자가 확인을 선택했으면 true, 취소했으면 false
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText ?? AppStrings.of(context).btnCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText ?? AppStrings.of(context).btnConfirm),
          ),
        ],
      ),
    );
  }

  /// 에러 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [title] 다이얼로그 제목 (기본값: '오류')
  /// [content] 에러 메시지
  /// [confirmText] 확인 버튼 텍스트 (기본값: '확인')
  /// [onConfirm] 확인 버튼 클릭 시 실행될 콜백 (기본값: 다이얼로그 닫기)
  static Future<void> showErrorDialog(
    BuildContext context, {
    String title = '오류',
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            child: Text(confirmText ?? AppStrings.of(context).btnConfirm),
          ),
        ],
      ),
    );
  }

  /// 성공 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [title] 다이얼로그 제목 (기본값: '성공')
  /// [content] 성공 메시지
  /// [confirmText] 확인 버튼 텍스트 (기본값: '확인')
  /// [onConfirm] 확인 버튼 클릭 시 실행될 콜백 (기본값: 다이얼로그 닫기)
  static Future<void> showSuccessDialog(
    BuildContext context, {
    String title = '성공',
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            child: Text(confirmText ?? AppStrings.of(context).btnConfirm),
          ),
        ],
      ),
    );
  }

  /// 로딩 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [message] 로딩 메시지 (기본값: '처리 중...')
  ///
  /// Returns: 다이얼로그를 닫을 수 있는 함수
  static VoidCallback showLoadingDialog(
    BuildContext context, {
    String message = '처리 중...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // 뒤로가기로 닫을 수 없음
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );

    // 다이얼로그를 닫는 함수 반환
    return () => Navigator.of(context).pop();
  }

  /// 커스텀 다이얼로그를 표시합니다
  ///
  /// [context] BuildContext
  /// [child] 다이얼로그에 표시할 위젯
  /// [barrierDismissible] 외부 터치로 닫기 가능 여부 (기본값: true)
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
}
