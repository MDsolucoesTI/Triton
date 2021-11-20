/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_R001.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Recibos Locat rio
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=16, l_i:=15, c_i:=68, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±± Emiss„o de Recibos - Locat rio ±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Pasta ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Mˆs ÄÄÂ Ano ÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³ Inicial :       Final :      ³       ³        ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"
pasta1=0                                                     // Pasta
pasta2=0                                                     // Pasta
mes=0                                                        // Mˆs
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+14 GET  pasta1;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta1,04,00),'ALUGUEL',1)~PASTA n„o aceit vel")
                    DEFAULT "0"
                    AJUDA "Informe o N£mero da Pasta inicial|mantenha o valor inicial se for todas"
                    CMDF8 "VDBF(6,43,20,77,'ALUGUEL',{'pasta','codi','inicon','venc'},1,'pasta',[])"

   @ l_s+04 ,c_s+28 GET  pasta2;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta2,04,00),'ALUGUEL',1)~PASTA n„o aceit vel")
                    DEFAULT "9999"
                    AJUDA "Informe o N£mero da Pasta final|mantenha o valor inicial se for todos"
                    CMDF8 "VDBF(6,43,20,77,'ALUGUEL',{'pasta','codi','inicon','venc'},1,'pasta',[])"

   @ l_s+04 ,c_s+35 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<=12~Mˆs n„o aceit vel")
                    AJUDA "Informe o mˆs dos Recibos a serem impressos"

   @ l_s+04 ,c_s+43 GET  ano;
                    PICT "9999";
                    VALI CRIT("ano>0~Ano n„o aceit vel")
                    AJUDA "Informe o ano dos recibos a serem impressos"

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

   PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)                    // abre arquivo p/ o relacionamento
   PTAB(STR(pasta,04,00),"IMOVEIS",1,.t.)
   SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;               // relacionamento dos arquivos
            TO STR(pasta,04,00) INTO IMOVEIS
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,53,11)                   // nao quis configurar...
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
         IF pasta>=M->pasta1.and.pasta<=M->pasta2.and.Month(venc)=M->mes.and.Year(venc)=M->ano// se atender a condicao...
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º"
            IMPEXP(cl,022,Par([empresa]),70)                 // Nome
            @ cl,106 SAY "CRECI :"
            @ cl,114 SAY TRAN(Par([creci]),"@R 999.999")     // Inscri‡„o Estadual
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º                                                                                                                        º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º"
            @ cl,008 SAY Par([ender1])                       // Endere‡o
            @ cl,043 SAY ","
            @ cl,045 SAY TRAN(Par([numero1]),"99999")        // N£mero
            @ cl,051 SAY "-"
            @ cl,053 SAY Par([compl1])                       // Complemento
            @ cl,069 SAY "-"
            @ cl,071 SAY Par([cidade1])                      // Cidade
            @ cl,092 SAY "/"
            @ cl,094 SAY TRAN(Par([uf1]),"!!")               // UF
            @ cl,104 SAY "Fone:"
            @ cl,110 SAY TRAN(Par([tele1]),"@R (!999)!99-9999")// Telefone
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º                                                                                                                        º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º"
            IMPEXP(cl,050,TRAN(R00101F9(),"@!"),34)          // nome recibo
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("º N§ Recibo  ³  N§ Pasta  ³  Sequencia  ³   Venc. Contrato    ³      Aluguel do Per¡odo    º    Valores a Serem Pagos    º",cl,005)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º            ³            ³             ³                     ³                            ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "º"
            @ cl,007 SAY TRAN(numrec,"9999")                 // Sequencia
            @ cl,018 SAY "³"
            @ cl,023 SAY TRAN(pasta,"9999")                  // Pasta
            @ cl,031 SAY "³"
            @ cl,036 SAY TRAN(sequen,"999999999")            // N£mero Recibo
            @ cl,045 SAY "³"
            @ cl,051 SAY TRAN(ALUGUEL->fincon,"@D")          // Fim do Contrato
            @ cl,067 SAY "³"
            @ cl,070 SAY TRAN(per1,"@D")                     // Data In¡cio
            @ cl,082 SAY "a"
            @ cl,085 SAY TRAN(per2,"@D")                     // Data Final
            IMPAC("º     At‚      ³ A Partir de  º",cl,096)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹"
            @ cl,100 SAY TRAN(venc,"@D")                     // Vencimento
            @ cl,111 SAY "³"
            @ cl,115 SAY TRAN(venc+1,"@D")                   // Data Ap¢s
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                            ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("³ Locat rio :",cl,005)
            @ cl,019 SAY TRAN(ALUGUEL->codi,"99999999")      // C¢digo Lacat rio
            @ cl,028 SAY "-"
            @ cl,030 SAY if(PTAB(STR(ALUGUEL->codi,8,0),'PESSOA'),PESSOA->Nome,'')// Locat rio
            @ cl,067 SAY "³         Aluguel............º"
            @ cl,099 SAY TRAN(valor1,"@E 999,999.99")        // Valor
            @ cl,111 SAY "³"
            @ cl,114 SAY TRAN(valor2,"@E 999,999.99")        // Valor
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         IPTU...............º"
            IF !Empty(iptu1)                                 // pode imprimir?
               @ cl,099 SAY TRAN(iptu1,"@E 999,999.99")      // IPTU
            ENDI
            @ cl,111 SAY "³"
            IF !Empty(iptu1)                                 // pode imprimir?
               @ cl,114 SAY TRAN(iptu1,"@E 999,999.99")      // IPTU
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         Agua...............º"
            IF !Empty(agua)                                  // pode imprimir?
               @ cl,099 SAY TRAN(agua,"@E 999,999.99")       // gua
            ENDI
            @ cl,111 SAY "³"
            IF !Empty(agua)                                  // pode imprimir?
               @ cl,114 SAY TRAN(agua,"@E 999,999.99")       // gua
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³ Bem :"
            @ cl,013 SAY If(PTAB(IMOVEIS->tipo,'TIPOIMO'),TIPOIMO->tipoimo,[])// Tipo Im¢vel
            @ cl,067 SAY "³         Luz................º"
            IF !Empty(luz)                                   // pode imprimir?
               @ cl,099 SAY TRAN(luz,"@E 999,999.99")        // Luz
            ENDI
            @ cl,111 SAY "³"
            IF !Empty(luz)                                   // pode imprimir?
               @ cl,114 SAY TRAN(luz,"@E 999,999.99")        // Luz
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³"
            @ cl,013 SAY IMOVEIS->ender                      // Ender
            @ cl,048 SAY ","
            @ cl,050 SAY TRAN(IMOVEIS->numero,"99999")       // n£mero
            @ cl,067 SAY "³         Telefone...........º"
            IF !Empty(telefone)                              // pode imprimir?
               @ cl,099 SAY TRAN(telefone,"@E 999,999.99")   // Telefone
            ENDI
            @ cl,111 SAY "³"
            IF !Empty(telefone)                              // pode imprimir?
               @ cl,114 SAY TRAN(telefone,"@E 999,999.99")   // Telefone
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³"
            @ cl,013 SAY IMOVEIS->compl                      // Complemento
            @ cl,067 SAY "³         Outros.............º"
            IF !Empty(outros)                                // pode imprimir?
               @ cl,099 SAY TRAN(outros,"@E 999,999.99")     // Outros
            ENDI
            @ cl,111 SAY "³"
            IF !Empty(outros)                                // pode imprimir?
               @ cl,114 SAY TRAN(outros,"@E 999,999.99")     // Outros
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³"
            @ cl,013 SAY IMOVEIS->bairro                     // Bairro
            @ cl,034 SAY "-"
            @ cl,036 SAY IMOVEIS->cidade                     // Cidade
            @ cl,057 SAY "/"
            @ cl,059 SAY TRAN(IMOVEIS->uf,"!!")              // UF
            @ cl,067 SAY "³         Clausula 20¦.......º              ³"
            IF !Empty(cla20)                                 // pode imprimir?
               @ cl,114 SAY TRAN(cla20,"@E 999,999.99")      // Claus.20
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         Juros e Corre‡„o...º              ³",cl,005)
            IF !Empty(correc)                                // pode imprimir?
               @ cl,114 SAY TRAN(correc,"@E 999,999.99")     // Corre‡„o
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         ------------------ ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³ Fiador    :"
            @ cl,019 SAY TRAN(ALUGUEL->codf,"99999999")      // C¢digo do Fiador
            @ cl,028 SAY "-"
            @ cl,030 SAY If(PTAB(STR(ALUGUEL->codf,8,0),'PESSOA'),PESSOA->nome,'')// Fiador
            @ cl,067 SAY "³         Total..............º"
            @ cl,099 SAY TRAN(total,"@E 999,999.99")         // Total
            @ cl,111 SAY "³"
            IF total2>valor2                                 // pode imprimir?
               @ cl,114 SAY TRAN(total2,"@E 999,999.99")     // Total
            ENDI
            @ cl,126 SAY "º"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                            ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  RECEBEMOS"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "³ Locador   :"
            @ cl,019 SAY TRAN(IMOVEIS->codpro,"99999999")    // C¢digo do propriet rio
            @ cl,028 SAY "-"
            @ cl,030 SAY If(PTAB(STR(IMOVEIS->codpro,8,0),'PESSOA'),PESSOA->nome,'')// Locador
            @ cl,067 SAY "³"
            @ cl,070 SAY Par([cidade1])                      // Cidade1
            @ cl,090 SAY ",....de....................de......."
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY "referente ao aluguel e encargos acima especificados,"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("Bem localizado no endere‡o supra.",cl,006)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY "Pago Conforme Cheque : _______________ do Banco : ______,"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("a quita‡„o desse Recibo s¢ ser  v lida ap¢s compensa‡„o                     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",cl,006)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY "do cheque acima."
            @ cl,086 SAY Par([empresa])                      // Nome1
            SKIP                                             // pega proximo registro
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
GRELA(53)                                                    // grava variacao do relatorio
SELE ARECIBO                                                 // salta pagina
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

* \\ Final de TRI_R001.PRG
