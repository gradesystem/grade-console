part of datasets;

class Dataset extends GradeEntity with Filters {

  Dataset(Map bean) : super(bean);

  static final String CREATION_DATE_FIELD = "http://purl.org/dc/terms/created";
  static final String MODIFIED_DATE_FIELD = "http://purl.org/dc/terms/modified";
  static final String URI_FIELD = "uri";

  static final String id = "uri";
  static final List<String> titles_keys = ["label", "http://www.w3.org/2000/01/rdf-schema#label", "http://purl.org/dc/terms/title"];
  static final List<String> subtitles_keys = [CREATION_DATE_FIELD, MODIFIED_DATE_FIELD, URI_FIELD];
  
  String get title {

    for (String lbl in titles_keys) {
      String label = get(lbl);
      if (label != null) return label;
    }

    return get(id);
  }

  String get creationDate => extractAndFormatDate(CREATION_DATE_FIELD);
  String get modifiedDate => extractAndFormatDate(MODIFIED_DATE_FIELD);
  
  String get subtitle {
    for (String key in subtitles_keys) if (bean.containsKey(key)) return get(key);
    return null;
  }


  String extractAndFormatDate(String key) {
    
    String value = get(key);
    if (value == null) return null;
    
    String timeZone = getTimeZone(value);

    return "${formatDate(getDate(key))} $timeZone";
  }

  String getTimeZone(String value) {
    int zIndex = value.toLowerCase().lastIndexOf('Z');
    if (zIndex >= 0) return value.substring(zIndex);
    return "";
  }
  
  String toString() => 'Dataset $title';

}

int compareDatasets(Dataset d1, Dataset d2) {
  if (d1 == null || d1.modifiedDate == null) return 1;
  if (d2 == null || d2.modifiedDate == null) return -1;
  return d2.modifiedDate.compareTo(d1.modifiedDate);
}


class Datasets extends ListItems<Dataset> {
  Datasets() : super(compareDatasets);
}

class DatasetsPageModel extends SubPageModel<Dataset> {

  DatasetsPageModel(PageEventBus bus, ListService<Dataset> service, ListItems<Dataset> storage) : super(bus, service, storage) {
    bus.on(GraphOperation).listen((_) => loadAll());
    bus.on(EndpointOperation).listen((_) => loadAll());
  }

  DatasetService get datasetService => service;

  Future<bool> uploadDataset(DatasetUploadMetadata metadata, File file) {
    return datasetService.upload(metadata, file).then((_) {
      loadAll();
      bus.fireInPage(new DatasetUploaded(metadata.endpointId));
      return true;
    });
  }

}

class DatasetUploadMetadata {
  String name;
  String author;
  MediaType type;
  String endpointId;
  CSVConfiguration csvConfiguration;

  DatasetUploadMetadata(this.name, this.author, this.type, this.endpointId, [this.csvConfiguration]);
}

class CSVConfiguration {
  String delimiter;
  String encoding;
  String quote;

  CSVConfiguration(this.delimiter, this.encoding, this.quote);

}
