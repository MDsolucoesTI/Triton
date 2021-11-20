/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: CV4.PRG
 \ Data....: 28-08-03
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Bens por Qtd de C“modos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=4, c_s:=20, l_i:=20, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CV4", op_sis:=EVAL(qualsis,"IMOVEIS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±± Consulta de Bens - Completo ±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú C¢digo Â Tipo do Bem ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³        ³                              ³"
@ l_s+05,c_s+1 SAY " Ã Valor M¡nimo ÄÄÄÄÄÂ Valor M ximo ÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³                   ³                   ³"
@ l_s+07,c_s+1 SAY " Ã Bairro ÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+08,c_s+1 SAY " ³                                       ³"
@ l_s+09,c_s+1 SAY " Ã Dormit¢rios ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+10,c_s+1 SAY " ³      M¡nimo :        M ximo :         ³"
@ l_s+11,c_s+1 SAY " Ã Suites ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+12,c_s+1 SAY " ³      M¡nimo :        M ximo :         ³"
@ l_s+13,c_s+1 SAY " Ã Garagem (Vagas) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+14,c_s+1 SAY " ³      M¡nimo :        M ximo :         ³"
@ l_s+15,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
codigo=0                                                     // C¢digo
valmin=0                                                     //Valor Minimo
valmax=0                                                     // Valor Maximo
bairro1=SPAC(20)                                             // Bairro
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
   @ l_s+04 ,c_s+04 GET  codigo;
                    PICT "99";
                    VALI CRIT("PTAB(STR(codigo,02,00),'TIPOIMO',1)~C¢DIGO n„o existe na tabela")
                    AJUDA "Informe o c¢digo do Tipo do Bem"
                    CMDF8 "VDBF(6,54,20,77,'TIPOIMO',{'codigo','tipoimo'},1,'codigo',[])"
                    MOSTRA {"LEFT(TRAN(TIPOIMO->tipoimo,[@!]),15)", 4 , 13 }

   @ l_s+06 ,c_s+04 GET  valmin;
                    PICT "@E 999,999,999,999.99"
                    DEFAULT "0.00"
                    AJUDA "Informe o valor m¡nimo a pagar|se n„o for utilizar na consulta mantenha o valor inicial"

   @ l_s+06 ,c_s+24 GET  valmax;
                    PICT "@E 999,999,999,999.99"
                    DEFAULT "999999999999.99"
                    AJUDA "Informe o valor m ximo a pagar|se n„o for utilizar na consulta mantenha o valor inicial"
                    
   @ l_s+08 ,c_s+04 GET  bairro1
                    AJUDA "Informe o bairro do endere‡o"
                    
   @ l_s+10 ,c_s+18 GET  dormin;
                    PICT "99"
                    DEFAULT "1"
                    AJUDA "Informe o n£mero m¡nimo de dormit¢rios|se n„o for utilizar na consulta mantenha o valor inicial"

   @ l_s+10 ,c_s+35 GET  dormax;
                    PICT "99"
                    DEFAULT "99"
                    AJUDA "Informe o n£mero m ximo de dormit¢rios|se n„o for utilizado na cosulta manter o valor inicial"

   @ l_s+12 ,c_s+18 GET  suimin;
                    PICT "99"
                    DEFAULT "0"
                    AJUDA "Informe o n£mero m¡nimo de suites|se n„o for utilizar na consulta manter o valor inicial"

   @ l_s+12 ,c_s+35 GET  suimax;
                    PICT "99"
                    DEFAULT "99"
                    AJUDA "Informe o n£mero m ximo de suites|se for utilizar na consulta manter o valor inicial"

   @ l_s+14 ,c_s+18 GET  garmin;
                    PICT "99"
                    DEFAULT "0"
                    AJUDA "Informe o n£mero m¡nimo de vagas na garagem|se n„o for utilizar na consulta manter o valor inicial"

   @ l_s+14 ,c_s+35 GET  garmax;
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
          "escrit",;
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
          "Escritorio",;
          "Suite",;
          "TV - Sala",;
          "Sala de refei‡„o",;
          "Copa",;
          "Cozinha",;
          "rea de Servi‡o",;
          "Despensa",;
          "Garagem";
       }
If Select("&Usuario")!=0
   Close
EndIF
AFILL(sistema:=ARRAY(nss+1),{})             // enche sistema[] com vetores nulos
TRI_ATRI()                                  // enche sistema[] com atributos dos arquivos
TRI_ATR1()
TRI_ATR3()

