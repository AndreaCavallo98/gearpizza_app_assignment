import 'package:gearpizza/core/network/gearpizza_directus_api_service.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<GearPizzaDirectusApiService>(
    () => GearPizzaDirectusApiService(),
  );
}
