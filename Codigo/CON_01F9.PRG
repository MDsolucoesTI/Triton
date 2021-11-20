/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CON_01F9.PRG
 \ Data....: 04-09-95
 \ Sistema.: Sistema Financeiro - 2.00
 \ Funcao..: F¢rmula (Tipo) a mostrar na tela de CONTAS
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"      // inicializa constantes manifestas

Para xTipo
Local Ret:= Space(6)
Do Case
Case xTipo = 'E'
   Ret:= 'ntrada'
Case xTipo = 'S'
   Ret:= 'a¡da  '
Case xTipo = 'T'
   Ret:= '¡tulo '
EndCase

RETU Ret      // <- deve retornar um valor qualquer

* \\ Final de CON_01F9.PRG
