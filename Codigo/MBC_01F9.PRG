/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: MBC_01F9.PRG
 \ Data....: 19-09-95
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Valida‡„o do campo MESANO, arquivo MBCABEC
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"     // inicializa constantes manifestas

M->anomes:= right(mesano,2) + '/' + left(mesano,2)

RETU .t.      // <- deve retornar um valor L¢GICO

* \\ Final de MBC_01F9.PRG
