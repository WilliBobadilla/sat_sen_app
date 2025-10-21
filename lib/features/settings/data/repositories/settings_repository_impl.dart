import '../datasource/settings_remote_source.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository{

final SettingsRemoteSource remoteSource;

SettingsRepositoryImpl({required this.remoteSource});


}