dbf=drvdbf+Usuario
ntx=drvntx+Usuario+"1"
Do While .T.
   If !file("&dbf")
      DBCREATE(dbf,{;
                   {"pasta"     ,"N",  4, 0},; // 9999
                   {"tipo"      ,"C",  1, 0},; // 9
                   {"valor1"    ,"N", 15, 2},; // @E 999,999,999,999.99
                   {"tipoimo"   ,"N",  2, 0},; // 99
                   {"codpro"    ,"N",  8, 0},; // 99999999
                   {"cadpref"   ,"C", 15, 0},; // @!
                   {"escritura" ,"C", 15, 0},; // @!
                   {"areater"   ,"N",  8, 2},; // 99999.99
                   {"uniare"    ,"C",  3, 0},; // @!
                   {"areaconst" ,"N",  8, 2},; // 99999.99
                   {"ender"     ,"C", 35, 0},; //
                   {"numero"    ,"N",  5, 0},; // 99999
                   {"cep"       ,"C",  8, 0},; // @R 99999-999
                   {"compl"     ,"C", 20, 0},; //
                   {"bairro"    ,"C", 20, 0},; //
                   {"cidade"    ,"C", 20, 0},; //
                   {"uf"        ,"C",  2, 0},; // !!
                   {"opcao"     ,"C",  1, 0},; // @!
                   {"valor2"    ,"N", 15, 2},; // @E 999,999,999,999.99
                   {"obs"       ,"M", 10, 0},; // @S40
                   {"dorm"      ,"N",  2, 0},; // 99
                   {"wc"        ,"N",  2, 0},; // 99
                   {"lavabo"    ,"N",  2, 0},; // 99
                   {"hall"      ,"N",  2, 0},; // 99
                   {"escrit"    ,"N",  2, 0},; // 99
                   {"suite"     ,"N",  2, 0},; // 99
                   {"salatv"    ,"N",  2, 0},; // 99
                   {"living"    ,"N",  2, 0},; // 99
                   {"salaref"   ,"N",  2, 0},; // 99
                   {"copa"      ,"N",  2, 0},; // 99
                   {"cozinha"   ,"N",  2, 0},; // 99
                   {"areaserv"  ,"N",  2, 0},; // 99
                   {"despensa"  ,"N",  2, 0},; // 99
                   {"garagem"   ,"N",  2, 0},; // 99
                   {"dormemp"   ,"N",  2, 0},; // 99
                   {"wcemp"     ,"N",  2, 0},; // 99
                   {"rancho"    ,"N",  2, 0},; // 99
                   {"ativo"     ,"C",  1, 0},; //
                   {"intref"    ,"N",  8, 0};  // 99999999
                   };
             )
      USEARQ(dbf,.t.,20,1,.f.)
      INDE ON &(sistema[29,O_CHAVE,1]) TO (ntx)
      Exit
    Else
      FErase("&dbf")
      FErase("&ntx")
    EndIf
EndDo
USEARQ("&Usuario",.t.,10,1)
SELECT IMOVEIS
ind_t=SAVESCREEN(0,0,MAXROW(),79)              // salva tela e da msg
DBOX(" Aguarde !!! ...Processando os dados...",,,,NAO_APAGA)
IF EMPTY(bairro1)
   SET FILTER TO ((Tipo=[2].And.Ativo=[S]).Or.(Tipo=[1].And.Opcao=[S])).and.(tipoimo=M->codigo)
ELSE
   SET FILTER TO ((Tipo=[2].And.Ativo=[S]).Or.(Tipo=[1].And.Opcao=[S])).And.UPPER(bairro)=UPPER(M->bairro1).and.(tipoimo=M->codigo)
ENDIF
GO TOP
DO WHILE .NOT. EOF()
   IF ((dorm>=M->dormin).and.(dorm<=M->dormax)).and.((suite>=M->suimin).and.(suite<=M->suimax)).and.((garagem>=M->garmin).and.(garagem<=M->garmax))
      IF (((Tipo=[2]).And.(Ativo=[S])).And.((valor1>=M->valmin).and.(valor1<=M->valmax))).or.(((Tipo=[1]).And.(Opcao=[S])).and.((valor2>=M->valmin).and.(valor2<=M->valmax)))
         SELECT &Usuario
         APPEND BLANK
         REPLACE pasta     with IMOVEIS->pasta
         REPLACE tipo      with IMOVEIS->tipo
         REPLACE ativo     with IMOVEIS->ativo
         IF (IMOVEIS->Tipo=[2]).And.(IMOVEIS->Ativo=[S])
            REPLACE valor1 with IMOVEIS->valor1
         ELSE
            REPLACE valor1 with IMOVEIS->valor2
         ENDIF
         REPLACE tipoimo   with IMOVEIS->tipoimo
         REPLACE areater   with IMOVEIS->areater
         REPLACE uniare    with IMOVEIS->uniare
         REPLACE areaconst with IMOVEIS->areaconst
         REPLACE ender     with IMOVEIS->ender
         REPLACE numero    with IMOVEIS->numero
         REPLACE cep       with IMOVEIS->cep
         REPLACE compl     with IMOVEIS->compl
         REPLACE bairro    with IMOVEIS->bairro
         REPLACE cidade    with IMOVEIS->cidade
         REPLACE uf        with IMOVEIS->uf
         REPLACE dorm      with IMOVEIS->dorm
         REPLACE wc        with IMOVEIS->wc
         REPLACE escrit    with IMOVEIS->escrit
         REPLACE suite     with IMOVEIS->suite
         REPLACE salatv    with IMOVEIS->salatv
         REPLACE salaref   with IMOVEIS->salaref
         REPLACE copa      with IMOVEIS->copa
         REPLACE cozinha   with IMOVEIS->cozinha
         REPLACE areaserv  with IMOVEIS->areaserv
         REPLACE garagem   with IMOVEIS->garagem
         COMMIT
      ENDIF
   ENDIF
   SELECT IMOVEIS
   SKIP
ENDDO
Close ALL
op_sis:=EVAL(qualsis,Usuario)
USEARQ(Usuario,.t.,10,1)
//op_sis:=EVAL(qualsis,"IMOVEIS")
//USEARQ("IMOVEIS",.t.,10,1)
RESTSCREEN(0,0,MAXROW(),79,ind_t)
GO TOP                                                       // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti)
CLOSE ALL
AFILL(sistema:=ARRAY(nss+1),{})             // enche sistema[] com vetores nulos
TRI_ATRI()                                  // enche sistema[] com atributos dos arquivos
TRI_ATR1()
TRI_ATR2()                                                     // fecha todos os arquivos e
RETU                                                         // volta para o menu anterior
* \\ Final de CV4.PRG
