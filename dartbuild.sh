pub install
dartanalyzer --fatal-warnings web/*.dart
#test/run.sh
pub build

mvn clean install
