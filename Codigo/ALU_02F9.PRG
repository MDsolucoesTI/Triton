/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: ALU_02F9.PRG
 \ Data....: 05-01-96
 \ Sistema.: Triton - Controle Imobiliario
 \ Funcao..: Formula (Nome Fiador) a mostrar na tela de ALUGUEL
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters mCodigo
Local reg_dbf:=POINTER_DBF(), mResp
PTAB(STR(mCodigo,08,00),'PESSOA',1)
mResp=PESSOA->nome
POINTER_DBF(reg_dbf)
RETU mResp      // <- deve retornar um valor qualquer

* \\ Final de ALU_02F9.PRG
