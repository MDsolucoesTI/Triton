/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P031.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Baixa Recibo Locat爎io
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=17, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北 Baixa de Recibo do Locat爎io 北北北"
@ l_s+03,c_s+1 SAY " � Sequencia 目"
@ l_s+04,c_s+1 SAY " �            �"
@ l_s+05,c_s+1 SAY " � Data Pag. 呐 Valor Pago 哪哪哪哪哪哪目"
@ l_s+06,c_s+1 SAY " �            �                         �"
@ l_s+07,c_s+1 SAY " 滥哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪馁"
sequenp=0                                                    // Sequencia
datpagp=CTOD('')                                             // Data Pagamento
pagvalp=0                                                    // Pagamento
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  sequenp;
                    PICT "999999999";
                    VALI CRIT("PTAB(STR(sequenp,09,00),'ARECIBO',1)~Sequencia n刼 aceit爒el")
                    CMDF8 "VDBF(6,3,20,77,'ARECIBO',{'sequen','pasta','numrec','per1','per2','venc','valor1'},1,'sequenp',[Empty(datpag)])"

   @ l_s+06 ,c_s+04 GET  datpagp;
                    PICT "@D";
                    VALI CRIT("!EMPT(datpagp).and.TerCont(datpagp)~Necess爎io informar Data do Pagamento")
                    DEFAULT "DataC"
                    AJUDA "Informe a data do pagamento"

   @ l_s+06 ,c_s+17 GET  pagvalp;
                    PICT "@E 999,999.99";
                    VALI CRIT("!EMPT(pagvalp)~Necess爎io informar o Valor Pago")
                    AJUDA "Informe o valor pago"

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
msgt="BAIXA RECIBO LOCAT廟IO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera噭o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE ARECIBO
            IF !USEARQ("ARECIBO",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("ARECIBO")                                // abre o dbf e seus indices
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

   SELE ARECIBO                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF sequen=m->sequenp                                   // se atender a condicao...
         IF Empty(datpag)
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

            SELE ARECIBO                                     // inicializa registro em branco
            REPL MOVIM->data WITH m->datpagp
            Repl MOVIM->documen WITH Str(m->sequenp,09,00)
            Repl MOVIM->contas WITH 10
            Repl MOVIM->banco WITH 1
            Repl MOVIM->tipo WITH [E]
            Repl MOVIM->historico WITH 10
            Repl MOVIM->complem WITH [Pasta =]+Str(pasta,04,00)
            Repl MOVIM->valor WITH m->pagvalp
            Repl MOVIM->custo WITH 10
            SELE MOVIM                                       // arquivo alvo do lancamento
            MOV_GET1(FORM_DIRETA)                            // faz processo do arq do lancamento

            #ifdef COM_REDE
               UNLOCK                                        // libera o registro
            #endi

            SELE ARECIBO                                     // arquivo origem do processamento
         ENDI

         #ifdef COM_REDE
            REPBLO('ARECIBO->datpag',{||m->datpagp})
            REPBLO('ARECIBO->pagval',{||m->pagvalp})
         #else
            REPL ARECIBO->datpag WITH m->datpagp
            REPL ARECIBO->pagval WITH m->pagvalp
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

* \\ Final de TRI_P031.PRG
