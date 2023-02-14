#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include "project.h"

// Parse a tDate from string information
void date_parse(tDate* date, const char* text)
{
    // Check output data
    assert(date != NULL);
    
    // Check input date
    assert(text != NULL);
    assert(strlen(text) == 10);
    
    // Parse the input date
    sscanf(text, "%d/%d/%d", &(date->day), &(date->month), &(date->year));
}

// Compare two tDate structures and return true if they contain the same value or false otherwise.
bool date_equals(tDate date1, tDate date2)
{
    return (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year); 
}

// EX2: Implement your methods here....

// Initialize the projects data
void projectData_init(tProjectData* data)
{
    // TODO
    
    /////////////
    // Set the initial number of elements to zero.
    data->count = 0;
    /////////////
}

// Get the number of projects
int projectData_len(tProjectData data)
{
    // TODO
    //return -1;
    
    //////////////
    // Return the number of elements
    return data.count;
    //////////////
}

// Get a project
void projectData_get(tProjectData data, int index, char* buffer)
{
    // TODO
    
    /////////////
    tProject *elem;

    assert(index < data.count);
    elem = &(data.elems[index]);
    sprintf(buffer, "%02d/%02d/%04d;%s;%s;%s;%s;%.2f;%d", 
            elem->detail.date.day, elem->detail.date.month, elem->detail.date.year,
            elem->ong, elem->ongName, elem->detail.city, elem->code,
	        elem->detail.cost, elem->detail.numPeople);
    /////////////
}

// Parse input from CSVEntry
void project_parse(tProject* proj, tCSVEntry entry)
{
    // TODO
    
    /////////////
    char date[11];
    
    // Check input data (Pre-conditions)
    assert(proj != NULL);    
    assert(csv_numFields(entry) == 7);
    
    // Get the date 
    csv_getAsString(entry, 0, date, 11);    
    date_parse(&(proj->detail.date), date);
    
    // Assign the ong code
    csv_getAsString(entry, 1, proj->ong, MAX_ONG_CODE + 1);
        
    // Assign the ong name
    csv_getAsString(entry, 2, proj->ongName, MAX_NAME + 1);

    // Assign the city
    csv_getAsString(entry, 3, proj->detail.city, MAX_NAME + 1);

    // Assign the project code
    csv_getAsString(entry, 4, proj->code, MAX_PROJECT_CODE + 1);

    // Assign the cost
    proj->detail.cost = csv_getAsReal(entry, 5);

    // Set the number of people
    proj->detail.numPeople = csv_getAsInteger(entry, 6);
    /////////////
}

////////////////////////////////////////

// Add a new project
void projectData_add(tProjectData* data, tProject proj)
{
    int idx;
    // Check input data (Pre-conditions)
    assert(data != NULL);    
    
    // Check if an entry with this data already exists
    idx = projectData_find(*data, proj.code, proj.detail.city, proj.detail.date);
    
    // If it does not exist, create a new entry, otherwise add the money and thenumber of people
    if (idx < 0) {
        assert(data->count < MAX_PROJECTS);
        project_cpy(&(data->elems[data->count]), proj);
        data->count++;        
    } else {
        data->elems[idx].detail.cost += proj.detail.cost;
        data->elems[idx].detail.numPeople += proj.detail.numPeople;
    }
}

// Remove money and people from a project
void projectData_del(tProjectData* data, const char* code, const char* city, tDate date, float money, int numPeople)
{
    int idx;
    int i;
    
    // Check if an entry with this data already exists
    idx = projectData_find(*data, code, city, date);
    
    if (idx >= 0) {
        // Reduce the cost and number of people
        data->elems[idx].detail.cost -= money;
        data->elems[idx].detail.numPeople -= numPeople;
        // Shift elements to remove selected
        if ((data->elems[idx].detail.cost <= 0.0) || (data->elems[idx].detail.numPeople <= 0)) {
        
            for(i = idx; i < data->count-1; i++) {
                // Copy element on position i+1 to position i
                project_cpy(&(data->elems[i]), data->elems[i+1]);
            }
            // Update the number of elements
            data->count--;     
        }
    }
}

// [AUX METHOD] Return the position of a project entry with provided information. -1 if it does not exist
int projectData_find(tProjectData data, const char* code, const char* city, tDate date)
{
    int i;
    int res = -1;

    i = 0;
    while ((i < data.count) && (res < 0)) 
    {
        if((strcmp(data.elems[i].code, code) == 0) && (strcmp(data.elems[i].detail.city, city) == 0) && date_equals(data.elems[i].detail.date, date)) 
            res = i;
        else 
            i++;
    }
    
    return res;
}

// [AUX METHODS] Copy the data from the source to destination
void projectDetail_cpy(tProjectDetail* destination, tProjectDetail source)
{
    destination->date = source.date;
    strcpy(destination->city, source.city);
    destination->cost = source.cost;
    destination->numPeople = source.numPeople;
}

void project_cpy(tProject* destination, tProject source)
{
    strcpy(destination->code, source.code);
    strcpy(destination->ong, source.ong);
    strcpy(destination->ongName, source.ongName);
    projectDetail_cpy(&(destination->detail), source.detail);
}
