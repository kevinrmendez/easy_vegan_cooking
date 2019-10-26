package com.kevinrmendez.easy.vegan.cooking;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;


import java.io.File;
import java.io.IOException;

import android.util.DisplayMetrics;
import android.view.Display;

public class MainActivity extends FlutterActivity {
     private static final String SHARE_CHANNEL = "setWallpaper";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

          new MethodChannel(getFlutterView(), SHARE_CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals("shareFile")) {
                    shareFile((String) methodCall.arguments);
            }
                    }
                });
  }
  private void shareFile(String path){
      // DisplayMetrics metrics = new DisplayMetrics();
      // Display display = getWindowManager().getDefaultDisplay();
      // display.getMetrics(metrics);
      // final int screenWidth  = metrics.widthPixels;
      // final int screenHeight = metrics.heightPixels;

    File imgFile = new  File(this.getApplicationContext().getCacheDir(), path);
    // File imgFile = new  File( path);
 Bitmap bitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
 WallpaperManager wm = WallpaperManager.getInstance(this);

// wm.suggestDesiredDimensions(wm.getDesiredMinimumWidth(), wm.getDesiredMinimumHeight());

//  wm.suggestDesiredDimensions(screenWidth, screenHeight);

      // 3. Get the desired size.
      // final int width = wm.getDesiredMinimumWidth();
      // final int height = wm.getDesiredMinimumHeight();

//      Bitmap bitmap = getBitmap(); // getBitmap(): Get the image to be set as wallpaper.
      // Bitmap wallpaper = Bitmap.createScaledBitmap(bitmap, (int)(bitmap.getWidth()/2),(int) (bitmap.getHeight()/2), true);


    try{
              
              wm.setBitmap(bitmap);
            }catch (IOException e){
              // Log.e(TAG, "shareFile: cannot set image as wallpaper",e );
            }
  }
}
