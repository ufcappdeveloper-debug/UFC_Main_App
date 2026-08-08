package sa.com.ufc.mobile  // ✅ Must be the first line

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.ufc.pip"
    private var isCallActive = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "updateCallState" -> {
                    isCallActive = call.arguments as Boolean
                    result.success(null)
                }
                "enterPiPIfCallActive" -> {
                    if (isCallActive && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val aspectRatio = Rational(9, 16)
                        val pipBuilder = PictureInPictureParams.Builder()
                        pipBuilder.setAspectRatio(aspectRatio)
                        enterPictureInPictureMode(pipBuilder.build())
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (isCallActive && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val aspectRatio = Rational(9, 16)
            val pipBuilder = PictureInPictureParams.Builder()
            pipBuilder.setAspectRatio(aspectRatio)
            enterPictureInPictureMode(pipBuilder.build())
        }
    }
}
