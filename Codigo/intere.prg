/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: INTERE.PRG
 \ Data....: 26-08-03
 \ Sistema.: Triton - Controle Imobili爎io
 \ Funcao..: Gerenciador do subsistema de interessados
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"INTERE")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]                  // se usuario nao tem permissao,
   ALERTA()                                                  // entao, beep, beep, beep
   DBOX(msg_auto,,,3)                                        // lamentamos e
   RETU                                                      // retornamos ao menu
ENDI
cn:=fgrep :=.f.

#ifdef COM_LOCK
   IF LEN(pr_ok)>0                                           // se a protecao acusou
      ? pr_ok                                                // erro, avisa e
      QUIT                                                   // encerra a aplicacao
   ENDI
#endi

t_fundo=SAVESCREEN(0,0,MAXROW(),79)                          // salva tela do fundo
op_cad=1
DO WHIL op_cad!=0
   criterio=""
   RESTSCREEN(,0,MAXROW(),79,t_fundo)                        // restaura tela do fundo
   cod_sos=5 ; cn=.f.
   CLEA TYPEAHEAD                                            // limpa o buffer do teclado
   fgrep=.f.
   SET KEY K_F3 TO                                           // retira das teclas F3 e F4 as
   SET KEY K_F4 TO                                           // funcoes de repeticao e confirmacao
   msg="Inclus刼|"+;
       "Manuten噭o|"+;
       "Consulta"
   op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,,,,op_cad)
   IF op_cad!=0                                              // se escolheu uma opcao
      Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)                 // salva a tela para ROLATELA()
      SELE A                                                 // e abre o arquivo e seus indices

      #ifdef COM_REDE
         IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)        // se falhou a abertura do
            RETU                                             // arquivo volta ao menu anterior
         ENDI
      #else
         USEARQ(sistema[op_sis,O_ARQUI])
      #endi

      SET KEY K_F9 TO veoutros                               // habilita consulta em outros arquivos
   ENDI
   DO CASE
      CASE op_cad=01                                         // inclus刼
         op_menu=INCLUSAO
         IF AT("D",exrot[op_sis])=0                          // se usuario pode fazer inclusao
            INT_INCL()                                       // neste arquivo chama prg de inclusao
         ELSE                                                // caso contrario vamos avisar que
            ALERTA()                                         // ele nao tem permissao para isto
            DBOX(msg_auto,,,3)
         ENDI

      CASE op_cad=02                                         // manuten噭o
         op_menu=ALTERACAO
         cod_sos=7
         EDIT()

      CASE op_cad=03                                         // consulta
         op_menu=PROJECOES
         cod_sos=8
         EDITA(3,3,MAXROW()-2,77)

   ENDC
   SET KEY K_F9 TO                                           // F9 nao mais consultara outros arquivos
   CLOS ALL                                                  // fecha todos arquivos abertos
ENDD
RETU

PROC INT_incl     // inclusao no arquivo INTERE
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
FOR i=1 TO FCOU()                                            // cria/declara privadas as
   msg=FIEL(i)                                               // variaveis de memoria com
   PRIV &msg.                                                // o mesmo nome dos campos
NEXT                                                         // do arquivo
AFILL(rep,"")
t_f3_=SETKEY(K_F3,{||rep()})                                 // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                                // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})                         // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})

#ifdef COM_REDE
   INT_CRIA_SEQ()                                            // cria dbf de controle de cp sequenciais
   FOR i=1 TO FCOU()                                         // cria/declara privadas as
      msg="sq_"+FIEL(i)                                      // variaveis de memoria com
      PRIV &msg.                                             // o mesmo nome dos campos
   NEXT                                                      // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE INTERE
   GO BOTT                                                   // forca o
   SKIP                                                      // final do arquivo
   
   /*
      cria variaveis de memoria identicas as de arquivo, para inclusao
      de registros
   */
   FOR i=1 TO FCOU()
      msg=FIEL(i)
      M->&msg.=IF(fgrep.AND.!EMPT(rep[1]),rep[i],&msg.)
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   INT_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   INT_GERA_SEQ()
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/INTERE->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA�O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUS嶰 INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   INT_GET1(INCLUI)                                          // recebe campos
   SELE INTERE
   IF LASTKEY()=K_ESC                                        // se cancelou
      cabem=0
      LOOP
   ENDI

   #ifdef COM_REDE
      GO BOTT                                                // vamos bloquear o final do
      SKIP                                                   // arq para que nehum outro
      BLOREG(0,.5)                                           // usuario possa incluir
   #endi

   APPEND BLANK                                              // inclui reg em branco no dbf
   FOR i=1 TO FCOU()                                         // para cada campo,
      msg=FIEL(i)                                            // salva o conteudo
      rep[i]=M->&msg.                                        // para repetir
      REPL &msg. WITH rep[i]                                 // enche o campo do arquivo
   NEXT

   #ifdef COM_REDE
      UNLOCK                                                 // libera o registro e
      COMMIT                                                 // forca gravacao
   #else
      IF RECC()-INT(RECC()/20)*20=0                          // a cada 20 registros
         COMMIT                                              // digitados forca gravacao
      ENDI
   #endi

   ult_reg=RECN()                                            // ultimo registro digitado
