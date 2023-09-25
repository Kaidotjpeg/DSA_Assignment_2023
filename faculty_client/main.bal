import ballerina/io;
import ballerina/http;

public function main() returns error? {
    io:println("Assignment 1 Client");
    io:println("-------------------------------------");

    Client apiClient = check new;

    showMenu(apiClient);
}

function showMenu(Client apiClient) {
    while (true) {
        io:println("Available Actions:");
        io:println("1. List Lecturers");
        io:println("2. Add Lecturer");
        io:println("3. Get Lecturer by Staff Number");
        io:println("4. Update Lecturer by Staff Number");
        io:println("5. Delete Lecturer by Staff Number");
        io:println("6. List Lecturers by Office Number");
        io:println("7. List Courses");
        io:println("8. Add Course");
        io:println("9. Get Course by Course Code");
        io:println("10. Update Course by Course Code");
        io:println("11. Delete Course by Course Code");
        io:println("12. Exit");

        string number = io:readln("Enter your choice: ");
        int|error choice = int:fromString(number);

        match choice {
        1 => {
            listLecturers(apiClient);
        }
        // Use `|` to match more than one value.
        2 => {
            addLecturer(apiClient);
        }
        3 => {
            getLecturerByStaffNumber(apiClient);
        }
        // Use `|` to match more than one value.
        4 => {
            updateLecturerByStaffNumber(apiClient);
        }
        5 => {
            deleteLecturerByStaffNumber(apiClient);
        }
        // Use `|` to match more than one value.
        6 => {
            listLecturerByOfficeNumber(apiClient);
        }
        7 => {
            listCourses(apiClient);
        }
        // Use `|` to match more than one value.
        8 => {
            addCourse(apiClient);
        }
        9 => {
            getCourseByCourseCode(apiClient);
        }
        10 => {
            updateCourseByCourseCode(apiClient);
        }
        11 => {
            deleteCourseByCourseCode(apiClient);
        }
    }
    }
}

function listLecturers(Client apiClient) {
    // Call the corresponding method on the client
    var result = apiClient->/["lecturers"];

    if result is Lecturer[] {
        // Loop through array
        foreach var lecturer in result {
            io:println("Staff Number: "+lecturer.staffNumber);
            io:println("Title: "+lecturer.title);
            io:println("Name: "+lecturer.staffName);
            io:println("Office Number: "+lecturer.officeNumber);
            io:println("Courses: ");

            foreach var course in lecturer.courses {
                io:println("Course Code: "+course.courseCode);
                io:println("Course Name: "+course.courseName);
                io:println("NQF Level: "+course.nqfLevel);
            }

            io:println("-------------------------------");
            io:println("");
        }
    }
    else {
        io:println("Error message: " + result.message());
        io:println(result.cause());
    }
}

function addLecturer(Client apiClient) {

    //Get a list of available courses
    var allCourses = apiClient->/["courses"];

    if(allCourses is error){
        io:println("Error retrieving the list of courses");
        return;
    }

    // Collect input from the user
    Lecturer lecturer = {courses: [], officeNumber: "", staffName: "", staffNumber: "", title: ""};
    lecturer.staffNumber = io:readln("Enter Staff Number: ");
    lecturer.officeNumber = io:readln("Enter Office Number: ");
    lecturer.staffName = io:readln("Enter Staff Name: ");
    lecturer.title = io:readln("Enter Title: ");

    io:println("----------------------------------");
    io:println("Available Courses to Assign To The Lecturer");

    int courseIndex = 0;

    foreach var course in allCourses {
        io:println(courseIndex.toString() + ": "+course.courseCode+ ": "+course.courseName);
        courseIndex = courseIndex +1;
    }
    
    boolean addMoreCourses = true;
    courseIndex = courseIndex-1;
    while(addMoreCourses){
        io:println("Enter the number of the course to assign (0- " +courseIndex.toString()+ ") or type 'exit' to finish assigning: ");
        var input = io:readln();
        if(input == "exit"){
            break;
        }

        int courseNumber;
        int|error chosenInput = int:fromString(input);

        if(chosenInput is error){
            io:println("Invalid Input. Please Enter a valid Course Number.");
        } else{
            courseNumber = chosenInput;
            lecturer.courses[lecturer.courses.length()] = allCourses[courseNumber];
            io:println("Course Assigned");
        }

        io:println("Do you want to add another Course? (yes/no): ");
        var continueInput = io:readln();
        if (continueInput != "yes") {
            addMoreCourses = false;
        }
    }
    
    // Call the corresponding method on the client
    var result = apiClient->/["lecturers"].post(lecturer);
    
    if(result is http:Response){
        io:println(result.statusCode);
        io:println("Lecturer succesfully added.");
    }else{
        io:println("Error Message: " + result.message());
        io:println(result.cause());
    }
}

