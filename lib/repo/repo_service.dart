part of repo;

@Injectable()
class RepoService {
  
  List<Graph> graphs = [
                                   new Graph("0", "SPECIES", "n/a", new DateTime(2014,10,1), "ASFIS", "C. Baldassarre"),
                                   new Graph("1", "VESSELS", "n/a", new DateTime(2012,11,21), "ASFIS", "C. Baldassarre"),
                                   new Graph("2", "GEARS", "n/a", new DateTime(2011,1,12), "ASFIS", "C. Baldassarre"),
                                   new Graph("3", "EEZ", "n/a", new DateTime(2014,5,2), "ASFIS", "C. Baldassarre"),
                                   new Graph("4", "WATER", "n/a", new DateTime(2014,3,23), "SMAC", "G. Verdi")
                                   
                                   ];
  Future<List<Graph>> getAll() {
    Completer completer = new Completer();
    completer.complete(graphs);
    
    return completer.future;
  }

}