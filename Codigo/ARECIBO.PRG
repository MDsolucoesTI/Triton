/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: ARECIBO.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili�rio
 \ Funcao..: Gerenciador do subsistema de recibos locat�rios
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"ARECIBO")
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
   msg="Manuten��o|"+;
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
      CASE op_cad=01                                         // manuten��o
         op_menu=ALTERACAO
         cod_sos=7
         EDIT()

      CASE op_cad=02                                         // consulta
         op_menu=PROJECOES
         cod_sos=8
         EDITA(3,3,MAXROW()-2,77)

   ENDC
   SET KEY K_F9 TO                                           // F9 nao mais consultara outros arquivos
   CLOS ALL                                                  // fecha todos arquivos abertos
ENDD
RETU

PROC ARE_incl     // inclusao no arquivo ARECIBO
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=2}                                           // condicao de inclusao de registros
IF !EVAL(cond_incl_)                                         // se nao pode incluir
   ALERTA(2)                                                 // avisa o motivo
   DBOX("Inclus�o s� pela rotina de Gerar Recibos",,,4,,"ATEN��O, "+usuario)
   RETU                                                      // e retorna
ENDI
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
   ARE_CRIA_SEQ()                                            // cria dbf de controle de cp sequenciais
   FOR i=1 TO FCOU()                                         // cria/declara privadas as
      msg="sq_"+FIEL(i)                                      // variaveis de memoria com
      PRIV &msg.                                             // o mesmo nome dos campos
   NEXT                                                      // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE ARECIBO
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
   ARE_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   ARE_GERA_SEQ()
   IF !EVAL(cond_incl_)
      EXIT
   ENDI
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/ARECIBO->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA�O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   M->per2=(per1+30)-1
   M->total=valor1+iptu+agua+luz+telefone+outros
   M->total2=valor2+iptu1+agua+luz+telefone+outros+cla20+correc
   SELE 0                                                    // torna visiveis variaveis de memoria
   ARE_GET1(INCLUI)                                          // recebe campos
   SELE ARECIBO
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
   ARE_ANT_SEQ()                                             // restaura sequencial anterior
   SELE ARECIBO
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
   PROC ARE_ANT_SEQ(est_seq)     // restaura sequencial anterior
   SELE ARE_SEQ     // seleciona arquivo de controle de sequencial
   BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
   IF sq_atual_ == sequen
      REPL sequen WITH sq_sequen
   ENDI
   UNLOCK           // libera DBF para outros usuarios
   COMMIT           // atualiza cps sequenciais no disco
   RETU
#endi


PROC ARE_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"ARE_seq"       // arq temporario
SELE 0                                // seleciona area vazia
IF !FILE(dbfseq_+".dbf")              // se o dbf nao existe
   DBCREATE(dbfseq_,{;                // vamos criar a sua estrutura
                      {"sequen"    ,"N",  9, 0};
                    };
   )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)             // abre arquivo de cps sequencial
IF RECC()=0                           // se o dbf foi criado agora
   BLOARQ(0,.5)                       // inclui um registro que tera
   APPEND BLANK                       // os ultomos cps sequenciais
   SELE ARECIBO
   IF RECC()>0                        // se o DBF nao estiver
      SET ORDER TO 0                  // vazio, entao enche DBF seq
      GO BOTT                         // com o ultimo reg digitado
      REPL ARE_SEQ->sequen WITH sequen
      SET ORDER TO 1                  // retorna ao indice principal
   ENDI
   SELE ARE_SEQ                       // seleciona arq de sequencias
   UNLOCK                             // libera DBF para outros usuarios
   COMMIT                             // atualiza cps sequenciais no disco
ENDI
RETURN

PROC ARE_GERA_SEQ()

#ifdef COM_REDE
   LOCAL ar_:=SELEC()
#else
   LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
   SELE ARE_SEQ
   BLOARQ(0,.5)
   sq_sequen=ARE_SEQ->sequen
#else
   SET ORDER TO 0
   GO BOTT
#endi

M->sequen=sequen+1
IF M->sequen=1
   M->sequen=1
ENDI

#ifdef COM_REDE
   ARE_GRAVA_SEQ()
   sq_atual_=ARE_SEQ->sequen
   UNLOCK                                                    // libera o registro
   COMMIT
   SELE (ar_)
#else
   DBSETORDER(ord_ind)
   GO reg_
#endi

RETU

PROC ARE_GRAVA_SEQ
REPL sequen WITH M->sequen
RETU

