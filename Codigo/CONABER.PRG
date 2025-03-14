/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CONABER.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili�rio
 \ Funcao..: Valores Pagos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=19, l_i:=14, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CON", op_sis:=EVAL(qualsis,"PAGAR")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "��������� Contas � Pagar - Pagos ���������"
@ l_s+03,c_s+1 SAY " � Data Inicial ������ Data Final �����Ŀ"
@ l_s+04,c_s+1 SAY " �                   �                  �"
@ l_s+05,c_s+1 SAY " ����������������������������������������"
datai=CTOD('')                                               // Data Inicial
dataf=CTOD('')                                               // Data Final
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  datai;
                    PICT "@D";
                    VALI CRIT("!EMPT(datai)~Necess�rio informar a data inicial")
                    DEFAULT "CtoD('01/01/1970')"
                    AJUDA "Informe a data inicial para a consulta"

   @ l_s+04 ,c_s+24 GET  dataf;
                    PICT "@D";
                    VALI CRIT("!EMPT(dataf)~Necess�rio informar a data final")
                    DEFAULT "DataC"
                    AJUDA "Informe a data final para a consulta"

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA(.f.)
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI
   EXIT
ENDD
op_menu=PROJECOES                                            // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
   IF !USEARQ("PAGAR",.f.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("PAGAR")                                           // abre o dbf e seus indices
#endi

PTAB(STR(codigo,04,00),"FORNEC",1,.t.)                       // abre arquivo p/ o relacionamento
PTAB(STR(custo,04,00),"CUSTO",1,.t.)
SET RELA TO STR(codigo,04,00) INTO FORNEC,;                  // relacionamento dos arquivos
         TO STR(custo,04,00) INTO CUSTO
col_cp={;                                                    // conteudo das colunas
          "vencimento",;
          "documen",;
          "codigo",;
          "TRAN(FORNEC->razao,[@!])",;
          "custo",;
          "TRAN(CUSTO->departa,[])";
       }
col_ti={;                                                    // titulo das colunas
          "Data",;
          "Documento",;
          "Fornecedor",;
          "Raz�o Social",;
          "Centro de Custos",;
          "Departamento";
       }
cr_="!Empty(datapago).and.(vencimento>=M->datai.and.vencimento<=M->dataf)"
                                                             // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
SELE PAGAR                                                   // salta pagina
SET RELA TO                                                  // retira os relacionamentos
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CONABER.PRG
