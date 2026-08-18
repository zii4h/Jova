/// Dev note:
/// Reads the Gemini API key from a compile-time define so it never sits
/// hardcoded in source control. Run with:
///   flutter run --dart-define=GEMINI_API_KEY=your_key_here
/// or add the same --dart-define to your IDE's run configuration
/// (Android Studio: Run > Edit Configurations > Additional run args;
/// VS Code: add it to the "args" array in launch.json).
class Env {
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;
}
