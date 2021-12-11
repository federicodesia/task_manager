enum TaskFilter { All, Completed, Uncompleted }

String getEnumValue(Enum e){
  return e.toString().split('.').last;
}