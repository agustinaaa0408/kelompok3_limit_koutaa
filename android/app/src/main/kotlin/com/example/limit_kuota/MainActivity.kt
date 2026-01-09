package com.example.limit_kuota

import android.app.usage.NetworkStats      // PENTING: Harus ada .usage
import android.app.usage.NetworkStatsManager
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.os.Build
import android.provider.Settings
import android.app.AppOpsManager
import android.os.Process
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val CHANNEL = "limit_kuota/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getTodayUsage") {
                val usage = getTodayMobileUsage()
                result.success(usage)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getTodayMobileUsage(): Long {
        val networkStatsManager = getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)

        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()
        var totalBytes: Long = 0

        try {
            // Gunakan ConnectivityManager.TYPE_MOBILE
            val stats = networkStatsManager.querySummary(
                ConnectivityManager.TYPE_MOBILE,
                null,
                startTime,
                endTime
            )

            val bucket = NetworkStats.Bucket()
            while (stats.hasNextBucket()) {
                stats.getNextBucket(bucket)
                totalBytes += bucket.rxBytes + bucket.txBytes
            }
            stats.close()
        } catch (e: Exception) {
            return -1 // Indikasi error (mungkin izin belum diberikan)
        }
        return totalBytes
    }
}