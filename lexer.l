%{
    #include<stdio.h>
    #include"parser.tab.h"
    void yyerror(const char *s);
    int countn=0;
%}
%option yylineno
letter[A-Za-z]
digit [0-9]
del [ \t\n]

%%

"<?php"                           {fprintf(yyout, "<PHPstartingTag, %s>\n", yytext); return(PhpStart);}
"?>"                              {fprintf(yyout, "<PHPclosingTag, %s>\n", yytext); return(PhpEnd);}
[iI][fF]                          {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(IF);}
[eE][lL][sS][eE]                  {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(ELSE);}
[rR][eE][tT][uU][rR][nN]          {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(RETURN);}
[nN][eE][wW]	                  {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(NEWK);}
[eE][cC][hH][oO]                  {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(ECHO_T);} 
[fF][uU][nN][cC][tT][iI][oO][nN]  {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(FUNC);}
[cC][lL][aA][sS][sS]              { fprintf(yyout, "<Keyword, %s>\n", yytext); return (CLASS); }
[pP][uU][bB][lL][iI][cC]          { fprintf(yyout, "<Keyword, %s>\n", yytext); return (PUBLIC); }
[pP][rR][iI][vV][aA][tT][eE]      { fprintf(yyout, "<Keyword, %s>\n", yytext); return (PRIVATE); }
[pP][rR][oO][tT][eE][cC][tT][eE][dD]  { fprintf(yyout, "<Keyword, %s>\n", yytext); return (PROTECTED); }
[wW][hH][iI][lL][eE]              {fprintf(yyout, "<Keyword, %s>\n", yytext);  return(WHILE);}
"$"_?{letter}({letter}|{digit}|"_")*  {fprintf(yyout, "<Identifier, %s>\n", yytext); yylval = strdup(yytext); return(ID);}
_?{letter}({letter}|{digit}|"_")* {fprintf(yyout, "<Identifier, %s>\n", yytext);  return(FID);}
{digit}+                          {fprintf(yyout, "<Integer, %s>\n", yytext);  return(INT);}
{digit}+"."{digit}*               {fprintf(yyout, "<Float, %s>\n", yytext);  return(FLOAT);}
'[^\']'                           {fprintf(yyout, "<Character, %s>\n", yytext); return(CHAR);}
\"[^\"]*\"                        {fprintf(yyout, "<String, %s>\n", yytext);  return(STRING);}
"["|"{"|"("|")"|"}"|"]"|";"|","   {fprintf(yyout, "<PUN, %s>\n", yytext);  return yytext[0];}
("//"|"#").*                      {fprintf(yyout, "<SLC, %s>\n", yytext);}
"/*"(.|\n)*"*/"                   {fprintf(yyout, "<MLC, %s>", yytext);}
"<"|">"|"="|"*"|"+"|"/"|"-"|"%"|"."  {fprintf(yyout, "<Operator, %s>\n", yytext);  return yytext[0];}
"<="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(LE);}
">="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(GE);}
"=="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(ET);}
"!="                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(NE);}
"->"				  {fprintf(yyout, "<Operator, %s>\n", yytext);  return(ARROW);}
"**"                              {fprintf(yyout, "<Operator, %s>\n", yytext);  return(POW);}
"++"    { return INC; }  // Now INC is recognized
"--"    { return DEC; }

{del}*                                                
.                                 { fprintf(stderr, "Error: Unrecognized character: %s\n", yytext); yyerror("Lexical error"); }

%%
int yywrap(){return 1;}