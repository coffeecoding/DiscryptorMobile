import 'package:discryptor/repos/repos.dart';
import 'package:discryptor/services/services.dart';
import 'package:get_it/get_it.dart';

/// Global [GetIt.instance]
final GetIt locator = GetIt.instance;

/// Set up [GetIt] locator
Future<void> setUpLocator() async {
  locator
    ..registerSingleton<PreferenceRepo>(PreferenceRepo())
    ..registerSingleton<NetworkService>(NetworkService())
    ..registerSingleton<AuthRepo>(AuthRepo())
    ..registerSingleton<ApiRepo>(ApiRepo())
    ..registerSingleton<CryptoService>(CryptoService())
    ..registerSingleton<DiscryptorBL>(DiscryptorBL());
}
