/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: DIVCLI.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Dida Cliente
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=17, l_i:=14, c_i:=70, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="DIV", op_sis:=EVAL(qualsis,"RECEBER")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北北� Dida de Clientes 北北北北北北北北�"
@ l_s+03,c_s+1 SAY " � Cliente 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目"
@ l_s+04,c_s+1 SAY " �          -                                     �"
@ l_s+05,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁"
coddiv=0                                                     // Cigo
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  coddiv;
                    PICT "99999999";
                    VALI CRIT("PTAB(STR(coddiv,08,00),'PESSOA',1)~Cigo n刼 existe na tabela")
                    DEFAULT "1"
                    AJUDA "Informe o cigo do Cliente (Pessoa)"
                    CMDF8 "VDBF(6,3,20,77,'PESSOA',{'cod','nome','tipo','rg','cgc'},1,'cod',[])"
                    MOSTRA {"LEFT(TRAN(PESSOA->nome,[]),35)", 4 , 15 }

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA(.f.)
      LOOP
   ENDI
   IF LASTKEY()=K_ESC                                        // se quer cancelar
      RETU                                                   // retorna
   ENDI
   EXIT
ENDD
op_menu=PROJECOES                                            // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
   IF !USEARQ("RECEBER",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("RECEBER")                                         // abre o dbf e seus indices
#endi

col_cp={;                                                    // conteudo das colunas
          "seque",;
          "documen",;
          "vencimento",;
          "valpagar",;
          "custo",;
          "parcelas";
       }
col_ti={;                                                    // titulo das colunas
          "Sequ坣cia",;
          "Documento",;
          "Vencimento",;
          "Vl Receber",;
          "Centro de Custos",;
          "Nero da Parcela";
       }
cr_="M->codigo=codigo.and.Empty(datapago)"                   // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de DIVCLI.PRG
