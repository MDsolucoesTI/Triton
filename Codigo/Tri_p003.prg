/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_P003.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerar Recibo Locat rio
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e mofificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=16, l_i:=14, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±± Gera‡„o de Recibo Individual - Locat rio ±±±±"
@ l_s+03,c_s+1 SAY "    Ú Pasta Â Referˆncia ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY "    ³       ³    Mˆs :         Ano :        ³"
@ l_s+05,c_s+1 SAY "    ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
pasta1=0                                                     // Pasta
mes=0                                                        // Mˆs
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+07 GET  pasta1;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta1,04,00),'ALUGUEL',1)~PASTA n„o aceit vel")
                    AJUDA "Informe o N£mero da Pasta"
                    CMDF8 "VDBF(6,37,20,77,'ALUGUEL',{'pasta','codi','inicon','fincon'},1,'pasta',[])"

   @ l_s+04 ,c_s+24 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<=12~MES n„o aceit vel")
                    AJUDA "Informe o mˆs de Referˆncia do Recibo"

   @ l_s+04 ,c_s+38 GET  ano;
                    PICT "9999";
                    VALI CRIT("ano>0~Necess rio informar o Ano")
                    AJUDA "Informe o ano de Referˆncia dos Recibos"

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
cod_sos=65
msgt="GERAR RECIBO LOCATRIO"
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
      IF pasta=m->pasta1                                     // se atender a condicao...
         IF (Ptab(Str(codigo,06,00)+Str(pasta,04,00)+DtoS(CtoD(Str(venc,02,00)+'/'+Str(m->Mes,02,00)+'/'+Str(m->ano,04,00))),'ARecibo',2))
            SELE ARECIBO                                     // arquivo alvo do lancamento
            SELE ALUGUEL                                     // inicializa registro em branco
            REPL ARECIBO->pasta WITH pasta,;
                 ARECIBO->numrec WITH numrec+1,;
                 ARECIBO->per1 WITH VerData(antcp,venc,m->mes,m->ano),;
                 ARECIBO->per2 WITH CalData(ARECIBO->per1,30),;
                 ARECIBO->venc WITH VerData([S],venc,m->Mes,m->ano),;
                 ARECIBO->valor1 WITH valor1,;
                 ARECIBO->iptu1 WITH P00501F9(),;
                 ARECIBO->agua WITH P00502F9(),;
                 ARECIBO->luz WITH P00503F9(),;
                 ARECIBO->telefone WITH P00504F9(),;
                 ARECIBO->outros WITH P00505F9(),;
                 ARECIBO->total WITH aRECIBO->valor1+aRECIBO->iptu1+aRECIBO->agua+aRECIBO->luz+aRECIBO->telefone+aRECIBO->outros,;
                 ARECIBO->valor2 WITH aRECIBO->valor1*(1+(m->multa/100)),;
                 ARECIBO->cla20 WITH 0,;
                 ARECIBO->correc WITH 0,;
                 ARECIBO->total2 WITH ARECIBO->valor2+ARECIBO->iptu1+ARECIBO->agua+ARECIBO->luz+ARECIBO->telefone+ARECIBO->outros,;
                 ARECIBO->codalu WITH codigo

         ELSE
           SELE ARECIBO                                     // arquivo alvo do lancamento

            #ifdef COM_REDE
               ARE_CRIA_SEQ()
               SELE ARECIBO
               ARE_GERA_SEQ()
               DO WHIL .t.
                  APPE BLAN                                  // tenta abri-lo
                  IF NETERR()                                // nao conseguiu
                     DBOX(ms_uso,20)                         // avisa e
                     LOOP                                    // tenta novamente
                  ENDI
                  EXIT                                       // ok. registro criado
               ENDD
            #else
               ARE_GERA_SEQ()
               APPE BLAN                                     // cria registro em branco
            #endi

            ARE_GRAVA_SEQ()
            SELE ALUGUEL                                     // inicializa registro em branco
            REPL ARECIBO->pasta WITH pasta,;
                 ARECIBO->numrec WITH numrec+1,;
                 ARECIBO->per1 WITH VerData(antcp,venc,m->mes,m->ano),;
                 ARECIBO->per2 WITH CalData(ARECIBO->per1,30),;
                 ARECIBO->venc WITH VerData([S],venc,m->Mes,m->ano),;
                 ARECIBO->valor1 WITH valor1,;
                 ARECIBO->iptu1 WITH P00501F9(),;
                 ARECIBO->agua WITH P00502F9(),;
                 ARECIBO->luz WITH P00503F9(),;
                 ARECIBO->telefone WITH P00504F9(),;
                 ARECIBO->outros WITH P00505F9(),;
                 ARECIBO->total WITH aRECIBO->valor1+aRECIBO->iptu1+aRECIBO->agua+aRECIBO->luz+aRECIBO->telefone+aRECIBO->outros,;
                 ARECIBO->valor2 WITH aRECIBO->valor1*(1+(m->multa/100)),;
                 ARECIBO->cla20 WITH 0,;
                 ARECIBO->correc WITH 0,;
                 ARECIBO->total2 WITH ARECIBO->valor2+ARECIBO->iptu1+ARECIBO->agua+ARECIBO->luz+ARECIBO->telefone+ARECIBO->outros,;
                 ARECIBO->codalu WITH codigo

            #ifdef COM_REDE
               ARECIBO->(DBUNLOCK())                         // libera o registro
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

* \\ Final de TRI_P003.PRG
