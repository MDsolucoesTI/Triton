/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P002.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerar Outras Despesas
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=5, c_s:=14, l_i:=16, c_i:=69, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±± Gera‡„o de Outras Despesas ±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " É Pasta »"
@ l_s+04,c_s+1 SAY " º       º"
@ l_s+05,c_s+1 SAY " ÈÍÍÍÍÍÍÍ¼"
@ l_s+06,c_s+1 SAY " Ú Tipo de Despesa ÄÄÄÄÄÄÄÂ Valor ÄÄÄÄÄÄÄÂ Parcelas ¿"
@ l_s+07,c_s+1 SAY " ³    -                   ³              ³          ³"
@ l_s+08,c_s+1 SAY " Ã Vencimento Â Favorecido ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+09,c_s+1 SAY " ³            ³                                     ³"
@ l_s+10,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
pasta1=0                                                     // Pasta
tipdes=0                                                     // Tipo de Despesa
valdes=0                                                     // Valor Despesa
parc=0                                                       // Parcela
dtvenc=CTOD('')                                              // Data Vencimento
nome=SPAC(35)                                                // Nome
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  pasta1;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta1,04,00),'ALUGUEL',1)~Pasta n„o aceit vel")
                    AJUDA "Informe o N£mero da Pasta"
                    CMDF8 "VDBF(6,37,20,77,'ALUGUEL',{'pasta','codi','inicon','fincon'},1,'pasta',[])"

   @ l_s+07 ,c_s+04 GET  tipdes;
                    PICT "99";
                    VALI CRIT("PTAB(STR(tipdes,02,00),'DESPE',1)~Tipo de Despesa n„o aceit vel")
                    AJUDA "Informe o Tipo de Despesa"
                    CMDF8 "VDBF(6,54,20,77,'DESPE',{'codigo','tipodesp'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(DESPE->tipodesp,[]),15)", 7 , 9 }

   @ l_s+07 ,c_s+29 GET  valdes;
                    PICT "@E 999,999.99";
                    VALI CRIT("valdes <> 0~Valor da Despesa n„o aceit vel")
                    AJUDA "Informe o valor a ser pago pela despesa"

   @ l_s+07 ,c_s+44 GET  parc;
                    PICT "99";
                    VALI CRIT("parc>0~Parcela n„o aceit vel")
                    AJUDA "Informe o n£mero de ordem da parcela"

   @ l_s+09 ,c_s+04 GET  dtvenc;
                    PICT "@D";
                    VALI CRIT("!EMPT(dtvenc).and.TerCont(dtvenc)~Necess rio informar Data do Vencimento")
                    AJUDA "Informe a data de vencimento da despesa|1¦ parcela"

   @ l_s+09 ,c_s+17 GET  nome;
                    VALI CRIT("!EMPT(nome)~Necess rio informar o nome")
                    AJUDA "Informar o nome do Favorecido"

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
msgt="GERAR OUTRAS DESPESAS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            CLOSE ALUGUEL
            IF !USEARQ("ALUGUEL",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("ALUGUEL")                                // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("OUTDES",.t.,10,1)                             // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("OUTDES")                                          // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
   msg=FIEL(i)
   PRIV &msg.
NEXT
   SELE ALUGUEL                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF pasta=M->pasta1                                     // se atender a condicao...
         FOR nparc=1 TO m->Parc
            SELE OUTDES                                      // arquivo alvo do lancamento

            #ifdef COM_REDE
               OUT_CRIA_SEQ()
               SELE OUTDES
               OUT_GERA_SEQ()
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               OUT_GERA_SEQ()
               APPE BLAN                                     // cria registro em branco
            #endi

            OUT_GRAVA_SEQ()
            SELE ALUGUEL                                     // inicializa registro em branco
            REPL OUTDES->pasta WITH pasta,;
                 OUTDES->tipdes WITH m->TipDes,;
                 OUTDES->valdes WITH m->ValDes,;
                 OUTDES->parc WITH m->Parc,;
                 OUTDES->dtvenc WITH CalData(m->DtVenc,30*(nparc-1)),;
                 OUTDES->nome WITH m->Nome

            #ifdef COM_REDE
               OUTDES->(DBUNLOCK())                          // libera o registro
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

* \\ Final de TRI_P002.PRG
