/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Multim¡dia
 \ Programa: P00102F9.PRG
 \ Data....: 08-01-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Lan‡amento em RECIBO->agua, gerado por TRI_P001
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Local reg_dbf:=POINTER_DBF(),mResp:=0

If Select('OUTDES')=0
   Use OUTDES New
Else
   Sele OUTDES
EndIf

Set Filter To ((OUTDES->tipdes=2).and.(Month(OUTDES->dtvenc)=M->mes)).and.OUTDES->pasta=ALUGUEL->pasta
DBGOTOP()
Do While !Eof()
   mResp=mResp+OUTDES->valdes
   DbSkip()
EndDo

POINTER_DBF(reg_dbf)
RETU mResp  // <- deve retornar um valor NUMRICO

* \\ Final de P00102F9.PRG
