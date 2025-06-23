//
//  Smart_tasksTests.swift
//  Smart tasksTests
//
//  Created by Umair on 21/06/2025.
//

import XCTest
@testable import Smart_tasks

final class Smart_tasksTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Pesudo Test
    func testTaskSortingWithPriorityDueDate() {
        let task1 = Task(id: "1", targetDate: "2025-07-20", dueDate: "2025-07-20",
                         title: "Low priority", description: "", priority: 1)
        let task2 = Task(id: "2", targetDate: "2025-07-22", dueDate: "2025-07-22",
                         title: "High priority", description: "", priority: 5)
        let task3 = Task(id: "3", targetDate: "2025-07-18", dueDate: "2025-07-18",
                         title: "Medium priority", description: "", priority: 3)
        let task4 = Task(id: "4", targetDate: "2025-07-15", dueDate: "2025-07-15",
                         title: "Same priority older", description: "", priority: 3)
        
        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2, task3, task4])
        let result = SUT.prioritiseTasks()
        
        let resultTitles = result.map { ($0.model as? DemoItem)?.title ?? "" }
        XCTAssertEqual(resultTitles, ["High priority", "Same priority older", "Medium priority", "Low priority"])
    }
    
    //MARK: Basic Priority Sorting Test
    func test_PrioritiseTasks_sortsByPriorityDescending() {
        let task1 = Task(id: "1", targetDate: "2025-07-20", dueDate: "2025-07-20",
                         title: "Low" , description: "", priority: 1)
        let task2 = Task(id: "2", targetDate: "2025-07-22", dueDate: "2025-07-22",
                         title: "High", description: "", priority: 5)
        let task3 = Task(id: "3", targetDate: "2025-07-18", dueDate: "2025-07-18",
                         title: "Medium", description: "", priority: 3)

        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2, task3])
        let result = SUT.prioritiseTasks()

        XCTAssertEqual(result.map { ($0.model as? DemoItem)?.taskId }, [task2.id, task3.id, task1.id])
    }
    
    //MARK: Same Priority, Sorted by Due Date Ascending
    func test_PrioritiseTasks_sortsByDueDateIfPriorityEqual() {
        let task1 = Task(id: "1",targetDate: "2025-07-15",  dueDate: "2025-07-15",
                         title: "Task1", description: "", priority: 3)
        let task2 = Task(id: "2",  targetDate: "2025-07-18", dueDate: "2025-07-18",
                         title: "Task2", description: "", priority: 3)

        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2])
        let result = SUT.prioritiseTasks()

        XCTAssertEqual(result.map { ($0.model as? DemoItem)?.taskId }, [task1.id, task2.id])
    }
    
    //MARK:  Missing Priority Fallback
    func test_PrioritiseTasks_handlesMissingPriority() {
        let task1 = Task(id: "1", targetDate: "2025-07-20",dueDate: "2025-07-20",
                         title: "No priority", description: "", priority: nil)
        let task2 = Task(id: "2", targetDate: "2025-07-22",  dueDate: "2025-07-22",
                         title: "High",description: "" , priority: 5)
        
        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2])
        let result = SUT.prioritiseTasks()
       
        XCTAssertEqual((result.first?.model as? DemoItem)?.taskId, task2.id)
    }

    //MARK: Missing Due Dates
    func test_PrioritiseTasks_handlesMissingDueDates() {
        let task1 = Task(id: "1", targetDate: "2025-07-20", dueDate: nil,
                         title: "No date", description: "", priority: 2)
        let task2 = Task(id: "2", targetDate: "2025-07-22", dueDate: "2025-07-19",
                         title: "With date", description: "", priority: 2)

        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2])
        let result = SUT.prioritiseTasks()
        
        XCTAssertEqual((result.first?.model as? DemoItem)?.taskId, task2.id)
    }


    //MARK: All Equal Priority and Date (Stable Ordering)
    func test_PrioritiseTasks_preservesOrderIfSamePriorityAndDate() {
        let task1 = Task(id: "1", targetDate: "2025-07-20", dueDate: "2025-07-20",
                         title: "A", description: "", priority: 3)
        let task2 = Task(id: "2",targetDate: "2025-07-20", dueDate: "2025-07-20",
                         title: "B", description: "", priority: 3)

        let SUT = TaskViewModel(task: MockTaskRepository())
        SUT.setTasks(with: [task1, task2])
        let result = SUT.prioritiseTasks()

        XCTAssertEqual(result.map { ($0.model as? DemoItem)?.taskId }, [task1.id, task2.id])
    }

    

    
}
