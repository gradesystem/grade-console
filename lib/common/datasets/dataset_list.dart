part of datasets;

@CustomTag("dataset-list") 
class DatasetList extends GradeList {
  
  @published
  bool ddEnabled = false;
  
  KeywordFilterFunction itemFilter = (Dataset item, String term) => item.title != null && item.title.toLowerCase().contains(term.toLowerCase());

  DatasetList.created() : super.created('list') {
    setupKeywordFilter(itemFilter, false);
  }
  
  void ready() {
    super.ready();
    
    if (ddEnabled) {
      onDragOver.listen(_onDragOver);
      onDragEnter.listen((e) => classes.add('hover'));
      onDragLeave.listen((e) => classes.remove('hover'));
      onDrop.listen(_onDrop);
    }
  }
  
  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    classes.remove('hover');
    List<File> files = event.dataTransfer.files;
    if (files != null && files.isNotEmpty) fire("file-drop", detail:files.first);
  }
 
}
