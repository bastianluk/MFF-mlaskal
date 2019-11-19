%language "c++"
%require "3.0.4"
%defines
%define parser_class_name{ mlaskal_parser }
%define api.token.constructor
%define api.token.prefix{DUTOK_}
%define api.value.type variant
%define parse.assert
%define parse.error verbose

%locations
%define api.location.type{ unsigned }

%code requires
{
	// this code is emitted to du3456g.hpp

	// allow references to semantic types in %type
#include "dutables.hpp"

	// avoid no-case warnings when compiling du3g.hpp
#pragma warning (disable:4065)

// adjust YYLLOC_DEFAULT macro for our api.location.type
#define YYLLOC_DEFAULT(res,rhs,N)	(res = (N)?YYRHSLOC(rhs, 1):YYRHSLOC(rhs, 0))
// supply missing YY_NULL in bfexpg.hpp
#define YY_NULL	0
#define YY_NULLPTR	0
}

%param{ mlc::yyscan_t2 yyscanner }	// formal name "yyscanner" is enforced by flex
%param{ mlc::MlaskalCtx* ctx }

%start mlaskal

%code
{
	// this code is emitted to du3456g.cpp

	// declare yylex here 
	#include "bisonflex.hpp"
	YY_DECL;

	// allow access to context 
	#include "dutables.hpp"

	// other user-required contents
	#include <assert.h>
	#include <stdlib.h>

    /* local stuff */
    using namespace mlc;

}

%token EOF	0	"end of file"

%token PROGRAM			/* program */
%token LABEL			    /* label */
%token CONST			    /* const */
%token TYPE			    /* type */
%token VAR			    /* var */
%token BEGIN			    /* begin */
%token END			    /* end */
%token PROCEDURE			/* procedure */
%token FUNCTION			/* function */
%token ARRAY			    /* array */
%token OF				    /* of */
%token GOTO			    /* goto */
%token IF				    /* if */
%token THEN			    /* then */
%token ELSE			    /* else */
%token WHILE			    /* while */
%token DO				    /* do */
%token REPEAT			    /* repeat */
%token UNTIL			    /* until */
%token FOR			    /* for */
%token OR				    /* or */
%token NOT			    /* not */
%token RECORD			    /* record */

/* literals */
%token<mlc::ls_id_index> IDENTIFIER			/* identifier */
%token<mlc::ls_int_index> UINT			    /* unsigned integer */
%token<mlc::ls_real_index> REAL			    /* real number */
%token<mlc::ls_str_index> STRING			    /* string */

/* delimiters */
%token SEMICOLON			/* ; */
%token DOT			    /* . */
%token COMMA			    /* , */
%token EQ				    /* = */
%token COLON			    /* : */
%token LPAR			    /* ( */
%token RPAR			    /* ) */
%token DOTDOT			    /* .. */
%token LSBRA			    /* [ */
%token RSBRA			    /* ] */
%token ASSIGN			    /* := */

/* grouped operators and keywords */
%token<mlc::DUTOKGE_OPER_REL> OPER_REL			    /* <, <=, <>, >=, > */
%token<mlc::DUTOKGE_OPER_SIGNADD> OPER_SIGNADD		    /* +, - */
%token<mlc::DUTOKGE_OPER_MUL> OPER_MUL			    /* *, /, div, mod, and */
%token<mlc::DUTOKGE_FOR_DIRECTION> FOR_DIRECTION		    /* to, downto */

%%

/* START - PROGRAM */
mlaskal:	    PROGRAM IDENTIFIER SEMICOLON block_p DOT;

/* BLOCK P */
block_p:		label_block const_block type_block var_block procfunc_decl_block code_block;
/* LABEL */
label_block:			| LABEL UINT label_blocks SEMICOLON;
label_blocks:			| COMMA UINT label_blocks;
/* CONST */
const_block:			| CONST IDENTIFIER EQ constant SEMICOLON const_blocks;
const_blocks:			| IDENTIFIER EQ constant SEMICOLON const_blocks;
/* TYPE */
type_block:			| TYPE IDENTIFIER EQ type SEMICOLON type_blocks;
type_blocks:		| IDENTIFIER EQ type SEMICOLON type_blocks;
/* VAR */
var_block:			| VAR IDENTIFIER identifiers COLON type SEMICOLON var_blocks;
var_blocks:			| IDENTIFIER identifiers COLON type SEMICOLON var_blocks;
/* PROC/FUNC */
procfunc_decl_block:		| procfunc_header SEMICOLON block SEMICOLON procfunc_decl_block;
procfunc_header:		procedure_header | function_header;
/* CODE */
code_block:		BEGIN statement statements END;
statements:		| SEMICOLON statement statements;

