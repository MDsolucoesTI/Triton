/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: IMO_02F9.PRG
 \ Data....: 16-01-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Valida‡„o do campo PASTA, arquivo IMOVEIS
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
Ordem=.F.
Select IMOVEIS
If !BOF()
   Go Top
EndIf
If LastRec()>0
   Locate For pasta = x
   If Found()
      Alerta(2)
      Dbox("N£mero de Pasta j  Cadastrado|n„o ‚ permitido cadastrar|uma pasta mais de uma vez",,,4)
   Else
      Ordem=.T.
   EndIf
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)
RETU Ordem     // <- deve retornar um valor L¢GICO

* \\ Final de IMO_02F9.PRG
