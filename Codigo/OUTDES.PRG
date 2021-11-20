/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: OUTDES.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerenciador do subsistema de outras despesas
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"OUTDES")
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
   msg="Manuten‡„o|"+;                                       // menu do subsistema
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
      CASE op_cad=01                                         // manuten‡„o
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

PROC OUT_incl     // inclusao no arquivo OUTDES
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=2}                                           // condicao de inclusao de registros
IF !EVAL(cond_incl_)                                         // se nao pode incluir
   ALERTA(2)                                                 // avisa o motivo
   DBOX("Inclus„o s¢ pela rotina de Gerar Outas Despesas",,,4,,"ATEN€ŽO, "+usuario)
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
   OUT_CRIA_SEQ()                                            // cria dbf de controle de cp sequenciais
   FOR i=1 TO FCOU()                                         // cria/declara privadas as
      msg="sq_"+FIEL(i)                                      // variaveis de memoria com
      PRIV &msg.                                             // o mesmo nome dos campos
   NEXT                                                      // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE OUTDES
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
   OUT_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   OUT_GERA_SEQ()
   IF !EVAL(cond_incl_)
      EXIT
   ENDI
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/OUTDES->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   SET KEY K_ALT_F8 TO ROLATELA
   
   /*
      recebe chaves do arquivo de indice basico
   */
   @ l_s+04 ,c_s+12 GET  cod;
                    PICT sistema[op_sis,O_CAMPO,02,O_MASC]
   CLEA GETS
   @ l_s+04 ,c_s+04 GET  pasta;
                    PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                    DEFINICAO 1

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA()

      #ifdef COM_REDE
         OUT_ANT_SEQ()                                       // decrementa sequencial
      #endi

      LOOP
   ENDI
   SELE OUTDES
   IF LASTKEY()=K_ESC                                        // cancelou ou chave em branco
      cabem=0                                                // prepara saida da inclusao
      LOOP                                                   // volta p/ menu de cadastramento
   ENDI
   SEEK STR(M->pasta,04,00)+STR(M->cod,09,00)
   aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)           // vai aproveitar o registro?
   IF FOUND() .AND. !aprov_reg_                              // pesquisou e achou!
      op_menu=ALTERACAO                                      // seta flag de ateracao

      #ifdef COM_REDE
         OUT_ANT_SEQ()                                       // decrementa sequencial
         SELE OUTDES
      #endi

      DISPBEGIN()
      OUT_GETS()                                             // mostra conteudo do registro
      INFOSIS()                                              // exibe informacao no rodape' da tela
      DISPEND()
      ALERTA()
      msg="Consultar/alterar|Retornar … inclus„o"            // pergunta se deseja
      op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")           // alterar o registro
      IF op_ =1                                              // caso afirmativo
         EDIT()                                              // deixa alterar
      ENDI
      op_menu=INCLUSAO
      LOOP                                                   // volta para inclusao
   ENDI
   SELE 0
   OUT_GET1(INCLUI)                                          // recebe campos
   SELE OUTDES
   IF LASTKEY()=K_ESC                                        // se cancelou

      #ifdef COM_REDE
         OUT_ANT_SEQ()                                       // decrementa sequencial
      #endi

      ALERTA()                                               // avisa que o registro
      DBOX("Registro n„o inclu¡do!",18,,1)                   // nao foi incluido, e volta
      LOOP
   ENDI

   #ifdef COM_REDE
      GO BOTT                                                // vamos bloquear o final do
      SKIP                                                   // arq para que nehum outro
      BLOREG(0,.5)                                           // usuario possa incluir
      SEEK STR(M->pasta,04,00)+STR(M->cod,09,00)             // se registro foi incluido
      aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)        // vai aproveitar o registro?
      IF FOUND() .AND. !aprov_reg_                           // por outro usuario, entao
         BLOREG(0,.5)
         FOR i=1 TO FCOU()
            msg=FIEL(i)
            rep[i]=&msg.
            REPL &msg. WITH M->&msg.
         NEXT
         OUT_GET1(FORM_INVERSA)                              // executa formula inversa
         RECA
         FOR i=1 TO FCOU()
            msg=FIEL(i)
            REPL &msg. WITH rep[i]
         NEXT
         ALERTA(4)                                           // beep 4 vezes
         msg="Registro acabou de ser|inclu¡do por outro usu rio!"
         DBOX(msg,,,,,"ATEN€ŽO!")                            // avisa
         SELE OUTDES
         UNLOCK                                              // libera o registro
         LOOP                                                // e recebe chave novamente
      ENDI
   #endi

   IF aprov_reg_                                             // se vai aproveitar reg excluido

      #ifdef COM_REDE
         BLOREG(0,.5)
      #endi

      RECA                                                   // excluido, vamos recupera-lo
   ELSE                                                      // caso contrario
      APPEND BLANK                                           // inclui reg em branco no dbf
   ENDI
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
   OUT_ANT_SEQ()                                             // restaura sequencial anterior
   SELE OUTDES
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
   PROC OUT_ANT_SEQ(est_seq)     // restaura sequencial anterior
   SELE OUT_SEQ     // seleciona arquivo de controle de sequencial
   BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
   IF sq_atual_ == cod
      REPL cod WITH sq_cod
   ENDI
   UNLOCK           // libera DBF para outros usuarios
   COMMIT           // atualiza cps sequenciais no disco
   RETU
