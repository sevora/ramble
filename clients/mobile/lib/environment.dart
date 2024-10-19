abstract class Environment {
  static const String serverURL = String.fromEnvironment(
      "SERVER_URL",
      defaultValue: "10.0.2.2:8000"
  );
}