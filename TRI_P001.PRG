/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_P001.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerar Recibos Locat rios
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=21, l_i:=15, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±± Gera‡„o de Recibos - Locat rios ±±±±±"
@ l_s+03,c_s+1 SAY " Ú Referˆncia ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³       Mˆs:             Ano:          ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
mes=0                                                        // Mˆs
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+15 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<13~Mˆs n„o aceit vel")
                    AJUDA "Inforne o mˆs de referˆncia para|gerar os recibos de Aluguel"

   @ l_s+04 ,c_s+32 GET  ano;
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
msgt="GERAR RECIBOS LOCATRIOS"
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

         criterio:=cpord := ""                               // inicializa variaveis
         chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
   IF !USEARQ("ARECIBO",.t.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ARECIBO")                                         // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
   msg=FIEL(i)
   PRIV &msg.
NEXT
   SELE ALUGUEL                                              // processamentos apos emissao
   INI_ARQ()                                                 // acha 1o. reg valido do arquivo
   DO WHIL !EOF()
      IF !(Ptab(Str(codigo,06,00)+Str(pasta,04,00)+DtoS(CtoD(Str(venc,02,00)+'/'+Str(m->Mes,02,00)+'/'+Str(m->ano,04,00))),'ARecibo',2))
         SELE ARECIBO                                        // arquivo alvo do lancamento

         #ifdef COM_REDE
            ARE_CRIA_SEQ()
            SELE ARECIBO
            ARE_GERA_SEQ()
            DO WHIL .t.
               APPE BLAN                                     // tenta abri-lo
               IF NETERR()                                   // nao conseguiu
                  DBOX(ms_uso,20)                            // avisa e
                  LOOP                                       // tenta novamente
               ENDI
               EXIT                                          // ok. registro criado
            ENDD
         #else
            ARE_GERA_SEQ()
            APPE BLAN                                        // cria registro em branco
         #endi

         ARE_GRAVA_SEQ()
         SELE ALUGUEL                                        // inicializa registro em branco
         REPL ARECIBO->pasta WITH pasta,;
              ARECIBO->numrec WITH numrec+1,;
              ARECIBO->per1 WITH VerData(antcp,venc,m->mes,m->ano),;
              ARECIBO->per2 WITH CalData(ARECIBO->per1,30),;
              ARECIBO->venc WITH VerData([S],venc,m->mes,m->ano),;
              ARECIBO->valor1 WITH valor1,;
              ARECIBO->iptu1 WITH P00401F9(),;
              ARECIBO->agua WITH P00402F9(),;
              ARECIBO->luz WITH P00403F9(),;
              ARECIBO->telefone WITH P00404F9(),;
              ARECIBO->outros WITH P00405F9(),;
              ARECIBO->total WITH ARecibo->valor1+Arecibo->iptu1+arecibo->agua+arecibo->luz+arecibo->telefone+arecibo->outros,;
              ARECIBO->valor2 WITH arecibo->valor1*(1+(m->multa/100)),;
              ARECIBO->cla20 WITH 0,;
              ARECIBO->correc WITH 0,;
              ARECIBO->total2 WITH ARECIBO->valor2+ARECIBO->iptu1+ARECIBO->agua+ARECIBO->luz+ARECIBO->telefone+ARECIBO->outros,;
              ARECIBO->codalu WITH codigo

         #ifdef COM_REDE
            ARECIBO->(DBUNLOCK())                            // libera o registro
         #endi

      ENDI

      #ifdef COM_REDE
         IF ARECIBO->venc > datrec
            REPBLO('ALUGUEL->numrec',{||numrec+1})
         ENDI
         IF ARECIBO->venc > datrec
            REPBLO('ALUGUEL->datrec',{||ARECIBO->venc})
         ENDI
      #else
         IF ARECIBO->venc > datrec
            REPL ALUGUEL->numrec WITH numrec+1
         ENDI
         IF ARECIBO->venc > datrec
            REPL ALUGUEL->datrec WITH ARECIBO->venc
         ENDI
      #endi

      SKIP                                                   // pega proximo registro
   ENDD
   SET(_SET_DELETED,dele_atu)                                // os excluidos serao vistos
   ALERTA(2)
   DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de TRI_P001.PRG
