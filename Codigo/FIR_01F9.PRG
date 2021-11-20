/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: FIR_01F9.PRG
 \ Data....: 02-01-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: F¢rmula (TipoEmp) a mostrar na tela de FIRMA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters mTipoEmp
Local mResp

Do Case
   Case tipemp = '1'
      mResp='Atual   '
   Case tipemp = '2'
      mResp='Anterior'
   Case tipemp = '3'
      mResp='Conjuge '
EndCase


RETU mResp      // <- deve retornar um valor qualquer

* \\ Final de FIR_01F9.PRG
