/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: ALUABER.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Alugueis em Atraso
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=16, l_i:=17, c_i:=69, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="ALU", op_sis:=EVAL(qualsis,"ARECIBO")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北北北 Alugueis em Atraso 北北北北北北北北"
@ l_s+03,c_s+1 SAY " � Pasta � Contrato 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+04,c_s+1 SAY " �       � de            a                        �"
@ l_s+05,c_s+1 SAY " � Locat爎io 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+06,c_s+1 SAY " �          -                                     �"
@ l_s+07,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁"
pastacon=0                                                   // Pasta
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  pastacon;
                    PICT "9999";
                    VALI CRIT("PTAB(STR(pastacon,04,00),'ALUGUEL',1)~Pasta n刼 existe na tabela")
                    AJUDA "Informe o nero da pasta do Bem"
                    CMDF8 "VDBF(6,61,20,77,'ALUGUEL',{'pasta','codigo'},1,'pasta',[])"
                    MOSTRA {"LEFT(TRAN(ALUGUEL->inicon,[@D]),10)", 4 , 15 }
                    MOSTRA {"LEFT(TRAN(ALUGUEL->fincon,[@D]),10)", 4 , 28 }
                    MOSTRA {"LEFT(TRAN(ALUGUEL->codi,[99999999]),08)", 6 , 4 }

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
   IF !USEARQ("ARECIBO",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ARECIBO")                                         // abre o dbf e seus indices
#endi

col_cp={;                                                    // conteudo das colunas
          "sequen",;
          "numrec",;
          "per1",;
          "per2",;
          "venc",;
          "total",;
          "total2";
       }
col_ti={;                                                    // titulo das colunas
          "Sequencia",;
          "Recibo",;
          "De",;
          "a",;
          "Vencimento",;
          "Total no Venc.",;
          "Total ap Venc.";
       }
cr_="M->pastacon=pasta .and. Empty(datpag)"                  // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de ALUABER.PRG
