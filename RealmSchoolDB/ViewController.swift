//
//  ViewController.swift
//  RealmSchoolDB
//
//  Created by Arshad Shaik on 07/12/23.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("realm path ", RealmHandler.shared.getDatabasePath() as Any)
  }
  
  // MARK: - Actions -
  @IBAction func addTapped(_ sender: UIButton) {
//    saveData()
    addStudentsIntoEngineeringDepartment()
  }
  
  @IBAction func fetchTapped(_ sender: UIButton) {
//    fetchDataWithPrimaryKey()
    fetchDataWithSchemaMigration()
  }
  
  @IBAction func updateTapped(_ sender: UIButton) {
//    updateData()
//    updateStudentName()
//    updateDataWithSchemaMigration()
    renameProperty()
  }
  
  @IBAction func deleteTapped(_ sender: UIButton) {
    deleteStudentInEngineering()
  }
  
}

extension ViewController {
  func saveData() {
    // Create Student, studentId is Primary Key
    let student1 = Student(studentId: 10, studentName: "student1")
    let student2 = Student(studentId: 11, studentName: "student2")
    
    // Create Department, departmentId is Primary Key
    let department1 = Department(departmentId: 100, departmentName: "Engineering")
    department1.students.append(objectsIn: [student1, student2])
    
    let student3 = Student(studentId: 20, studentName: "student1")
    let department2 = Department(departmentId: 101, departmentName: "Engineering")
    department2.students.append(objectsIn: [student3])
    
    // Create School, schoolId is Primary Key
    let school = School(schoolId: 112, schoolName: "Crelio")
    school.departments.append(objectsIn: [department1, department2])
    
    RealmHandler.shared.saveToRealm(data: school)
  }
  
  func addStudentsIntoEngineeringDepartment() {
    // Create Student
    let student1 = Student(studentId: 11, studentName: "Part")
    let student2 = Student(studentId: 12, studentName: "Yash")
    
    let realm = try! Realm()
    if let school = realm.object(ofType: School.self, forPrimaryKey: 112),
       let engineeringDepartment = school.departments.filter("departmentName == 'Engineering'").first {
      try! realm.write {
        engineeringDepartment.students.append(objectsIn: [student1, student2])
      }
    }
    
  }
  
  
  func fetchDataWithPrimaryKey() {
    let realm = try! Realm()
    /// Fetch data from School Class, whose primary key is 112
    let school = realm.object(ofType: School.self, forPrimaryKey: 112)
    /// Get students list from Engineering Department
    let engineeringDepartment = school?.departments.filter("departmentName == 'Engineering'").first
    print("engineering department students are ", engineeringDepartment?.students as Any)
  }
  
  func fetchDataWithSchemaMigration() {
    /// When you open the realm, specify that the schema
    /// is now using a newer version.
    let config = Realm.Configuration(schemaVersion: 2)
    /// Use this configuration when opening realms
    Realm.Configuration.defaultConfiguration = config
    print("realm path after migration ", RealmHandler.shared.getDatabasePath() as Any)
    let realm = try! Realm()
    /// Fetch data from School Class, whose primary key is 112
    let school = realm.object(ofType: School.self, forPrimaryKey: 112)
    /// Get students list from Engineering Department
    let engineeringDepartment = school?.departments.filter("departmentName == 'Engineering'").first
    print("engineering department students are ", engineeringDepartment?.students as Any)
  }
  
  func updateData() {
    let realm = try! Realm()
    /// Change department name whose primary key or department id is 101
    let department = realm.object(ofType: Department.self, forPrimaryKey: 101)
    try! realm.write({
      department?.departmentName = "Sales"
    })
  }
  
  func updateStudentName() {
    let realm = try! Realm()
    if let school = realm.object(ofType: School.self, forPrimaryKey: 112),
       let engineeringDepartment = school.departments.filter("departmentName == 'Engineering'").first,
       let studentInEngineering = engineeringDepartment.students.first {
      try! realm.write {
        studentInEngineering.studentName = "Arshad"
      }
    }
  }
  
  func updateDataWithSchemaMigration() {
    // When you open the realm, specify that the schema
    // is now using a newer version.
    let config = Realm.Configuration(schemaVersion: 2)
    // Use this configuration when opening realms
    Realm.Configuration.defaultConfiguration = config
    print("realm path after migration ", RealmHandler.shared.getDatabasePath() as Any)
    let realm = try! Realm()
    let student = realm.object(ofType: Student.self, forPrimaryKey: 20)
    try! realm.write({
      student?.studentName = "Vikas"
      student?.age = 30
    })
  }
  
  func renameProperty() {
    let config = Realm.Configuration(
      schemaVersion: 2,
      migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 2 {
          migration.enumerateObjects(ofType: Student.className()) { oldObject, newObject in
            // Rename the "age" property to "yearsSinceBirth"
            newObject?["yearsSinceBirth"] = oldObject?["age"]
          }
        }
      }
    )
    /// Apply the new configuration
    Realm.Configuration.defaultConfiguration = config
  }
  
  func deleteDepartment() {
    let realm = try! Realm()
    /// Delete Department with Department id or Primary Key 100
    if let department = realm.object(ofType: Department.self, forPrimaryKey: 100) {
      try! realm.write {
        realm.delete(department)
      }
    }
  }
  
  func deleteSchool() {
    let realm = try! Realm()
    if let school = realm.object(ofType: School.self, forPrimaryKey: 112) {
      try! realm.write {
        /// Delete related students
        for department in school.departments {
          realm.delete(department.students)
        }
        /// Delete related departments
        realm.delete(school.departments)
        /// Delete the school
        realm.delete(school)
      }
    }
  }
  
  func deleteStudentInEngineering() {
    let realm = try! Realm()
    if let school = realm.object(ofType: School.self, forPrimaryKey: 112),
       let engineeringDepartment = school.departments.filter("departmentName == 'Engineering'").first,
       engineeringDepartment.students.count >= 2 {
      let studentToDelete = engineeringDepartment.students[1]
      try! realm.write {
        realm.delete(studentToDelete)
      }
    }
  }
  
}
