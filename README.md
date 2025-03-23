# Database Project
Project for Structured Database course where the task were create a Datababse for an University with Schemas for an Engineering School, and schemas for Engineering programs and Library: 
- Systems Engineering.
- Electronic Engineering.
- Mechanical Engineering.
- Environmental Engineering.
- Industrial Engineering.
- Library.

By COPY, different .csv files were read to add data into different tables.

Across the whole project, some different constraints were added to ensure well-founded Database structure.

Also create views to query Teacher's and Student's information such as Program, Courses, Teach, Grades, etc. A view to query Library's information like Book Availability. And a view only for Admin User to query Stutents across different Courses.

Define roles for Students and Teachers to allow Student to query information about its Program (Courses and Grades), and for Teachers to query information about Courses  
and Students within its Courses. Also, define roles for Students and Teachers to query about information like Author, Books, and Book Availability.

Create triggers and functions: a function to create Student's Users, a function to allow a Teacher to update a Grade for its Students; a trigger for updates on Registered Courses, a trigger to check if a Student also has registered a Course, and a trigger to ensure unique data is added to Registered Courses.

This project includes a DML file where 25 queries has been used to test Database structure and performance.
