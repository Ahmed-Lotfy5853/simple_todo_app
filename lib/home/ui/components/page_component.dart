import 'package:flutter/material.dart';
import 'package:simple_todo_app/home/cubit/cubit.dart';
import 'package:simple_todo_app/home/model/task_model.dart';

import '../../../resources/enums.dart';

class PageComponent extends StatelessWidget {
  const PageComponent({
    super.key,
    required this.tasks,
    required this.empty,
    required this.loading,
  });

  final List<TaskModel> tasks;
  final bool empty;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (empty) {
      return const Center(
        child: Text("There are not tasks"),
      );
    } else if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              TaskModel task = tasks[index];
              return Dismissible(
                key: Key('${task.id}'),
                onDismissed: (direction) async {
                  await HomeCubit.get(context)
                      .deleteRecordFromDatabase(id: task.id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Text(
                        task.taskTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.taskContent,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          task.taskDate,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () async {
                          await HomeCubit.get(context).updateRecordInDatabase(
                              id: task.id, status: Status.done.name);
                        },
                        child: const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )),
                    InkWell(
                        onTap: () async {
                          await HomeCubit.get(context).updateRecordInDatabase(
                              id: task.id, status: Status.archived.name);
                        },
                        child: const Icon(
                          Icons.archive,
                          color: Colors.grey,
                        )),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  indent: 20,
                ),
            itemCount: tasks.length),
      );
    }
  }
}
