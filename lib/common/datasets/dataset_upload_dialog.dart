part of datasets;

@CustomTag("dataset-upload-dialog")
class DatasetUploadDialog extends PolymerElement with Filters {
  
  static final RegExp valid_name_exp = new RegExp(r"^[A-Za-z0-9-_.!~*'()]*$");
  static final RegExp name_exp = new RegExp(r"[^A-Za-z0-9-_.!~*'()]");

  static String DEFAULT_DELIMITER = ",";
  static String DEFAULT_QUOTE = '"';
  static String DEFAULT_ENCODING = 'UTF-8';
  
  @observable
  List<Format> acceptedFormats = [new Format("CSV",MediaType.CSV), new Format("JSON", MediaType.JSON), new Format("XML", MediaType.XML)];
  
  @observable
  List<String> encodings = [DEFAULT_ENCODING, "UTF-16"];

  @observable
  bool opened = false;
  
  @published
  DatasetsPageModel model;
  
  @observable
  String name;
  
  @observable
  bool nameInvalid = false;
  
  @observable
  String author;
  
  @observable
  bool authorInvalid = false;
  
  @published
  Endpoints endpoints;
  
  @observable
  String endpoint;
  
  @observable
  bool endpointInvalid = false;
  
  @observable
  File file;
  
  @observable
  bool fileInvalid;
  
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
  
  @observable
  bool uploading = false;
  
  @observable
  bool failed = false;
  
  @observable
  ErrorResponse error = null;

  DatasetUploadDialog.created() : super.created();
  
  void open() {
    reset();
    opened = true;
  }
  
  void openWithFile(File file) {
    reset();
    opened = true;
    this.file = file; 
  }

  void ready() {
    onPropertyChange(this, #file, _onFileSelected);
  }
  
  void reset() {
    name = null;
    author = null;
    endpoint = null;
    file = null;
    mimeType = null;
    delimiter = DEFAULT_DELIMITER;
    encoding = DEFAULT_ENCODING;
    quote = DEFAULT_QUOTE;
    
    uploading = false;
    failed = false;
    error = null;
    
    if (endpoints.synchedData.length == 1) endpoint = endpoints.synchedData.first.model.id;
  }
  
  String validate_name(String s) 
    => s!=null && s.isNotEmpty && !valid_name_exp.hasMatch(s)?"Invalid name...":null;

  void _onFileSelected() {
    
    if (file != null) {
      print('file.type ${file.type}');
      MediaType fileType = MediaType.parse(file.type);
      mimeTypeInvalid = !acceptedFormats.any((Format f)=>f.type == fileType); 
      mimeType = (fileType!=null)?fileType.value:null;
      _calculateName();
    } else {
      mimeTypeInvalid = null;
      mimeType = null;
    }
    
  }
  
  void _calculateName() {
    if ((name == null || name.isEmpty) && file!=null) {
      String fileName = file.name;
      int dotIndex = fileName.indexOf(".");
      if (dotIndex>0) fileName = fileName.substring(0,dotIndex);
      name = fileName.replaceAll(name_exp, "-");
    }
  }
  
  @ComputedProperty("mimeType")
  bool get isTypeCSV => mimeType == MediaType.CSV.value;
  
  @ComputedProperty("name")
  String get uri => name!=null && name.isNotEmpty ?"http://data.gradesystem.eu/graphs/upload/$name":"http://data.gradesystem.eu/graphs/upload/~missing~";
  
  @ComputedProperty("error")
  String get errorMessage {
  
    return error!=null && error.isClientError()?
                      "Check the upload parameters...":
                      "Ouch. Something went horribly wrong...";
  
  }
  
  void upload() {
    
    uploading = true;
    failed = false;
    error = null;
        
    MediaType userFileType = MediaType.parse(mimeType);
    
    CSVConfiguration csvConfiguration = null;
    if (isTypeCSV) {
      csvConfiguration = new CSVConfiguration(delimiter, encoding, quote);
    }

    DatasetUploadMetadata metadata = new DatasetUploadMetadata(name, author, userFileType, endpoint, csvConfiguration);
    model.uploadDataset(metadata, file)
    .then((_){
      opened = false;
    })
    .catchError((e){
      error = e;
      failed = true;
    })
    .whenComplete((){
      uploading = false;
    });
  }
  
  void retry() {
    failed = false;
    error = null;
  }
    
  @ComputedProperty("nameInvalid || authorInvalid || endpointInvalid || mimeTypeInvalid || fileInvalid || (isTypeCSV && (delimiterInvalid || encodingInvalid || quoteInvalid))")
  bool get invalid => readValue(#invalid, ()=>false);

}

class Format {
  String label;
  MediaType type;
  
  String get value => type.value;
  
  Format(this.label, this.type);
}
