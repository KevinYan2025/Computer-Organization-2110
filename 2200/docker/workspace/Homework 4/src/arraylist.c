/**
 * Name: Zhixiang Yan
 * GTID: 903810954
 */

/*  PART 2: A CS-2200 C implementation of the arraylist data structure.
    Implement an array list.
    The methods that are required are all described in the header file. 
    Description for the methods can be found there.

    Hint 1: Review documentation/ man page for malloc, calloc, and realloc.
    Hint 2: Review how an arraylist works.
    Hint 3: You can use GDB if your implentation causes segmentation faults.

    You will submit this file to gradescope.
*/

#include "arraylist.h"


/* Student code goes below this point */
arraylist_t *create_arraylist(uint capacity) {
    arraylist_t *list = (arraylist_t*)malloc(sizeof(arraylist_t));
    if (list == NULL) {
        return NULL;
    }
    list->capacity = capacity;
    list->size = 0;
    list->backing_array = (char **)malloc((capacity) * sizeof(char *));
    if (list->backing_array == NULL) {
        free(list);
        return NULL;
    }
    for(int i = 0; i < capacity; i++) {
        list->backing_array[i]=NULL;
    }
    return list;
}
void add_at_index(arraylist_t *arraylist, char *data, int index){

    if (arraylist->size >= arraylist->capacity) {
        resize(arraylist);
    }
    for(int i = arraylist->size; i > index; i--){
            arraylist->backing_array[i] =  arraylist->backing_array[i-1];
    }
    arraylist->backing_array[index] = data;
    arraylist->size += 1;
}

void append(arraylist_t *arraylist, char *data){

    if (arraylist->size >= arraylist->capacity) {
        resize(arraylist);
    }
    arraylist->backing_array[arraylist->size] = data;
    arraylist->size += 1;
}

char *remove_from_index(arraylist_t *arraylist, int index){
    if (index < 0 || index >= arraylist->size) {
            return NULL;
    }
    char *temp = arraylist->backing_array[index];
    arraylist->backing_array[index] = NULL;

    for(int i = index; i < arraylist->size - 1; i++) {
        arraylist->backing_array[i] = arraylist->backing_array[i + 1];
    }
    arraylist->backing_array[arraylist->size-1] = NULL;
    arraylist->size -= 1;
    return temp;

}

void resize(arraylist_t *arraylist){
    arraylist->capacity *= 2;
    char **temp_backing_array= realloc(arraylist->backing_array,(arraylist->capacity) * sizeof(char *));
    if (temp_backing_array == NULL) {
        free(arraylist->backing_array);
        arraylist->backing_array = NULL;
        arraylist->capacity = 0;
        return;
    }
    arraylist->backing_array = temp_backing_array;

}

void destroy(arraylist_t *arraylist){
    free(arraylist->backing_array);
    free(arraylist);
}
