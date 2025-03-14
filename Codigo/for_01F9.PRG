/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: FOR_01F9.PRG
 \ Data....: 08-07-96
 \ Sistema.: Triton - Controle Imobili�rio
 \ Funcao..: Valida��o do campo RG, arquivo FORNEC
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
Ordem=.F.
Select FORNEC
If !BOF()
   Go Top
EndIf
If LastRec()>0
   Locate For rg = x
   If Found()
      Alerta(2)
      Dbox("N�mero do RG j� Cadastrado|n�o � permitido cadastrar|um Fornecedor mais de uma vez",,,4)
   Else
      Ordem=.T.
   EndIf
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)

RETURN(Ordem)       // <- deve retornar um valor L�GICO

* \\ Final de FOR_01F9.PRG
