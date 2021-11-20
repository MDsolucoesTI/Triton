/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P035.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerar Recibos Locadores
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=15, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±± Gera‡„o de Recibos - Locador ±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Referˆncia ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³    Mˆs:                  Ano:        ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
mes=0                 // Mˆs
ano=0                 // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+12 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<13~Mˆs n„o aceit vel")
                    AJUDA "Inforne o mˆs de referˆncia para|gerar os recibos de Aluguel"

   @ l_s+04 ,c_s+34 GET  ano;
                    PICT "9999";
                    VALI CRIT("!EMPT(ano)~Necess rio informar o Ano")
                    AJUDA "Informe o ano de referˆncia para|gerar os recibos de aluguel"

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
msgt="GERAR RECIBOS LOCADORES"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
   DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
   dele_atu:=SET(_SET_DELETED,.t.)                           // os excluidos nao servem...

         #ifdef COM_REDE
            IF !USEARQ("ALUGUEL",.t.,10,1)                   // se falhou a abertura do arq
               RETU                                          // volta ao menu anterior
            ENDI
         #else
            USEARQ("ALUGUEL")                                // abre o dbf e seus indices
         #endi

         PTAB(STR(codcomi,01,00),"COMISSAO",1,.t.)           // abre arquivo p/ o relacionamento
         SET RELA TO STR(codcomi,01,00) INTO COMISSAO        // relacionamento dos arquivos
         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("LRECIBO",.t.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("LRECIBO")                                         // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
   msg=FIEL(i)
   PRIV &msg.
NEXT
   SELE ALUGUEL                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF (Ptab(Str(codigo,06,00)+Str(pasta,04,00)+DtoS(CtoD(Str(venc,02,00)+'/'+Str(m->Mes,02,00)+'/'+Str(m->ano,04,00))),'lRecibo',2))
         SELE LRECIBO                                        // arquivo alvo do lancamento
         SELE ALUGUEL                                        // inicializa registro em branco
        REPL LRECIBO->pasta WITH pasta,;
              LRECIBO->numrec WITH numrec,;
              LRECIBO->per1 WITH VerData(antcp,venc,m->mes,m->ano),;
              LRECIBO->per2 WITH CalData(LRECIBO->per1,30),;
              LRECIBO->venc WITH VerData([S],venc,m->mes,m->ano),;
              LRECIBO->valor1 WITH valor1,;
              LRECIBO->iptu1 WITH P00401F9(),;
              LRECIBO->agua WITH P00402F9(),;
              LRECIBO->luz WITH P00403F9(),;
              LRECIBO->telefone WITH P00404F9(),;
              LRECIBO->outros WITH P00405F9(),;
              LRECIBO->total WITH lRecibo->valor1+lrecibo->iptu1+lrecibo->agua+lrecibo->luz+lrecibo->telefone+lrecibo->outros,;
              LRECIBO->taxa WITH COMISSAO->comissao,;
              LRECIBO->adm WITH LRECIBO->valor1*(LRECIBO->taxa/100),;
              LRECIBO->lprop WITH LRECIBO->valor1-LRECIBO->adm,;
              LRECIBO->valor2 WITH lrecibo->valor1*(1+(m->multa/100)),;
              LRECIBO->cla20 WITH 0,;
              LRECIBO->correc WITH 0,;
              LRECIBO->total2 WITH LRECIBO->valor2+LRECIBO->iptu1+LRECIBO->agua+LRECIBO->luz+LRECIBO->telefone+LRECIBO->outros,;
              LRECIBO->adm2 WITH LRECIBO->valor2*(LRECIBO->taxa/100),;
              LRECIBO->lprop2 WITH LRECIBO->valor2-LRECIBO->adm2,;
              LRECIBO->codalu WITH codigo

      ELSE
        SELE LRECIBO                                        // arquivo alvo do lancamento

         #ifdef COM_REDE
            LRE_CRIA_SEQ()
            SELE LRECIBO
            LRE_GERA_SEQ()
            DO WHIL .t.
               APPE BLAN                                     // tenta abri-lo
               IF NETERR()                                   // nao conseguiu
                  DBOX(ms_uso,20)                            // avisa e
                  LOOP                                       // tenta novamente
               ENDI
               EXIT                                          // ok. registro criado
            ENDD
         #else
            LRE_GERA_SEQ()
            APPE BLAN                                        // cria registro em branco
         #endi

         LRE_GRAVA_SEQ()
         SELE ALUGUEL                                        // inicializa registro em branco
        REPL LRECIBO->pasta WITH pasta,;
              LRECIBO->numrec WITH numrec,;
              LRECIBO->per1 WITH VerData(antcp,venc,m->mes,m->ano),;
              LRECIBO->per2 WITH CalData(LRECIBO->per1,30),;
              LRECIBO->venc WITH VerData([S],venc,m->mes,m->ano),;
              LRECIBO->valor1 WITH valor1,;
              LRECIBO->iptu1 WITH P00401F9(),;
              LRECIBO->agua WITH P00402F9(),;
              LRECIBO->luz WITH P00403F9(),;
              LRECIBO->telefone WITH P00404F9(),;
              LRECIBO->outros WITH P00405F9(),;
              LRECIBO->total WITH lRecibo->valor1+lrecibo->iptu1+lrecibo->agua+lrecibo->luz+lrecibo->telefone+lrecibo->outros,;
              LRECIBO->taxa WITH COMISSAO->comissao,;
              LRECIBO->adm WITH LRECIBO->valor1*(LRECIBO->taxa/100),;
              LRECIBO->lprop WITH LRECIBO->valor1-LRECIBO->adm,;
              LRECIBO->valor2 WITH lrecibo->valor1*(1+(m->multa/100)),;
              LRECIBO->cla20 WITH 0,;
              LRECIBO->correc WITH 0,;
              LRECIBO->total2 WITH LRECIBO->valor2+LRECIBO->iptu1+LRECIBO->agua+LRECIBO->luz+LRECIBO->telefone+LRECIBO->outros,;
              LRECIBO->adm2 WITH LRECIBO->valor2*(LRECIBO->taxa/100),;
              LRECIBO->lprop2 WITH LRECIBO->valor2-LRECIBO->adm2,;
              LRECIBO->codalu WITH codigo

         #ifdef COM_REDE
            LRECIBO->(DBUNLOCK())                            // libera o registro
         #endi
      ENDIF
      SKIP                                                   // pega proximo registro
   ENDD
   SELE ALUGUEL                                              // salta pagina
   SET RELA TO                                               // retira os relacionamentos
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de TRI_P035.PRG
