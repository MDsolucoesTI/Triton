/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: MBD_02F9.PRG
 \ Data....: 20-09-95
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Valida‡„o do campo CODCONTA, arquivo MBDETA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"     // inicializa constantes manifestas

LOCAL reg_dbf:= POINTER_DBF(), cTipo:= '', lRetu:= .f.

If PTAB(codconta,'CONTAS',1) .and. CONTAS->tipo # 'T'
   If CONTAS->tipo = 'E'
      cTipo:= 'C'
   Else
      cTipo:= 'D'
   Endif
   If (cTipo = if(op_menu=1.or.op_menu=3,M->tipo,MBDETA->tipo))
      lRetu:= .t.
   Endif
Endif
POINTER_DBF(reg_dbf,.t.)

RETU lRetu       // <- deve retornar um valor L¢GICO

* \\ Final de MBD_02F9.PRG
