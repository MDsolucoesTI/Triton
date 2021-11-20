/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Cons. & Multim¡dia Ltda
 \ Programa: MBD_01F9.PRG
 \ Data....: 19-09-95
 \ Sistema.: Sistema Financeiro - 2.00
 \ Funcao..: Valida‡„o do campo SEQ, arquivo MBDETA
 \ Analista: Fernando - Solution
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"     // inicializa constantes manifestas

M->anomes:= right(mesano,2) + '/' + left(mesano,2)

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de MBD_01F9.PRG