PROC ARE_tela     // tela do arquivo ARECIBO
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "����������������������� Manuten��o de Recibos ������������������������"
@ l_s+03,c_s+1 SAY " � Sequencia � Pasta � N� ��� Venc Cont. � Periodo ����������������Ŀ"
@ l_s+04,c_s+1 SAY " �           �       �      �            �            a             �"
@ l_s+05,c_s+1 SAY " � Locat�rio�������������������������������������������������������Ĵ"
@ l_s+06,c_s+1 SAY " �          -                                                       �"
@ l_s+07,c_s+1 SAY " � Fiador ���������������������������������������������������������Ĵ"
@ l_s+08,c_s+1 SAY " �          -                                                       �"
@ l_s+09,c_s+1 SAY " ��������������������������������������������������������������������"
@ l_s+10,c_s+1 SAY " �� At� :            ��������������� Ap�s :            ������������ͻ"
@ l_s+11,c_s+1 SAY " � Aluguel.......:                � Aluguel.......:                 �"
@ l_s+12,c_s+1 SAY " � IPTU..........:                � IPTU..........:                 �"
@ l_s+13,c_s+1 SAY " � Agua..........:                � Agua..........:                 �"
@ l_s+14,c_s+1 SAY " � Luz...........:                � Luz...........:                 �"
@ l_s+15,c_s+1 SAY " � Telefone......:                � Telefone......:                 �"
@ l_s+16,c_s+1 SAY " � Outros........:                � Outros........:                 �"
@ l_s+17,c_s+1 SAY " �                                � Diversos......:                 �"
@ l_s+18,c_s+1 SAY " �                                � Corre��o......:                 �"
@ l_s+19,c_s+1 SAY " ������������������������������������������������������������������Ķ"
@ l_s+20,c_s+1 SAY " � Total.........:                � Total.........:                 �"
@ l_s+21,c_s+1 SAY " ������������������������������������������������������������������ͼ"
RETU

PROC ARE_gets     // mostra variaveis do arquivo ARECIBO
LOCAL getlist := {}
ARE_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(PASTA,04,00),'ALUGUEL',1)
CRIT("",,"7")
@ l_s+04 ,c_s+04 GET  sequen;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+04 ,c_s+24 GET  numrec;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+04 ,c_s+44 GET  per1;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+04 ,c_s+57 GET  per2;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+10 ,c_s+11 GET  venc;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"6")

@ l_s+11 ,c_s+23 GET  valor1;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+12 ,c_s+23 GET  iptu1;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,08,O_CRIT],,"8")

@ l_s+13 ,c_s+23 GET  agua;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,09,O_CRIT],,"9")

@ l_s+14 ,c_s+23 GET  luz;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,10,O_CRIT],,"10")

@ l_s+15 ,c_s+23 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,11,O_CRIT],,"11")

@ l_s+16 ,c_s+23 GET  outros;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,12,O_CRIT],,"12")

@ l_s+20 ,c_s+23 GET  total;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+11 ,c_s+57 GET  valor2;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+17 ,c_s+57 GET  cla20;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+18 ,c_s+57 GET  correc;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+20 ,c_s+57 GET  total2;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

CRIT("",,"1|2|3|4|5")
CLEAR GETS
RETU

PROC ARE_get1     // capta variaveis do arquivo ARECIBO
LOCAL getlist := {}
PRIV  blk_arecibo:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET sequen;
                       PICT sistema[op_sis,O_CAMPO,01,O_MASC]
      @ l_s+04 ,c_s+24 GET numrec;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
      CLEA GETS
      CRIT("",,"7")
      @ l_s+04 ,c_s+44 GET  per1;
                       PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                       DEFINICAO 4

      @ l_s+04 ,c_s+57 GET per2;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 5

      @ l_s+10 ,c_s+11 GET  venc;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                       DEFINICAO 6
                       MOSTRA sistema[op_sis,O_FORMULA,6]

      @ l_s+11 ,c_s+23 GET  valor1;
                       PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                       DEFINICAO 7

      @ l_s+12 ,c_s+23 GET  iptu1;
                       PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                       DEFINICAO 8
                       MOSTRA sistema[op_sis,O_FORMULA,8]

      @ l_s+13 ,c_s+23 GET  agua;
                       PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                       DEFINICAO 9
                       MOSTRA sistema[op_sis,O_FORMULA,9]

      @ l_s+14 ,c_s+23 GET  luz;
                       PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                       DEFINICAO 10
                       MOSTRA sistema[op_sis,O_FORMULA,10]

      @ l_s+15 ,c_s+23 GET  telefone;
                       PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                       DEFINICAO 11
                       MOSTRA sistema[op_sis,O_FORMULA,11]

      @ l_s+16 ,c_s+23 GET  outros;
                       PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                       DEFINICAO 12
                       MOSTRA sistema[op_sis,O_FORMULA,12]

      @ l_s+20 ,c_s+23 GET total;
                       PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                       DEFINICAO 13

      @ l_s+11 ,c_s+57 GET  valor2;
                       PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                       DEFINICAO 14

      @ l_s+17 ,c_s+57 GET  cla20;
                       PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                       DEFINICAO 15

      @ l_s+18 ,c_s+57 GET  correc;
                       PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                       DEFINICAO 16

      @ l_s+20 ,c_s+57 GET total2;
                       PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                       DEFINICAO 17

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
PTAB(STR(PASTA,04,00),'ALUGUEL',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. ALUGUEL->(DELE())
         msg="|"+sistema[EVAL(qualsis,""),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu�do em:"+msg+"|*",,,,,"IMPOSS�VEL RECUPERAR!")
      ELSE
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

* \\ Final de ARECIBO.PRG
