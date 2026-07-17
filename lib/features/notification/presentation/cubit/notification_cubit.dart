// features/notifications/presentation/cubit/notification_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRemoteDataSource _dataSource;
  final AuthCubit _authCubit;

  NotificationCubit(this._dataSource, this._authCubit)
      : super(const NotificationState.initial());

  Future<void> load() async {
    final auth = _authCubit.state;
    if (auth is! AuthAuthenticated) {
      emit(const NotificationState.loaded([]));
      return;
    }
    emit(const NotificationState.loading());
    try {
      final items = await _dataSource.getNotifications(auth.user.id);
      emit(NotificationState.loaded(items));
    } catch (e) {
      emit(NotificationState.error(e.toString()));
    }
  }

  Future<void> markRead(String id) async {
    final auth = _authCubit.state;
    if (auth is! AuthAuthenticated) return;
    await _dataSource.markAsRead(auth.user.id, id);
    await load();
  }
}