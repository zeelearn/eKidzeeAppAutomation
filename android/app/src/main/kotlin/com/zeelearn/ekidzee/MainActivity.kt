package com.zeelearn.ekidzee

import com.example.literaoctave.LiteraoctavePlugin

import android.app.Activity
import android.app.ActivityManager
import android.app.PictureInPictureParams
import android.content.res.Configuration
import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Build;
import android.util.Rational;
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.unity3d.player.UnityPlayerActivity

import org.json.JSONObject
import org.json.JSONException;
import android.provider.Settings
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;
import android.content.Context;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.View
import androidx.annotation.RequiresApi
import android.os.StatFs
import android.content.pm.PackageManager
import android.os.Bundle
import com.thesparks.android_pip.PipCallbackHelper

import android.net.Uri
import java.net.URLDecoder
import java.io.UnsupportedEncodingException

import android.content.pm.*




class MainActivity : FlutterActivity() {
private var callbackHelper = PipCallbackHelper()
    private var unityIntent: Intent? = null
    //private val CHANNEL = "dev.steenbakker.ai_barcode_scanner/method"
    //private  val CHANNEL = "pip_channel"

     override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
callbackHelper.onPictureInPictureModeChanged(isInPictureInPictureMode,this)
        if (!isInPictureInPictureMode) {
            // Get the plugin and notify it
            println("Sending exit_pip event to Dart")
          LiteraoctavePlugin.instance?.notifyPiPModeChanged(false)

           val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val tasks = am.appTasks

            val isAppInBackground =
                tasks.isEmpty() || tasks[0].taskInfo.topActivity?.packageName != packageName
 println("IsApp in background - $isAppInBackground")
if (isAppInBackground) {
            // Kill Flutter and all logic: pauses everything
            android.os.Process.killProcess(android.os.Process.myPid())
        }

        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
callbackHelper.configureFlutterEngine(flutterEngine)
 

        flutterEngine.platformViewsController.registry.registerViewFactory(
            "native-webview", WebViewFactory()
        )
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openStorageSettings") {
                openStorageSettings()
                result.success(null)
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.zeelearn.literahub/literaubapp").setMethodCallHandler {
            call, result ->
            if(call.method == "showToast") {
                val rand = ('a'..'z').shuffled().take(4).joinToString("")
                var argument : String? = call.arguments()
                if(argument!=null) {
                    result.success(argument.toString())
                    openmuseplay(argument.toString())
                }else
                    result.success("Argument not found")
            }
            else {
                result.notImplemented()
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openUnityActivity") {
                    println("inside method channel")
                    val contentCode = call.argument<String>("contentCode") ?: ""
                    try {
                        openUnityActivity(contentCode)
                        result.success(null)
                    } catch (e: JSONException) {
                        e.printStackTrace()
                        result.error("JSON_ERROR", "Failed to create JSON object", null)
                    }
                } 
                else if(call.method == "enterPiP") {
                    enterPiPMode();
                    result.success(null);
                }
                else if (call.method == "checkDebug"){
                    result.success(isUsbDebuggingEnabled())
                }
                else  if (call.method == "getAvailableStorage") {
                val statFs = StatFs(filesDir.absolutePath)
                val freeSpace = statFs.availableBytes
                result.success(freeSpace)
            } 
            else if (call.method == "isAndroidTV") {
                val isTV = isAndroidTV(this)
                result.success(isTV)
            }
                else {
                    result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pip_channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "openStorageSettings") {
                    openStorageSettings()
                    result.success(null)
                }else
                if(call.method == "enterPiP") {
                    enterPiPMode();
                    result.success(null);
                }
                else {
                    //result.notImplemented()
                    enterPiPMode();
                    result.success(null);
                }
            }
    }

     private fun openStorageSettings() {
        val intent = Intent(android.provider.Settings.ACTION_INTERNAL_STORAGE_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    private class WebViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, id: Int, args: Any?): PlatformView {
            val creationParams = args as? Map<String, Any>
            val url = creationParams?.get("url") as? String ?: "https://flutter.dev"
            return NativeWebView(context, url)
        }
    }

    // Custom PlatformView that wraps a WebView
    private class NativeWebView(context: Context, url: String) : PlatformView {

        private val webView: WebView = WebView(context).apply {
            settings.javaScriptEnabled = true
            settings.domStorageEnabled = true
            settings.mediaPlaybackRequiresUserGesture = false
            settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW

            webChromeClient = object : WebChromeClient() {

                // Handle PiP in full-screen video within the WebView
                override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
                    super.onShowCustomView(view, callback)
                    // Ensure PiP is triggered when Vimeo enters full-screen
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val aspectRatio = Rational(14, 9)
                        val pipParams = PictureInPictureParams.Builder()
                            .setAspectRatio(aspectRatio)
                            .build()
                        (context as? Activity)?.enterPictureInPictureMode(pipParams)
                    }
                }

                override fun onHideCustomView() {
                    super.onHideCustomView()
                    // Exit PiP when fullscreen is dismissed (if required)
                }
            }
            webViewClient = WebViewClient()
            loadDataWithBaseURL(null, url, "text/html", "UTF-8", null)// Load the URL passed from Flutter
        }

        override fun getView(): View {
            return webView
        }

        override fun dispose() {
            webView.destroy()
        }
    }

    private fun  enterPiPMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                // Set the PiP aspect ratio (e.g., 16:9 for videos)
                val aspectRatio = Rational(16, 9) // Width, Height
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(aspectRatio)
                    .build()

                // Enter PiP mode
                enterPictureInPictureMode(params)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun isUsbDebuggingEnabled(): Boolean {
        return Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) == 1
      }

    @Throws(JSONException::class)
    private fun openUnityActivity(contentCode: String) {
        println("opening unity")
        val messageData = JSONObject().apply {
            put("contentcode", contentCode)
            put("showlogs", true)
        }

        // Convert the JSON object to a string
        val message = messageData.toString()

       unityIntent = Intent(this, UnityPlayerActivity::class.java).apply {
           putExtra("message", message)
       }
       startActivityForResult(unityIntent, UNITY_REQUEST_CODE)
    }

    private fun isAndroidTV(context: Context): Boolean {
        return context.packageManager.hasSystemFeature(PackageManager.FEATURE_LEANBACK)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == UNITY_REQUEST_CODE) {
            // Handle any necessary actions on returning from Unity, if required checking git update
        }
    }

    companion object {
        private const val CHANNEL = "unity_launcher_channel"
        private const val UNITY_REQUEST_CODE = 1
    }

    private fun openmuseplay(json: String) {
        //if(isPackageExisted("com.zeelearn.kidzeeFantasyBox")) {
        try{
            openApplication2PassingValues(json)
        } catch (e: Exception) {
            print("in 114 error in opening fantastbox");
            print(e);
            //openApplication2PassingValues(json)
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.zeelearn.kidzeeFantasyBox&hl=en_US&gl=US")))
        }
    }

    fun isPackageExisted(targetPackage: String?): Boolean {
        val packages: List<ApplicationInfo>
        val pm: PackageManager
        pm = getPackageManager()
        packages = pm.getInstalledApplications(0)
        for (packageInfo in packages) {
            System.out.print(packageInfo.packageName)
            if (packageInfo.packageName.equals(targetPackage)) return true
        }
        return false
    }

    val DEEP_LINKING_DESTINATION_ACTION = "https://www.kidzee.com/fantasybox"
    val DEEP_LINKING_DATA_TYPE = "text/plain"

    fun openApplication2PassingValues(json: String) {
        // -------------------------------------------------
        // Deep Linking - OUT-COMING
        // open/start other Activity/App
        val action: String = DEEP_LINKING_DESTINATION_ACTION
        val sendIntent =  Intent (Intent.ACTION_VIEW);
        sendIntent.setData(Uri.parse(DEEP_LINKING_DESTINATION_ACTION));
        // set flags
        sendIntent.setFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or  // make another app open in external new task (not embedded internal)
                        Intent.FLAG_ACTIVITY_CLEAR_TASK // force onCreate() in RECEIVER each time
        )
        // set data map (key / value) of parameters
        val parameter1: String = json
        sendIntent.putExtra("data", parameter1)
        // set type of data
        sendIntent.setType(DEEP_LINKING_DATA_TYPE)
        // try to open/start other Activity/App
        try {
            val intentFoo = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.kidzee.com/fantasybox?"+URLDecoder.decode(parameter1, "UTF-8")))
            //intentFoo.putExtra("data", parameter1)
            intentFoo.setPackage("com.zeelearn.kidzeeFantasyBox");
            startActivity(intentFoo)
            print(intentFoo)
            //startActivity(sendIntent)
        } catch (e: Exception) {
            print("---------------_ERROR");
            print(e.toString())
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.zeelearn.kidzeeFantasyBox&hl=en_US&gl=US")))
            // DESTINATION Application: NOT installed
            // DESTINATION Application: can NOT handle passed parameter

            // -----------------------------------
            // show corresponding info msg into AlertDialog
            /*val msg: String = e.toString();//this.getResources().getText(R.string.CanNotDestinationApplicationText).toString()
            val builder1: AlertDialog.Builder = Builder(this)
            builder1.setMessage(msg)
            builder1.setCancelable(true)
            builder1.setPositiveButton(
                    this.getText(R.string.Okword),
                    object : OnClickListener() {
                        fun onClick(dialog: DialogInterface, id: Int) {
                            dialog.cancel()
                        }
                    })
            val alert11: AlertDialog = builder1.create()
            alert11.show()*/
            // -----------------------------------
        }
        // -------------------------------------------------
    }
}