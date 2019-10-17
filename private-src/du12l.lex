%{
	// this code is emitted into du12l.cpp 
	// avoid macro redefinition warnings when compiling du1l.cpp
	#pragma warning (disable:4005)
	// avoid unreferenced parameter warnings when compiling du1l.cpp
	#pragma warning (disable:4100)
	// avoid unreferenced function warnings when compiling du1l.cpp
	#pragma warning (disable:4505)

	// allow access to YY_DECL macro
	#include "bisonflex.hpp"

	// allow access to context 
	// CHANGE THIS LINE TO #include "du3456g.hpp" WHEN THIS FILE IS COPIED TO du3456l.lex
	#include "dummyg.hpp"
%}

/* DO NOT TOUCH THIS OPTIONS! */
%option noyywrap nounput batch noinput stack reentrant
%option never-interactive

WHITESPACE[ \r\t\f\n]
DIGIT[0-9]
EXPONENT(E|e)(\+|\-)?{DIGIT}+
LETTERS[A-Za-z]

%%

%{
	typedef yy::mlaskal_parser parser;
%}


(?i:"program")	return parser::make_PROGRAM(ctx->curline);

(?i:"begin")	return parser::make_BEGIN(ctx->curline);

(?i:"end")	return parser::make_END(ctx->curline);

(?i:"procedure")	return parser::make_PROCEDURE(ctx->curline);

(?i:"function")	return parser::make_FUNCTION(ctx->curline);

(?i:"goto")	return parser::make_GOTO(ctx->curline);

(?i:"if")	return parser::make_IF(ctx->curline);

(?i:"then")	return parser::make_THEN(ctx->curline);

(?i:"else")	return parser::make_ELSE(ctx->curline);

(?i:"or")	return parser::make_OR(ctx->curline);

(?i:"not")	return parser::make_NOT(ctx->curline);

(?i:"for")	return parser::make_FOR(ctx->curline);

(?i:"while")	return parser::make_WHILE(ctx->curline);

(?i:"do")	return parser::make_DO(ctx->curline);

(?i:"repeat")	return parser::make_REPEAT(ctx->curline);

(?i:"until")	return parser::make_UNTIL(ctx->curline);

(?i:"record")	return parser::make_RECORD(ctx->curline);

(?i:"label")	return parser::make_LABEL(ctx->curline);

(?i:"var")	return parser::make_VAR(ctx->curline);

(?i:"type")	return parser::make_TYPE(ctx->curline);

(?i:"const")	return parser::make_CONST(ctx->curline);

(?i:"array")	return parser::make_ARRAY(ctx->curline);

(?i:"of")	return parser::make_OF(ctx->curline);

\,			return parser::make_COMMA(ctx->curline);

\.\.		return parser::make_DOTDOT(ctx->curline);

\.			return parser::make_DOT(ctx->curline);

\;			return parser::make_SEMICOLON(ctx->curline);

\=			return parser::make_EQ(ctx->curline);

\:			return parser::make_COLON(ctx->curline);

\(			return parser::make_LPAR(ctx->curline);

\)			return parser::make_RPAR(ctx->curline);

\[			return parser::make_LSBRA(ctx->curline);

\]			return parser::make_RSBRA(ctx->curline);

\:\=		return parser::make_ASSIGN(ctx->curline);

\>			return parser::make_OPER_REL(mlc::DUTOKGE_OPER_REL::DUTOKGE_GT, ctx->curline);

\<			return parser::make_OPER_REL(mlc::DUTOKGE_OPER_REL::DUTOKGE_LT, ctx->curline);

\>\=		return parser::make_OPER_REL(mlc::DUTOKGE_OPER_REL::DUTOKGE_GE, ctx->curline);

\<\=		return parser::make_OPER_REL(mlc::DUTOKGE_OPER_REL::DUTOKGE_LE, ctx->curline);

\<\>		return parser::make_OPER_REL(mlc::DUTOKGE_OPER_REL::DUTOKGE_NE, ctx->curline);

\+			return parser::make_OPER_SIGNADD(mlc::DUTOKGE_OPER_SIGNADD::DUTOKGE_PLUS, ctx->curline);

\-			return parser::make_OPER_SIGNADD(mlc::DUTOKGE_OPER_SIGNADD::DUTOKGE_MINUS, ctx->curline);

\*			return parser::make_OPER_MUL(mlc::DUTOKGE_OPER_MUL::DUTOKGE_ASTERISK, ctx->curline);

\/			return parser::make_OPER_MUL(mlc::DUTOKGE_OPER_MUL::DUTOKGE_SOLIDUS, ctx->curline);

(?i:"div")	return parser::make_OPER_MUL(mlc::DUTOKGE_OPER_MUL::DUTOKGE_DIV, ctx->curline);

(?i:"mod")	return parser::make_OPER_MUL(mlc::DUTOKGE_OPER_MUL::DUTOKGE_MOD, ctx->curline);

(?i:"and")	return parser::make_OPER_MUL(mlc::DUTOKGE_OPER_MUL::DUTOKGE_AND, ctx->curline);

(?i:"to")	return parser::make_FOR_DIRECTION(mlc::DUTOKGE_FOR_DIRECTION::DUTOKGE_TO, ctx->curline);

(?i:"downto")	return parser::make_FOR_DIRECTION(mlc::DUTOKGE_FOR_DIRECTION::DUTOKGE_DOWNTO, ctx->curline);

{DIGIT}+\.{DIGIT}+({EXPONENT})?	return parser::make_REAL(mlc::ls_real_index(), ctx->curline);

{DIGIT}+{EXPONENT}			return parser::make_REAL(mlc::ls_real_index(), ctx->curline);
			
{DIGIT}+		return parser::make_UINT(mlc::ls_int_index(), ctx->curline);

{LETTERS}({DIGIT}|{LETTERS})*	return parser::make_IDENTIFIER(mlc::ls_id_index(), ctx->curline);

{WHITESPACE}+		/* go out with whitespaces */

.			message(mlc::DUERR_UNKCHAR, ctx->curline, *yytext, *yytext);

<<EOF>>		return parser::make_EOF(ctx->curline);

%%

namespace mlc {

	yyscan_t2 lexer_init(FILE * iff)
	{
		yyscan_t2 scanner;
		yylex_init(&scanner);
		yyset_in(iff, scanner);
		return scanner;
	}

	void lexer_shutdown(yyscan_t2 scanner)
	{
		yyset_in(nullptr, scanner);
		yylex_destroy(scanner);
	}

}
