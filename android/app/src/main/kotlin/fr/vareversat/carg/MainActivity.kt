package fr.vareversat.carg;

import fr.vareversat.carg.R
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {
    private val CHANNEL = "fr.vareversat.carg/version"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            if (call.method == "getFlavor") {
                val flavor = getFlavor()

                if (flavor != null) {
                    result.success(flavor)
                } else {
                    result.error("UNAVAILABLE", "Flavor is null.", null)
                }
            } else {
                result.notImplemented()
            }

        }
    }

    private fun getFlavor(): String {
        return getString(R.string.flavor)
    }
}
