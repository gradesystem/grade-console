part of datasets;

@CustomTag("dataset-upload-dialog")
class DatasetUploadDialog extends PolymerElement with Filters {
  
  static final RegExp valid_name_exp = new RegExp(r"^[A-Za-z0-9-_.!~*'()]*$");

  static String DEFAULT_DELIMITER = ",";
  static String DEFAULT_QUOTE = '"';
  static String DEFAULT_ENCODING = 'UTF-8';
  
  @observable
  List<Format> acceptedFormats = [new Format("CSV",MediaType.CSV), new Format("JSON", MediaType.JSON), new Format("XML", MediaType.XML)];
  
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

  DatasetUploadDialog.created() : super.created();

  void ready() {
    
    onPropertyChange(this, #opened, (){
      if (opened) reset();      
    });
    
    onPropertyChange(this, #file, _onFileSelected);
  }
  
  void reset() {
    name = "";
    endpoint = null;
    file = null;
    mimeType = null;
    delimiter = DEFAULT_DELIMITER;
    encoding = DEFAULT_ENCODING;
    quote = DEFAULT_QUOTE;
    
    if (endpoints.synchedData.length == 1) endpoint = endpoints.synchedData.first.model.id;
  }
  
  String validate_name(String s) {
      return !valid_name_exp.hasMatch(s)?"Invalid name...":null;
    }

  void _onFileSelected() {
    
    if (file != null) {
      MediaType fileType = MediaType.parse(file.type);
      mimeTypeInvalid = !acceptedFormats.any((Format f)=>f.type == fileType); 
      mimeType = fileType.value;
    } else {
      mimeTypeInvalid = null;
      mimeType = null;
    }
    
  }
  
  @ComputedProperty("mimeType")
  bool get isTypeCSV => mimeType == MediaType.CSV.value;
  
  @ComputedProperty("name")
  String get uri => name!=null && name.isNotEmpty ?"http://gradesystem.io/staging/graph/$name":"http://gradesystem.io/staging/graph/~missing~";
  
  void upload() {
    
    print('file type: ${file.type}');
    
    MediaType userFileType = MediaType.parse(mimeType);
    
    
    
    
    CSVConfiguration csvConfiguration = null;
    if (isTypeCSV) {
      csvConfiguration = new CSVConfiguration(delimiter, encoding, quote);
    }

    DatasetUploadMetadata metadata = new DatasetUploadMetadata(name, author, userFileType, endpoint, csvConfiguration);
    model.uploadDataset(metadata, file);
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
