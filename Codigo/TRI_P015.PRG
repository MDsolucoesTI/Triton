 /*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P015.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Baixa de Contas a Pagar
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=4, c_s:=11, l_i:=21, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss刼 negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北� BAIXA DE CONTAS � PAGAR 北北北北北北北�"
@ l_s+03,c_s+1 SAY " � Fornencedor 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+04,c_s+1 SAY " �      -                                          �"
@ l_s+05,c_s+1 SAY " � Documento 哪哪哪哪哪哪哪穆 Data Vencimento 哪哪拇"
@ l_s+06,c_s+1 SAY " �                          �                      �"
@ l_s+07,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+08,c_s+1 SAY "      � Caixa/Banco 哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+09,c_s+1 SAY "      �    -                                  �"
@ l_s+10,c_s+1 SAY "      � Histico Padr刼 哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+11,c_s+1 SAY "      �      -                                �"
@ l_s+12,c_s+1 SAY "      � Complemento do Histico 哪哪哪哪哪哪拇"
@ l_s+13,c_s+1 SAY "      �                                       �"
@ l_s+14,c_s+1 SAY "      � Data Pagamento � Valor Pago 哪哪哪哪哪�"
@ l_s+15,c_s+1 SAY "      �                �                      �"
@ l_s+16,c_s+1 SAY "      滥哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪�"
codigo=0                                                     // Cigo
documenp=SPAC(15)                                            // Documento
datap=CTOD('')                                               // Dt Vencimento
bancopag=0                                                   // Cigo do Banco
histopag=0                                                   // Cigo do Histico
comple=SPAC(35)                                              // Complemento
datapag=CTOD('')                                             // Data do Pagamento
valorpag=0                                                   // Valor Pago
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  codigo;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(codigo,04,00),'FORNEC',1)~Necess爎io informar CIGO")
                    AJUDA "Informe o cigo do Fornecedor|F8 Tabela Pick"
                    CMDF8 "VDBF(6,3,20,77,'FORNEC',{'codigo','razao','cgc','rg'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(FORNEC->razao,[]),35)", 4 , 11 }

   @ l_s+06 ,c_s+04 GET  documenp;
                    PICT "@!";
                    VALI CRIT("!EMPT(documenp)~Necess爎io informar o nero do documento")
                    AJUDA "Informe o nero do documento a ser pago|se houver tar噊s ou barras manter na digita噭o"

   @ l_s+06 ,c_s+31 GET  datap;
                    PICT "@D";
                    VALI CRIT("PTAB(STR(m->codigo,04,00)+m->documenp+DTOS(m->datap),'PAGAR',3)~Necess爎io informar Data de Vencimento")
                    AJUDA "Informe a Data de Vencimento|do Documento ou Parcela"
                    CMDF8 "VDBF(6,21,20,77,'PAGAR',{'seque','codigo','documen','vencimento'},3,'vencimento',[])"

   @ l_s+09 ,c_s+09 GET  bancopag;
                    PICT "99";
                    VALI CRIT("PTAB(STR(bancopag,02,00),'BANCOS',1)~CIGO DO BANCO n刼 existe na tabela")
                    AJUDA "Informe o Cigo do Banco|F8 Tabela Pick"
                    CMDF8 "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(BANCOS->descricao,[]),30)", 9 , 14 }

   @ l_s+11 ,c_s+09 GET  histopag;
                    PICT "999";
                    VALI CRIT("PTAB(STR(histopag,03,00),'HISTO',1)~Cigo n刼 aceit爒el")
                    AJUDA "Informe o Cigo do Histico Padr刼|F8 Tabela Pick"
                    CMDF8 "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(HISTO->descri,[]),30)", 11 , 16 }

   @ l_s+13 ,c_s+09 GET  comple;
                    PICT "@!"
                    AJUDA "Informe o complemento do Histico|se houver"

   @ l_s+15 ,c_s+09 GET  datapag;
                    PICT "@D";
                    VALI CRIT("!EMPT(datapag).and.TerCont(datapag)~Necess爎io informar Data do Pagamento")
                    DEFAULT "DataC"
                    AJUDA "Informe a Data do Pagamento"

   @ l_s+15 ,c_s+26 GET  valorpag;
                    PICT "@E 999,999,999,999.99";
                    VALI CRIT("valorpag>0~Valor Pago n刼 aceit爒el")
                    AJUDA "Informe o Valor Pago"

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
cod_sos=1
msgt="BAIXA DE CONTAS A PAGAR"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera噭o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE PAGAR
            IF !USEARQ("PAGAR",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("PAGAR")                                  // abre o dbf e seus indices
         #endi

         PTAB(STR(codigo,04,00),"FORNEC",1,.t.)              // abre arquivo p/ o relacionamento
         SET RELA TO STR(codigo,04,00) INTO FORNEC           // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("MOVIM",.t.,10,1)                              // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("MOVIM")                                           // abre o dbf e seus indices
#endi

   SELE PAGAR                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF m->codigo=codigo .And. m->documenp=documen .And. m->datap=vencimento// se atender a condicao...
         IF Empty(datapago)
            SELE MOVIM                                       // arquivo alvo do lancamento

            #ifdef COM_REDE
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               APPE BLAN                                     // cria registro em branco
            #endi

            SELE PAGAR                                       // inicializa registro em branco
            REPL MOVIM->data WITH m->datapag,;
                 MOVIM->documen WITH documen,;
                 MOVIM->contas WITH contas,;
                 MOVIM->banco WITH m->bancopag,;
                 MOVIM->tipo WITH [S],;
                 MOVIM->historico WITH m->histopag,;
                 MOVIM->complem WITH m->comple,;
                 MOVIM->valor WITH m->valorpag,;
                 MOVIM->custo WITH custo,;
                 MOVIM->obs WITH FORNEC->razao
            SELE MOVIM                                       // arquivo alvo do lancamento
            MOV_GET1(FORM_DIRETA)                            // faz processo do arq do lancamento

            #ifdef COM_REDE
               UNLOCK                                        // libera o registro
            #endi

            SELE PAGAR                                       // arquivo origem do processamento
         ENDI

         #ifdef COM_REDE
            REPBLO('PAGAR->valor',{||m->valorpag})
            REPBLO('PAGAR->datapago',{||m->datapag})
            REPBLO('PAGAR->banco',{||m->bancopag})
            REPBLO('PAGAR->historico',{||m->histopag})
         #else
            REPL PAGAR->valor WITH m->valorpag
            REPL PAGAR->datapago WITH m->datapag
            REPL PAGAR->banco WITH m->bancopag
            REPL PAGAR->historico WITH m->histopag
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE PAGAR                                                // salta pagina
   SET RELA TO                                               // retira os relacionamentos
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de TRI_P015.PRG
