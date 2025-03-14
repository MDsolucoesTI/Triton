/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P017.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Estorno Contas a Pagar
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=12, l_i:=17, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss刼 negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北� ESTORNO DE CONTAS � PAGAR 北北北北北北�"
@ l_s+03,c_s+1 SAY " � Fornecedores 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目"
@ l_s+04,c_s+1 SAY " �      -                                          �"
@ l_s+05,c_s+1 SAY " � Documento 哪哪哪哪哪穆 Data da Baixa 哪哪哪哪哪拇"
@ l_s+06,c_s+1 SAY " �                      �                          �"
@ l_s+07,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪�"
codigo=0                                                     // Cigo
documenp=SPAC(15)                                            // Documento
datap=CTOD('')                                               // Data
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

   @ l_s+06 ,c_s+27 GET  datap;
                    PICT "@D";
                    VALI CRIT("!EMPT(datap).and.TerCont(datap)~Necess爎io informar Data do Pagamento")
                    AJUDA "Informe a data em que foi dado baixa"

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
msgt="ESTORNO CONTAS A PAGAR"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera噭o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            IF !USEARQ("PAGAR",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("PAGAR")                                  // abre o dbf e seus indices
         #endi

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
      IF m->codigo=codigo.And.m->documenp=documen .And. m->datap=datapago// se atender a condicao...
         IF !Empty(datapago)
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
            REPL MOVIM->data WITH datac,;
                 MOVIM->contas WITH contas,;
                 MOVIM->banco WITH banco,;
                 MOVIM->tipo WITH [E],;
                 MOVIM->documen WITH documen,;
                 MOVIM->historico WITH historico,;
                 MOVIM->complem WITH [Extorno],;
                 MOVIM->valor WITH valor,;
                 MOVIM->custo WITH custo,;
                 MOVIM->obs WITH obs
            SELE MOVIM                                       // arquivo alvo do lancamento
            MOV_GET1(FORM_DIRETA)                            // faz processo do arq do lancamento

            #ifdef COM_REDE
               UNLOCK                                        // libera o registro
            #endi

            SELE PAGAR                                       // arquivo origem do processamento
         ENDI

         #ifdef COM_REDE
            REPBLO('PAGAR->datapago',{||CtoD('  /  /    ')})
            REPBLO('PAGAR->valor',{||0})
         #else
            REPL PAGAR->datapago WITH CtoD('  /  /    ')
            REPL PAGAR->valor WITH 0
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de TRI_P017.PRG
