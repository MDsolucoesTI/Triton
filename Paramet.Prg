/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: PARAMET.PRG
 \ Data....: 06-08-96
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerenciador do subsistema de configura‡”es do sistema
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"PARAMET")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]                  // se usuario nao tem permissao,
   ALERTA()                                                  // entao, beep, beep, beep
   DBOX(msg_auto,,,3)                                        // lamentamos e
   RETU                                                      // retornamos ao menu
ENDI

#ifdef COM_LOCK
   IF LEN(pr_ok)>0                                           // se a protecao acusou
      ? pr_ok                                                // erro, avisa e
      QUIT                                                   // encerra a aplicacao
   ENDI
#endi

SELE A

#ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI],.t.,20,1,.f.)          // se falhou a abertura do
      RETU                                                   // arquivo volta ao menu anterior
   ENDI
#else
   USEARQ(sistema[op_sis,O_ARQUI],,,,.f.)
#endi

SET KEY K_F9 TO veoutros                                     // habilita consulta em outros arquivos
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})                         // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
op_menu=ALTERACAO                                            // parametro e' como se fosse alteracao
cod_sos=54
rola_t=.f.                                                   // flag se quer rolar a tela
SELE PARAMET
DISPBEGIN()                                                  // monta tela na pagina de traz
PAR_TELA()
PAR_GETS()
INFOSIS()                                                  // exibe informacao no rodape' da tela
DISPEND()
PAR_GET1(INCLUI)
SELE PARAMET
mudou_=.f.
FOR i=1 TO FCOU()                                            // atualiza variaveis publicas
   msg=FIEL(i)                                               // do arquivo de parametros
   mudou_=IF(M->&msg.!=&msg.,.t.,mudou_)
   M->&msg.=&msg.
NEXT
SET KEY K_F9 TO                                              // desativa tecla F9 (veoutros)
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
*If Senha()!=AllTrim(Paramet->Palavra)
*   DBox('Houve Viola‡„o na Configura‡„o do Sistema ou na Senha de libera‡„o|comunique-se com sua empresa de suporte ou com a SOLUTION|para verifica‡„o do ocorrido.',,,0,.T.,,)
*   Close all
*   KeyBoard chr(13)
*   do Sair
*EndIf
IF mudou_
   CBC1(.t.)
   v01=SAVESCREEN(0,0,MAXROW(),79)
   BREAK
ENDI
RETU

PROC PAR_tela     // tela do arquivo PARAMET
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
IF sistema[op_sis,O_TELA,O_ATUAL]=1
   @ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±±±± Parƒmetros do Sistema ±±±±±±±±±±±±±±±±±±±±±±±±±"
   @ l_s+03,c_s+1 SAY " Ú Empresa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ CGC ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ CRECI ÄÄ¿"
   @ l_s+04,c_s+1 SAY " ³                                     ³                    ³         ³"
   @ l_s+05,c_s+1 SAY " Ã Endere‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ N£mero ÄÄÄÄÄÂ CEP ÄÁÄÄÄÄÄÄÄÄÄ´"
   @ l_s+06,c_s+1 SAY " ³                                     ³             ³                ³"
   @ l_s+07,c_s+1 SAY " Ã Complemento ÄÄÄÄÂ Bairro ÄÄÄÄÄÄÄÄÄÄÄÁÄÄÂ Cidade ÄÄÁÄÄÄÄÄÄÄÄÄÄÄÂ UF ´"
   @ l_s+08,c_s+1 SAY " ³                 ³                      ³                      ³    ³"
   @ l_s+09,c_s+1 SAY " Ã Telefone ÄÄÄÄÄÄÄÅ Fax ÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÙ"
   @ l_s+10,c_s+1 SAY " ³                 ³                ³"
   @ l_s+11,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ l_s+12,c_s+1 SAY " Ú Multa ÄÄÂ Indice IPTU ¿"
   @ l_s+13,c_s+1 SAY " ³       % ³             ³"
   @ l_s+14,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
ELSE
   @ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±±±± Parƒmetros do Sistema ±±±±±±±±±±±±±±±±±±±±±±±±±"
   @ l_s+04,c_s+1 SAY "  ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ Libera‡„o de Uso ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ"
   @ l_s+05,c_s+1 SAY "  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
   @ l_s+06,c_s+1 SAY "  º In¡cio do Contrato  ³            º       ³                      º"
   @ l_s+07,c_s+1 SAY "  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ¶ Senha ³                      º"
   @ l_s+08,c_s+1 SAY "  º T‚rmino do Contrato ³            º       ³                      º"
   @ l_s+09,c_s+1 SAY "  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
ENDI
RETU

