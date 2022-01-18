

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thisapp/Components/components.dart';
import 'package:thisapp/Shared/Cuibt/cubit.dart';
import 'package:thisapp/Shared/Cuibt/states.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state)
        {
          var tasks = AppCubit.get(context).archiveTask;
          return ConditionalItemBuilder(
              task: tasks,
              hint: 'No Archive Task yet!',
              src: 'assets/image/archive.png'
          );
        }
    );
  }
}