function getLecturerByStaffNumber(Client apiClient){
    string staffNumber = io:readln("Enter Staff Number: ");
    
    var result = apiClient->/["lecturers"]/[staffNumber];

    if result is Lecturer {
        io:println("Lecturer Details");
        io:println("----------------------");
        io:println("Staff Number: "+result.staffNumber);
        io:println("Title: "+result.title);
        io:println("Name: "+result.staffName);
        io:println("Office Number: "+result.officeNumber);
        io:println("Courses: ");

        foreach var course in result.courses {
            io:println("Course Code: "+course.courseCode);
            io:println("Course Name: "+course.courseName);
            io:println("NQF Level: "+course.nqfLevel);
        }
    }
    else {
        io:println("Error Message" + result.message());
    }
}

function updateLecturerByStaffNumber(Client apiClient){
    string staffNumber = io:readln("Enter Staff Number: ");

    //Check if lecturer exists
    var existingLecturer = apiClient->/["lecturers"]/[staffNumber];
    if(existingLecturer is error){
        io:println("Lecturer with staff number '" +staffNumber+ "' not found.");
        return;
    }

    Lecturer lecturer = {courses: [], officeNumber: "", staffName: "", staffNumber: "", title: ""};
    lecturer.staffNumber = staffNumber;
    lecturer.officeNumber = io:readln("Enter Office Number: ");
    lecturer.staffName = io:readln("Enter Staff Name: ");
    lecturer.title = io:readln("Enter Title: ");

    // Retrieve the existing lecturer details
    Lecturer lecturerToUpdate = existingLecturer;

    while (true) {
        // Display the current courses and let the user choose which one to update
        int courseIndex = 0;
        while (courseIndex < lecturerToUpdate.courses.length()) {
            Course course = lecturerToUpdate.courses[courseIndex];
            io:println("Course " + courseIndex.toString() + ":");
            io:println("Course Code: " + course.courseCode);
            io:println("Course Name: " + course.courseName);
            io:println("NQF Level: " + course.nqfLevel);
            io:println("--------------------------");
            courseIndex = courseIndex + 1;
        }

        int courseIndexMinusOne = courseIndex - 1;

        io:println("Enter the number of the course to update (0-" + courseIndexMinusOne.toString() + ") or type 'exit' to finish updating: ");
        string userInput = io:readln();

        if (userInput == "exit") {
            io:println("Update operation finished.");
            break;
        }

        int|error input = int:fromString(userInput);

        if(input is error){
            io:println("Invalid Input");
            return;
        } else {
            if (input < 0 || input >= courseIndex){
            io:println("Invalid course number.");
            return;
        }

        // Collect updated course details from the user
        Course updatedCourse = {courseCode: "", courseName: "", nqfLevel: ""};
        updatedCourse.courseCode = io:readln("Enter updated Course Code: ");
        updatedCourse.courseName = io:readln("Enter updated Course Name: ");
        updatedCourse.nqfLevel = io:readln("Enter updated NQF Level: ");

        // Update the selected course
        lecturer.courses[input] = updatedCourse;

        // Call the corresponding method on the client to update the lecturer
        var result = apiClient->/["lecturers"]/[staffNumber].put(lecturer);

        if (result is error) {
            io:println("Error Message: " + result.message());
        } else {
            io:println("Lecturer Details Updated Successfully.");
        }
    }
    }
}

