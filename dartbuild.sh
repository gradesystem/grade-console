pub install
dartanalyzer --fatal-warnings web/*.dart
#test/run.sh
pub build --mode=debug

mvn clean install
