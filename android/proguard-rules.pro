# Preserve line numbers for readable crash reports and R8 mapping.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses,EnclosingMethod

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Unity / Vuforia
-keep class com.unity3d.** { *; }
-dontwarn com.unity3d.**

# Firebase / Google Play services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# Keep classes used by reflection
-keepclassmembers class * {
    public <init>(...);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class j$.util.DoubleSummaryStatistics
-keepclassmembers class j$.util.LongSummaryStatistics
-keepclassmembers class j$.util.IntSummaryStatistics
-keepclassmembers class j$.util.concurrent.ConcurrentHashMap$CounterCell
-keepclassmembers class j$.util.concurrent.ConcurrentHashMap
-keepclassmembers class j$.util.concurrent.ConcurrentHashMap$TreeBin
