/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P019.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Gera Parcelas a Receber
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=1, c_s:=12, l_i:=23, c_i:=69, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss刼 negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北北北 Gera Contas a Receber 北北北北北北北北�"
@ l_s+03,c_s+1 SAY " � Documento 哪哪哪�"
@ l_s+04,c_s+1 SAY " �                 �"
@ l_s+05,c_s+1 SAY " � Cliente 哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目"
@ l_s+06,c_s+1 SAY " �          -                                         �"
@ l_s+07,c_s+1 SAY " � Vencimento � Valor � Receber 哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+08,c_s+1 SAY " �            �                                       �"
@ l_s+09,c_s+1 SAY " � A噭o Financeira 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+10,c_s+1 SAY " �      -                                             �"
@ l_s+11,c_s+1 SAY " � Caixa/Banco 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+12,c_s+1 SAY " �    -                                               �"
@ l_s+13,c_s+1 SAY " � Histico Pad刼 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+14,c_s+1 SAY " �      -                                             �"
@ l_s+15,c_s+1 SAY " � Centro de Custo 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+16,c_s+1 SAY " �        -                                           �"
@ l_s+17,c_s+1 SAY " � Observa噭o 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+18,c_s+1 SAY " �                                                    �"
@ l_s+19,c_s+1 SAY " � Parcelas 履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+20,c_s+1 SAY " �          �"
@ l_s+21,c_s+1 SAY " 滥哪哪哪哪馁"
documenp=SPAC(15)                                            // Documento
codigop=0                                                    // Cigo do Cliente
vencimentp=CTOD('')                                          // Data
valpagarp=0                                                  // Vl Pagar
contasp=0                                                    // Cigo da Conta
bancop=0                                                     // Cigo do Banco
historicop=0                                                 // Histico
custop=0                                                     // Centro de Custos
obsp=SPAC(50)                                                // Observa噭o
parcelasp=0                                                  // Nero da Parcela
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  documenp;
                    PICT "@!";
                    VALI CRIT("!EMPT(documenp)~Necess爎io informar o nero do documento")
                    AJUDA "Informe o nero do documento a ser pago|se houver tar噊s ou barras manter na digita噭o"

   @ l_s+06 ,c_s+04 GET  codigop;
                    PICT "99999999";
                    VALI CRIT("PTAB(STR(codigop,08,00),'PESSOA',1)~Cigo do Cliente n刼 existe na tabela")
                    AJUDA "Informe o cigo do Cliente|F8 Tabela Pick"
                    CMDF8 "VDBF(6,3,20,77,'PESSOA',{'cod','nome','rg','cgc'},1,'cod',[])"
                    MOSTRA {"LEFT(TRAN(PESSOA->nome,[]),35)", 6 , 15 }

   @ l_s+08 ,c_s+04 GET  vencimentp;
                    PICT "@D";
                    VALI CRIT("!EMPT(vencimentp).and.TerCont(vencimentp)~Necess爎io informar o vencimento")
                    AJUDA "Informe a primeira data de vencimento"

   @ l_s+08 ,c_s+17 GET  valpagarp;
                    PICT "@E 999,999,999,999.99";
                    VALI CRIT("valpagarp>0~Valor n刼 aceit爒el")
                    AJUDA "Informe o valor a ser pago"

   @ l_s+10 ,c_s+04 GET  contasp;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(contasp,04,00),'CONTAS',1)~Necess爎io informar Cigo da Conta")
                    AJUDA "Informe o Cigo da A噭o Financeira|F8 Tabela Pick"
                    CMDF8 "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo<2000])"
                    MOSTRA {"LEFT(TRAN(CONTAS->descricao,[]),30)", 10 , 11 }

   @ l_s+12 ,c_s+04 GET  bancop;
                    PICT "99";
                    VALI CRIT("PTAB(STR(bancop,02,00),'BANCOS',1).or.Empty(bancop)~Cigo do Banco n刼 existe na tabela")
                    AJUDA "Informe o Cigo do Banco|F8 Tabela Pick"
                    CMDF8 "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(BANCOS->descricao,[]),30)", 12 , 9 }

   @ l_s+14 ,c_s+04 GET  historicop;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(historicop,04,00),'HISTO',1).or.Empty(historicop)~Cigo do Histico n刼 existe na tabela")
                    AJUDA "Informe o Cigo do Histico Padr刼|F8 Tabela Pick"
                    CMDF8 "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(HISTO->descri,[]),30)", 14 , 11 }

   @ l_s+16 ,c_s+04 GET  custop;
                    PICT "999999";
                    VALI CRIT("PTAB(STR(custop,06,00),'CUSTO',1).or.Empty(custop)~Centro de Custos n刼 existe na tabela")
                    AJUDA "Informe o Cigo do Centro de Custo|F8 Tabela Pick|se houver"
                    CMDF8 "VDBF(6,30,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(CUSTO->departa,[]),35)", 16 , 13 }

   @ l_s+18 ,c_s+04 GET  obsp
                    AJUDA "Informe uma observa噭o|se houver"

   @ l_s+20 ,c_s+04 GET  parcelasp;
                    PICT "99";
                    VALI CRIT("parcelasp>=0~Nero da Parcela n刼 aceit爒el")
                    AJUDA "Se for pagamentos parcelos|informe o nero da parcela|caso contr爎io digite 0"

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
msgt="GERA PARCELAS A RECEBER"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera噭o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE PESSOA
            IF !USEARQ("PESSOA",.t.,10,1)                    // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("PESSOA")                                 // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("RECEBER",.t.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("RECEBER")                                         // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
   msg=FIEL(i)
   PRIV &msg.
NEXT
   SELE PESSOA                                               // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF codigo=m->codigop                                   // se atender a condicao...
         FOR nparc=1 TO m->parcelasp
            SELE RECEBER                                     // arquivo alvo do lancamento

            #ifdef COM_REDE
               REC_CRIA_SEQ()
               SELE RECEBER
               REC_GERA_SEQ()
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               REC_GERA_SEQ()
               APPE BLAN                                     // cria registro em branco
            #endi

            REC_GRAVA_SEQ()
            SELE PESSOA                                      // inicializa registro em branco
            REPL RECEBER->seque WITH RECEBER->seque,;
                 RECEBER->data WITH Datac,;
                 RECEBER->documen WITH m->documenp,;
                 RECEBER->codigo WITH cod,;
                 RECEBER->vencimento WITH CalData(m->Vencimentp,30*(Nparc-1)),;
                 RECEBER->valpagar WITH m->valpagarp,;
                 RECEBER->contas WITH m->contasp,;
                 RECEBER->banco WITH m->bancop,;
                 RECEBER->historico WITH m->historicop,;
                 RECEBER->custo WITH m->custop,;
                 RECEBER->obs WITH m->obsp,;
                 RECEBER->parcelas WITH nparc

            #ifdef COM_REDE
               RECEBER->(DBUNLOCK())                         // libera o registro
            #endi

         NEXT
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

* \\ Final de TRI_P019.PRG
