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
    
    onPropertyChange(listitems, #selected, syncSelection);
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
  
  void syncSelection() {
    if (listitems.selected!= null && listitems.selected != list.selection) {
      if (listitems.selected == null) list.clearSelection();
      else {
        int index = listitems.data.indexOf(listitems.selected);
        list.selectItem(index);
      }
    }
  } 
  
  void selectDataset(event) {
    listitems.selected = list.selection;
  }
 
}