#endi


PROC OUT_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"OUT_seq"       // arq temporario
SELE 0                                // seleciona area vazia
IF !FILE(dbfseq_+".dbf")              // se o dbf nao existe
   DBCREATE(dbfseq_,{;                // vamos criar a sua estrutura
                      {"cod"       ,"N",  9, 0};
                    };
   )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)             // abre arquivo de cps sequencial
IF RECC()=0                           // se o dbf foi criado agora
   BLOARQ(0,.5)                       // inclui um registro que tera
   APPEND BLANK                       // os ultomos cps sequenciais
   SELE OUTDES
   IF RECC()>0                        // se o DBF nao estiver
      SET ORDER TO 0                  // vazio, entao enche DBF seq
      GO BOTT                         // com o ultimo reg digitado
      REPL OUT_SEQ->cod WITH cod
      SET ORDER TO 1                  // retorna ao indice principal
   ENDI
   SELE OUT_SEQ                       // seleciona arq de sequencias
   UNLOCK                             // libera DBF para outros usuarios
   COMMIT                             // atualiza cps sequenciais no disco
ENDI
RETURN

PROC OUT_GERA_SEQ()

#ifdef COM_REDE
   LOCAL ar_:=SELEC()
#else
   LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
   SELE OUT_SEQ
   BLOARQ(0,.5)
   sq_cod=OUT_SEQ->cod
#else
   SET ORDER TO 0
   GO BOTT
#endi

M->cod=cod+1
IF M->cod=1
   M->cod=1
ENDI

#ifdef COM_REDE
   OUT_GRAVA_SEQ()
   sq_atual_=OUT_SEQ->cod
   UNLOCK                                                    // libera o registro
   COMMIT
   SELE (ar_)
#else
   DBSETORDER(ord_ind)
   GO reg_
#endi

RETU

PROC OUT_GRAVA_SEQ
REPL cod WITH M->cod
RETU

PROC OUT_tela     // tela do arquivo OUTDES
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±± Outras Despesas ±±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " É Pasta Ë C¢digo ÍÍÍ»"
@ l_s+04,c_s+1 SAY " º       º           º"
@ l_s+05,c_s+1 SAY " ÈÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¼"
@ l_s+06,c_s+1 SAY " Ú Tipo de Despesa ÄÄÄÄÄÄÄÂ Valor ÄÄÄÄÄÄÄÂ Parcela Ä¿"
@ l_s+07,c_s+1 SAY " ³    -                   ³              ³          ³"
@ l_s+08,c_s+1 SAY " Ã Vencimento Â Favorecido ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+09,c_s+1 SAY " ³            ³                                     ³"
@ l_s+10,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
RETU

PROC OUT_gets     // mostra variaveis do arquivo OUTDES
LOCAL getlist := {}
OUT_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(TIPDES,02,00),'DESPE',1)
@ l_s+04 ,c_s+04 GET  pasta;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+04 ,c_s+12 GET  cod;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+07 ,c_s+04 GET  tipdes;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

@ l_s+07 ,c_s+29 GET  valdes;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+07 ,c_s+44 GET  parc;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+09 ,c_s+04 GET  dtvenc;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+09 ,c_s+17 GET  nome

CLEAR GETS
RETU

PROC OUT_get1     // capta variaveis do arquivo OUTDES
LOCAL getlist := {}
PRIV  blk_outdes:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+07 ,c_s+04 GET  tipdes;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 3
                       MOSTRA sistema[op_sis,O_FORMULA,1]

      @ l_s+07 ,c_s+29 GET  valdes;
                       PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                       DEFINICAO 4

      @ l_s+07 ,c_s+44 GET  parc;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 5

      @ l_s+09 ,c_s+04 GET  dtvenc;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                       DEFINICAO 6

      @ l_s+09 ,c_s+17 GET  nome
                       DEFINICAO 7

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
PTAB(STR(TIPDES,02,00),'DESPE',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   MANUREF(STR(TIPDES,02,00),'DESPE',1,DECREMENTA)
   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (ALUGUEL->(DELE()) .OR. DESPE->(DELE()))
         msg=""
         IF ALUGUEL->(DELE())
            msg="|"+sistema[EVAL(qualsis,"ALUGUEL"),O_MENU]
         ENDI
         IF DESPE->(DELE())
            msg+="|"+sistema[EVAL(qualsis,"DESPE"),O_MENU]
         ENDI
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
         MANUREF(STR(TIPDES,02,00),'DESPE',1,INCREMENTA)
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

* \\ Final de OUTDES.PRG
