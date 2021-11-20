/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: V00401F9.PRG
 \ Data....: 16-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: F¢rmula (Raz„o Social) a mostrar na tela de SFI_P004
 \ Analista: Diretoria Desenvolvimento
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"      // inicializa constantes manifestas

Local x:=[]

x=If(Ptab(Str(Receber->Codigo,04,00),'Pessoa',1),Pessoa->Razao,'')

RETU x      // <- deve retornar um valor qualquer

* \\ Final de V00401F9.PRG
