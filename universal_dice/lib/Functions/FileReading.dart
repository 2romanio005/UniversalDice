

int? getNumberFromFileName(String path){
  int start = path.lastIndexOf('/') + 1;
  int end = path.lastIndexOf('.');
  if (end <= start) {
    print("Точка не там");
    return null;
  }
  return int.tryParse(path.substring(start, end));
}