PROC PAR_gets     // mostra variaveis do arquivo PARAMET
LOCAL getlist := {}, ctl_c, ctl_r
PAR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
IF sistema[op_sis,O_TELA,O_ATUAL]=1
   @ l_s+04 ,c_s+04 GET  empresa

   @ l_s+04 ,c_s+42 GET  cgc1;
                    PICT sistema[op_sis,O_CAMPO,02,O_MASC]

   @ l_s+04 ,c_s+63 GET  creci;
                    PICT sistema[op_sis,O_CAMPO,03,O_MASC]

   @ l_s+06 ,c_s+04 GET  ender1

   @ l_s+06 ,c_s+42 GET  numero1;
                    PICT sistema[op_sis,O_CAMPO,05,O_MASC]

   @ l_s+06 ,c_s+56 GET  cep1;
                    PICT sistema[op_sis,O_CAMPO,06,O_MASC]

   @ l_s+08 ,c_s+04 GET  compl1

   @ l_s+08 ,c_s+22 GET  bairro1

   @ l_s+08 ,c_s+45 GET  cidade1

   @ l_s+08 ,c_s+68 GET  uf1;
                    PICT sistema[op_sis,O_CAMPO,10,O_MASC]

   @ l_s+10 ,c_s+04 GET  tele1;
                    PICT sistema[op_sis,O_CAMPO,11,O_MASC]

   @ l_s+10 ,c_s+22 GET  fax1;
                    PICT sistema[op_sis,O_CAMPO,12,O_MASC]

   @ l_s+13 ,c_s+04 GET  multa;
                    PICT sistema[op_sis,O_CAMPO,13,O_MASC]

   @ l_s+13 ,c_s+14 GET  iptu;
                    PICT sistema[op_sis,O_CAMPO,14,O_MASC]

ELSE
   @ l_s+06 ,c_s+27 GET  dtinicont;
                    PICT sistema[op_sis,O_CAMPO,15,O_MASC]

   @ l_s+08 ,c_s+27 GET  dtfimcont;
                    PICT sistema[op_sis,O_CAMPO,16,O_MASC]

   @ l_s+07 ,c_s+48 GET  palavra

ENDI
CLEAR GETS
RETU

PROC PAR_get1     // capta variaveis do arquivo PARAMET
LOCAL getlist := {}, ctl_c, ctl_r
PRIV  blk_paramet:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   ctl_r=SETKEY(K_CTRL_R,{||tela_ant()})
   IF op_menu!=INCLUSAO
      ctl_c=SETKEY(K_CTRL_C,{||tela_seg()})
   ENDI
   DO WHILE sistema[op_sis,O_TELA,O_ATUAL]<=sistema[op_sis,O_TELA,O_DEF]
      volta=0; rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      IF sistema[op_sis,O_TELA,O_ATUAL]=1
         @ l_s+04 ,c_s+04 GET  empresa
                          DEFINICAO 1

         @ l_s+04 ,c_s+42 GET  cgc1;
                          PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                          DEFINICAO 2

         @ l_s+04 ,c_s+63 GET  creci;
                          PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                          DEFINICAO 3

         @ l_s+06 ,c_s+04 GET  ender1
                          DEFINICAO 4

         @ l_s+06 ,c_s+42 GET  numero1;
                          PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                          DEFINICAO 5

         @ l_s+06 ,c_s+56 GET  cep1;
                          PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                          DEFINICAO 6

         @ l_s+08 ,c_s+04 GET  compl1
                          DEFINICAO 7

         @ l_s+08 ,c_s+22 GET  bairro1
                          DEFINICAO 8

         @ l_s+08 ,c_s+45 GET  cidade1
                          DEFINICAO 9

         @ l_s+08 ,c_s+68 GET  uf1;
                          PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                          DEFINICAO 10

         @ l_s+10 ,c_s+04 GET  tele1;
                          PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                          DEFINICAO 11

         @ l_s+10 ,c_s+22 GET  fax1;
                          PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                          DEFINICAO 12

         @ l_s+13 ,c_s+04 GET  multa;
                          PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                          DEFINICAO 13

         @ l_s+13 ,c_s+14 GET  iptu;
                          PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                          DEFINICAO 14

      ELSE
         @ l_s+06 ,c_s+27 GET  dtinicont;
                          PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                          DEFINICAO 15

         @ l_s+08 ,c_s+27 GET  dtfimcont;
                          PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                          DEFINICAO 16

         @ l_s+07 ,c_s+48 GET  palavra
                          DEFINICAO 17

      ENDI
      READ
      SET KEY K_ALT_F8 TO
      IF rola_t
         ROLATELA()
         LOOP
      ENDI
      IF volta=0 .AND. LASTKEY()=K_ESC
         EXIT
      ENDI
      sistema[op_sis,O_TELA,O_ATUAL]++
      IF sistema[op_sis,O_TELA,O_ATUAL]<=sistema[op_sis,O_TELA,O_DEF]
         PAR_TELA()
         IF op_menu=ALTERACAO .OR. volta=1
            PAR_GETS()
         ENDI
         INFOSIS()
      ELSE
         sistema[op_sis,O_TELA,O_ATUAL]=sistema[op_sis,O_TELA,O_DEF]
         EXIT
      ENDI
   ENDD
   SETKEY(K_CTRL_R,ctl_r)
   IF op_menu!=INCLUSAO
      SETKEY(K_CTRL_C,ctl_c)
   ENDI
ENDI
RETU

* \\ Final de PARAMET.PRG
