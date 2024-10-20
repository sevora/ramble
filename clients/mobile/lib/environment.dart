abstract class Environment {
  static const String serverURL = String.fromEnvironment(
      "SERVER_URL",

      // This default value assumes that the server is on the local machine on port 8000.
      // It also assumes that this client is on an emulator hence the 10.0.2.2 IP address.
      defaultValue: "10.0.2.2:8000"
  );
}