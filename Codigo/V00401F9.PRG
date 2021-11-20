/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: V00401F9.PRG
 \ Data....: 16-07-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: F¢rmula (Raz„o Social) a mostrar na tela de SFI_P004
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"      // inicializa constantes manifestas

Local x:=[]

x=If(Ptab(Str(Receber->Codigo,04,00),'Pessoa',1),Pessoa->Razao,'')

RETU x      // <- deve retornar um valor qualquer

* \\ Final de V00401F9.PRG
