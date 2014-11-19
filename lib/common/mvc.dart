part of common;

abstract class Model {} 

abstract class GradeEntity extends Delegate with Observable {
  GradeEntity(Map bean):super(bean);
}

