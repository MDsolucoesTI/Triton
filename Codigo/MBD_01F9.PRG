/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: MBD_01F9.PRG
 \ Data....: 19-09-95
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Valida‡„o do campo SEQ, arquivo MBDETA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"     // inicializa constantes manifestas

M->anomes:= right(mesano,2) + '/' + left(mesano,2)

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de MBD_01F9.PRG
