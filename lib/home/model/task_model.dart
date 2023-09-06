class TaskModel {
  int? id;
  String taskContent;
  String taskTime;
  String taskDate;
  String taskStatus;

  TaskModel({
     this.id,
    required this.taskContent,
    required this.taskTime,
    required this.taskDate,
    required this.taskStatus,
  });
}
