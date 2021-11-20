/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CV2.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Bens por Bairro
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CV2", op_sis:=EVAL(qualsis,"IMOVEIS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±± Consulta de Bens - Bairro ±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Bairro ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                                      ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
bairro1=SPAC(20)                                             // Bairro
DO WHILE .t.
   rola_t=.f.
   cod_sos=56
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+04 ,c_s+04 GET  bairro1
                    AJUDA "Informe o bairro do endere‡o"

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
cr_="UPPER(bairro)=UPPER(M->bairro1).and.((tipo=[2].and.ativo=[S]).or.(tipo=[1].and.opcao=[S]))"
                                                             // filtro inicial
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti,cr_)
CLOSE ALL                                                    // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior

* \\ Final de CV2.PRG
