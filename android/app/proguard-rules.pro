# Razorpay SDK keep rules
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }

# Google Pay integration (used by Razorpay internally)
-dontwarn com.google.android.apps.nbu.paisa.**
-keep class com.google.android.apps.nbu.paisa.** { *; }

# Ignore proguard.annotation warnings
-dontwarn proguard.annotation.**
