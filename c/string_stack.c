#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

struct _Stack {
    char** elements;      
    int size;             
    int capacity;      };

// creates a new stack and initializes its properties
stack_response create() {
    stack_response response;
    stack s = (stack)malloc(sizeof(struct _Stack));
    if (!s) {
        response.code = out_of_memory;
        response.stack = NULL;
        return response;}
// init stack properties
    s->capacity = MAX_CAPACITY;
    s->size = 0;
    s->elements = (char**)malloc(s->capacity * sizeof(char*));
    if (!s->elements) {
        free(s);
        response.code = out_of_memory;
        response.stack = NULL;
        return response;}
    response.code = success;
    response.stack = s;
    return response;}

int size(const stack s) {
    return s->size;}

bool is_empty(const stack s) {
    return s->size == 0;}

bool is_full(const stack s) {
    return s->size >= MAX_CAPACITY;}
// pushes a new element onto the stack
response_code push(stack s, char* item) {
    if (strlen(item) > MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;}
    if (is_full(s)) {
        return stack_full;}
    char* copy = strdup(item);
    if (!copy) {
        return out_of_memory;}
    s->elements[s->size] = copy;
    s->size++;
    return success;}

string_response pop(stack s) {
    string_response response;
    if (is_empty(s)) {
        response.code = stack_empty;
        response.string = NULL;
        return response;
    }
    response.string = s->elements[s->size - 1];
    s->size--;
    response.code = success;
    return response;}

void destroy(stack* s) {
    if (*s) {
        for (int i = 0; i < (*s)->size; i++) {
            free((*s)->elements[i]);}
        free((*s)->elements);
        free(*s);
        *s = NULL;
    }
}
