/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R004.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Relao de Reajustes
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "ฑฑฑฑฑฑฑฑฑฑ Relao de Reajuste ฑฑฑฑฑฑฑฑฑฑฑ"
@ l_s+03,c_s+1 SAY " ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@ l_s+04,c_s+1 SAY " ณ         Ms de Reajuste :            ณ"
@ l_s+05,c_s+1 SAY " ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
mesrea=0                                                     // Mes
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+30 GET  mesrea;
                    PICT "99";
                    VALI CRIT("mesrea>0.and.mesrea<=12~Ms no aceit vel")
                    AJUDA "Informe o ms de reajuste a ser impresso"

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
   SET RELA TO STR(codi,08,00) INTO PESSOA                   // relacionamento dos arquivos
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,58,11)                   // nao quis configurar...
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
maxli=65                                                     // maximo de linhas no relatorio
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
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
         IF MONTH((inicon+(reaju*30)))=M->mesrea             // se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY TRAN(pasta,"9999")                  // Pasta
            @ cl,006 SAY "ณ"
            @ cl,008 SAY TRAN(valor1,"@E 999,999.99")        // Valor
            @ cl,019 SAY "ณ"
            @ cl,021 SAY TRAN(fincon,"@D")                   // Fim do Contrato
            @ cl,032 SAY "ณ"
            @ cl,034 SAY TRAN(codi,"99999999")               // Cขdigo Lacat rio
            @ cl,043 SAY "-"
            @ cl,045 SAY PESSOA->nome                        // Nome
            SKIP                                             // pega proximo registro
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(58)                                                    // grava variacao do relatorio
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
   @ 0,067 SAY "Pag :"
   @ 0,073 SAY TRAN(pg_,'9999')                              // nฃmero da p gina
   @ 1,024 SAY M->empresa                                    // Nome
   IMPAC("Relao de Reajustes de Alugueis no Ms :",3,019)
   @ 3,061 SAY M->mesrea                                     // mes
   @ 4,000 SAY "ออออออัออออออออออออัออออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออ"
   @ 5,001 SAY "Nง   ณ            ณ Venc.      ณ"
   IMPAC("Pasta ณ Valor      ณ Contrato   ณ Locat rio",6,000)
   @ 7,000 SAY "ฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
   cl=qt+7 ; pg_++
ENDI
RETU

* \\ Final de TRI_R004.PRG