ENDD

#ifdef COM_REDE
   INT_ANT_SEQ()                                             // restaura sequencial anterior
   SELE INTERE
#endi

GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU


#ifdef COM_REDE
   PROC INT_ANT_SEQ(est_seq)     // restaura sequencial anterior
   SELE INT_SEQ     // seleciona arquivo de controle de sequencial
   BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
   IF sq_atual_ == cod
      REPL cod WITH sq_cod
   ENDI
   UNLOCK           // libera DBF para outros usuarios
   COMMIT           // atualiza cps sequenciais no disco
   RETU
#endi


PROC INT_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"INT_seq"       // arq temporario
SELE 0                                // seleciona area vazia
IF !FILE(dbfseq_+".dbf")              // se o dbf nao existe
   DBCREATE(dbfseq_,{;                // vamos criar a sua estrutura
                      {"cod"       ,"N",  8, 0};
                    };
   )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)             // abre arquivo de cps sequencial
IF RECC()=0                           // se o dbf foi criado agora
   BLOARQ(0,.5)                       // inclui um registro que tera
   APPEND BLANK                       // os ultomos cps sequenciais
   SELE INTERE
   IF RECC()>0                        // se o DBF nao estiver
      SET ORDER TO 0                  // vazio, entao enche DBF seq
      GO BOTT                         // com o ultimo reg digitado
      REPL INT_SEQ->cod WITH cod
      SET ORDER TO 1                  // retorna ao indice principal
   ENDI
   SELE INT_SEQ                       // seleciona arq de sequencias
   UNLOCK                             // libera DBF para outros usuarios
   COMMIT                             // atualiza cps sequenciais no disco
ENDI
RETURN

PROC INT_GERA_SEQ()

#ifdef COM_REDE
   LOCAL ar_:=SELEC()
#else
   LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
   SELE INT_SEQ
   BLOARQ(0,.5)
   sq_cod=INT_SEQ->cod
#else
   SET ORDER TO 0
   GO BOTT
#endi

M->cod=cod+1
IF M->cod=1
   M->cod=1
ENDI

#ifdef COM_REDE
   INT_GRAVA_SEQ()
   sq_atual_=INT_SEQ->cod
   UNLOCK                                                    // libera o registro
   COMMIT
   SELE (ar_)
#else
   DBSETORDER(ord_ind)
   GO reg_
#endi

RETU

PROC INT_GRAVA_SEQ
REPL cod WITH M->cod
RETU

PROC INT_tela     // tela do arquivo INTERE
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "北北北北北北北 Interessados 北北北北北北北�"
@ l_s+03,c_s+1 SAY " � Cigo 哪哪�"
@ l_s+04,c_s+1 SAY " �            �"
@ l_s+05,c_s+1 SAY " � Nome 哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪目"
@ l_s+06,c_s+1 SAY " �                                       �"
@ l_s+07,c_s+1 SAY " � Telefone 哪哪哪哪穆 Celular 哪哪哪哪哪�"
@ l_s+08,c_s+1 SAY " �                   �                   �"
@ l_s+09,c_s+1 SAY " � Tipo do Bem 哪哪哪聊哪穆 Tipo Oper. 哪�"
@ l_s+10,c_s+1 SAY " �   -                    �   -          �"
@ l_s+11,c_s+1 SAY " � Valor Mimo 哪哪穆 Valor M爔imo 哪哪拇"
@ l_s+12,c_s+1 SAY " �                   �                   �"
@ l_s+13,c_s+1 SAY " � Bairro 哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪拇"
@ l_s+14,c_s+1 SAY " �                                       �"
@ l_s+15,c_s+1 SAY " � Dormitios 哪哪哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+16,c_s+1 SAY " �      Mimo :        M爔imo :         �"
@ l_s+17,c_s+1 SAY " � Suites 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇"
@ l_s+18,c_s+1 SAY " �      Mimo :        M爔imo :         �"
@ l_s+19,c_s+1 SAY " � Garagem (Vagas) 哪哪哪哪哪哪哪哪哪哪哪�"
@ l_s+20,c_s+1 SAY " �      Mimo :        M爔imo :         �"
@ l_s+21,c_s+1 SAY " 滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�"

