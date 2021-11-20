/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_P025.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerar Posi‡„o Financeira
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±± Gerar Posi‡„o Financeira ±±±±±±±±"
@ l_s+03,c_s+1 SAY "      ÚÄÄÄÄÄÄÄÄÄ Data ÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY "      ³                         ³"
@ l_s+05,c_s+1 SAY "      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
datafim=CTOD('')                                             // Data Fim
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+15 GET  datafim;
                    PICT "@D";
                    VALI CRIT("!EMPT(datafim).and.TerCont(datafim)~Necess rio informar Data Fim")
                    AJUDA "Informe a Data Final do periodo|para a gera‡„o da posi‡„o financeira"

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
msgt="GERAR POSI€ŽO FINANCEIRA"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            IF !USEARQ("CUSTO",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("CUSTO")                                  // abre o dbf e seus indices
         #endi

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE CUSTO                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()

      #ifdef COM_REDE
         REPBLO('CUSTO->receber',{||0})
         REPBLO('CUSTO->recebvenc',{||0})
         REPBLO('CUSTO->pagar',{||0})
         REPBLO('CUSTO->pagovenc',{||0})
      #else
         REPL CUSTO->receber WITH 0
         REPL CUSTO->recebvenc WITH 0
         REPL CUSTO->pagar WITH 0
         REPL CUSTO->pagovenc WITH 0
      #endi

      SKIP                                                   // pega proximo registro
   ENDD

         #ifdef COM_REDE
            IF !USEARQ("RECEBER",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("RECEBER")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(custo,04,00),"CUSTO",1,.t.)                // abre arquivo p/ o relacionamento
         SET RELA TO STR(custo,04,00) INTO CUSTO             // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE RECEBER                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datapago).and.vencimento>m->DataFim           // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->receber',{||CUSTO->receber+valpagar})
         #else
            REPL CUSTO->receber WITH CUSTO->receber+valpagar
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE RECEBER                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("RECEBER",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("RECEBER")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(custo,04,00),"CUSTO",1,.t.)                // abre arquivo p/ o relacionamento
         SET RELA TO STR(custo,04,00) INTO CUSTO             // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE RECEBER                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datapago).and.vencimento<m->DataFim           // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->recebvenc',{||CUSTO->recebvenc+valpagar})
         #else
            REPL CUSTO->recebvenc WITH CUSTO->recebvenc+valpagar
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE RECEBER                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("ARECIBO",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("ARECIBO")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)              // abre arquivo p/ o relacionamento
         PTAB(STR(ALUGUEL->custos,04,00),"CUSTO",1,.t.)
         SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;         // relacionamento dos arquivos
                  TO STR(ALUGUEL->custos,04,00) INTO CUSTO
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE ARECIBO                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datpag).and.venc>m->DataFim                   // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->receber',{||CUSTO->receber+valor1})
         #else
            REPL CUSTO->receber WITH CUSTO->receber+valor1
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE ARECIBO                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("ARECIBO",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("ARECIBO")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)              // abre arquivo p/ o relacionamento
         PTAB(STR(ALUGUEL->custos,04,00),"CUSTO",1,.t.)
         SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;         // relacionamento dos arquivos
                  TO STR(ALUGUEL->custos,04,00) INTO CUSTO
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE ARECIBO                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datpag).and.venc<m->DataFim                   // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->recebvenc',{||CUSTO->recebvenc+valor2})
         #else
            REPL CUSTO->recebvenc WITH CUSTO->recebvenc+valor2
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE ARECIBO                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("PAGAR",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("PAGAR")                                  // abre o dbf e seus indices
         #endi

         PTAB(STR(custo,04,00),"CUSTO",1,.t.)                // abre arquivo p/ o relacionamento
         SET RELA TO STR(custo,04,00) INTO CUSTO             // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE PAGAR                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datapago).and.vencimento>m->DataFim           // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->pagar',{||CUSTO->pagar+valpagar})
         #else
            REPL CUSTO->pagar WITH CUSTO->pagar+valpagar
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE PAGAR                                                // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("PAGAR",.t.,10,1)                     // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("PAGAR")                                  // abre o dbf e seus indices
         #endi

         PTAB(STR(custo,04,00),"CUSTO",1,.t.)                // abre arquivo p/ o relacionamento
         SET RELA TO STR(custo,04,00) INTO CUSTO             // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE PAGAR                                                // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datapago).and.vencimento<m->DataFim           // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->pagovenc',{||CUSTO->pagovenc+valpagar})
         #else
            REPL CUSTO->pagovenc WITH CUSTO->pagovenc+valpagar
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE PAGAR                                                // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("LRECIBO",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("LRECIBO")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)              // abre arquivo p/ o relacionamento
         PTAB(STR(ALUGUEL->numrec,04,00),"CUSTO",1,.t.)
         SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;         // relacionamento dos arquivos
                  TO STR(ALUGUEL->numrec,04,00) INTO CUSTO
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE LRECIBO                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datpag).and.venc>m->DataFim                   // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->pagar',{||CUSTO->pagar+lprop})
         #else
            REPL CUSTO->pagar WITH CUSTO->pagar+lprop
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE LRECIBO                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos

         #ifdef COM_REDE
            IF !USEARQ("LRECIBO",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("LRECIBO")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)              // abre arquivo p/ o relacionamento
         PTAB(STR(ALUGUEL->custos,04,00),"CUSTO",1,.t.)
         SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;         // relacionamento dos arquivos
                  TO STR(ALUGUEL->custos,04,00) INTO CUSTO
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""
   SELE LRECIBO                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF Empty(datpag).and.venc<m->DataFim                   // se atender a condicao...

         #ifdef COM_REDE
            REPBLO('CUSTO->pagovenc',{||CUSTO->pagovenc+lprop2})
         #else
            REPL CUSTO->pagovenc WITH CUSTO->pagovenc+lprop2
         #endi

         SKIP                                                // pega proximo registro
      ELSE                                                   // se nao atende condicao
         SKIP                                                // pega proximo registro
      ENDI
   ENDD
   SELE LRECIBO                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de TRI_P025.PRG
