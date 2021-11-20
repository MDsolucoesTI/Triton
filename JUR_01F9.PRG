/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Multim¡dia
 \ Programa: JUR_01F9.PRG
 \ Data....: 08-09-95
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Valida‡„o do campo CGC, arquivo JURIDICA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters x
LOCAL reg_dbf:=POINTER_DBF()
Ordem=.F.
Select PESSOA
Go Top
Locate For cgc = x
If Found()
   Alerta(2)
   Dbox("N£mero do CGC j  Cadastrado|n„o ‚ permitido cadastrar|uma pessoa mais de uma vez",,,4)
Else
   Ordem=.T.
EndIf
POINTER_DBF(reg_dbf)
RETURN(Ordem)       // <- deve retornar um valor L¢GICO
* \\ Final de JUR_01F9.PRG
