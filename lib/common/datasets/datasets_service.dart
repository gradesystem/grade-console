part of datasets;

abstract class DatasetService extends ListService<Dataset> {
  
  DatasetService(String path):super(path, "datasets", toDataset);

  static Dataset toDataset(Map json) {
    return new Dataset(json);
  }
}