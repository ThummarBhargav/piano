package piano.keyboard.pianomusic

import android.util.Log
import androidx.annotation.NonNull
import piano.keyboard.pianomusic.AdConstant
import piano.keyboard.pianomusic.R
import com.google.gson.annotations.SerializedName
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "samples.flutter.dev/firebase"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->
            if (call.method == "setId") {
                Log.d("TAG123", "configureFlutterEngine: ${getString(R.string.dbName)}")
                AdConstant.init(context,result,getString(R.string.dbName))
            } else {
                result.notImplemented()
            }
        }
    }
    data class AdModel(
            @SerializedName("app_id") val appId: String,
            @SerializedName("interstitial_id") val interstitialId: String,
            @SerializedName("banner_id") val bannerId: String,
            @SerializedName("native_id") val nativeId: String,
            @SerializedName("app_open_id") val appOpenId: String,
            @SerializedName("reward_id") val rewardId: String
    )
}
