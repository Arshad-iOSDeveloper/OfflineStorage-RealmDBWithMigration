//
//  SchoolDBModel.swift
//  RealmSchoolDB
//
//  Created by Arshad Shaik on 07/12/23.
//

import Foundation
import RealmSwift

class School: Object {
  @Persisted(primaryKey: true) var schoolId: Int
  @Persisted var schoolName: String
  @Persisted var departments = List<Department>()
  
  convenience init(schoolId: Int, schoolName: String) {
    self.init()
    self.schoolId = schoolId
    self.schoolName = schoolName
  }
}

class Department: Object {
  @Persisted(primaryKey: true) var departmentId: Int
  @Persisted var departmentName: String
  @Persisted var students = List<Student>()
  @Persisted(originProperty: "departments") var school: LinkingObjects<School>
  
  convenience init(departmentId: Int, departmentName: String) {
    self.init()
    self.departmentId = departmentId
    self.departmentName = departmentName
  }
}

class Student: Object {
  @Persisted(primaryKey: true) var studentId: Int
  @Persisted var studentName: String
  @Persisted var age: Int?
  @Persisted(originProperty: "students") var department: LinkingObjects<Department>
  
  convenience init(studentId: Int, studentName: String) {
    self.init()
    self.studentId = studentId
    self.studentName = studentName
  }
}
