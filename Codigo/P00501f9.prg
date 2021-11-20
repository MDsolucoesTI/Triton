/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: P00301F9.PRG
 \ Data....: 08-01-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Lan‡amento em RECIBO->iptu, gerado por TRI_P003
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Local reg_dbf:=POINTER_DBF(),mResp:=0,op_sis
op_sis=EVAL(qualsis,"OUTDES")

#ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)        // se falhou a abertura do
      RETU                                             // arquivo volta ao menu anterior
   ENDI
#else
   USEARQ(sistema[op_sis,O_ARQUI])
#endi

Set Filter To ((OUTDES->tipdes=1).and.(Month(OUTDES->dtvenc)=M->mes)).and.OUTDES->pasta=ALUGUEL->pasta
DBGOTOP()
Do While !Eof()
   mResp=mResp+OUTDES->valdes
   DbSkip()
EndDo

POINTER_DBF(reg_dbf)
RETU mResp      // <- deve retornar um valor NUMRICO

* \\ Final de P00301F9.PRG
