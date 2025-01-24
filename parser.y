%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<ctype.h>
    extern int yylineno;
    extern FILE* yyin;
    extern FILE* yyout;
    int yywrap();
    int yylex();
    void yyerror(const char *str);
    extern char *yytext;
    int count=0;
    int q;

struct dataType {
        char * id_name;
        char * data_type;
	char* value;
        int line_no;
} symbol_table[40];
void add(char* var_name, char* datatype);
int search(char *id_name);
void insert_value(char* value);
%}

%token PhpStart PhpEnd PUBLIC PRIVATE PROTECTED ID INT NEWK FLOAT STRING CHAR LE GE ET NE POW IF ELSE FUNC WHILE ECHO_T FID CLASS ARROW RETURN INC DEC
%left '+' '-'
%left '*' '/' POW
%left LE GE ET NE '<' '>'

%%

ProgramBlock: PhpStart StatementList PhpEnd  {printf("Code Compiled Successfully");} 

StatementList : Statement StatementList 
              | 
              ;

Statement: AssStmt 
          | BoolExp
          | RepStmt
          | DecStruct
	  | ThisOperator ';'
          | OutStmt
          | FuncStmt
	  | ClassStmt
	  | FunctionCall ';'
	  ; 
          
AssStmt: ID '=' RHS ';' {$$=$1;add($$, "unknown"); };
ThisOperator: ID ARROW FunctionCall ;
RHS: Value OP RHS
   | Value;
Value: INT {insert_value(yytext); add($$, "int"); }
     | FLOAT {insert_value(yytext); add($$, "float"); }
     | STRING { insert_value(yytext); add($$, "string"); }
     | CHAR { insert_value(yytext); add($$, "char"); }
     | ID {  add($$, "unknown"); insert_value(yytext); }
     | FunctionCall
     | ClassCall 
     |ThisOperator;
OP: '+'
  | '-'
  | '*'
  | POW
  | '/';


BoolExp: Exp '>' Exp  
       | Exp '<' Exp  
       | Exp ET Exp   
       | Exp NE Exp   
       | Exp GE Exp   
       | Exp LE Exp   
       | INT	
       ;
Exp: INT | FLOAT | ID | Exp DEC | Exp INC;       


RepStmt: WHILE '(' BoolExp ')' '{' StatementList '}';


DecStruct: IF '(' BoolExp ')' '{' StatementList '}' 
         | IF '(' BoolExp ')' '{' StatementList '}' ELSE '{' StatementList '}' ;
 

OutStmt: ECHO_T Output ';' ;
Output: STRING
       | ID 
       | STRING '.' ID '.' STRING
       | STRING '.' FunctionCall '.' STRING ;

FuncStmt: FUNC FID'('FuncParameter')''{' StatementList OptionalReturn'}';
FuncParameter: ParamList | /*empty*/;
ParamList: Param 
         | Param ',' ParamList
         ;

Param: ID;

OptionalReturn: RETURN ReturnValue ';' |  ;

ReturnValue: ID
	   | FLOAT
	   | STRING
	   | INT; 

ClassStmt: CLASS FID '{' ClassMembers '}';

ClassMembers: ClassMember ClassMembers
            | 
	    ;

ClassMember: VisibilityOpt MemberDefinition;
MemberDefinition: PropertyDefinition
		| MethodDefinition
		;

PropertyDefinition: ID ';' ;

MethodDefinition: FuncStmt;

VisibilityOpt: PUBLIC | PRIVATE | PROTECTED | ; 

FunctionCall: FID'('FuncParameter')' ;

ClassCall: NEWK FID'('FuncParameter')';


%%

int main() {
  yyin = fopen("source.txt", "r");
  yyout = fopen("token.txt", "w");
  yyparse();
  printf("\nSYMBOL   DATATYPE  VALUE  LINE NUMBER \n");
  printf("_______________________________________\n\n");
  int i = 0;
  for (i = 0; i < count; i++) {
     printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].value, symbol_table[i].line_no);
  }
  FILE *symbolFile = fopen("identifiers.txt", "w");
  for (i = 0; i < count; i++) {
     fprintf(symbolFile, "%s\t%s\t%s\t%d\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].value, symbol_table[i].line_no);
  }
  fclose(symbolFile); 
  for(i=0;i<count;i++) {
     free(symbol_table[i].id_name);
     free(symbol_table[i].data_type);
     free(symbol_table[i].value);
  }
   
   fclose(yyin);
   fclose(yyout);
   return 0;
}
void add(char* var_name, char* datatype) {
    int index = search(var_name);
    if (index >= 0) {
        if (strcmp(datatype, "unknown") != 0) {
            symbol_table[index].value = strdup(yytext);
            symbol_table[index].data_type = strdup(datatype);
        }

        if (strcmp(datatype, "unknown") == 0) {
            insert_value(yytext);
            symbol_table[index].line_no = yylineno;
        }
    } else {
        symbol_table[count].id_name = strdup(var_name);

        if (strcmp(datatype, "unknown") != 0) {
            symbol_table[count].data_type = strdup(datatype);
        }

        if (strcmp(datatype, "unknown") == 0) {
            insert_value(yytext); 
            symbol_table[count].line_no = yylineno;
        }

        count++;
    }
}



void insert_value(char *value) {
    symbol_table[count].value = strdup(value);
}
int search(char *id_name) { 
    int i; 
    for(i = count - 1; i >= 0; i--) {
        if(strcmp(symbol_table[i].id_name, id_name) == 0) {   
            return i; 
        }
    } 
    return -1;
}

void yyerror(const char *str)
{
  printf("Code cannot be compiled\n");
  fprintf(stderr,"Error type: %s\n",str);
  fprintf(stderr,"Line number: %d\n",yylineno);
}