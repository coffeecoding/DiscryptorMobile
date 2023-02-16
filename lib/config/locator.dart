import 'package:discryptor/repos/preference_repo.dart';
import 'package:discryptor/services/crypto_service.dart';
import 'package:get_it/get_it.dart';

/// Global [GetIt.instance]
final GetIt locator = GetIt.instance;

/// Set up [GetIt] locator
Future<void> setUpLocator() async {
  locator
    ..registerSingleton<PreferenceRepo>(PreferenceRepo())
    ..registerSingleton<CryptoService>(CryptoService());
}
