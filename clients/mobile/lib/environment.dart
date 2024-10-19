abstract class Environment {
  static const String serverURL = String.fromEnvironment(
      "SERVER_URL",
      defaultValue: "localhost:8000"
  );
}