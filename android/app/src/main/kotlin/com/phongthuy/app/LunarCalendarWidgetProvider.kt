package com.phongthuy.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.util.Calendar
import java.util.Locale

class LunarCalendarWidgetProvider : AppWidgetProvider() {

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
        fun updateAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, LunarCalendarWidgetProvider::class.java)
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
            val views = RemoteViews(context.packageName, R.layout.widget_lunar_calendar)

            // Calculate Solar and Lunar Date
            val cal = Calendar.getInstance()
            val day = cal.get(Calendar.DAY_OF_MONTH)
            val month = cal.get(Calendar.MONTH) + 1
            val year = cal.get(Calendar.YEAR)
            val dayOfWeek = cal.get(Calendar.DAY_OF_WEEK)

            val daysOfWeekVi = arrayOf(
                "", "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"
            )
            val dowStr = if (dayOfWeek in 1..7) daysOfWeekVi[dayOfWeek] else ""

            val solarDateText = String.format(
                Locale.getDefault(),
                "%s, %02d/%02d/%d",
                dowStr, day, month, year
            )
            views.setTextViewText(R.id.tv_solar_date, solarDateText)

            // Convert to Lunar
            val lunar = convertSolar2Lunar(day, month, year)
            val lDay = lunar[0]
            val lMonth = lunar[1]
            val lYear = lunar[2]
            val isLeap = lunar[3] == 1

            views.setTextViewText(R.id.tv_lunar_day, lDay.toString())
            views.setTextViewText(
                R.id.tv_lunar_month,
                "Tháng $lMonth" + if (isLeap) " (N)" else ""
            )

            // Can Chi
            val jd = jdFromDate(day, month, year)
            val canChiDay = getCanChiDay(jd)
            val canChiMonth = getCanChiMonth(lMonth, lYear)
            val canChiYear = getCanChiYear(lYear)

            views.setTextViewText(
                R.id.tv_can_chi_day,
                "Ngày $canChiDay · Tháng $canChiMonth"
            )
            views.setTextViewText(
                R.id.tv_can_chi_year,
                "Năm $canChiYear"
            )

            // Hoàng Đạo check
            val dayChiIndex = (jd + 1) % 12
            val hoangDaoStars = arrayOf(
                "Thanh Long (HĐ)", "Minh Đường (HĐ)", "Thiên Hình (HĐ)",
                "Chu Tước (HĐ)", "Kim Quỹ (HĐ)", "Kim Đường (HĐ)",
                "Bạch Hổ (HĐ)", "Ngọc Đường (HĐ)", "Thiên Lao (HĐ)",
                "Nguyên Vũ (HĐ)", "Tư Mệnh (HĐ)", "Câu Trận (HĐ)"
            )
            val monthChi = (lMonth + 1) % 12
            val isHoangDaoDay = isHoangDao(monthChi, dayChiIndex)
            views.setTextViewText(
                R.id.tv_hoang_dao_tag,
                if (isHoangDaoDay) "Hoàng Đạo" else "Hắc Đạo"
            )

            // Giờ Hoàng Đạo
            val hdHours = getHoangDaoHours(dayChiIndex)
            views.setTextViewText(
                R.id.tv_hoang_dao_hours,
                "Giờ HĐ: $hdHours"
            )

            // Click Intent to open app
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_lunar_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        // --- Core Lunar Algorithms (Astronomical Hồ Ngọc Đức / Meeus) ---
        private const val TIME_ZONE = 7.0
        private const val NEW_MOON_CYCLE = 29.530588853
        private const val JULIUS_DAYS_IN_1900 = 2415021

        private val CAN_LIST = arrayOf("Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý")
        private val CHI_LIST = arrayOf("Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi")

        private fun jdFromDate(d: Int, m: Int, y: Int): Int {
            var a = (14 - m) / 12
            var yy = y + 4800 - a
            var mm = m + 12 * a - 3
            var jd = d + (153 * mm + 2) / 5 + 365 * yy + yy / 4 - yy / 100 + yy / 400 - 32045
            if (jd < 2299161) {
                jd = d + (153 * mm + 2) / 5 + 365 * yy + yy / 4 - 32083
            }
            return jd
        }

        private fun getCanChiDay(jd: Int): String {
            val can = CAN_LIST[(jd + 9) % 10]
            val chi = CHI_LIST[(jd + 1) % 12]
            return "$can $chi"
        }

        private fun getCanChiYear(year: Int): String {
            val can = CAN_LIST[(year + 6) % 10]
            val chi = CHI_LIST[(year + 8) % 12]
            return "$can $chi"
        }

        private fun getCanChiMonth(month: Int, year: Int): String {
            val yearCanIndex = (year + 6) % 10
            val startCan = (yearCanIndex * 2 + 1) % 10
            val monthCan = CAN_LIST[(startCan + month - 1) % 10]
            val monthChi = CHI_LIST[(month + 1) % 12]
            return "$monthCan $monthChi"
        }

        private fun isHoangDao(monthChi: Int, dayChi: Int): Boolean {
            val offset = (dayChi - monthChi + 12) % 12
            val hoangDaoOffsets = setOf(0, 1, 4, 5, 7, 10)
            return hoangDaoOffsets.contains(offset)
        }

        private fun getHoangDaoHours(dayChi: Int): String {
            val start = when (dayChi) {
                2, 8 -> 0
                3, 9 -> 2
                4, 10 -> 4
                5, 11 -> 6
                0, 6 -> 8
                else -> 10
            }
            val hoangDaoOffsets = setOf(0, 1, 4, 5, 7, 10)
            val names = mutableListOf<String>()
            for (h in 0 until 12) {
                val offset = (h - start + 12) % 12
                if (hoangDaoOffsets.contains(offset)) {
                    names.add(CHI_LIST[h])
                }
            }
            return names.joinToString(", ")
        }

        private fun convertSolar2Lunar(dd: Int, mm: Int, yy: Int): IntArray {
            val dayNumber = jdFromDate(dd, mm, yy)
            val k = Math.floor((dayNumber - JULIUS_DAYS_IN_1900) / NEW_MOON_CYCLE).toInt()
            var monthStart = getNewMoonDay(k + 1)
            if (monthStart > dayNumber) {
                monthStart = getNewMoonDay(k)
            }
            var a11 = getLunarMonth11(yy)
            val b11 = a11
            var lunarYear: Int
            if (a11 >= monthStart) {
                lunarYear = yy
                a11 = getLunarMonth11(yy - 1)
            } else {
                lunarYear = yy + 1
                getLunarMonth11(yy + 1)
            }
            val lunarDay = dayNumber - monthStart + 1
            val diff = (monthStart - a11) / 29
            var lunarLeap = 0
            var lunarMonth = diff + 11
            if (b11 - a11 > 365) {
                val leapMonthDiff = getLeapMonthOffset(a11)
                if (diff >= leapMonthDiff) {
                    lunarMonth = diff + 10
                    if (diff == leapMonthDiff) {
                        lunarLeap = 1
                    }
                }
            }
            if (lunarMonth > 12) {
                lunarMonth -= 12
            }
            if (lunarMonth >= 11 && diff < 4) {
                lunarYear -= 1
            }
            return intArrayOf(lunarDay, lunarMonth, lunarYear, lunarLeap)
        }

        private fun getNewMoonDay(k: Int): Int {
            val t = k / 1236.85
            val t2 = t * t
            val t3 = t2 * t
            val dr = Math.PI / 180.0
            var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3
            jd1 += 0.00033 * Math.sin((166.56 + 132.87 * t - 0.009173 * t2) * dr)
            val m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3
            val mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3
            val f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3
            var c1 = (0.1734 - 0.000393 * t) * Math.sin(m * dr) + 0.0021 * Math.sin(2 * dr * m)
            c1 = c1 - 0.4068 * Math.sin(mpr * dr) + 0.0161 * Math.sin(dr * 2 * mpr)
            c1 = c1 - 0.0004 * Math.sin(dr * 3 * mpr)
            c1 = c1 + 0.0104 * Math.sin(dr * 2 * f) - 0.0051 * Math.sin(dr * (m + mpr))
            c1 = c1 - 0.0074 * Math.sin(dr * (m - mpr)) + 0.0004 * Math.sin(dr * (2 * f + m))
            c1 = c1 - 0.0004 * Math.sin(dr * (2 * f - m)) - 0.0006 * Math.sin(dr * (2 * f + mpr))
            c1 = c1 + 0.0010 * Math.sin(dr * (2 * f - mpr)) + 0.0005 * Math.sin(dr * (2 * mpr + m))
            val delta = if (t < -11) {
                0.001 + 0.000839 * t + 0.0002261 * t2 - 0.00000845 * t3 - 0.000000081 * t * t3
            } else {
                -0.000278 + 0.000265 * t + 0.000262 * t2
            }
            val jd = jd1 + c1 - delta
            return Math.floor(jd + 0.5 + TIME_ZONE / 24.0).toInt()
        }

        private fun sunLongitude(jdn: Double): Double {
            val t = (jdn - 2451545.0) / 36525.0
            val t2 = t * t
            val dr = Math.PI / 180.0
            val m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2
            val l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2
            val dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * Math.sin(dr * m) +
                    (0.019993 - 0.000101 * t) * Math.sin(dr * 2 * m) +
                    0.000290 * Math.sin(dr * 3 * m)
            var l = (l0 + dl) * dr
            l -= Math.PI * 2 * Math.floor(l / (Math.PI * 2))
            return l
        }

        private fun getSunLongitude(dayNumber: Int): Int {
            return Math.floor(sunLongitude(dayNumber - 0.5 - TIME_ZONE / 24.0) / Math.PI * 6).toInt()
        }

        private fun getLunarMonth11(yy: Int): Int {
            val off = jdFromDate(31, 12, yy) - JULIUS_DAYS_IN_1900.toDouble()
            val k = Math.floor(off / NEW_MOON_CYCLE).toInt()
            var nm = getNewMoonDay(k)
            val sunLong = getSunLongitude(nm)
            if (sunLong >= 9) {
                nm = getNewMoonDay(k - 1)
            }
            return nm
        }

        private fun getLeapMonthOffset(a11: Int): Int {
            val k = Math.floor((a11 - JULIUS_DAYS_IN_1900) / NEW_MOON_CYCLE + 0.5).toInt()
            var last = 0
            var i = 1
            var arc = getSunLongitude(getNewMoonDay(k + i))
            do {
                last = arc
                i++
                arc = getSunLongitude(getNewMoonDay(k + i))
            } while (arc != last && i < 14)
            return i - 1
        }
    }
}