function deleteLecturerByStaffNumber(Client apiClient){
    string staffNumber = io:readln("Enter Staff Number: ");

    var result = apiClient->/["lecturers"]/[staffNumber].delete;
    
    if result is Lecturer {
        io:println("Lecturer Successfully Deleted");
    }
    else {
        io:println("Error Message" + result.message());
    }
}

function listLecturerByOfficeNumber(Client apiClient){
    string officeNumber = io:readln("Enter Office Number: ");

    var result = apiClient->/["lecturers"]/["office"]/[officeNumber];

    if result is Lecturer[] {
        foreach var lecturer in result {           
            io:println("Lecturer Details");
            io:println("-----------------------------------------------------");
            io:println("Staff Number: "+lecturer.staffNumber);
            io:println("Title: "+lecturer.title);
            io:println("Name: "+lecturer.staffName);
            io:println("Office Number: "+lecturer.officeNumber);
            io:println("Courses: ");
            io:println("-----------------------------------------------------");

                foreach var course in lecturer.courses {
                io:println("Course Code: "+course.courseCode);
                io:println("Course Name: "+course.courseName);
                io:println("NQF Level: "+course.nqfLevel);
            }
        }       
    }
    else {
        io:println("Error Message: " + result.message());
    }
}

function listCourses(Client apiClient){
    var result = apiClient->/["courses"];

    if result is Course[] {
        foreach var course in result {
            io:println("Course Code: "+course.courseCode);
            io:println("Course Name: "+course.courseName);
            io:println("NQF Level: "+course.nqfLevel);

            io:println("-------------------------------");
            io:println("");
        }
    }
    else {
        io:println("Error message: " + result.message());
    }
}

function addCourse(Client apiClient){
    string courseCode = io:readln("Enter Course Code: ");
    string courseName = io:readln("Enter Course Name: ");
    string nqfLevel = io:readln("Enter NQF Level: ");

    Course newCourse = {courseName: "", courseCode: "", nqfLevel: ""};
    newCourse.courseCode = courseCode;
    newCourse.courseName = courseName;
    newCourse.nqfLevel = nqfLevel;

    var result = apiClient->/["courses"].post(newCourse);
    
    if(result is http:Response){
        io:println(result.statusCode);
        io:println("Lecturer succesfully added.");
    }else{
        io:println("Error Message" + result.message());
    }
}

function getCourseByCourseCode(Client apiClient){
    string courseCode = io:readln("Enter Course Code: ");

    var result = apiClient->/["courses"]/[courseCode];

    if result is Course {
        io:println("Course Code: "+result.courseCode);
        io:println("Course Name: "+result.courseName);
        io:println("NQF Level: "+result.nqfLevel);
    }
    else {
        io:println("Error Message" + result.message());
    }
}

function updateCourseByCourseCode(Client apiClient){

    string courseCode = io:readln("Enter Course Code: ");
    string updatedCourseName = io:readln("Enter Course Name:");
    string nqfLevel = io:readln("Enter NQF Level: ");

    Course updatedCourse = {courseName: "", courseCode: "", nqfLevel: ""};
    updatedCourse.courseCode = courseCode;
    updatedCourse.courseName = updatedCourseName;
    updatedCourse.nqfLevel = nqfLevel;

    var result = apiClient->/["courses"]/[courseCode].put(updatedCourse);
    
    if(result is error){
        io:println("Error Message: " +result.message());
    }
    else {
        io:println("Course Details Updated Successfully.");
    }
}

function deleteCourseByCourseCode(Client apiClient){
    string courseCode = io:readln("Enter Course Code: ");

    var result = apiClient->/["courses"]/[courseCode].delete;

    if result is Course {
        io:println("Course Deleted Succesfully");
    }
    else {
        io:println("Error Message" + result.message());
    }
}
