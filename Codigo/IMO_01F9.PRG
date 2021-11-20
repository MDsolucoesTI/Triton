/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: IMO_01F9.PRG
 \ Data....: 04-01-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: F¢rmula (opope) a mostrar na tela de IMOVEIS
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas
Parameters mTipo,mOpc

Local mResp

Do Case
   Case mTipo='1' .and. mOpc='S'
      mResp='Op‡„o para Venda    '
   Case mTipo='1' .and. mOpc='N'
      mResp='Sem Op‡„o de Venda  '
   Case mTipo='2' .and. mOpc='S'
      mResp='Op‡„o para Aluguel  '
   Case mTipo='2' .and. mOpc='N'
      mResp='Sem Op‡„o de Aluguel'
EndCase

RETU mResp      // <- deve retornar um valor qualquer

* \\ Final de IMO_01F9.PRG
