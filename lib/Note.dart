import 'package:flutter/scheduler.dart';

class Note {

int _id ,_priority;
String _title , _description , _date ;

Note(this._title,this._date,this._priority,[this._description]);
Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

//creating getters
int get id => _id ;
String get title => _title;
String get description => _description;
String get date => _date;
int get priority => _priority;


//setters
set title (String newTitle){
 if(newTitle.length <= 255){
   this._title = newTitle;
 }
}

set description (String newDescription){
  if(newDescription.length <= 255){
    this._description = newDescription;
  }
}

set date (String newDate){
  this._date = newDate;
}

set priority(int newPriority){
  if(newPriority>=1 && newPriority<=2){
    this.priority= newPriority;
  }
}


// used to save and retrive from database 

//convert note object to map object 
Map<String, dynamic> toMap(){
  var map = new Map<String , dynamic>(); // creating an object from a class
  if(id!= null){
    map['id'] = _id;
  }
  map['title']=_title;
  map['description']=_description;
  map['priority']=_priority;
  map['date']=_date;
  return map;
}

//map to note object 
Note.fromMapObject(Map<String, dynamic>map){
  this._id = map['id'];
  this._title= map['title'];
  this._description = map['description'];
  this._priority = map['priority'];
  this._date = map['date'];




}



}