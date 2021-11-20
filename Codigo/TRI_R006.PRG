/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R006.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Rendimentos Anuais
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=21, l_i:=14, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±± Rendimentos Anuais ±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³  Ano Base para Relat¢rio :           ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+31 GET  ano;
                    PICT "9999";
                    VALI CRIT("ano>0~ANO n„o aceit vel")
                    DEFAULT "Year(Date())"
                    AJUDA "Informe o ano Base do Relat¢rio de Rendimentos"

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
      IF !USEARQ("ARECIBO",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("ARECIBO")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(codalu,06,00),"ALUGUEL",2,.t.)                   // abre arquivo p/ o relacionamento
   PTAB(STR(ALUGUEL->codcomi,01,00),"COMISSAO",1,.t.)
   PTAB(STR(pasta,04,00),"IMOVEIS",1,.t.)
   SET RELA TO STR(codalu,06,00) INTO ALUGUEL,;              // relacionamento dos arquivos
            TO STR(ALUGUEL->codcomi,01,00) INTO COMISSAO,;
            TO STR(pasta,04,00) INTO IMOVEIS
   titrel:=criterio := ""                                    // inicializa variaveis
   cpord="STR(codalu,06,00)+STR(numrec,04,00)"
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,51,11)                   // nao quis configurar...
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
      ult_imp=0                                              // ultimo reg impresso
      tot096021:=tot096023:=tot096024 := 0                   // inicializa variaves de totais
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
         IF !Empty(datpag)                                   // se atender a condicao...
            qb09601=codalu                                   // campo para agrupar 1a quebra
            DO WHIL !EOF() .AND. codalu=qb09601
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF !Empty(datpag)                             // se atender a condicao...
                  REL_CAB(1,.t.)                             // soma cl/imprime cabecalho
                  @ cl,003 SAY "³"
                  @ cl,005 SAY TRAN(MONTH(datpag),"99")      // mes
                  @ cl,009 SAY "³"
                  @ cl,013 SAY TRAN(datpag,"@D")             // Data Pagamento
                  @ cl,026 SAY "³"
                  valbruto=IF(datpag>venc,valor2+cla20+correc,valor1)// variavel temporaria
                  tot096021+=valbruto
                  @ cl,028 SAY TRAN(valbruto,"@E 999,999.99")// Valor Pago
                  @ cl,038 SAY "³"
                  @ cl,041 SAY TRAN(COMISSAO->comissao,"99") // Comiss„o
                  @ cl,049 SAY "³"
                  vlcom=valbruto*(COMISSAO->comissao/100)    // variavel temporaria
                  tot096023+=vlcom
                  @ cl,051 SAY TRAN(vlcom,"@E 999,999.99")   // valor Comiss„o
                  @ cl,063 SAY "³"
                  tot096024+=valbruto-vlcom
                  @ cl,065 SAY TRAN(valbruto-vlcom,"@E 999,999.99")// valor liquido
                  @ cl,079 SAY "³"
                  ult_imp=RECNO()                            // ultimo reg impresso
                  SKIP                                       // pega proximo registro
               ELSE                                          // se nao atende condicao
                  SKIP                                       // pega proximo registro
               ENDI
            ENDD
            cl=999                                           // forca salto de pagina
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,028 SAY REPL('-',46)
      @ ++cl,028 SAY TRAN(tot096021,"@E 999,999.99")         // total Valor Pago
      @ cl,051 SAY TRAN(tot096023,"@E 999,999.99")           // total valor Comiss„o
      @ cl,065 SAY TRAN(tot096024,"@E 999,999.99")           // total valor liquido
      REL_RDP(.t.)                                           // imprime rodape' do relatorio
   ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(51)                                                    // grava variacao do relatorio
SELE ARECIBO                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_RDP(volta_reg)                               // rodape'
LOCAL reg_atual:=RECNO()
IF volta_reg
   GO ult_imp                                                // ajusta reg p/ imp de campos no rodape'
ENDI
@ 64,000 SAY M->cidade1                                      // Cidade1
@ 64,020 SAY ",...de.............de......     Visto:......................"
IF volta_reg
   GO reg_atual                                              // retorna reg a posicao original
