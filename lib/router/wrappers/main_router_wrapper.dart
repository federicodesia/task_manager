import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/category_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

class MainRouteWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TaskRepository(authBloc: context.read<AuthBloc>())),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => SyncRepository(authBloc: context.read<AuthBloc>())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc(
            taskRepository: context.read<TaskRepository>()
          )..add(TaskLoaded())),
          
          BlocProvider(create: (context) => CategoryBloc(
            categoryRepository: context.read<CategoryRepository>(),
            taskBloc: context.read<TaskBloc>(),
          )..add(CategoryLoaded())),

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