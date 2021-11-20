/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R025.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Emiss„o Nota Promissoria
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro fv3.s0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=16, l_i:=15, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±± Impress„o de Notas Promissorias ±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú N£mero da Nota Promissoria ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³  Inicio :               Final :            ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
sequeini=0                                                   // Sequˆncia
sequefinal=0                                                 // Sequˆncia
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+14 GET  sequeini;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(sequeini,10,00),'RECEBER',1)~Sequˆncia n„o aceit vel")
                    AJUDA "Informe o n£mero da NP para ser|utilizado como inicio da sequˆncia de impress„o"
                    CMDF8 "VDBF(6,21,20,77,'RECEBER',{'seque','documen','codigo','vencimento'},1,'seque',[])"

   @ l_s+04 ,c_s+36 GET  sequefinal;
                    PICT "9999999999";
                    VALI CRIT("PTAB(STR(sequefinal,10,00),'RECEBER',1)~Sequˆncia n„o aceit vel")
                    AJUDA "Informe o n£mero da NP para ser|utilizado como final da sequˆncia de impress„o"
                    CMDF8 "VDBF(6,21,20,77,'RECEBER',{'seque','documen','codigo','vencimento'},1,'seque',[])"

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
      IF !USEARQ("RECEBER",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("RECEBER")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(custo,04,00),"CUSTO",1,.t.)                      // abre arquivo p/ o relacionamento
   PTAB(STR(codigo,08,00),"PESSOA",1,.t.)
   SET RELA TO STR(custo,04,00) INTO CUSTO,;                 // relacionamento dos arquivos
            TO STR(codigo,08,00) INTO PESSOA
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,61,11)                   // nao quis configurar...
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
IF !EMPTY(drvtapg)                                           // existe configuracao de tam pag?
   op_=AT("NNN",drvtapg)                                     // se o codigo que altera
   IF op_=0                                                  // o tamanho da pagina
      msg="Configura‡„o do tamanho da p gina!"               // foi informado errado
      DBOX(msg,,,,,"ERRO!")                                  // avisa
      CLOSE ALL                                              // fecha todos arquivos abertos
      RETU                                                   // e cai fora...
   ENDI                                                      // codigo para setar/resetar tam pag
   lpp_033=LEFT(drvtapg,op_-1)+"033"+SUBS(drvtapg,op_+3)
   lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
   lpp_033:=lpp_066 :=""                                     // nao ira mudara o tamanho da pag
ENDI
op_2=1
DO WHIL op_2=1 .AND. tps=1                                   // teste de posicionamento
   msg="Testar Posicionamento|Emitir o Relat¢rio|"+;
       "Cancelar a Opera‡„o"
   op_2=DBOX(msg,,,E_MENU,,"POSICIONAMENTO DO PAPEL")        // menu de opcoes
   IF op_2=0 .OR. op_2=3                                     // cancelou ou teclou ESC
      CLOSE ALL                                              // fecha todos arquivos abertos
      RETU
   ELSEIF op_2=2                                             // emite conteudos...
      EXIT
   ELSE                                                      // testar posicionamento
      SET DEVI TO PRIN                                       // direciona para impressora
      IMPCTL(lpp_033)                                        // seta pagina com 33 linhas
      IMPCTL(drvpcom)                                        // comprime os dados
      @ 005,089 SAY REPL("X",2)
      @ 005,102 SAY REPL("X",9)
      @ 005,125 SAY REPL("X",4)
      @ 007,031 SAY REPL("X",10)
      @ 007,111 SAY REPL("X",18)
      @ 009,024 SAY REPL("X",80)
      @ 011,024 SAY REPL("X",35)
      @ 011,108 SAY REPL("X",18)
      @ 013,038 SAY REPL("X",80)
      @ 015,025 SAY REPL("X",80)
      @ 017,035 SAY REPL("X",20)
      @ 018,075 SAY REPL("X",2)
      @ 018,099 SAY REPL("X",9)
      @ 018,123 SAY REPL("X",4)
      @ 022,034 SAY REPL("X",20)
      @ 022,080 SAY REPL("X",2)
      @ 023,029 SAY REPL("X",6)
      @ 023,040 SAY REPL("X",35)
      @ 025,035 SAY REPL("X",35)
      @ 027,035 SAY REPL("X",19)
      @ 027,088 SAY REPL("X",35)
      @ 028,108 SAY REPL("X",8)
      EJEC                                                   // salta pagina no inicio
      IMPCTL(drvtcom)                                        // retira comprimido
      IMPCTL(lpp_066)                                        // seta pagina com 66 linhas
      SET DEVI TO SCRE                                       // se parametro maior que 0
   ENDI
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                              // os excluidos nao servem...
SET DEVI TO PRIN                                             // inicia a impressao
maxli=32                                                     // maximo de linhas no relatorio
IMPCTL(lpp_033)                                              // seta pagina com 33 linhas
IMPCTL(drvpcom)                                              // comprime os dados
IF tps=2
   IMPCTL("' '+CHR(8)")
