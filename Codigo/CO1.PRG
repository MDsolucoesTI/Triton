/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CO1.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Bens por Tipo
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CO1", op_sis:=EVAL(qualsis,"IMOVEIS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北 Consulta de Bens - Tipo 北北北北�"
@ l_s+03,c_s+1 SAY " � Cigo � Tipo do Bem 哪哪哪哪哪哪哪哪�"
@ l_s+04,c_s+1 SAY " �        �                             �"
@ l_s+05,c_s+1 SAY " 滥哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁"
codigo=0                                                     // Cigo
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  codigo;
                    PICT "99";
                    VALI CRIT("PTAB(STR(codigo,02,00),'TIPOIMO',1)~CIGO n刼 existe na tabela")
                    AJUDA "Informe o cigo do Tipo de Bem"
                    CMDF8 "VDBF(6,54,20,77,'TIPOIMO',{'codigo','tipoimo'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(TIPOIMO->tipoimo,[@!]),15)", 4 , 14 }

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
          "tipo",;
          "valor1",;
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
          "Tipo Opera噭o",;
          "Valor",;
          "弐ea do Terreno",;
          "Unidade da 爎ea",;
          "弐ea da Constru噭o",;
          "Endere噊",;
          "Nero",;
          "Complemento",;
          "Bairro",;
          "Cidade",;
          "UF",;
          "Dormitios",;
          "WC",;
          "Suite",;
          "TV - Sala",;
          "Sala de refei噭o",;
          "Copa",;
          "Cozinha",;
          "弐ea de Servi噊",;
          "Despensa",;
          "Garagem";
       }
cr_="tipoimo=M->codigo.and.(((tipo=[1]).or.(tipo=[2].and.opcao=[S])).and.ativo=[S])"
                                                             // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CO1.PRG
