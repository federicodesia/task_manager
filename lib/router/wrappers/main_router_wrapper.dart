import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/hydrated_helper.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';

class MainRouteWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SyncRepository(base: context.read<BaseRepository>()),
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
        child: LifecycleEventHandler(
          child: AutoRouter(),

          appLifecycleStateChanged: (state, context) async{
            if(state == AppLifecycleState.resumed){
              final hydratedHelper = HydratedHelper();
              
              context.read<SyncBloc>().add(SyncReloadStateRequested(json: await hydratedHelper.readJsonState("SyncBloc")));
              context.read<CategoryBloc>().add(CategoryReloadStateRequested(json: await hydratedHelper.readJsonState("CategoryBloc")));
              context.read<TaskBloc>().add(TaskReloadStateRequested(json: await hydratedHelper.readJsonState("TaskBloc")));
            }
          }
        ),
      ),
    );
  }
}

class LifecycleEventHandler extends StatefulWidget{
  final Widget child;
  final Function(AppLifecycleState, BuildContext) appLifecycleStateChanged;

  LifecycleEventHandler({
    required this.child,
    required this.appLifecycleStateChanged
  });

  @override
  State<LifecycleEventHandler> createState() => _LifecycleEventHandlerState();
}

class _LifecycleEventHandlerState extends State<LifecycleEventHandler> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => widget.appLifecycleStateChanged(state, context);

  @override
  Widget build(BuildContext context) => widget.child;
}