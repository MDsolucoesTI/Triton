/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_R002.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Relao de Locat rios
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
   IF !USEARQ("ALUGUEL",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ALUGUEL")                                         // abre o dbf e seus indices
#endi

PTAB(STR(codi,08,00),"PESSOA",1,.t.)                         // abre arquivo p/ o relacionamento
SET RELA TO STR(codi,08,00) INTO PESSOA                      // relacionamento dos arquivos
titrel:=criterio := ""                                       // inicializa variaveis
cpord="PESSOA->nome"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,52,11)                      // nao quis configurar...
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
         @ cl,002 SAY TRAN(pasta,"9999")                     // Pasta
         @ cl,010 SAY "ณ"
         @ cl,012 SAY PESSOA->nome                           // Nome
         @ cl,049 SAY "ณ"
         @ cl,051 SAY TRAN(fincon,"@D")                      // Fim do Contrato
         SKIP                                                // pega proximo registro
      ENDD
   ENDD ccop
END SEQUENCE
SET MARG TO                                                  // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(52)                                                    // grava variacao do relatorio
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
   @ 0,021 SAY "-"
   @ 0,023 SAY NSEM(DATE())                                  // dia da semana
   @ 0,030 SAY ","
   @ 0,032 SAY DTOC(DATE())                                  // data do sistema
   @ 0,057 SAY "Pag :"
   @ 0,063 SAY TRAN(pg_,'9999')                              // nฃmero da p gina
   IMPCTL(drvpenf)
   @ 1,019 SAY M->empresa                                    // Nome
   IMPCTL(drvtenf)
   IMPAC("Relao de Locat rios",3,024)
   @ 4,000 SAY "ออออออออออัออออออออออออออออออออออออออออออออออออออัออออออออออออออออออออ"
   IMPAC("Nง Pasta ณ Locat rio                            ณ Vencimento Contrato",5,001)
   @ 6,000 SAY "ฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R002.PRG
