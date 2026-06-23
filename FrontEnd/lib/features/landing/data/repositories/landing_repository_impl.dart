import 'package:dbnus/features/landing/domain/entities/landing_banner.dart';
import 'package:dbnus/features/landing/domain/repositories/landing_repository.dart';

import '../datasources/landing_data_source.dart';

class LandingRepositoryImpl implements LandingRepository {
  final LandingDataSource dataSource;

  LandingRepositoryImpl({required this.dataSource});

  @override
  Future<LandingBanner?> getSplashBanner() async {
    return await dataSource.getSplashBanner();
  }
}
