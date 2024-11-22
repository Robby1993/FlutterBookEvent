import 'package:bookmyevent/bloc/authCubit/auth_cubit.dart';
import 'package:bookmyevent/bloc/navbar_cubit.dart';
import 'package:bookmyevent/repo/auth_repository.dart';
import 'package:get_it/get_it.dart';

import 'services/dio_helper.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  /// Navbar Cubit
  locator.registerFactory(
    () => NavbarCubit(),
  );

  locator.registerFactory(
    () => AuthCubit(AuthRepository(DioHelper())),
  );


}
