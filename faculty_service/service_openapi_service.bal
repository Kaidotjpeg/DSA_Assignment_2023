// AUTO-GENERATED FILE.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/http;


# Bad request response
public type ValidationError record {|
    *http:BadRequest;
    # Error response.
    ErrorResponse body;
|};

# Represents headers of created response
public type LocationHeader record {|
    # Location header. A link to the created resource.
    string location;
|};

# Resource Created response
public type ResourceCreated record {|
    *http:Created;
    # Location header representing a link to the created resource.
    LocationHeader headers;
|};

# Resource updated response
public type ResourceUpdated record {|
    *http:Ok;
|};

# Tables for storing Lecturers & Courses
table<Lecturer> key(staffNumber) lecturersTable = table [];
table<Course> key(courseCode) courseTable = table [];

listener http:Listener ep0 = new (8080, config = {host: "localhost"});

service / on ep0 {
    # 
    #
    # + return - Ok 
    resource function get lecturers() returns Lecturer[] {
        return lecturersTable.toArray();
    }
    # 
    #
    # + payload - parameter description 
    # + return - returns can be any of following types
    # http:Created (Created)
    # BadRequestErrorResponse (BadRequest)
    resource function post lecturers(@http:Payload Lecturer lecturer) returns http:Created|BadRequestErrorResponse {
        //Validate lecturer information
        if (!isValidLecturer(lecturer)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid lecturer data"
                    }
                }
            };
        }

        //Add lecturer to table after successfull validation
        _= lecturersTable.add(lecturer);        

        //Return successfull response
        string lecturerUrl = string `/lecturers/${lecturer.staffNumber}`;
        return <ResourceCreated>{
            headers: {
                location: lecturerUrl
            }
        };

    }
    # 
    #
    # + staffNumber - parameter description 
    # + return - returns can be any of following types
    # Lecturer (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function get lecturers/[string staffNumber]() returns Lecturer|BadRequestErrorResponse {

        if (lecturersTable.hasKey(staffNumber)) {
            Lecturer foundLecturer = lecturersTable.get(staffNumber);
            return foundLecturer;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "LECTURER_NOT_FOUND",
                        message: "Lecturer not found"
                    }
                }
            };
        }

        
    }
    # 
    #
    # + staffNumber - parameter description 
    # + payload - parameter description 
    # + return - returns can be any of following types
    # http:Ok (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function put lecturers/[string staffNumber](@http:Payload Lecturer lecturer) returns http:Ok|BadRequestErrorResponse {

        if (!lecturersTable.hasKey(staffNumber)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "LECTURER_NOT_FOUND",
                        message: "Lecturer not found"
                    }
                }
            };
        }

        // Validate provided lecturer data
        if (!isValidLecturer(lecturer)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid lecturer data"
                    }
                }
            };
        }

        lecturersTable.put(lecturer);
        
        return <ResourceUpdated>{};


    }
    # 
    #
    # + staffNumber - parameter description 
    # + return - returns can be any of following types
    # Lecturer (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function delete lecturers/[string staffNumber]() returns Lecturer|BadRequestErrorResponse {

        if (lecturersTable.hasKey(staffNumber)) {
            Lecturer removed = lecturersTable.remove(staffNumber);
            return removed;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "LECTURER_NOT_FOUND",
                        message: "Lecturer not found"
                    }
                }
            };
        }


    }
    # 
    #
    # + officeNumber - parameter description 
    # + return - Ok 
    resource function get lecturers/office/[string officeNumber]() returns Lecturer[] {

        Lecturer[] lecturersInOffice = [];
        foreach var lecturer in lecturersTable {
            if (lecturer.officeNumber == officeNumber) {
                lecturersInOffice.push(lecturer);
            }
        }
        return lecturersInOffice;


    }
    # 
    #
    # + return - Ok 
    resource function get courses() returns Course[] {
        return courseTable.toArray();
    }
    # 
    #
    # + payload - parameter description 
    # + return - returns can be any of following types
    # http:Created (Created)
    # BadRequestErrorResponse (BadRequest)
    resource function post courses(@http:Payload Course course) returns http:Created|BadRequestErrorResponse {
        if (!isValidNewCourse(course)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid course data"
                    }
                }
            };
        }

        _= courseTable.add(course);
        string courseUrl = string `/courses/${course.courseCode}`;
        return <ResourceCreated>{
            headers: {
                location: courseUrl
            }
        };

    }
    # 
    #
    # + courseCode - parameter description 
    # + return - returns can be any of following types
    # Course (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function get courses/[string courseCode]() returns Course|BadRequestErrorResponse {
        if (courseTable.hasKey(courseCode)) {
            Course requestedCourse = courseTable.get(courseCode);
            return requestedCourse;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "COURSE_NOT_FOUND",
                        message: "Course not found"
                    }
                }
            };
        }

    }
    # 
    #
    # + courseCode - parameter description 
    # + payload - parameter description 
    # + return - returns can be any of following types
    # http:Ok (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function put courses/[string courseCode](@http:Payload Course course) returns http:Ok|BadRequestErrorResponse {
        if (!courseTable.hasKey(courseCode)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "COURSE_NOT_FOUND",
                        message: "Course not found"
                    }
                }
            };
        }

        if (!isValidUpdatedCourse(course)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid course data"
                    }
                }
            };
        }

        courseTable.put(course);
        return <ResourceUpdated>{};

    }
    # 
    #
    # + courseCode - parameter description 
    # + return - returns can be any of following types
    # Course (Ok)
    # BadRequestErrorResponse (BadRequest)
    resource function delete courses/[string courseCode]() returns Course|BadRequestErrorResponse {
        if (courseTable.hasKey(courseCode)) {
            Course removed = courseTable.remove(courseCode);
            return removed;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "COURSE_NOT_FOUND",
                        message: "Course not found"
                    }
                }
            };
        }
    }

    }
    
function isValidLecturer(Lecturer lecturer)  returns boolean {
    // Check if the staffNumber is unique
    if(lecturersTable.hasKey(lecturer.staffNumber)){
        return false;
    }

    // Check if all required fields are present and not empty
    if(lecturer.staffNumber == "" || lecturer.staffName == "" || lecturer.courses.length() == 0 || lecturer.officeNumber == "" || lecturer.title == ""){
        return false;
    }

    // Check if provided course codes for new lecturer exists in Course Table
    foreach var course in lecturer.courses {
        if(!courseTable.hasKey(course.courseCode)){
            return false;
        }
    }

    return true; 
}
function isValidNewCourse(Course course) returns boolean {
    // Check if the courseCode is unique
    if(courseTable.hasKey(course.courseCode)){
        return false;
    }

    return true; 
}

function isValidUpdatedCourse(Course course) returns boolean {
    // Check if all required fields are present and not empty
    if(course.courseCode == "" || course.courseName == "" || course.nqfLevel == ""){
        return false;
    }

    return true; 
}

