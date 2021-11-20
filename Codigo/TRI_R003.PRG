/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R003.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Relao de Alugueis
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emisso negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
nucop=1

#ifdef COM_REDE
   IF !USEARQ("ALUGUEL",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ALUGUEL")                                         // abre o dbf e seus indices
#endi

PTAB(STR(codi,08,00),"PESSOA",1,.t.)                         // abre arquivo p/ o relacionamento
PTAB(STR(codcomi,01,00),"COMISSAO",1,.t.)
SET RELA TO STR(codi,08,00) INTO PESSOA,;                    // relacionamento dos arquivos
         TO STR(codcomi,01,00) INTO COMISSAO
titrel:=criterio := ""                                       // inicializa variaveis
cpord="STR(venc,02,00)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,56,11)                      // nao quis configurar...
   CLOS ALL                                                  // fecha arquivos e
   RETU                                                      // volta ao menu
ENDI
IF tps=2                                                     // se vai para arquivo/video
   arq_=ARQGER()                                             // entao pega nome do arquivo
   IF EMPTY(arq_)                                            // se cancelou ou nao informou
      RETU                                                   // retorna
   ENDI
ELSE
   arq_=drvporta                                             // porta de saida configurada
ENDI
SET PRINTER TO (arq_)                                        // redireciona saida
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET DEVI TO PRIN                                             // inicia a impressao
maxli=65                                                     // maximo de linhas no relatorio
SET MARG TO 10                                               // ajusta a margem esquerda
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot102006:=tot102007 := 0                              // inicializa variaves de totais
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
         REL_CAB(1)                                          // soma cl/imprime cabecalho
         @ cl,001 SAY TRAN(pasta,"9999")                     // Pasta
         @ cl,007 SAY "ณ"
         @ cl,009 SAY PESSOA->nome                           // Nome
         @ cl,045 SAY "ณ"
         @ cl,047 SAY TRAN(venc,"99")                        // Vencimento
         @ cl,051 SAY "ณ"
         tot102006+=valor1
         @ cl,053 SAY TRAN(valor1,"@E 999,999.99")           // Valor
         @ cl,064 SAY "ณ"
         tot102007+=valor1*(COMISSAO->comissao/100)
         @ cl,066 SAY TRAN(valor1*(COMISSAO->comissao/100),"@E 999,999.99")// Valor da comisso
         SKIP                                                // pega proximo registro
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,053 SAY REPL('-',23)
      @ ++cl,053 SAY TRAN(tot102006,"@E 999,999.99")         // total Valor
      @ cl,066 SAY TRAN(tot102007,"@E 999,999.99")           // total Valor da comisso
   ENDD ccop
END SEQUENCE
SET MARG TO                                                  // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(56)                                                    // grava variacao do relatorio
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
   @ 0,063 SAY TRAN(pg_,'9999')                              // nฃmero da p gina
   @ 1,016 SAY M->empresa                                    // Nome
   IMPAC("Relao de Vencimentos / Valores",3,018)
   @ 4,000 SAY "อออออออัอออออออออออออออออออออออออออออออออออออัอออออัออออออออออออัออออออออออออออ"
   IMPAC("Pasta ณ Locat rio                           ณ Dia ณ Valor      ณ Comisso",5,001)
   @ 6,000 SAY "ฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R003.PRG
