import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/category_repository.dart';
import 'package:task_manager/repositories/task_repository.dart';

class MainRouteWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => TaskRepository(authBloc: context.read<AuthBloc>())),
        RepositoryProvider(create: (context) => CategoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc(taskRepository: context.read<TaskRepository>())..add(TaskLoaded())),
        ],
        child: AutoRouter(),
      ),
    );
  }
}