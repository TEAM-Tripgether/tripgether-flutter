package com.tripgether.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SHARING_CHANNEL = "sharing_service"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("MainActivity", "onCreate 호출됨")
        Log.d("MainActivity", "Intent: ${intent}")
        Log.d("MainActivity", "Intent Action: ${intent?.action}")
        Log.d("MainActivity", "Intent Type: ${intent?.type}")
        Log.d("MainActivity", "Intent Categories: ${intent?.categories}")
        Log.d("MainActivity", "Intent Data: ${intent?.data}")
        Log.d("MainActivity", "Intent Extras: ${intent?.extras}")

        // Chrome 관련 처리
        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
            Log.d("MainActivity", "Chrome 관련 Intent 감지됨, 재시작 중...")
            this.finish()
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }

        super.onCreate(savedInstanceState)

        // Intent 처리 (앱 시작 시)
        Log.d("MainActivity", "Intent 처리 시작 - onCreate에서")
        handleSharingIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel 설정
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARING_CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedData" -> {
                    Log.d("MainActivity", "getSharedData 호출됨")
                    result.success(null) // iOS용 메서드이므로 null 반환
                }
                "clearSharedData" -> {
                    Log.d("MainActivity", "clearSharedData 호출됨")
                    result.success(true) // iOS용 메서드이므로 true 반환
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "onNewIntent 호출됨")
        Log.d("MainActivity", "New Intent: ${intent}")
        Log.d("MainActivity", "New Intent Action: ${intent?.action}")
        Log.d("MainActivity", "New Intent Type: ${intent?.type}")
        Log.d("MainActivity", "New Intent Categories: ${intent?.categories}")
        Log.d("MainActivity", "New Intent Data: ${intent?.data}")
        Log.d("MainActivity", "New Intent Extras: ${intent?.extras}")

        setIntent(intent)
        // 앱이 실행 중일 때 새로운 공유 Intent 처리
        Log.d("MainActivity", "Intent 처리 시작 - onNewIntent에서")
        handleSharingIntent(intent)
    }

    private fun handleSharingIntent(intent: Intent?) {
        Log.d("MainActivity", "handleSharingIntent 시작")

        if (intent == null) {
            Log.d("MainActivity", "Intent가 null입니다")
            return
        }

        val action = intent.action
        val type = intent.type

        Log.d("MainActivity", "Intent 분석 결과:")
        Log.d("MainActivity", "  - Action: $action")
        Log.d("MainActivity", "  - Type: $type")
        Log.d("MainActivity", "  - Data: ${intent.data}")
        Log.d("MainActivity", "  - Extras Keys: ${intent.extras?.keySet()}")

        when (action) {
            Intent.ACTION_SEND -> {
                Log.d("MainActivity", "ACTION_SEND 감지됨 - 단일 공유 처리")
                handleSingleShare(intent, type)
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                Log.d("MainActivity", "ACTION_SEND_MULTIPLE 감지됨 - 다중 공유 처리")
                handleMultipleShare(intent, type)
            }
            else -> {
                Log.d("MainActivity", "지원하지 않는 Intent Action: $action")
                Log.d("MainActivity", "일반 앱 실행으로 처리됩니다")
            }
        }
    }

    private fun handleSingleShare(intent: Intent, type: String?) {
        Log.d("MainActivity", "단일 공유 처리 시작")

        when {
            type?.startsWith("text/") == true -> {
                val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
                if (!sharedText.isNullOrEmpty()) {
                    Log.d("MainActivity", "텍스트 공유됨: $sharedText")
                    sendToFlutter(mapOf<String, Any>(
                        "type" to "text",
                        "text" to sharedText
                    ))
                }
            }
            type?.startsWith("image/") == true -> {
                val imageUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (imageUri != null) {
                    Log.d("MainActivity", "이미지 공유됨: $imageUri")
                    sendToFlutter(mapOf<String, Any>(
                        "type" to "image",
                        "uri" to imageUri.toString()
                    ))
                }
            }
            type?.startsWith("video/") == true -> {
                val videoUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (videoUri != null) {
                    Log.d("MainActivity", "비디오 공유됨: $videoUri")
                    sendToFlutter(mapOf<String, Any>(
                        "type" to "video",
                        "uri" to videoUri.toString()
                    ))
                }
            }
            else -> {
                val fileUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (fileUri != null) {
                    Log.d("MainActivity", "파일 공유됨: $fileUri")
                    sendToFlutter(mapOf<String, Any>(
                        "type" to "file",
                        "uri" to fileUri.toString()
                    ))
                }
            }
        }
    }

    private fun handleMultipleShare(intent: Intent, type: String?) {
        Log.d("MainActivity", "다중 공유 처리 시작")

        val imageUris = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
        if (imageUris != null && imageUris.isNotEmpty()) {
            Log.d("MainActivity", "${imageUris.size}개 파일 공유됨")

            val uriList = imageUris.map { it.toString() }
            sendToFlutter(mapOf<String, Any>(
                "type" to "multiple",
                "uris" to uriList,
                "mimeType" to (type ?: "")
            ))
        }
    }

    private fun sendToFlutter(data: Map<String, Any>) {
        Log.d("MainActivity", "==== Flutter 데이터 전송 시작 ====")
        Log.d("MainActivity", "전송할 데이터: $data")
        Log.d("MainActivity", "MethodChannel 상태: ${if (methodChannel != null) "초기화됨" else "null"}")

        if (methodChannel == null) {
            Log.e("MainActivity", "MethodChannel이 초기화되지 않았습니다!")
            return
        }

        try {
            methodChannel?.invokeMethod("onSharedData", data)
            Log.d("MainActivity", "MethodChannel.invokeMethod 호출 완료")
        } catch (e: Exception) {
            Log.e("MainActivity", "MethodChannel 호출 중 오류 발생: ${e.message}")
            e.printStackTrace()
        }

        Log.d("MainActivity", "==== Flutter 데이터 전송 종료 ====")
    }
}
