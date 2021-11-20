/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_R007.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Rendimentos de Vendas
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=15, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±± Rendimentos de Vendas ±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³       Mˆs :          Ano :           ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
mes=0                                                        // Mˆs
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+16 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<=12~Mˆs n„o aceit vel")
                    AJUDA "Informe o mˆs para o relat¢rio"

   @ l_s+04 ,c_s+31 GET  ano;
                    PICT "9999";
                    VALI CRIT("ano>0~ANO n„o aceit vel")
                    AJUDA "Informe o ano para a relat¢rio"

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
      IF !USEARQ("VENDAS",.f.,10,1)                          // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("VENDAS")                                       // abre o dbf e seus indices
   #endi

   PTAB(STR(corretor,08,00),"CORRETOR",1,.t.)                // abre arquivo p/ o relacionamento
   SET RELA TO STR(corretor,08,00) INTO CORRETOR             // relacionamento dos arquivos
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,60,11)                   // nao quis configurar...
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
IMPCTL(drvpcom)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot106002:=tot106007:=tot106009 := 0                   // inicializa variaves de totais
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
         IF MONTH(dataven)=M->mes.and.YEAR(dataven)=(M->ano)// se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,001 SAY TRAN(pasta,"9999")                  // Pasta
            @ cl,006 SAY "³"
            tot106002+=valor1
            @ cl,008 SAY TRAN(valor1,"@E 999,999,999,999.99")// Valor
            @ cl,027 SAY "³"
            @ cl,029 SAY TRAN(dataven,"@D")                  // Data Venda
            @ cl,038 SAY "³"
            @ cl,040 SAY TRAN(corretor,"99999999")           // C¢digo do Corretor
            @ cl,048 SAY "-"
            @ cl,049 SAY CORRETOR->nome                      // Nome Corretor
            @ cl,085 SAY "³"
            @ cl,087 SAY TRAN(comven,"99")                   // Comiss„o Vendedor
            @ cl,089 SAY "% -"
            tot106007+=valor1*(comven/100)
            @ cl,093 SAY TRAN(valor1*(comven/100),"@E 999,999,999.99")// Vl Vendedor
            @ cl,108 SAY "³"
            @ cl,110 SAY TRAN(comimo,"99")                   // Comiss„o Imobili ria
            @ cl,112 SAY "% -"
            tot106009+=valor1*(comimo/100)
            @ cl,116 SAY TRAN(valor1*(comimo/100),"@E 999,999,999.99")// Vl Imob
            SKIP                                             // pega proximo registro
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,008 SAY REPL('-',122)
      @ ++cl,008 SAY TRAN(tot106002,"@E 999,999,999,999.99") // total Valor
      @ cl,093 SAY TRAN(tot106007,"@E 999,999,999.99")       // total Vl Vendedor
      @ cl,116 SAY TRAN(tot106009,"@E 999,999,999.99")       // total Vl Imob
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(60)                                                    // grava variacao do relatorio
SELE VENDAS                                                  // salta pagina
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
   @ 0,119 SAY "Pag :"
   @ 0,125 SAY TRAN(pg_,'9999')                              // n£mero da p gina
   @ 1,053 SAY M->empresa                                    // Nome
   @ 3,060 SAY "Rendimentos de Vendas"
   @ 4,000 SAY "ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   IMPAC("Pasta ³ Valor da Venda     ³ Dt Venda ³ Corretor                                     ³ Comiss„o Corretor    ³ Comiss„o Imobili ria",5,000)
   @ 6,000 SAY "ÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R007.PRG
