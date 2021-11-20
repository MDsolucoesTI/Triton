/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_R010.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Pagamentos em Aberto
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
   IF !USEARQ("ARECIBO",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ARECIBO")                                         // abre o dbf e seus indices
#endi

PTAB(STR(codalu,06,00),"ALUGUEL",2,.t.)                      // abre arquivo p/ o relacionamento
PTAB(STR(ALUGUEL->codi,08,00),"PESSOA",1,.t.)
SET RELA TO STR(codalu,06,00) INTO ALUGUEL,;                 // relacionamento dos arquivos
         TO STR(ALUGUEL->codi,08,00) INTO PESSOA
titrel:=criterio := ""                                       // inicializa variaveis
cpord="DTOS(venc)"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,64,11)                      // nao quis configurar...
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
IMPCTL(drvpcom)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
   DO WHIL ccop<=nucop                                       // imprime qde copias pedida
      pg_=1; cl=999
      INI_ARQ()                                              // acha 1o. reg valido do arquivo
      ccop++                                                 // incrementa contador de copias
      tot111009 := 0                                         // inicializa variaves de totais
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
         IF Empty(datpag)                                    // se atender a condicao...
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,000 SAY 'Total a Receber - Ms'             // titulo da quebra
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            qb11101=Mont(venc)                               // campo para agrupar 1a quebra
            st11101009 := 0                                  // inicializa sub-totais
            DO WHIL !EOF() .AND. Mont(venc)=qb11101
               #ifdef COM_TUTOR
                  IF IN_KEY()=K_ESC                          // se quer cancelar
               #else
                  IF INKEY()=K_ESC                           // se quer cancelar
               #endi
                  IF canc()                                  // pede confirmacao
                     BREAK                                   // confirmou...
                  ENDI
               ENDI
               IF Empty(datpag)                              // se atender a condicao...
                  REL_CAB(1)                                 // soma cl/imprime cabecalho
                  @ cl,001 SAY TRAN(sequen,"999999999")      // Sequencia
                  @ cl,011 SAY "ณ"
                  @ cl,013 SAY TRAN(pasta,"9999")            // Pasta
                  @ cl,019 SAY "ณ"
                  @ cl,021 SAY TRAN(numrec,"9999")           // Nฃmero Recibo
                  @ cl,026 SAY "ณ"
                  @ cl,028 SAY TRAN(per1,"@D")               // Data Inกcio
                  @ cl,037 SAY "a"
                  @ cl,039 SAY TRAN(per2,"@D")               // Data Final
                  @ cl,048 SAY "ณ"
                  @ cl,050 SAY TRAN(venc,"@D")               // Vencimento
                  @ cl,059 SAY "ณ"
                  st11101009+=total
                  tot111009+=total
                  @ cl,061 SAY TRAN(total,"@E 999,999.99")   // Total
                  @ cl,072 SAY "ณ"
                  @ cl,074 SAY TRAN(PESSOA->cod,"99999999")  // Cขdigo
                  @ cl,082 SAY "-"
                  @ cl,083 SAY PESSOA->nome                  // Nome
                  @ cl,119 SAY "ณ"
                  @ cl,121 SAY TRAN(ALUGUEL->fincon,"@D")    // Fim do Contrato
                  SKIP                                       // pega proximo registro
               ELSE                                          // se nao atende condicao
                  SKIP                                       // pega proximo registro
               ENDI
            ENDD
            IF cl+3>maxli                                    // se cabecalho do arq filho
               REL_CAB(0)                                    // nao cabe nesta pagina
            ENDI                                             // salta para a proxima pagina
            @ ++cl,061 SAY REPL('-',10)
            @ ++cl,061 SAY TRAN(st11101009,"@E 999,999.99")  // sub-tot Total
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
      IF cl+3>maxli                                          // se cabecalho do arq filho
         REL_CAB(0)                                          // nao cabe nesta pagina
      ENDI                                                   // salta para a proxima pagina
      @ ++cl,061 SAY REPL('-',10)
      @ ++cl,061 SAY TRAN(tot111009,"@E 999,999.99")         // total Total
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(64)                                                    // grava variacao do relatorio
SELE ARECIBO                                                 // salta pagina
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
   @ 0,058 SAY M->empresa                                    // Nome
   @ 0,118 SAY "Pag :"
   @ 0,124 SAY TRAN(pg_,'9999')                              // nฃmero da p gina
   IMPAC("Relao de Recibos em Aberto",2,052)
   @ 3,000 SAY "อออออออออออัอออออออัออออออัอออออออออออออออออออออัออออออออออัออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออัออออออออออออ"
   IMPAC("Sequncia ณ Pasta ณ Nฃm. ณ       Periodo       ณ   Venc.  ณ Valor      ณ Locat rio                                    ณ  Fim do",4,001)
   IMPAC("ณ       ณ      ณ      do Aluguel     ณ  Recibo  ณ a receber  ณ Cขdigo    Nome                               ณ Contrato",5,011)
   @ 6,000 SAY "ฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤ"
   cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de TRI_R010.PRG
