/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_R024.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Recibos Locador
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=16, l_i:=15, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss刼 negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北 Emiss刼 de Recibos - Locador 北北北北北"
@ l_s+03,c_s+1 SAY " � Pasta 哪哪哪哪哪哪哪哪哪哪哪穆 M坰 哪� Ano 哪�"
@ l_s+04,c_s+1 SAY " � Inicial :       Final :      �       �       �"
@ l_s+05,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪馁"
pasta1=0                                                     // Pasta
pasta2=0                                                     // Pasta
mes=0                                                        // M坰
ano=0                                                        // Ano
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+14 GET  pasta1;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta1,04,00),'ALUGUEL',1)~PASTA n刼 aceit爒el")
                    DEFAULT "0"
                    AJUDA "Informe o Nero da Pasta inicial|mantenha o valor inicial se for todas"
                    CMDF8 "VDBF(6,43,20,77,'ALUGUEL',{'pasta','codi','inicon','venc'},1,'pasta',[])"

   @ l_s+04 ,c_s+28 GET  pasta2;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pasta2,04,00),'ALUGUEL',1)~PASTA n刼 aceit爒el")
                    DEFAULT "9999"
                    AJUDA "Informe o Nero da Pasta final|mantenha o valor inicial se for todos"
                    CMDF8 "VDBF(6,43,20,77,'ALUGUEL',{'pasta','codi','inicon','venc'},1,'pasta',[])"

   @ l_s+04 ,c_s+35 GET  mes;
                    PICT "99";
                    VALI CRIT("mes>0.and.mes<=12~M坰 n刼 aceit爒el")
                    AJUDA "Informe o m坰 dos Recibos a serem impressos"

   @ l_s+04 ,c_s+43 GET  ano;
                    PICT "9999";
                    VALI CRIT("ano>0~Ano n刼 aceit爒el")
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
      IF !USEARQ("LRECIBO",.f.,10,1)                         // se falhou a abertura do arq
         RETU                                                // volta ao menu anterior
      ENDI
   #else
      USEARQ("LRECIBO")                                      // abre o dbf e seus indices
   #endi

   PTAB(STR(pasta,04,00),"ALUGUEL",1,.t.)                    // abre arquivo p/ o relacionamento
   PTAB(STR(pasta,04,00),"IMOVEIS",1,.t.)
   SET RELA TO STR(pasta,04,00) INTO ALUGUEL,;               // relacionamento dos arquivos
            TO STR(pasta,04,00) INTO IMOVEIS
   titrel:=criterio:=cpord := ""                             // inicializa variaveis
   titrel:=chv_rela:=chv_1:=chv_2 := ""
   tps:=op_x:=ccop := 1
   IF !opcoes_rel(lin_menu,col_menu,55,11)                   // nao quis configurar...
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
      msg="Configura噭o do tamanho da p爂ina!"               // foi informado errado
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
            @ cl,005 SAY "赏屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯突"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            IMPEXP(cl,022,Par([empresa]),70)                 // Nome
            @ cl,106 SAY "CRECI :"
            @ cl,114 SAY TRAN(Par([creci]),"@R 999.999")     // Inscri噭o Estadual
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            @ cl,008 SAY Par([ender1])                       // Endere噊
            @ cl,043 SAY ","
            @ cl,045 SAY TRAN(Par([numero1]),"99999")        // Nero
            @ cl,051 SAY "-"
            @ cl,053 SAY Par([compl1])                       // Complemento
            @ cl,069 SAY "-"
            @ cl,071 SAY Par([cidade1])                      // Cidade
            @ cl,092 SAY "/"
            @ cl,094 SAY TRAN(Par([uf1]),"!!")               // UF
            @ cl,104 SAY "Fone:"
            @ cl,110 SAY TRAN(Par([tele1]),"@R (!999)!99-9999")// Telefone
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�                                                                                                                        �"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            IMPEXP(cl,050,TRAN(R00101F9(),"@!"),34)          // nome recibo
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "韧屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "赏屯屯屯屯屯脱屯屯屯屯屯屯淹屯屯屯屯屯屯淹屯屯屯屯屯屯屯屯屯屯淹屯屯屯屯屯屯屯屯屯屯屯屯屯退屯屯屯屯屯屯屯屯屯屯屯屯屯屯突"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("� N� Recibo  �  N� Pasta  �  Sequencia  �   Venc. Contrato    �      Aluguel do Perdo    �    Valores a Serem Pagos    �",cl,005)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�            �            �             �                     �                            悄哪哪哪哪哪哪穆哪哪哪哪哪哪哪�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            @ cl,007 SAY TRAN(numrec,"9999")                 // Sequencia
            @ cl,018 SAY "�"
            @ cl,023 SAY TRAN(pasta,"9999")                  // Pasta
            @ cl,031 SAY "�"
            @ cl,036 SAY TRAN(sequen,"999999999")            // Nero Recibo
            @ cl,045 SAY "�"
            @ cl,051 SAY TRAN(ALUGUEL->fincon,"@D")          // Fim do Contrato
            @ cl,067 SAY "�"
            @ cl,070 SAY TRAN(per1,"@D")                     // Data Inio
            @ cl,082 SAY "a"
            @ cl,085 SAY TRAN(per2,"@D")                     // Data Final
            IMPAC("�     At�      � A Partir de  �",cl,096)
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "韧屯屯屯屯屯拖屯屯屯屯屯屯贤屯屯屯屯屯屯贤屯屯屯屯屯屯屯屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯屯凸"
            @ cl,100 SAY TRAN(venc,"@D")                     // Vencimento
            @ cl,111 SAY "�"
            @ cl,115 SAY TRAN(venc+1,"@D")                   // Data Ap
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�                            悄哪哪哪哪哪哪呐哪哪哪哪哪哪哪�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("� Locat爎io :",cl,005)
            @ cl,019 SAY TRAN(ALUGUEL->codi,"99999999")      // Cigo Lacat爎io
            @ cl,028 SAY "-"
            @ cl,030 SAY if(PTAB(STR(ALUGUEL->codi,8,0),'PESSOA'),PESSOA->Nome,'')// Locat爎io
            @ cl,067 SAY "�         Aluguel............�"
            @ cl,099 SAY TRAN(valor1,"@E 999,999.99")        // Valor
            @ cl,111 SAY "�"
            @ cl,114 SAY TRAN(valor2,"@E 999,999.99")        // Valor
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         IPTU...............�"
            IF !Empty(iptu1)                                 // pode imprimir?
               @ cl,099 SAY TRAN(iptu1,"@E 999,999.99")      // IPTU
            ENDI
            @ cl,111 SAY "�"
            IF !Empty(iptu1)                                 // pode imprimir?
               @ cl,114 SAY TRAN(iptu1,"@E 999,999.99")      // IPTU
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         Agua...............�"
            IF !Empty(agua)                                  // pode imprimir?
               @ cl,099 SAY TRAN(agua,"@E 999,999.99")       // 廹ua
            ENDI
            @ cl,111 SAY "�"
            IF !Empty(agua)                                  // pode imprimir?
               @ cl,114 SAY TRAN(agua,"@E 999,999.99")       // 廹ua
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "� Bem :"
            @ cl,013 SAY If(PTAB(IMOVEIS->tipo,'TIPOIMO'),TIPOIMO->tipoimo,[])// Tipo Imel
            @ cl,067 SAY "�         Luz................�"
            IF !Empty(luz)                                   // pode imprimir?
               @ cl,099 SAY TRAN(luz,"@E 999,999.99")        // Luz
            ENDI
            @ cl,111 SAY "�"
            IF !Empty(luz)                                   // pode imprimir?
               @ cl,114 SAY TRAN(luz,"@E 999,999.99")        // Luz
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            @ cl,013 SAY IMOVEIS->ender                      // Ender
            @ cl,048 SAY ","
            @ cl,050 SAY TRAN(IMOVEIS->numero,"99999")       // nero
            @ cl,067 SAY "�         Telefone...........�"
            IF !Empty(telefone)                              // pode imprimir?
               @ cl,099 SAY TRAN(telefone,"@E 999,999.99")   // Telefone
            ENDI
            @ cl,111 SAY "�"
            IF !Empty(telefone)                              // pode imprimir?
               @ cl,114 SAY TRAN(telefone,"@E 999,999.99")   // Telefone
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            @ cl,013 SAY IMOVEIS->compl                      // Complemento
            @ cl,067 SAY "�         Outros.............�"
            IF !Empty(outros)                                // pode imprimir?
               @ cl,099 SAY TRAN(outros,"@E 999,999.99")     // Outros
            ENDI
            @ cl,111 SAY "�"
            IF !Empty(outros)                                // pode imprimir?
               @ cl,114 SAY TRAN(outros,"@E 999,999.99")     // Outros
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "�"
            @ cl,013 SAY IMOVEIS->bairro                     // Bairro
            @ cl,034 SAY "-"
            @ cl,036 SAY IMOVEIS->cidade                     // Cidade
            @ cl,057 SAY "/"
            @ cl,059 SAY TRAN(IMOVEIS->uf,"!!")              // UF
            @ cl,067 SAY "�         Diversos...........�              �"
            IF !Empty(cla20)                                 // pode imprimir?
               @ cl,114 SAY TRAN(cla20,"@E 999,999.99")      // Claus.20
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         Juros e Corre噭o...�              �",cl,005)
            IF !Empty(correc)                                // pode imprimir?
               @ cl,114 SAY TRAN(correc,"@E 999,999.99")     // Corre噭o
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         ------------------ 悄哪哪哪哪哪哪呐哪哪哪哪哪哪哪�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "� Fiador    :"
            @ cl,019 SAY TRAN(ALUGUEL->codf,"99999999")      // Cigo do Fiador
            @ cl,028 SAY "-"
            @ cl,030 SAY If(PTAB(STR(ALUGUEL->codf,8,0),'PESSOA'),PESSOA->nome,'')// Fiador
            @ cl,067 SAY "�         Total..............�"
            @ cl,099 SAY TRAN(total,"@E 999,999.99")         // Total
            @ cl,111 SAY "�"
            IF total2>valor2                                 // pode imprimir?
               @ cl,114 SAY TRAN(total2,"@E 999,999.99")     // Total
            ENDI
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         Taxa -"
            @ cl,084 SAY TRAN(taxa,"99")                     // Taxa
            @ cl,087 SAY "% .......�"
            @ cl,099 SAY TRAN(adm,"@E 999,999.99")           // Administra噭o
            @ cl,111 SAY "�"
            @ cl,114 SAY TRAN(adm2,"@E 999,999.99")          // Administra噭o2
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         A Recolher.........�"
            @ cl,099 SAY TRAN(iptu1+agua+luz+telefone+outros,"@E 999,999.99")// recolher
            @ cl,111 SAY "�"
            @ cl,114 SAY TRAN(iptu1+agua+luz+telefone+outros,"@E 999,999.99")// recolher2
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "� Locador   :"
            @ cl,019 SAY TRAN(IMOVEIS->codpro,"99999999")    // Cigo do propriet爎io
            @ cl,028 SAY "-"
            @ cl,030 SAY If(PTAB(STR(IMOVEIS->codpro,8,0),'PESSOA'),PESSOA->nome,'')// Locador
            @ cl,067 SAY "�         ------------------ 悄哪哪哪哪哪哪呐哪哪哪哪哪哪哪�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,005 SAY "滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�         Liquido Locador....�"
            @ cl,099 SAY TRAN(lprop,"@E 999,999.99")         // Locador
            @ cl,111 SAY "�"
            @ cl,114 SAY TRAN(lprop2,"@E 999,999.99")        // Locador2
            @ cl,126 SAY "�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY "referente ao aluguel e encargos acima especificados,                                      韧屯屯屯屯屯屯拖屯屯屯屯屯屯屯�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            IMPAC("Bem localizado no endere噊 supra.",cl,006)
            REL_CAB(2)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY "RECEBI"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,006 SAY Par([cidade1])                      // Cidade1
            @ cl,026 SAY ",....de....................de.......                   哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"
            REL_CAB(1)                                       // soma cl/imprime cabecalho
            @ cl,085 SAY If(Ptab(Str(IMOVEIS->codpro,08,00),'Pessoa',1),Pessoa->Nome,[])// Nome1
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
GRELA(55)                                                    // grava variacao do relatorio
SELE LRECIBO                                                 // salta pagina
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

* \\ Final de TRI_R024.PRG
