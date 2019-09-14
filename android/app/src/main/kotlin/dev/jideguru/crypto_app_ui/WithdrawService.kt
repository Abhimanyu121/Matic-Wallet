package dev.jideguru.crypto_app_ui

import android.annotation.TargetApi
import android.app.IntentService
import android.app.Notification
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.widget.Toast
import java.security.PrivateKey

class WithdrawService : IntentService("WithdrawSerivice"){
  @TargetApi(26)
    override fun onCreate(){
        super.onCreate()
        val pendingIntent: PendingIntent =
                Intent(this, WithdrawService::class.java).let { notificationIntent ->
                    PendingIntent.getActivity(this, 0, notificationIntent, 0)
                }

        val notification: Notification = Notification.Builder(this, "abc")
                .setContentTitle("withdrawing")
                .setContentText("withdrwaing")
                .setSmallIcon(R.drawable.ic_launcher_background)
                .setContentIntent(pendingIntent)
                .setTicker("abc")
                .build()

        startForeground(1, notification)
    }
    override fun onHandleIntent(intent: Intent?) {
        var privateKey:String? = intent!!.getStringExtra("privateKey")
        try {
            val res= 1
            Thread.sleep(500000)
            Toast.makeText(this, "abc", Toast.LENGTH_LONG).show()
        } catch (e: InterruptedException) {
            // Restore interrupt status.
            Thread.currentThread().interrupt()
        }

    }

}