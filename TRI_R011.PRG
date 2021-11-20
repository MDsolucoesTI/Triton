/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_R011.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Alugueis a Receber - Dia
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=11, c_s:=21, l_i:=16, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±± Alugueis a Receber - Dias ±±±±±±±±"
@ l_s+02,c_s+1 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+03,c_s+1 SAY "³ Dia Inicial :     ³ Dia Final :        ³"
@ l_s+04,c_s+1 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
mdia1=0                                                      // Dia Inicial
mdia2=0                                                      // Dia Final
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+03 ,c_s+17 GET  mdia1;
                    PICT "99";
                    VALI CRIT("mdia1>0~DIA INICIAL n„o aceit vel")
                    DEFAULT "1"
                    AJUDA "Informe o dia inical|que vocˆ deseja para a emiss„o|da Rela‡„o de Recebimentos"

   @ l_s+03 ,c_s+35 GET  mdia2;
                    PICT "99";
                    VALI CRIT("mdia2>0~DIA FINAL n„o aceit vel")
                    DEFAULT "31"
                    AJUDA "Informe o dia Final|que vocˆ deseja para a emiss„o|da Rela‡„o de Recebimentos"

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA(.f.)
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI

   #ifdef COM_REDE
      IF !USEARQ("ALUGUEL",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("ALUGUEL")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(codi,08,00),"PESSOA",1,.t.)                      // abre arquivo p/ o relacionamento
   PTAB(STR(codcomi,01,00),"COMISSAO",1,.t.)
   SET RELA TO STR(codi,08,00) INTO PESSOA,;                 // relacionamento dos arquivos
            TO STR(codcomi,01,00) INTO COMISSAO
   titrel:=criterio := ""                                    // inicializa variaveis
   cpord="STR(venc,02,00)"
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,57,11)                   // nao quis configurar...
      CLOS ALL                                               // fecha arquivos e
      LOOP                                                   // volta ao menu
   ENDI
   IF tps=2                                                  // se vai para arquivo/video
      arq_=ARQGER()                                          // entao pega nome do arquivo
      IF EMPTY(arq_)                                         // se cancelou ou nao informou
         LOOP                                                // retorna
      ENDI
   ELSE
      arq_=drvporta                                          // porta de saida configurada
   ENDI
   SET PRINTER TO (arq_)                                     // redireciona saida
   EXIT
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET DEVI TO PRIN                                             // inicia a impressao
maxli=62                                                     // maximo de linhas no relatorio
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot103007:=tot103009 := 0                              // inicializa variaves de totais
      DO WHIL !EOF()
         #ifdef COM_TUTOR
            IF IN_KEY()=K_ESC                                // se quer cancelar
         #else
            IF INKEY()=K_ESC                                 // se quer cancelar
         #endi
            IF canc()                                        // pede confirmacao
               BREAK                                         // confirmou...
            ENDI
         ENDI
         IF venc>=M->mdia1.and.venc<=M->mdia2                // se atender a condicao...
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY 'Total do Dia'                      // titulo da quebra
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            qb10301=venc                                     // campo para agrupar 1a quebra
            st10301007:=st10301009 := 0                      // inicializa sub-totais
            DO WHIL !EOF() .AND. venc=qb10301
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF venc>=M->mdia1.and.venc<=M->mdia2          // se atender a condicao...
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,001 SAY TRAN(pasta,"9999")            // Pasta
                  @ cl,007 SAY "³"
                  @ cl,009 SAY PESSOA->nome                  // Nome
                  @ cl,045 SAY "³"
                  @ cl,047 SAY TRAN(venc,"99")               // Vencimento
                  @ cl,051 SAY "³"
                  st10301007+=valor1
                  tot103007+=valor1
                  @ cl,053 SAY TRAN(valor1,"@E 999,999.99")  // Valor
                  @ cl,064 SAY "³"
                  st10301009+=valor1*(COMISSAO->comissao/100)
                  tot103009+=valor1*(COMISSAO->comissao/100)
                  @ cl,066 SAY TRAN(valor1*(COMISSAO->comissao/100),"@E 999,999.99")// Valor comiss„o
                  SKIP                                       // pega proximo registro
               ELSE                                          // se nao atende condicao
                  SKIP                                       // pega proximo registro
               ENDI
            ENDD
            IF cl+3>maxli                                    // se cabecalho do arq filho
               REL_CAB(0)                                    // nao cabe nesta pagina
            ENDI                                             // salta para a proxima pagina
            @ ++cl,053 SAY REPL('-',23)
            @ ++cl,053 SAY TRAN(st10301007,"@E 999,999.99")  // sub-tot Valor
            @ cl,066 SAY TRAN(st10301009,"@E 999,999.99")    // sub-tot Valor comiss„o
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,053 SAY REPL('-',23)
      @ ++cl,053 SAY TRAN(tot103007,"@E 999,999.99")         // total Valor
      @ cl,066 SAY TRAN(tot103009,"@E 999,999.99")           // total Valor comiss„o
   ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(57)                                                    // grava variacao do relatorio
SELE ALUGUEL                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,000 SAY M->cidade1                                    // Cidade
   @ 0,020 SAY ","
   @ 0,022 SAY NSEM(DATE())                                  // dia da semana
   @ 0,030 SAY "-"
   @ 0,032 SAY DTOC(DATE())                                  // data do sistema
   @ 0,057 SAY "Pag :"
   @ 0,063 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,017 SAY M->empresa                                    // Nome
   IMPAC("Rela‡„o de Vencimentos / Valores - de",3,011)
   @ 3,049 SAY TRAN(M->mdia1,"99")                           // Dia Inicial
   @ 3,052 SAY "a"
   @ 3,054 SAY TRAN(M->mdia2,"99")                           // Dia Final
   @ 4,000 SAY "ÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ"
   IMPAC("Pasta ³ Locat rio                           ³ Dia ³ Valor      ³ Comiss„o",5,001)
   @ 6,000 SAY "ÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R011.PRG
