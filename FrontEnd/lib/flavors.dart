enum Flavor {
  prod,
  stg,
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Dbnus';
      case Flavor.stg:
        return 'Stg Dbnus';
      case Flavor.dev:
        return 'Dev Dbnus';
      default:
        return 'title';
    }
  }

}
