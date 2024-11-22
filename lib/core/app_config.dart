enum Flavor { prod, dev }

class AppConfig {
  String appName = "";
  String baseUrl = "";
  String oneSignalId = "";
  String stripeSecret = "";
  Flavor flavor = Flavor.dev;
  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appName = "",
    String baseUrl = "",
    String oneSignalId = "",
    String stripeSecret = "",
    Flavor flavor = Flavor.dev,
  }) {
    return shared = AppConfig(
      appName,
      baseUrl,
      oneSignalId,
      stripeSecret,
      flavor,
    );
  }

  AppConfig(
    this.appName,
    this.baseUrl,
    this.oneSignalId,
    this.stripeSecret,
    this.flavor,
  );
}
