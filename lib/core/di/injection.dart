import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:statefulclickcounter/core/network/dio_client.dart';
import 'package:statefulclickcounter/core/storage/app_prefs.dart';
import 'package:statefulclickcounter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:statefulclickcounter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:statefulclickcounter/features/auth/domain/repositories/auth_repository.dart';
import 'package:statefulclickcounter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:statefulclickcounter/features/customer/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/favorites/domain/repositories/favorites_repository.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/datasources/agencies_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/datasources/bailleur_apply_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/repositories/agencies_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/data/repositories/bailleur_apply_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/domain/repositories/agencies_repository.dart';
import 'package:statefulclickcounter/features/customer/bailleur_apply/domain/repositories/bailleur_apply_repository.dart';
import 'package:statefulclickcounter/features/customer/home/data/datasources/property_visits_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/profile/data/datasources/tickets_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/hotels/data/datasources/reservation_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/hotels/data/repositories/reservation_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/hotels/domain/repositories/reservation_repository.dart';
import 'package:statefulclickcounter/features/customer/kyc/data/datasources/tenant_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/kyc/data/repositories/tenant_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/kyc/domain/repositories/tenant_repository.dart';
import 'package:statefulclickcounter/features/customer/properties/data/datasources/properties_remote_data_source.dart';
import 'package:statefulclickcounter/features/customer/properties/data/repositories/properties_repository_impl.dart';
import 'package:statefulclickcounter/features/customer/properties/domain/repositories/properties_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Dio>(
    () => DioClient.build(
      onUnauthorized: () async {
        await AppPrefs.clearTokens();
        getIt<AuthBloc>().add(const AuthSignedOut());
      },
    ),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<PropertiesRemoteDataSource>(
    () => PropertiesRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<PropertiesRepository>(
    () => PropertiesRepositoryImpl(getIt<PropertiesRemoteDataSource>()),
  );

  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(getIt<FavoritesRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<TenantRemoteDataSource>(
    () => TenantRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<TenantRepository>(
    () => TenantRepositoryImpl(getIt<TenantRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AgenciesRemoteDataSource>(
    () => AgenciesRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AgenciesRepository>(
    () => AgenciesRepositoryImpl(getIt<AgenciesRemoteDataSource>()),
  );

  getIt.registerLazySingleton<BailleurApplyRemoteDataSource>(
    () => BailleurApplyRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<BailleurApplyRepository>(
    () => BailleurApplyRepositoryImpl(getIt<BailleurApplyRemoteDataSource>()),
  );

  getIt.registerLazySingleton<ReservationRemoteDataSource>(
    () => ReservationRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<PropertyVisitsRemoteDataSource>(
    () => PropertyVisitsRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ReservationRepository>(
    () => ReservationRepositoryImpl(getIt<ReservationRemoteDataSource>()),
  );

  getIt.registerLazySingleton<TicketsRemoteDataSource>(
    () => TicketsRemoteDataSource(getIt<Dio>()),
  );
}
