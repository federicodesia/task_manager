import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/sync_repository.dart';

class MainRouteWrapper extends StatelessWidget {
  const MainRouteWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SyncRepository(
        base: context.read<AuthBloc>().baseRepository
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc(
            notificationsCubit: context.read<NotificationsCubit>()
          )..add(TaskLoaded())),

          BlocProvider(create: (context) => CategoryBloc(
            taskBloc: context.read<TaskBloc>()
          )..add(CategoryLoaded())),

          BlocProvider(create: (context) => SyncBloc(
            syncRepository: context.read<SyncRepository>(),
            taskBloc: context.read<TaskBloc>(),
            categoryBloc: context.read<CategoryBloc>()
          ), lazy: false),
        ],
        child: const AutoRouter(),
      ),
    );
  }
}