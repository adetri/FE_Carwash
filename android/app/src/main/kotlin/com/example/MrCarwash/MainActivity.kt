package com.example.MrCarwash

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/mediaScanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "scanFile") {
                    val filePath = call.argument<String>("filePath")
                    scanFile(filePath)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun scanFile(filePath: String?) {
        // Implement your logic to trigger media scanner here
    }
}
