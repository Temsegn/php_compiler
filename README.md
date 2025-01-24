# Mini_PHP-Compiler

Mini PHP Compiler with Syntax, Lexical, and Symbol Table Implementation using automated tools LEX and YACC
It is a case insensitive language.
This project implements the following:

1. Implement the lexical analysis phase.
2. Implement the syntax analysis phase.
3. Implement symbol table manager (Register Variables).
4. Report error in case of error (lex, syntax).

A source file “source.txt” containing the source
code of “Mini PHP” as input.
It writes all the tokens <TokenType, Lemexe> in
separate file “token.txt”.
It writes all the Identifiers in a separate file
“Identifier.txt”. Symbol table will be stored in the Identifier.txt file. (change of value of a variable to a different data type is also incorporated in this go and check source file and then identifiers file.)
If the code is successfully parsed showing the given
message
“Code Compiled Successfully”
If the code carries an error it displays the message
“Code cannot be compiled ” and also displays the
type and line number of error.

This project does not implement semantic actions and automatic error recovery techniques.

**Requirements for running this program:**

-> you must have gcc installed in your system.
(For installing gcc in Windows install **mingw** from this link https://sourceforge.net/projects/mingw/files/latest/download )

-> Bison and Flex should also installed.
(For this i'll provide the setup files in this repository.)

After meeting the requirements you should open this project in the command line terminal where your project exists and run the following commands:

**yacc -d parser.y**

**lex lexer.l**

**gcc -u parser lex.yy.c parser.tab.c**
**parser <filename>**
