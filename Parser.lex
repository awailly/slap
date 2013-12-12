%{
#include "Parser.h"

extern int lineNum;
extern int numchars;

%}

blanks          [ \t]+
identifier      [_a-zA-Z0-9]+
timers          "day"|"week"
verbs           "backup"|"verify"|"check"|"refuse"|"keep"|"disable"|"need"
subjects        "VM"|"backups"|"network"|"API"|"firewall"|"proxy"|"server"|"DHCP"|"client"|"alimentation"|"servers"
tools           "antivirus"
adjectives      "changes"
duration	"for"
properties      "redundant"
comp            ">"|"="|"<"

%s ACTIONLINE
%%

{blanks}                { numchars++; }
<ACTIONLINE>[\n]+       { numchars = 0; lineNum++; BEGIN INITIAL; return(EOL); }
[\n]                    { lineNum++; numchars = 0; }

"sla"                   {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(SLA); 
}
"{"                     {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(BLOCK); 
}
"}"                     {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(ENDBLOCK); 
}
"with"                  {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(WITH); 
}
"every"                 {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(TIME); 
}
{timers}                {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(TIMER); 
}
"logs"                  {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(SUBSUBJECT); 
}
{subjects}              {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    add_subject(yylval.sval);
    return(SUBJECT); 
}
{tools}                 {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(TOOL); 
}
{adjectives}            {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(ADJECTIVE); 
}
{duration}              {
    numchars += yyleng; 
    yylval.sval = strdup(yytext);
    return(DURATION); 
}
{properties}            {
    numchars += yyleng;
    yylval.sval = strdup(yytext);
    return(PROPERTY);
}
{comp}                  {
    numchars += yyleng;
    yylval.sval = strdup(yytext);
    return(COMP);
}

{verbs}                 {
    BEGIN ACTIONLINE; 
    numchars += yyleng;
    yylval.sval = strdup(yytext);
    return(VERB);
}
{identifier}            {
    numchars += yyleng;
    yylval.sval = strdup(yytext);
    return(IDENTIFIER);
}

%%

Policy_t *create_policy()
{
    char *d = malloc(sizeof
}

int add_subject(char *s)
{
    /* Allocate policy */
    Policy_t *pol = create_policy();

    /* Allocate subject */

    printf("Want to add %s\n", s);
}
