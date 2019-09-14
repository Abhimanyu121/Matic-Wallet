package dev.jideguru.crypto_app_ui

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.renderscript.Sampler

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.PrivateKey

class MainActivity: FlutterActivity() {
  private val CHANNEL = "WithdrawFunds"
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      // Create the NotificationChannel
      val name = "Withdraw"
      val descriptionText = "Funds being withdrawn"
      val importance = NotificationManager.IMPORTANCE_DEFAULT
      val mChannel = NotificationChannel("abc", name, importance)
      mChannel.description = descriptionText
      // Register the channel with the system; you can't change the importance
      // or other notification behaviors after this
      val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(mChannel)
    }
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      var privateKey:String? = call.argument("privateKey")
      var value:Int? = call.argument("value")
      result.success(withdrawcall(privateKey!!, value!!))


     //startService(privateKey!!, value!!)
    }
  }
    fun startService(privateKey:String,value:Int){
      Intent(this, WithdrawService::class.java).also { intent ->
        intent.putExtra("privateKey", privateKey)
        intent.putExtra("value", value)
        startService(intent)
    }
  }
  fun withdrawcall(privateKey: String,value:Int): String{
    val wrapper:EthWrapper = EthWrapper(privateKey,value)
    var hash = wrapper.startWithdraw(value)
    return hash
  }
}
