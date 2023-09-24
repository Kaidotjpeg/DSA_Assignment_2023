// AUTO-GENERATED FILE.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/http;

public type BadRequestErrorResponse record {|
    *http:BadRequest;
    ErrorResponse body;
|};

# Represents an error
public type Error record {
    # Error code
    string code;
    # Error message
    string message;
};

# Represents a course
public type Course record {
    # Course Code (Unique identifier)
    string courseCode;
    # Course Name
    string courseName;
    # NQF Level
    string nqfLevel;
};

# Represents a lecturer
public type Lecturer record {
    # Staff Number (Unique identifier)
    string staffNumber;
    # Office Number
    string officeNumber;
    # Staff Name
    string staffName;
    # Title
    string title;
    # List of Courses
    Course[] courses;
};

# Error response
public type ErrorResponse record {
    # Represents an error
    Error 'error;
};