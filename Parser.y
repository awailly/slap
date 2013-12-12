%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct Validity_t
{
    int start;
    int end;
} Validity_t;

typedef struct Constraint_t
{
    char *verb;
    char *tool;
    int repetition;
    char *next;
} Constraint_t;

typedef struct Constraints_t
{
    Constraint_t *list;
} Constraints_t;

typedef struct Subject_t
{
    /* The subject name as defined in the second section of the lexer */
    char *name;

    /* Subject type to details if human, agent, service */
    char *type;
} Subject_t;

typedef struct Policy_t
{
    Subject_t *subject;
    Constraints_t *constraints;
    Validity_t *validity;
} Policy_t;

typedef struct Sla_policy_t
{
    Policy_t *start;
} Sla_policy_t;

int lineNum = 1;
int numchars = 1;
Sla_policy_t* global_sla;
%}

// Symbols.
%error-verbose
%union
{
    char *sval;
    int ival;
};
%token <sval> IDENTIFIER
%token SLA
%token BLOCK
%token ENDBLOCK
%token EOL
%token <sval> VERB
%token <sval> SUBJECT
%token <sval> SUBSUBJECT
%token ACTION
%token <sval> TIME
%token TIMER
%token <sval> WITH
%token TOOL
%token <sval> ADJECTIVE
%token <sval> DURATION
%token <sval> PROPERTY
%token <sval> COMP

%start Slas
%%

Slas:
    /* empty */
    | Slas Sla
    ;

Sla:
    SLA IDENTIFIER BLOCK { printf("SLA: %s\n", $2); }
    Parts
    ENDBLOCK
    ;

Parts:
    /* empty */
    | Parts Part
    ;

Part:
    VERB SUBJECT BLOCK { printf("\tVerb: %s for %s\n", $1, $2); }
        Actions
    ENDBLOCK
    | VERB SUBJECT Actions EOL { printf("\tVerb: %s for %s\n", $1, $2); }
    ;

Actions:
    /* empty */
    | Actions Action
    ;

Action:
    SUBSUBJECT { printf("\t\tActions: %s\n", $1); }
    | TIME TIMER { printf("\t\tTimer: %s\n", $1); }
    | WITH TOOL { printf("\t\tWith: %s\n", $1); }
    | ADJECTIVE { printf("\t\tAdjective: %s\n", $1); }
    | DURATION IDENTIFIER IDENTIFIER { printf("\t\tDuration: %s %s %s\n", $1, $2, $3); }
    | PROPERTY { printf("\t\tProperty: %s\n", $1); }
    | COMP IDENTIFIER { printf("\t\tIneq: %s num: %s\n", $1, $2); }
    ;
%%

int yyerror(char *s)
{
    printf("[%i, %i] yyerror: %s\n", lineNum, numchars, s);
}

int main(void)
{
    
    yyparse();
}
