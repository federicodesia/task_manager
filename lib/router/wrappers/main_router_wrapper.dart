import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

class MainRouteWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TaskRepository(base: context.read<BaseRepository>())),
        RepositoryProvider(create: (context) => SyncRepository(base: context.read<BaseRepository>())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc()),
          BlocProvider(create: (context) => CategoryBloc(taskBloc: context.read<TaskBloc>())),

          BlocProvider(create: (context) => SyncBloc(
            syncRepository: context.read<SyncRepository>(),
            taskBloc: context.read<TaskBloc>(),
            categoryBloc: context.read<CategoryBloc>()
          ), lazy: false),
        ],
        child: AutoRouter(),
      ),
    );
  }
}