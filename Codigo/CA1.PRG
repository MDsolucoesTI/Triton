/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CA1.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Alugueis a Receber - Dia
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=18, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CA1", op_sis:=EVAL(qualsis,"ALUGUEL")
IF nivelop < 2                                               // se usuario nao tem
   DBOX("Emiss„o negada, "+usuario,20)                       // permissao, avisa
   RETU                                                      // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±± Consulta Alugueis - Reciber no Dia ±±±"
@ l_s+03,c_s+1 SAY " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³ Informe o Dia a Colsultar :          ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
venc1=0                                                      // Vencimento
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+32 GET  venc1;
                    PICT "99";
                    VALI CRIT("venc1>0~VENCIMENTO n„o aceit vel")
                    AJUDA "Informe o dia de vencimento do aluguel"

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
   IF !USEARQ("ALUGUEL",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("ALUGUEL")                                         // abre o dbf e seus indices
#endi

PTAB(STR(codi,08,00),"PESSOA",1,.t.)                         // abre arquivo p/ o relacionamento
SET RELA TO STR(codi,08,00) INTO PESSOA                      // relacionamento dos arquivos
col_cp={;                                                    // conteudo das colunas
          "pasta",;
          "TRAN(PESSOA->nome,[@!])",;
          "valor1";
       }
col_ti={;                                                    // titulo das colunas
          "Pasta",;
          "Nome",;
          "Valor";
       }
cr_="venc=M->venc1"                                          // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,12,MAXROW()-2,68,.t.,col_cp,col_ti,cr_)
SELE ALUGUEL                                                 // salta pagina
SET RELA TO                                                  // retira os relacionamentos
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CA1.PRG
