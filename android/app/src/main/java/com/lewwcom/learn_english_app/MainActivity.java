package com.lewwcom.learn_english_app;

import android.content.Intent;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String processText;
  private static final String CHANNEL = "app.channel.process.text";

  @Override
  protected void onResume() {
    super.onResume();
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();
    if (Intent.ACTION_PROCESS_TEXT.equals(action)) {
      handleSendText(intent);
    }
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
              if (call.method.contentEquals("getProcessText")) {
                result.success(processText);
                processText = null;
              }
            });
  }

  private void handleSendText(Intent intent) {
    processText = intent.getStringExtra(Intent.EXTRA_PROCESS_TEXT);
  }
}
