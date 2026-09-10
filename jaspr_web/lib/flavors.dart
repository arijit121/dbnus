enum Flavor {
  prod,
  stg,
  dev,
}

class F {
  static const env = String.fromEnvironment(
    'ENV',
    defaultValue: 'prod',
  );

  static Flavor get appFlavor => env == 'dev'
      ? Flavor.dev
      : env == 'stg'
      ? Flavor.stg
      : Flavor.prod;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Dbnus';
      case Flavor.stg:
        return 'Stg Dbnus';
      case Flavor.dev:
        return 'Dev Dbnus';
    }
  }
}
