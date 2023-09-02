import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/home/cubit/cubit.dart';
import 'package:simple_todo_app/home/cubit/states.dart';
import 'package:simple_todo_app/home/model/text_form_field_model.dart';
import 'package:simple_todo_app/home/ui/components/bottom_sheet.dart';
import 'package:simple_todo_app/home/ui/components/page_component.dart';
import 'package:simple_todo_app/resources/enums.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeCubitStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, HomeCubitStates state) {
          HomeCubit homeCubit = HomeCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              toolbarHeight: 60,
              title: Text(
                "${Status.values[homeCubit.navBarIndex].name} Tasks",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            body: PageComponent(
              tasks: homeCubit
                      .tasksMap[Status.values[homeCubit.navBarIndex].name] ??
                  [],
              empty: state is EmptyTasksState,
              loading: state is LoadingTasksState,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                homeCubit.bottomSheetButton(
                  context,
                  bottomSheetWidget: CustomBottomSheet(
                    task: TextFormFieldModel(
                      controller: homeCubit.titleController,
                      title: 'Task Title',
                      onTap: () {},
                      icon: Icons.title,
                    ),
                    time: TextFormFieldModel(
                      controller: homeCubit.timeController,
                      title: 'Task Time',
                      onTap: () {
                        homeCubit.timePickerFunction();
                      },
                      icon: Icons.access_time_outlined,
                    ),
                    date: TextFormFieldModel(
                      controller: homeCubit.dateController,
                      title: 'Task Date',
                      onTap: () {
                        homeCubit.datePickerFunction();
                      },
                      icon: Icons.calendar_today,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
              child: Icon(
                homeCubit.edit ? Icons.edit : Icons.add,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived"),
              ],
              currentIndex: homeCubit.navBarIndex,
              onTap: (index) {
                homeCubit.updateNavBarIndex(index);
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
