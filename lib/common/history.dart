part of common;

GradeHistory history = new GradeHistory();

class GradeHistory {
  
  RegExp exp = new RegExp(r"(^[^#]*)");
  
  Map<String, Function> hashes = {};
  
  GradeHistory() {
    window.onPopState.listen(onHashChange);
  }
  
  void onHashChange(_) {
    
    String hash = currentHash();
    
    if (hashes.containsKey(hash)) {
      Function.apply(hashes[hash], []);
    }
  }
  
  void register(String hash, Function function) {
    hashes[hash] = function;
  }
  
  void registerRoot(String hash, Function function) {
    hashes[hash] = function;
    hashes[''] = function;
  }
  
  String currentHash() {
    return window.location.hash.replaceFirst('#', '');
  }
  
  void go(String hash, String title) {
    
    //prevent double registrations
    if (hash == currentHash()) return;
    
    String url = getBaseUrl() + "#$hash";

    window.history.pushState(hash, title, url);
  }
  
  String getBaseUrl() {
    return exp.stringMatch( window.location.toString());
  }
  
}