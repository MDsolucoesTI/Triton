/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: CV3.PRG
 \ Data....: 02-09-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Bens por Qtd de C“modos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=8, c_s:=20, l_i:=18, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CV3", op_sis:=EVAL(qualsis,"IMOVEIS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±± Consulta de Bens - Qtd C“modos ±±±±±"
@ l_s+03,c_s+1 SAY " Ú Dormit¢rios ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³      M¡nimo :        M ximo :        ³"
@ l_s+05,c_s+1 SAY " Ã Suites ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³      M¡nimo :        M ximo :        ³"
@ l_s+07,c_s+1 SAY " Ã Garagem (Vagas) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+08,c_s+1 SAY " ³      M¡nimo :        M ximo :        ³"
@ l_s+09,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
dormin=0                                                     // M¡nimo de Dormit¢rios
dormax=0                                                     // M ximo de Dormit¢rios
suimin=0                                                     // M¡nimo de Suites
suimax=0                                                     // M ximo de Suites
garmin=0                                                     // M¡nimo de Garagens
garmax=0                                                     // M ximo de Garagens
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+18 GET  dormin;
                    PICT "99"
                    DEFAULT "1"
                    AJUDA "Informe o n£mero m¡nimo de dormit¢rios|se n„o for utilizar na consulta mantenha o valor inicial"

   @ l_s+04 ,c_s+34 GET  dormax;
                    PICT "99"
                    DEFAULT "99"
                    AJUDA "Informe o n£mero m ximo de dormit¢rios|se n„o for utilizado na cosulta manter o valor inicial"

   @ l_s+06 ,c_s+18 GET  suimin;
                    PICT "99"
                    DEFAULT "0"
                    AJUDA "Informe o n£mero m¡nimo de suites|se n„o for utilizar na consulta manter o valor inicial"

   @ l_s+06 ,c_s+34 GET  suimax;
                    PICT "99"
                    DEFAULT "99"
                    AJUDA "Informe o n£mero m ximo de suites|se for utilizar na consulta manter o valor inicial"

   @ l_s+08 ,c_s+18 GET  garmin;
                    PICT "99"
                    DEFAULT "0"
                    AJUDA "Informe o n£mero m¡nimo de vagas na garagem|se n„o for utilizar na consulta manter o valor inicial"

   @ l_s+08 ,c_s+34 GET  garmax;
                    PICT "99"
                    DEFAULT "99"
                    AJUDA "Informe o n£mero m ximo de vagas na garagem|se n„o for utilizar na consulta manter o valor inicial"

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
          "ativo",;
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
          "Tipo Opera‡„o",;
          "Ativo",;
          "Valor",;
          "Tipo do Bem",;
          "rea do Terreno",;
          "Unidade da  rea",;
          "rea da Constru‡„o",;
          "Endere‡o",;
          "N£mero",;
          "Complemento",;
          "Bairro",;
          "Cidade",;
          "UF",;
          "Dormit¢rios",;
          "WC",;
          "Suite",;
          "TV - Sala",;
          "Sala de refei‡„o",;
          "Copa",;
          "Cozinha",;
          "rea de Servi‡o",;
          "Despensa",;
          "Garagem";
       }
cr_="(dorm>=M->dormin.and.dorm<=M->dormax).and.(suite>=M->suimin.and.suite<=M->suimax).and.(garagem>=M->garmin.and.garagem<=M->garmax).And.((Tipo=[2].And.Ativo=[S]).Or.(Tipo=[1].And.Opcao=[S]))"
                                                             // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CV3.PRG
