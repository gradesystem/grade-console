part of datasets;

@CustomTag("dataset-list") 
class DatasetList extends PolymerElement with Filters {
  
  @published
  String kfilter = '';
  
  @published
  ListItems listitems;
  
  @published
  bool ddEnabled = false;
  
  CoreList list;
  
  FilterFunction itemFilter = (Dataset item, String term) => item.title != null && item.title.toLowerCase().contains(term.toLowerCase());
  
  CoreResizable resizable;
  
  DatasetList.created() : super.created() {
    resizable = new CoreResizable(this);
  }
  
  void attached() {
    super.attached();
    resizable.resizableAttachedHandler((_)=>list.updateSize());
  }
  
  void detached() {
    super.detached();
    resizable.resizableDetachedHandler();
  }
  
  void ready() {
    list = $['list'] as CoreList;
    
    listitems.selection.listen(syncSelected);
    
    onPropertyChange(list, #selection, (){listitems.selected = list.selection;});
    
    onPropertyChange(listitems.data, #isEmpty, (){
      async((_)=>list.updateSize());
    });
    
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
  
  void syncSelected(SelectionChange change) {
    async((_) {
      var selected = change.selectFirst && list.data.isNotEmpty?list.data.first:change.item;
      if (selected != list.selection) {
        if (selected == null) list.clearSelection();
        else {
          Map index = list.indexesForData(selected);
          if (index['virtual']>=0) list.selectItem(index['virtual']);
          }
        }
    });
  }
 
}