ENDI
RETU

STATIC PROC REL_CAB(qt, volta_reg)                           // cabecalho do relatorio
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   IF pg_>1
      REL_RDP(volta_reg)                                     // imprime rodape' do relatorio
   ENDI
   @ 0,003 SAY M->cidade1                                    // Cidade
   @ 0,023 SAY ","
   @ 0,025 SAY NSEM(DATE())                                  // dia da semana
   @ 0,033 SAY "-"
   @ 0,035 SAY DTOC(DATE())                                  // data do sistema
   @ 0,068 SAY "Ú Ano Base ¿"
   @ 1,003 SAY M->empresa                                    // Nome
   @ 1,068 SAY "³"
   @ 1,073 SAY TRAN(M->ano,"9999")                             // Ano
   @ 1,079 SAY "³"
   @ 2,068 SAY "ÃÄN§ Pasta ´"
   IMPAC("Relat¢rio Anual de Rendimentos                  ³",3,020)
   @ 3,072 SAY TRAN(IMOVEIS->pasta,"9999")                   // Pasta
   @ 3,079 SAY "³"
   @ 4,068 SAY "ÀÄÄÄÄÄÄÄÄÄÄÙ"
   @ 5,003 SAY "Ú Locador ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ CPF ÄÄÄÄÄÄÄÄÄÄÄÂ CGC ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 6,003 SAY "³"
   @ 6,005 SAY If(PTAB(STR(IMOVEIS->codpro,8,0),'PESSOA'),PESSOA->nome,'')// Locador
   @ 6,041 SAY "³"
   @ 6,043 SAY TRAN(PESSOA->cpf,"@R 999.999.999-99")         // CPF
   @ 6,058 SAY "³"
   @ 6,060 SAY TRAN(PESSOA->cgc,"@R 99.999.999/9999-99")     // CGC
   @ 6,079 SAY "³"
   IMPAC("Ã Locat rio ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ CPF ÄÄÄÄÄÄÄÄÄÄÄÅ CGCÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´",7,003)
   @ 8,003 SAY "³"
   @ 8,005 SAY If(PTAB(STR(ALUGUEL->codi,8,0),'PESSOA'),PESSOA->nome,'')// Locat rio
   @ 8,041 SAY "³"
   @ 8,043 SAY TRAN(PESSOA->cpf,"@R 999.999.999-99")         // CPF
   @ 8,058 SAY "³"
   @ 8,060 SAY TRAN(PESSOA->cgc,"@R 99.999.999/9999-99")     // CGC
   @ 8,079 SAY "³"
   @ 9,003 SAY "Ã Bem ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ 10,003 SAY "³"
   @ 10,005 SAY TRAN(IMOVEIS->tipoimo,"99")                  // Tipo do Bem
   @ 10,007 SAY "-"
   @ 10,008 SAY IF(PTAB(IMOVEIS->tipoimo,'TIPOIMO'),TIPOIMO->tipoimo,'')// Nome do Tipo
   @ 10,026 SAY IMOVEIS->ender                               // Endere‡o
   @ 10,061 SAY ","
   @ 10,063 SAY TRAN(IMOVEIS->numero,"99999")                // N£mero
   @ 10,079 SAY "³"
   @ 11,003 SAY "³"
   @ 11,005 SAY IMOVEIS->compl                               // Complemento
   @ 11,026 SAY "-"
   @ 11,028 SAY IMOVEIS->cidade                              // Cidade
   @ 11,049 SAY "/"
   @ 11,051 SAY TRAN(IMOVEIS->uf,"!!")                       // UF
   @ 11,079 SAY "³"
   @ 12,003 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ 13,003 SAY "ÚÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   IMPAC("³ Mˆs ³ Data Pagamento ³ Valor     ³ Comiss„o ³ Vl Comiss„o ³ Valor Liquido ³",14,003)
   @ 15,003 SAY "ÃÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   cl=qt+15 ; pg_++
ENDI
RETU

* \\ Final de TRI_R006.PRG
