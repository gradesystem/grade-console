part of editables;

abstract class EditableListService<T extends EditableGradeEntity> extends ListService<T> {
  
  EditableListService(String path, String all_path, String single_item_path, Generator<T> generator): super(path, all_path, single_item_path, generator);
  
  Future<T> put(T item) {
    return http.postJSon(all_path, JSON.encode(item.bean)).then(generator);
  }

  Future<bool> delete(T item, [Map<String, String> parameters]) {
    return http.delete(getItemPath(item.id), parameters).then((response) => true);
  }
  
  String getItemPath(String key) => "$single_item_path/$key";
}
