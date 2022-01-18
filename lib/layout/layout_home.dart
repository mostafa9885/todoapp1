
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thisapp/Components/components.dart';
import 'package:thisapp/Shared/Cuibt/cubit.dart';
import 'package:thisapp/Shared/Cuibt/states.dart';

class LayoutHome extends StatelessWidget {

  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formState = GlobalKey<FormState>();
  var TaskController = TextEditingController();
  var DateController = TextEditingController();
  var TimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(

            key: ScaffoldKey,

            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
              backgroundColor: color.mainColor,
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {

                if(cubit.isbottomSheet)
                {
                  if(formState.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: TaskController.text,
                        date: DateController.text,
                        time: TimeController.text,
                    );
                  }
                }
                else
                {
                  ScaffoldKey.currentState?.showBottomSheet((context) =>
                      Container (
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formState,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFromFieldDefualt(
                                  controller: TaskController,
                                  label: 'New Task',
                                  hintText: 'Enter New Task',
                                  prefixIcon: Icons.line_weight_outlined,
                                  keyboardType: TextInputType.text,
                                  validator: (value)
                                  {
                                    if(value!.isEmpty){return 'New Task Field not be Empty!';}
                                  }
                              ),
                              const SizedBox(height: 15),
                              TextFromFieldDefualt(
                                controller: DateController,
                                label: 'Date Task',
                                hintText: 'Enter Date Task',
                                prefixIcon: Icons.today_outlined,
                                keyboardType: TextInputType.datetime,
                                validator: (value)
                                {
                                  if(value!.isEmpty){return 'Date Task Field not be Empty!';}
                                },
                                onTap: ()
                                {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1998),
                                    lastDate: DateTime(2500),
                                  ).then((value)
                                  {
                                    DateController.text = DateFormat.yMMMEd().format(value!);
                                  }
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFromFieldDefualt(
                                controller: TimeController,
                                label: 'Time Task',
                                hintText: 'Enter Time Task',
                                prefixIcon: Icons.watch_later_outlined,
                                keyboardType: TextInputType.datetime,
                                validator: (value)
                                {
                                  if(value!.isEmpty){return 'Time Task Field not be Empty!';}
                                },
                                onTap: ()
                                {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value)
                                  {
                                    TimeController.text = value!.format(context).toString();
                                  }
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ).closed.then((value){
                    cubit.ChangeBottomSheet(
                        isShow: false,
                        icon: const Icon(Icons.edit)
                    );
                  });
                  cubit.ChangeBottomSheet(
                      isShow: true,
                      icon: const Icon(Icons.add),
                  );
                }
              },
              child: cubit.iconfab,
              backgroundColor: color.mainColor,
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndexforBottomNavigationBar(index);
              },
              backgroundColor: color.primeColor.withOpacity(0.32),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.text_snippet_outlined), label: 'New Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check), label: 'Done Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive Task'),
              ],
            ),

            body: ConditionalBuilder(
              condition: true,
              builder: (context) =>  cubit.screens[cubit.currentIndex],
              fallback: (context) =>  const Center(child: CircularProgressIndicator()),
            ),

          );
        },
      ),
    );
  }
}
