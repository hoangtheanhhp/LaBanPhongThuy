package com.phongthuy.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import kotlin.concurrent.thread

class XSMBWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "xsmb_widget_prefs"
        private const val KEY_DATE = "last_date"
        private const val KEY_SPECIAL = "last_special"
        private const val KEY_PRIZE1 = "last_prize1"

        fun updateAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, XSMBWidgetProvider::class.java)
            val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (widgetId in allWidgetIds) {
                updateAppWidget(context, appWidgetManager, widgetId)
            }
        }

        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val cachedDate = prefs.getString(KEY_DATE, "06/10/2026") ?: "06/10/2026"
            val cachedSpecial = prefs.getString(KEY_SPECIAL, "12554") ?: "12554"
            val cachedPrize1 = prefs.getString(KEY_PRIZE1, "26733") ?: "26733"

            renderWidget(context, appWidgetManager, appWidgetId, cachedDate, cachedSpecial, cachedPrize1)

            // Asynchronously fetch latest data
            thread {
                try {
                    val url = URL("https://api.allorigins.win/raw?url=https%3A%2F%2Fwww.minhngoc.net.vn%2Fgetkqxs%2Fmien-bac.js")
                    val conn = (url.openConnection() as HttpURLConnection).apply {
                        connectTimeout = 6000
                        readTimeout = 6000
                        setRequestProperty("User-Agent", "Mozilla/5.0")
                    }
                    if (conn.responseCode == 200) {
                        val html = conn.inputStream.bufferedReader().use { it.readText() }

                        // Extract Date
                        val dateRegex = "Ng&agrave;y:\\s*([0-9/]+)".toRegex()
                        val dateMatch = dateRegex.find(html)
                        val fetchedDate = dateMatch?.groupValues?.get(1) ?: cachedDate

                        // Extract Special Prize
                        val dbRegex = "class=\"giaidb\"[^>]*>\\s*([^<]+)\\s*</td>".toRegex()
                        val dbMatch = dbRegex.find(html)
                        val fetchedSpecial = dbMatch?.groupValues?.get(1)?.trim() ?: cachedSpecial

                        // Extract Prize 1
                        val p1Regex = "class=\"giai1\"[^>]*>\\s*([^<]+)\\s*</td>".toRegex()
                        val p1Match = p1Regex.find(html)
                        val fetchedPrize1 = p1Match?.groupValues?.get(1)?.trim() ?: cachedPrize1

                        if (fetchedSpecial.isNotEmpty()) {
                            prefs.edit().apply {
                                putString(KEY_DATE, fetchedDate)
                                putString(KEY_SPECIAL, fetchedSpecial)
                                putString(KEY_PRIZE1, fetchedPrize1)
                                apply()
                            }
                            renderWidget(context, appWidgetManager, appWidgetId, fetchedDate, fetchedSpecial, fetchedPrize1)
                        }
                    }
                } catch (e: Exception) {
                    // Ignored: fallback to cached UI
                }
            }
        }

        private fun renderWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            date: String,
            special: String,
            prize1: String
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_xsmb)
            views.setTextViewText(R.id.tv_xsmb_date, date)
            views.setTextViewText(R.id.tv_xsmb_special, special)
            val tail = if (special.length >= 2) special.takeLast(2) else "--"
            views.setTextViewText(R.id.tv_xsmb_special_tail, "2 số cuối: $tail")
            views.setTextViewText(R.id.tv_xsmb_prize1, prize1)

            // Click Intent to open app directly to XSMB screen
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("initial_tab", "xsmb")
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 1, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_xsmb_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