ENDI
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
         IF seque>=M->sequeini.and.seque<=M->sequefinal      // se atender a condicao...
            REL_CAB(6)                                       // soma cl/imprime cabecalho
            @ cl,089 SAY Substr(DtoC(vencimento),01,02)      // Dia
            @ cl,102 SAY NMes(Month(vencimento))             // Mˆs
            @ cl,125 SAY Year(vencimento)                    // ano
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,031 SAY TRAN(seque,"9999999999")            // Sequˆncia
            @ cl,111 SAY TRAN(valpagar,"@E 999,999,999,999.99")// Vl Pagar
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,024 SAY Ext(Val(Substr(DtoC(vencimento),01,02)),0,0)+[ de ]+NMes(Val(Substr(DtoC(vencimento),04,02)))+[ de ]+Ext(Year(vencimento),0,0)// Data Extenso
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,071 SAY "ei                  minha"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,024 SAY Par([empresa])                      // Empresa
            @ cl,108 SAY TRAN(Par([cgc1]),"@R 99.999.999/9999-99")// CGC
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,038 SAY Left(Ext(valpagar,80),80)           // Extenso 1
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,025 SAY Substr(Ext(valpagar,80),81,80)      // Extenso 2
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,035 SAY Par([cidade1])                      // Cidade
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,075 SAY Substr(DtoC(data),01,02)            // HDia
            @ cl,099 SAY NMes(Month(data))                   // HMˆs
            @ cl,123 SAY Year(data)                          // HAno
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            IMPAC("Este t¡tulo foi emitido em decorrencia de contrato de compra e venda de unidades imobiliarias e o valor",cl,022)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("constante no campo acima dever  ser atualizado monetariamente desde a data de emiss„o.",cl,022)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,022 SAY "Documento :"
            @ cl,034 SAY TRAN(documen,"@!")                  // Documento
            IMPAC("Parcela N£mero :",cl,063)
            @ cl,080 SAY TRAN(parcelas,"99")                 // N£mero da Parcela
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,022 SAY "Obra :"
            @ cl,029 SAY CUSTO->codigo                       // C¢digo Centro de Custo
            @ cl,037 SAY "-"
            @ cl,040 SAY CUSTO->departa                      // Departamento
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,035 SAY PESSOA->nome                        // Nome1
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,035 SAY If(PESSOA->tipo=[F],PESSOA->cpf,PESSOA->cgc)// cgc/cpf
            @ cl,088 SAY PESSOA->nome                        // Nome
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,108 SAY TRAN(codigo,"99999999")             // Cliente
            SKIP                                             // pega proximo registro
            cl=999                                           // forca salto de pagina
         ELSE                                                // se nao atende condicao
            SKIP                                             // pega proximo registro
         ENDI
      ENDD
   ENDD ccop
END SEQUENCE
IMPCTL(drvtcom)                                              // retira comprimido
IMPCTL(lpp_066)                                              // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                                    // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                             // direciona saida p/ video
IF tps=2                                                     // se vai para arquivo/video
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                                         // mostra o arquivo gravado
GRELA(61)                                                    // grava variacao do relatorio
SELE RECEBER                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                                   // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                                      // cabecalho do relatorio
IF qt>0                                                      // se parametro maior que 0
   cl=cl+qt                                                  // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                                        // quebra de pagina
   cl=qt-1 ; pg_++
ENDI
RETU

* \\ Final de TRI_R025.PRG
