/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R009.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Relao de Locadores
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("IMOVEIS",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("IMOVEIS")                                         // abre o dbf e seus indices
#endi

PTAB(STR(codpro,08,00),"PESSOA",1,.t.)                       // abre arquivo p/ o relacionamento
PTAB(STR(tipoimo,02,00),"TIPOIMO",1,.t.)
SET RELA TO STR(codpro,08,00) INTO PESSOA,;                  // relacionamento dos arquivos
         TO STR(tipoimo,02,00) INTO TIPOIMO
titrel:=criterio := ""                                       // inicializa variaveis
cpord="PESSOA->nome"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,54,11)                      // nao quis configurar...
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
maxli=62                                                     // maximo de linhas no relatorio
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
         IF tipo='1'.or.(tipo='2'.and.opcao='S')             // se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,002 SAY TRAN(pasta,"9999")                  // Pasta
            @ cl,010 SAY "ณ"
            @ cl,012 SAY TRAN(tipoimo,"99")                  // Tipo do Bem
            @ cl,014 SAY "-"
            @ cl,015 SAY TIPOIMO->tipoimo                    // Tipo do Bem
            @ cl,031 SAY "ณ"
            @ cl,033 SAY PESSOA->nome                        // Nome
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
GRELA(54)                                                    // grava variacao do relatorio
SELE IMOVEIS                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   @ 0,000 SAY M->cidade1                                    // Cidade
   @ 0,021 SAY "-"
   @ 0,023 SAY NSEM(DATE())                                  // dia da semana
   @ 0,030 SAY ","
   @ 0,032 SAY DTOC(DATE())                                  // data do sistema
   @ 0,057 SAY "Pag :"
   @ 0,063 SAY TRAN(pg_,'9999')                              // nฃmero da p gina
   @ 1,018 SAY M->empresa                                    // Nome
   IMPAC("Relao de Locadores",3,024)
   @ 4,000 SAY "ออออออออออัออออออออออออออออออออัออออออออออออออออออออออออออออออออออออออ"
   @ 5,001 SAY "Nง Pasta ณ Tipo do Bem        ณ Locador"
   @ 6,000 SAY "ฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R009.PRG