RETU

PROC INT_gets     // mostra variaveis do arquivo INTERE
LOCAL getlist := {}
INT_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(TIPOIMO,02,00),'TIPOIMO',1)
@ l_s+04 ,c_s+04 GET  cod;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+06 ,c_s+04 GET  nome

@ l_s+08 ,c_s+04 GET  tele;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+08 ,c_s+24 GET  cel;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+10 ,c_s+04 GET  tipoimo;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"1")

@ l_s+10 ,c_s+29 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,15,O_CRIT],,"2")

@ l_s+12 ,c_s+04 GET  valmin;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+12 ,c_s+24 GET  valmax;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                 
@ l_s+14 ,c_s+04 GET  bairro

@ l_s+16 ,c_s+18 GET  dormin;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                 
@ l_s+16 ,c_s+35 GET  dormax;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                 
@ l_s+18 ,c_s+18 GET  suimin;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+18 ,c_s+35 GET  suimax;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                 
@ l_s+20 ,c_s+18 GET  garmin;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+20 ,c_s+35 GET  garmax;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                 
CLEAR GETS
RETU

PROC INT_get1     // capta variaveis do arquivo INTERE
LOCAL getlist := {}
PRIV  blk_INTERE:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  cod;
                       PICT sistema[op_sis,O_CAMPO,01,O_MASC]
      CLEA GETS
      
      @ l_s+06 ,c_s+04 GET  nome
                       DEFINICAO 02
                       
      @ l_s+08 ,c_s+04 GET  tele;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 03
                       
      @ l_s+08 ,c_s+24 GET  cel;
                       PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                       DEFINICAO 04
                       
      @ l_s+10 ,c_s+04 GET  tipoimo;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 05
                       MOSTRA sistema[op_sis,O_FORMULA,1]

      @ l_s+10 ,c_s+29 GET  tipo;
                       PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                       DEFINICAO 15
                       MOSTRA sistema[op_sis,O_FORMULA,2]
                       
      @ l_s+12 ,c_s+04 GET  valmin;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                       DEFINICAO 06

      @ l_s+12 ,c_s+24 GET  valmax;
                       PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                       DEFINICAO 07

      @ l_s+14 ,c_s+04 GET  bairro
                       DEFINICAO 08

      @ l_s+16 ,c_s+18 GET  dormin;
                       PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                       DEFINICAO 09

      @ l_s+16 ,c_s+35 GET  dormax;
                       PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                       DEFINICAO 10

      @ l_s+18 ,c_s+18 GET  suimin;
                       PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                       DEFINICAO 11

      @ l_s+18 ,c_s+35 GET  suimax;
                       PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                       DEFINICAO 12

      @ l_s+20 ,c_s+18 GET  garmin;
                       PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                       DEFINICAO 13

      @ l_s+20 ,c_s+35 GET  garmax;
                       PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                       DEFINICAO 14

      READ
      SET KEY K_ALT_F8 TO
      IF rola_t
         ROLATELA()
         LOOP
      ENDI
      IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
         IF !CONFINCL()
            LOOP
         ENDI
      ENDI
      EXIT
   ENDD
ENDI
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   MANUREF(STR(TIPOIMO,02,00),'TIPOIMO',1,DECREMENTA)
   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. TIPOIMO->(DELE())
         msg=""
         IF TIPOIMO->(DELE())
            msg="|"+sistema[EVAL(qualsis,"TIPOIMO"),O_MENU]
         ENDI
         ALERTA(2)
         DBOX("Registro excluo em:"+msg+"|*",,,,,"IMPOSSEL RECUPERAR!")
      ELSE
         MANUREF(STR(TIPOIMO,02,00),'TIPOIMO',1,INCREMENTA)
         IF op_menu!=INCLUSAO
            RECA
         ENDIF
      ENDIF
   ENDIF
ENDIF
RETU

* \\ Final de INTERE.PRG
