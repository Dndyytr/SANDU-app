-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
# Flutter Play Core (FIX R8 missing class)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