identifiers:	| COMMA IDENTIFIER identifiers;

/* BLOCK */
block:		label_block const_block type_block var_block code_block;

/* PROCEDURE HEADER */
procedure_header:		PROCEDURE IDENTIFIER LPAR formal_parameters RPAR
						| PROCEDURE IDENTIFIER;
/* FUNCTION HEADER */
function_header:		FUNCTION IDENTIFIER LPAR formal_parameters RPAR COLON IDENTIFIER /* scalar type identifier */
						| FUNCTION IDENTIFIER COLON IDENTIFIER /* scalar type identifier */;
/* FORMAL PARAMETERS */
formal_parameters:		VAR IDENTIFIER identifiers COLON IDENTIFIER formal_parameters_cycle
						|  IDENTIFIER identifiers COLON IDENTIFIER /* type identifier */ formal_parameters_cycle;
formal_parameters_cycle:			| SEMICOLON formal_parameters;

/*TYPES*/
type:		structured_type 
			| IDENTIFIER /* both ordinal type and type identifiers, by extension structured type indentifier */;

/* STRUCTERED TYPES */
structured_type:	record_type;

/* RECORD */
record_type:	RECORD field_list END
				| RECORD field_list SEMICOLON END;;
field_list:		| IDENTIFIER identifiers COLON type
				| field_list SEMICOLON IDENTIFIER identifiers COLON type;

/* STATEMENT */
statement:		optional_statement statement_inner | statement_inner;
optional_statement:		UINT COLON;
/* From slides */
statement_inner:	| m_statement | u_statement;
m_statement:	IF expression /* boolean expression */ THEN m_statement ELSE m_statement
				| WHILE expression /* boolean expression */ DO m_statement
				| FOR IDENTIFIER /* ordinal type or variable identifier */ ASSIGN expression /* ordinal expression */ FOR_DIRECTION expression /* ordinal expression */ DO m_statement
				| o_statement;
u_statement:	IF expression /* boolean expression */ THEN statement
				| IF expression /* boolean expression */ THEN m_statement ELSE u_statement
				| WHILE expression /* boolean expression */ DO u_statement
				| FOR IDENTIFIER /* ordinal type or variable identifier */ ASSIGN expression /* ordinal expression */ FOR_DIRECTION expression /* ordinal expression */ DO u_statement;
o_statement:	BEGIN statement statements END
				| REPEAT statement statements UNTIL expression /* boolean expression */
				| variable ASSIGN expression
				| IDENTIFIER /* function identifier */ ASSIGN expression
				| IDENTIFIER /* procedure identifier */
				| IDENTIFIER /* procedure identifier */ LPAR real_parameters RPAR
				| GOTO UINT;

/* VARIABLE */
variable:		IDENTIFIER /* record variable id */ DOT IDENTIFIER /* field identifier */;
/* REAL PARAMETERS */
real_parameters:		expression real_parameters_cycle;
real_parameters_cycle:	| COMMA real_parameters;

/* EXPRESSION */
expression:		simple_expression OPER_REL simple_expression
				| simple_expression EQ simple_expression
				| simple_expression;
/* SIMPLE EXPRESSION */
simple_expression:		OPER_SIGNADD term terms
						| term terms;
/* TERM */
term:		factor factors;
terms:		| OPER_SIGNADD term terms
			| OR term terms;
/* FACTOR */
factor:		unsign_constant
			| variable
			| IDENTIFIER /* function identifier */
			| IDENTIFIER LPAR real_parameters RPAR
			| LPAR expression RPAR
			| NOT factor;
factors:	| OPER_MUL factor factors;

/* CONSTANT */
constant:	IDENTIFIER /* unsigned constant identifier and constant identifier */
			| unsign_constant
			| OPER_SIGNADD UINT
			| OPER_SIGNADD REAL;

/* UNSIGNED CONSTANT */
unsign_constant:	UINT
					| REAL
					| STRING /* ' chars ' */;

/*
Left out:
- ordinal type
- ordinal constant
- unsigned integer
- unsigned real number
- identifier
- letter
- digit
*/

%%


namespace yy {

	void mlaskal_parser::error(const location_type& l, const std::string& m)
	{
		message(DUERR_SYNTAX, l, m);
	}

}

