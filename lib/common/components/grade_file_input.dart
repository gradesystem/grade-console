import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input_decorator.dart';

@CustomTag("grade-file-input")
class GradeFileInput extends PolymerElement {

  @published
  File file;

  @published
  bool required = true;
  
  @published
  bool invalid;

  PaperInputDecorator labelDecorator;
  InputElement label;
  InputElement input;

  GradeFileInput.created() : super.created();

  void ready() {
    labelDecorator = $['labelDecorator'];
    label = $['label'];
    input = $['input'];

    input.onChange.listen((e) => _onFileInputChange());

    onClick.listen((_) {
      input.click();
    });

    onDragOver.listen(_onDragOver);
    onDragEnter.listen((e) => classes.add('hover'));
    onDragLeave.listen((e) => classes.remove('hover'));
    onDrop.listen(_onDrop);

    _updateInvalid();

    onPropertyChange(this, #file, () {
      _updateLabel();
      _updateInvalid();
      if (file == null) input.value = null;
    });
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
    input.files = event.dataTransfer.files;
  }

  void _onFileInputChange() {
    _onFilesSelected(input.files);
  }

  void _onFilesSelected(List<File> files) {
    file = files.isNotEmpty ? files.first : null;
  }

  void _updateLabel() {
    label.value = (file != null) ? file.name : "";
  }

  void _updateInvalid() {
    if (required && file == null) {
      labelDecorator.error = "Please select a file";
      labelDecorator.isInvalid = true;
      invalid = true;
    } else {
      labelDecorator.error = null;
      labelDecorator.isInvalid = false;
      invalid = false;
    }
  }

}
