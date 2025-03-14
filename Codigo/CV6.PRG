/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CV6.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili�rio
 \ Funcao..: Bens por Valor
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CV5", op_sis:=EVAL(qualsis,"IMOVEIS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "������� Consulta de Bens - Valor ����������"
@ l_s+03,c_s+1 SAY " � Valor M�nimo ������ Valor M�ximo ����Ŀ"
@ l_s+04,c_s+1 SAY " �                   �                   �"
@ l_s+05,c_s+1 SAY " �����������������������������������������"
valmin=0                                                     //Valor Minimo
valmax=0                                                     // Valor Maximo
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  valmin;
                    PICT "@E 999,999,999,999.99"
                    DEFAULT "0.00"
                    AJUDA "Informe o valor m�nimo a pagar"

   @ l_s+04 ,c_s+24 GET  valmax;
                    PICT "@E 999,999,999,999.99"
                    DEFAULT "0.00"
                    AJUDA "Informe o valor m�ximo a pagar"

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
   IF !USEARQ("IMOVEIS",.f.,10,1)                            // se falhou a abertura do arq
      RETU                                                   // volta ao menu anterior
   ENDI
#else
   USEARQ("IMOVEIS")                                         // abre o dbf e seus indices
#endi

col_cp={;                                                    // conteudo das colunas
          "pasta",;
          "valor1",;
          "tipoimo",;
          "areater",;
          "uniare",;
          "areaconst",;
          "ender",;
          "numero",;
          "compl",;
          "bairro",;
          "cidade",;
          "uf",;
          "dorm",;
          "wc",;
          "suite",;
          "salatv",;
          "salaref",;
          "copa",;
          "cozinha",;
          "areaserv",;
          "despensa",;
          "garagem";
       }
col_ti={;                                                    // titulo das colunas
          "Pasta",;
          "Valor",;
          "Tipo do Bem",;
          "�rea do Terreno",;
          "Unidade da �rea",;
          "�rea da Constru��o",;
          "Endere�o",;
          "N�mero",;
          "Complemento",;
          "Bairro",;
          "Cidade",;
          "UF",;
          "Dormit�rios",;
          "WC",;
          "Suite",;
          "TV - Sala",;
          "Sala de refei��o",;
          "Copa",;
          "Cozinha",;
          "�rea de Servi�o",;
          "Despensa",;
          "Garagem";
       }
cr_="(valor1>=M->valmin).and.(valor1<=M->valmax).And.((Tipo=[2].And.Ativo=[S]).Or.(Tipo=[1].And.Opcao=[S])"
                                                             // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CV2.PRG
