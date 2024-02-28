//
//  ContentView.swift
//  Course Catalog
//
//  Created by Kaden Jessee on 6/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CourseViewModel()
    @State private var showOnlySelected = false
    
    var body: some View {
        VStack {
            Text("Course Catalog")
                .font(.title2)
                .accessibilityLabel("title")
            
            Spacer()
            
            List{
                ForEach(viewModel.filterCourses()){
                    course in
                    HStack{
                        if course.isSelected{
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .accessibilityLabel("ischecked")
                        }else{
                            Image(systemName: "square")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .accessibilityLabel("unchecked")
                        }
                        VStack(alignment: .leading)
                        {
                        
                            Text(course.number)
                                .font(.title3)
                            Text(course.shortDescription)
                                .font(.subheadline)
                        }
                        .padding(1)
                        
                    }
                    .onTapGesture {
                        viewModel.toggleCourseSelection(course)
                    }
                }
            }
            
            Spacer()
            
            HStack{
                Toggle("Show Only Selected Courses", isOn: $viewModel.showOnlySelected)
                    .toggleStyle(.button)
                    .accessibilityLabel("showOnlySelectedCoursesSwitch")
            }.padding(10)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



import Foundation

struct Course: Identifiable{
    let id = UUID()
    let number: String
    let shortDescription: String
    var isSelected: Bool
}

class CourseViewModel: ObservableObject{
    @Published var courses = [Course]()
    @Published var showOnlySelected = false
    
    init(){
        loadCourses()
    }
    
    func loadCourses(){
        loadCSCourses()
        
        courses = coursesDict.map{
            (courseNumber, courseData) in
            Course(number: courseNumber, shortDescription: courseData["ShortDescription"] ?? "", isSelected: false)
        }
        
        courses.sort{$0.number < $1.number}
    }
    
    func toggleCourseSelection(_ course: Course){
        if let index = courses.firstIndex(where: {$0.id == course.id}){
            courses[index].isSelected.toggle()
        }
    }
    
    func filterCourses() -> [Course]{
        if showOnlySelected{
            return courses.filter{$0.isSelected}
        }else{
            return courses
        }
    }
}
