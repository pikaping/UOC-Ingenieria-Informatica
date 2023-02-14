#ifndef __PROJECT_H__
#define __PROJECT_H__
#include "csv.h"

typedef struct _tDate {    
    int day; 
    int month;
    int year;
} tDate;


// Parse a tDate from string information
void date_parse(tDate* date, const char* text);

// Compare two tDate structures and return true if they contain the same value or false otherwise.
bool date_equals(tDate date1, tDate date2);

// Maximum number of projects
// #define MAX_PROJECTS 150
// Maximum length of project code
#define MAX_PROJECT_CODE 7
// Maximum length of a ong code
#define MAX_ONG_CODE 3
// Maximum length of a ong name or a city
#define MAX_NAME 40


typedef struct {
    tDate date;
    char  city[MAX_NAME + 1];
    float cost;
    int   numPeople;
} tProjectDetail;

typedef struct {
    char code[MAX_PROJECT_CODE + 1];
    char ong[MAX_ONG_CODE+1];
    char ongName[MAX_NAME + 1];
    tProjectDetail detail;
} tProject;

typedef struct {
    //tProject elems[MAX_PROJECTS];
    tProject *elems;
    int count;
} tProjectData;


// Initialize the projects data
void projectData_init(tProjectData* data);

// Get the number of projects
int projectData_len(tProjectData data);

// Get a project
void projectData_get(tProjectData data, int index, char* buffer);

// Parse input from CSVEntry
void project_parse(tProject* proj, tCSVEntry entry);

// Remove all elements
void projectData_free(tProjectData* data);

// Add a new project
void projectData_add(tProjectData* data, tProject proj);

// Remove money and people from a project
void projectData_del(tProjectData* data, const char* code, const char* city, tDate date, float money, int numPeople);

// [AUX METHOD] Return the position of a project entry with provided information. -1 if it does not exist
int projectData_find(tProjectData data, const char* code, const char* city, tDate date);

// [AUX METHODS] Copy the data from the source to destination
void projectDetail_cpy(tProjectDetail* destination, tProjectDetail source);
void project_cpy(tProject* destination, tProject source);

#endif
