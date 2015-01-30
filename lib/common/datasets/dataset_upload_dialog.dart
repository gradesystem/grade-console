part of datasets;

@CustomTag("dataset-upload-dialog")
class DatasetUploadDialog extends PolymerElement with Filters {
  
  static String DEFAULT_DELIMITER = ",";
  static String DEFAULT_QUOTE = '"';
  static String DEFAULT_ENCODING = 'UTF-8';
  
  @observable
  List<MediaType> acceptedMediaType = [MediaType.CSV, MediaType.JSON, MediaType.XML];
  
  @observable
  List<String> encodings = [DEFAULT_ENCODING, "UTF-16"];

  @published
  bool opened = false;
  
  @published
  DatasetsPageModel model;
  
  @observable
  String name;
  
  @observable
  bool nameInvalid = false;
  
  @published
  ListItems endpoints;
  
  @observable
  String endpoint;
  
  @observable
  bool endpointInvalid = false;
  
  @observable
  String mimeType;
  
  @observable
  bool mimeTypeInvalid;
  
  
  @observable
  String delimiter;
  
  @observable
  bool delimiterInvalid = false;
  
  @observable
  String encoding;
  
  @observable
  bool encodingInvalid;
  
  @observable
  String quote;
  
  @observable
  bool quoteInvalid = false;

  Element dropZone;
  InputElement fileInput;
  
  @observable
  File file;

  DatasetUploadDialog.created() : super.created();

  void ready() {

    //print('shadow: ${($['files'] as PaperInput).shadowRoot} ');
    //fileInput = ($['files'] as PaperInput).shadowRoot.querySelector("#input");
    fileInput = $['files'];
    fileInput.onChange.listen((e) => _onFileInputChange());

    dropZone = $['drop-zone'];
    dropZone.onDragOver.listen(_onDragOver);
    dropZone.onDragEnter.listen((e) => dropZone.classes.add('hover'));
    dropZone.onDragLeave.listen((e) => dropZone.classes.remove('hover'));
    dropZone.onDrop.listen(_onDrop);
    
    onPropertyChange(this, #opened, (){
      if (opened) reset();      
    });
  }
  
  void reset() {
    name = "";
    endpoint = null;
    file = null;
    fileInput.value = null;
    mimeType = null;
    delimiter = DEFAULT_DELIMITER;
    encoding = DEFAULT_ENCODING;
    quote = DEFAULT_QUOTE;
  }

  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    dropZone.classes.remove('hover');
    _onFilesSelected(event.dataTransfer.files);
  }

  void _onFileInputChange() {
    _onFilesSelected(fileInput.files);
  }

  void _onFilesSelected(List<File> files) {
    print('_onFilesSelected $files');
    file = files.isNotEmpty?files.first:null;
    
    if (file != null) {
      MediaType fileType = MediaType.parse(file.type);
      mimeTypeInvalid = !acceptedMediaType.contains(fileType); 
      mimeType = fileType.value;
    } else {
      mimeTypeInvalid = null;
      mimeType = null;
    }
    
  }
  
  @ComputedProperty("mimeType")
  bool get isTypeCSV => mimeType == MediaType.CSV.value;
  
  void upload() {
    
    print('file type: ${file.type}');
    
    MediaType userFileType = MediaType.parse(mimeType);
    
    CSVConfiguration csvConfiguration = null;
    if (isTypeCSV) {
      csvConfiguration = new CSVConfiguration(delimiter, encoding, quote);
    }

    
    model.uploadDataset(name, endpoint, userFileType, file, csvConfiguration);
  }
    
  @ComputedProperty("nameInvalid || endpointInvalid || mimeTypeInvalid || file == null || (isTypeCSV && (delimiterInvalid || encodingInvalid || quoteInvalid))")
  bool get invalid => readValue(#invalid, ()=>false);


}
