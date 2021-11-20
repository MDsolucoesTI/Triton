/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: PESSOA.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerenciador do subsistema de pessoas
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"PESSOA")
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
   sistema[op_sis,O_TELA,O_ATUAL]=1
   RESTSCREEN(,0,MAXROW(),79,t_fundo)                        // restaura tela do fundo
   cod_sos=5 ; cn=.f.
   CLEA TYPEAHEAD                                            // limpa o buffer do teclado
   fgrep=.f.
   SET KEY K_F3 TO                                           // retira das teclas F3 e F4 as
   SET KEY K_F4 TO                                           // funcoes de repeticao e confirmacao
   msg="Inclus„o|"+;
       "Manuten‡„o|"+;
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
      CASE op_cad=01                                         // inclus„o
         op_menu=INCLUSAO
         IF AT("D",exrot[op_sis])=0                          // se usuario pode fazer inclusao
            PES_INCL()                                       // neste arquivo chama prg de inclusao
         ELSE                                                // caso contrario vamos avisar que
            ALERTA()                                         // ele nao tem permissao para isto
            DBOX(msg_auto,,,3)
         ENDI

      CASE op_cad=02                                         // manuten‡„o
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

PROC PES_incl     // inclusao no arquivo PESSOA
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
   PES_CRIA_SEQ()                                            // cria dbf de controle de cp sequenciais
   FOR i=1 TO FCOU()                                         // cria/declara privadas as
      msg="sq_"+FIEL(i)                                      // variaveis de memoria com
      PRIV &msg.                                             // o mesmo nome dos campos
   NEXT                                                      // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE PESSOA
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
   IMPRELA()
   PES_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   PES_GERA_SEQ()
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/PESSOA->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   PES_GET1(INCLUI)                                          // recebe campos
   SELE PESSOA
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
   SUBNIVEL("FIRMA")
   SUBNIVEL("ATIVIDA")
   SUBNIVEL("RENDA")
   SUBNIVEL("REFER")
ENDD

#ifdef COM_REDE
   PES_ANT_SEQ()                                             // restaura sequencial anterior
   SELE PESSOA
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
   PROC PES_ANT_SEQ(est_seq)     // restaura sequencial anterior
   SELE PES_SEQ     // seleciona arquivo de controle de sequencial
   BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
   IF sq_atual_ == cod
      REPL cod WITH sq_cod
   ENDI
   UNLOCK           // libera DBF para outros usuarios
   COMMIT           // atualiza cps sequenciais no disco
   RETU
#endi


PROC PES_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"PES_seq"       // arq temporario
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
   SELE PESSOA
   IF RECC()>0                        // se o DBF nao estiver
      SET ORDER TO 0                  // vazio, entao enche DBF seq
      GO BOTT                         // com o ultimo reg digitado
      REPL PES_SEQ->cod WITH cod
      SET ORDER TO 1                  // retorna ao indice principal
   ENDI
   SELE PES_SEQ                       // seleciona arq de sequencias
   UNLOCK                             // libera DBF para outros usuarios
   COMMIT                             // atualiza cps sequenciais no disco
ENDI
RETURN

PROC PES_GERA_SEQ()

#ifdef COM_REDE
   LOCAL ar_:=SELEC()
#else
   LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
   SELE PES_SEQ
   BLOARQ(0,.5)
   sq_cod=PES_SEQ->cod
#else
   SET ORDER TO 0
   GO BOTT
#endi

M->cod=cod+1
IF M->cod=1
   M->cod=1
ENDI

#ifdef COM_REDE
   PES_GRAVA_SEQ()
   sq_atual_=PES_SEQ->cod
   UNLOCK                                                    // libera o registro
   COMMIT
   SELE (ar_)
#else
   DBSETORDER(ord_ind)
   GO reg_
#endi

RETU

PROC PES_GRAVA_SEQ
REPL cod WITH M->cod
RETU

PROC PES_tela     // tela do arquivo PESSOA
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
   @ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±± Pessoas F¡sicas / Jur¡dicas ±±±±±±±±±±±±±±±±±±±"
   @ l_s+03,c_s+1 SAY " Ú C¢digo ÄÄÄÂ Tipo ÄÄÄÄÄÂ R.G. ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ CPF ÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ l_s+04,c_s+1 SAY " ³           ³           ³                    ³                  ³"
   @ l_s+05,c_s+1 SAY " Ã Cr‚dito ÄÄÁÄÄÄÄÄÄÄÄÄÄÄÅ CGC ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ Inscr. Estadual Ä´"
   @ l_s+06,c_s+1 SAY " ³    -                  ³                    ³                  ³"
   @ l_s+07,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ l_s+08,c_s+1 SAY " Ú Nome ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Prof./rea Atua‡„o ÄÄÄ¿"
   @ l_s+09,c_s+1 SAY " ³                                       ³                       ³"
   @ l_s+10,c_s+1 SAY " Ã Dt Nasc/Abert ÄÂ Nacionalidade ÄÄÄÄÄÄÄÅ Naturalidade ÄÄÄÄÄÄÄÄÄ´"
   @ l_s+11,c_s+1 SAY " ³                ³                      ³                       ³"
   @ l_s+12,c_s+1 SAY " Ã Renda/Faturamento ÄÂ Estado Civil ÄÄÄÄÅ Regime Casamento ÄÄÄÄÄ´"
   @ l_s+13,c_s+1 SAY " ³                    ³   -              ³   -                   ³"
   @ l_s+14,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ l_s+15,c_s+1 SAY " É N§ Dep Ñ Conjuge ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑ CPF ÍÍÍÍÍÍÍÍÍÍÍ»"
   @ l_s+16,c_s+1 SAY " º        ³                                     ³                º"
   @ l_s+17,c_s+1 SAY " Ç Filia‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶"
   @ l_s+18,c_s+1 SAY " º Pai:                           M„e:                           º"
   @ l_s+19,c_s+1 SAY " ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
ELSE
   @ l_s+01,c_s+1 SAY "±±±±±±±±±±±±± Endere‡o - Pessoas F¡sicas / Jur¡dicas ±±±±±±±±±±±±±±"
   @ l_s+03,c_s+1 SAY " Ú Endere‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ N£mero ÄÄÂÄCEP ÄÄÄÄÄÄ¿"
   @ l_s+04,c_s+1 SAY " ³                                        ³          ³           ³"
   @ l_s+05,c_s+1 SAY " Ã Complemento ÄÄÄÄÂ Bairro ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ Cidade ÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+06,c_s+1 SAY " ³                 ³                      ³                      ³"
   @ l_s+07,c_s+1 SAY " Ã UF Â Tempo Residˆncia Â Aluguel ÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ l_s+08,c_s+1 SAY " ³    ³                  ³                ³±±±±±±±±±±±±±±±±±±±±±±³"
   @ l_s+09,c_s+1 SAY " ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ l_s+11,c_s+1 SAY " É Telefone ÍÍÍÍÍÍÍÍÑ Ramal ÍÍÍÑ Contato ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
   @ l_s+12,c_s+1 SAY " º                  ³          ³                                 º"
   @ l_s+13,c_s+1 SAY " ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
ENDI
RETU

PROC PES_gets     // mostra variaveis do arquivo PESSOA
LOCAL getlist := {}, ctl_c, ctl_r
PES_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(CODCRE,01,00),'CREDITO',1)
IF sistema[op_sis,O_TELA,O_ATUAL]=1
   @ l_s+04 ,c_s+04 GET  cod;
                    PICT sistema[op_sis,O_CAMPO,01,O_MASC]

   @ l_s+04 ,c_s+16 GET  tipo;
                    PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

   @ l_s+06 ,c_s+05 GET  codcre;
                    PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"2")

   @ l_s+04 ,c_s+28 GET  rg;
                    PICT sistema[op_sis,O_CAMPO,04,O_MASC]

   @ l_s+04 ,c_s+49 GET  cpf;
                    PICT sistema[op_sis,O_CAMPO,05,O_MASC]

   @ l_s+06 ,c_s+28 GET  cgc;
                    PICT sistema[op_sis,O_CAMPO,06,O_MASC]

   @ l_s+06 ,c_s+49 GET  inscr;
                    PICT sistema[op_sis,O_CAMPO,07,O_MASC]

   @ l_s+09 ,c_s+04 GET  nome

   @ l_s+09 ,c_s+44 GET  profis

   @ l_s+11 ,c_s+04 GET  dtnasc;
                    PICT sistema[op_sis,O_CAMPO,10,O_MASC]

   @ l_s+11 ,c_s+21 GET  nacio

   @ l_s+11 ,c_s+44 GET  natu

   @ l_s+13 ,c_s+04 GET  fatura;
                    PICT sistema[op_sis,O_CAMPO,13,O_MASC]

   @ l_s+13 ,c_s+25 GET  estcivi;
                    PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,14,O_CRIT],,"3")

   @ l_s+13 ,c_s+44 GET  regcasa;
                    PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,15,O_CRIT],,"4")

   @ l_s+16 ,c_s+04 GET  numdep;
                    PICT sistema[op_sis,O_CAMPO,16,O_MASC]

   @ l_s+16 ,c_s+13 GET  conjuge

   @ l_s+16 ,c_s+51 GET  cpfconju;
                    PICT sistema[op_sis,O_CAMPO,18,O_MASC]

   @ l_s+18 ,c_s+09 GET  pai

   @ l_s+18 ,c_s+40 GET  mae

ELSE
   @ l_s+04 ,c_s+04 GET  ender

   @ l_s+04 ,c_s+45 GET  numero;
                    PICT sistema[op_sis,O_CAMPO,22,O_MASC]

   @ l_s+04 ,c_s+56 GET  cep;
                    PICT sistema[op_sis,O_CAMPO,23,O_MASC]

   @ l_s+06 ,c_s+04 GET  compl

   @ l_s+06 ,c_s+22 GET  bairro

   @ l_s+06 ,c_s+45 GET  cidade

   @ l_s+08 ,c_s+04 GET  uf;
                    PICT sistema[op_sis,O_CAMPO,27,O_MASC]

   @ l_s+08 ,c_s+09 GET  tempo

   @ l_s+08 ,c_s+28 GET  aluguel;
                    PICT sistema[op_sis,O_CAMPO,29,O_MASC]

   @ l_s+12 ,c_s+04 GET  tele;
                    PICT sistema[op_sis,O_CAMPO,30,O_MASC]

   @ l_s+12 ,c_s+23 GET  ramal

   @ l_s+12 ,c_s+34 GET  contato

ENDI
CLEAR GETS
RETU

PROC PES_get1     // capta variaveis do arquivo PESSOA
LOCAL getlist := {}, ctl_c, ctl_r
PRIV  blk_pessoa:=.t.
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
         @ l_s+04 ,c_s+04 GET cod;
                          PICT sistema[op_sis,O_CAMPO,01,O_MASC]
         CLEA GETS
         @ l_s+04 ,c_s+16 GET  tipo;
                          PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                          DEFINICAO 2
                          MOSTRA sistema[op_sis,O_FORMULA,1]

         @ l_s+06 ,c_s+05 GET  codcre;
                          PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                          DEFINICAO 3
                          MOSTRA sistema[op_sis,O_FORMULA,2]

         @ l_s+04 ,c_s+28 GET  rg;
                          PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                          DEFINICAO 4

         @ l_s+04 ,c_s+49 GET  cpf;
                          PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                          DEFINICAO 5

         @ l_s+06 ,c_s+28 GET  cgc;
                          PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                          DEFINICAO 6

         @ l_s+06 ,c_s+49 GET  inscr;
                          PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                          DEFINICAO 7

         @ l_s+09 ,c_s+04 GET  nome
                          DEFINICAO 8

         @ l_s+09 ,c_s+44 GET  profis
                          DEFINICAO 9

         @ l_s+11 ,c_s+04 GET  dtnasc;
                          PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                          DEFINICAO 10

         @ l_s+11 ,c_s+21 GET  nacio
                          DEFINICAO 11

         @ l_s+11 ,c_s+44 GET  natu
                          DEFINICAO 12

         @ l_s+13 ,c_s+04 GET  fatura;
                          PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                          DEFINICAO 13

         @ l_s+13 ,c_s+25 GET  estcivi;
                          PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                          DEFINICAO 14
                          MOSTRA sistema[op_sis,O_FORMULA,3]

         @ l_s+13 ,c_s+44 GET  regcasa;
                          PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                          DEFINICAO 15
                          MOSTRA sistema[op_sis,O_FORMULA,4]

         @ l_s+16 ,c_s+04 GET  numdep;
                          PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                          DEFINICAO 16

         @ l_s+16 ,c_s+13 GET  conjuge
                          DEFINICAO 17

         @ l_s+16 ,c_s+51 GET  cpfconju;
                          PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                          DEFINICAO 18

         @ l_s+18 ,c_s+09 GET  pai
                          DEFINICAO 19

         @ l_s+18 ,c_s+40 GET  mae
                          DEFINICAO 20

      ELSE
         @ l_s+04 ,c_s+04 GET  ender
                          DEFINICAO 21

         @ l_s+04 ,c_s+45 GET  numero;
                          PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                          DEFINICAO 22

         @ l_s+04 ,c_s+56 GET  cep;
                          PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                          DEFINICAO 23

         @ l_s+06 ,c_s+04 GET  compl
                          DEFINICAO 24

         @ l_s+06 ,c_s+22 GET  bairro
                          DEFINICAO 25

         @ l_s+06 ,c_s+45 GET  cidade
                          DEFINICAO 26

         @ l_s+08 ,c_s+04 GET  uf;
                          PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                          DEFINICAO 27

         @ l_s+08 ,c_s+09 GET  tempo
                          DEFINICAO 28

         @ l_s+08 ,c_s+28 GET  aluguel;
                          PICT sistema[op_sis,O_CAMPO,29,O_MASC]
                          DEFINICAO 29

         @ l_s+12 ,c_s+04 GET  tele;
                          PICT sistema[op_sis,O_CAMPO,30,O_MASC]
                          DEFINICAO 30

         @ l_s+12 ,c_s+23 GET  ramal
                          DEFINICAO 31

         @ l_s+12 ,c_s+34 GET  contato
                          DEFINICAO 32

      ENDI
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
      IF volta=0 .AND. LASTKEY()=K_ESC
         EXIT
      ENDI
      sistema[op_sis,O_TELA,O_ATUAL]++
      IF sistema[op_sis,O_TELA,O_ATUAL]<=sistema[op_sis,O_TELA,O_DEF]
         PES_TELA()
         IF op_menu=ALTERACAO .OR. volta=1
            PES_GETS()
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
PTAB(STR(CODCRE,01,00),'CREDITO',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   IF intref>0 .AND. tp_mov=EXCLUI
      ALERTA()   // existe registro validado aqui!
      msg=LTRIM(STR(intref))+" valida‡„o(”es) neste registro"
      DBOX(msg,,,,,"IMPOSS¡VEL EXCLUIR!")
   ELSE
      MANUREF(STR(CODCRE,01,00),'CREDITO',1,DECREMENTA)
      INTREF(FORM_INVERSA)
      DELE
   ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. CREDITO->(DELE())
         msg="|"+sistema[EVAL(qualsis,""),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
         MANUREF(STR(CODCRE,01,00),'CREDITO',1,INCREMENTA)
         IF op_menu!=INCLUSAO
            RECA
            INTREF(FORM_DIRETA)
         ENDI
      ENDI
   ENDI
ENDI
RETU

PROC FIR_incl     // inclusao no arquivo FIRMA
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||PESSOA->tipo=[F]}                              // condicao de inclusao de registros
IF !EVAL(cond_incl_)                                         // se nao pode incluir
   IF op_menu!=INCLUSAO                                      // nao inclusao nao tem msg
      ALERTA(2)                                              // avisa o motivo
      DBOX("Dados exclusivos para Pessoa F¡sica",,,4,,"ATEN€O, "+usuario)
   ENDI
   RETU                                                      // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"FIRMA")
IF AT("D",exrot[op_sis])>0
   RETU
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
DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE FIRMA
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
   
   /*
      inicializa campos de relacionamentos do com os campos do arquivo
      superior (pai)
   */
   FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
      msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
      M->&msg.=&(sistema[op_sis,O_CPRELA,i])
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   FIR_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   IF !EVAL(cond_incl_)
      EXIT
   ENDI
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/FIRMA->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   FIR_GET1(INCLUI)                                          // recebe campos
   SELE FIRMA
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
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC FIR_tela     // tela do arquivo FIRMA
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±± Empregos - Pessoa F¡sica ±±±±±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Nome da Empresa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Data de Admiss„o ÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                                             ³                    ³"
@ l_s+05,c_s+1 SAY " Ã Fun‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Sal rio ÄÄÄÄÁÄÄÄÄÄÂ Tipo ÄÄÄÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³                               ³                   ³   -          ³"
@ l_s+07,c_s+1 SAY " ³ Endere‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÂ Complemento ÄÄÄÄÄÄÄÄÄ´"
@ l_s+08,c_s+1 SAY " ³                                    ,      ³                      ³"
@ l_s+09,c_s+1 SAY " Ã Bairro ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Cidade ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+10,c_s+1 SAY " ³                                     ³                            ³"
@ l_s+11,c_s+1 SAY " Ã CEP ÄÄÄÄÄÄÂ Telefone ÄÄÄÄÄÄÄÂ Ramal ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+12,c_s+1 SAY " ³           ³                 ³       ³±±±±±±±±±±±±±±±±±±±±±±±±±±±±³"
@ l_s+13,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
RETU

PROC FIR_gets     // mostra variaveis do arquivo FIRMA
LOCAL getlist := {}
FIR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+04 ,c_s+04 GET  empr

@ l_s+04 ,c_s+50 GET  dtadm;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+06 ,c_s+04 GET  funcao

@ l_s+06 ,c_s+36 GET  salario;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+06 ,c_s+56 GET  tipemp;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"1")

@ l_s+08 ,c_s+04 GET  ender

@ l_s+08 ,c_s+40 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+08 ,c_s+48 GET  compl

@ l_s+10 ,c_s+04 GET  bairro

@ l_s+10 ,c_s+42 GET  cidade

@ l_s+12 ,c_s+04 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+12 ,c_s+16 GET  tele;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+12 ,c_s+34 GET  ramal

CLEAR GETS
RETU

PROC FIR_get1     // capta variaveis do arquivo FIRMA
LOCAL getlist := {}
PRIV  blk_firma:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  empr
                       DEFINICAO 2

      @ l_s+04 ,c_s+50 GET  dtadm;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 3

      @ l_s+06 ,c_s+04 GET  funcao
                       DEFINICAO 4

      @ l_s+06 ,c_s+36 GET  salario;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 5

      @ l_s+06 ,c_s+56 GET  tipemp;
                       PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                       DEFINICAO 6
                       MOSTRA sistema[op_sis,O_FORMULA,1]

      @ l_s+08 ,c_s+04 GET  ender
                       DEFINICAO 7

      @ l_s+08 ,c_s+40 GET  numero;
                       PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                       DEFINICAO 8

      @ l_s+08 ,c_s+48 GET  compl
                       DEFINICAO 9

      @ l_s+10 ,c_s+04 GET  bairro
                       DEFINICAO 10

      @ l_s+10 ,c_s+42 GET  cidade
                       DEFINICAO 11

      @ l_s+12 ,c_s+04 GET  cep;
                       PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                       DEFINICAO 12

      @ l_s+12 ,c_s+16 GET  tele;
                       PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                       DEFINICAO 13

      @ l_s+12 ,c_s+34 GET  ramal
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

   #ifdef COM_REDE
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #else
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #endi

   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PESSOA->(DELE()))
         msg="|"+sistema[EVAL(qualsis,"PESSOA"),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
            IF !excl_rela
               IF op_menu=INCLUSAO
                  flag_excl=' '
               ELSE
                  REPL flag_excl WITH ' '
               ENDI
            ENDI
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

PROC ATI_incl     // inclusao no arquivo ATIVIDA
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||PESSOA->tipo=[F]}                              // condicao de inclusao de registros
IF !EVAL(cond_incl_)                                         // se nao pode incluir
   IF op_menu!=INCLUSAO                                      // nao inclusao nao tem msg
      ALERTA(2)                                              // avisa o motivo
      DBOX("Dados exclusivos para Pessoa F¡sica",,,4,,"ATEN€O, "+usuario)
   ENDI
   RETU                                                      // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"ATIVIDA")
IF AT("D",exrot[op_sis])>0
   RETU
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
DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE ATIVIDA
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
   
   /*
      inicializa campos de relacionamentos do com os campos do arquivo
      superior (pai)
   */
   FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
      msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
      M->&msg.=&(sistema[op_sis,O_CPRELA,i])
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   ATI_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   IF !EVAL(cond_incl_)
      EXIT
   ENDI
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/ATIVIDA->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   ATI_GET1(INCLUI)                                          // recebe campos
   SELE ATIVIDA
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
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC ATI_tela     // tela do arquivo ATIVIDA
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±± Outras Atividades - Pessoa F¡sica ±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Nome ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Valor ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                                           ³                      ³"
@ l_s+05,c_s+1 SAY " Ã Endere‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ Complemento ÄÄÄÄÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³                                    ,      ³                      ³"
@ l_s+07,c_s+1 SAY " Ã Bairro ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Cidade ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+08,c_s+1 SAY " ³                                     ³                            ³"
@ l_s+09,c_s+1 SAY " Ã CEP ÄÄÄÄÄÄÂ Telefone ÄÄÄÄÄÄÄÂ Ramal ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+10,c_s+1 SAY " ³           ³                 ³       ³±±±±±±±±±±±±±±±±±±±±±±±±±±±±³"
@ l_s+11,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
RETU

PROC ATI_gets     // mostra variaveis do arquivo ATIVIDA
LOCAL getlist := {}
ATI_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+04 ,c_s+04 GET  nome

@ l_s+04 ,c_s+48 GET  valor;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+06 ,c_s+04 GET  ender

@ l_s+06 ,c_s+40 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+06 ,c_s+48 GET  compl

@ l_s+08 ,c_s+04 GET  bairro

@ l_s+08 ,c_s+42 GET  cidade

@ l_s+10 ,c_s+04 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+10 ,c_s+16 GET  tele;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+10 ,c_s+34 GET  ramal

CLEAR GETS
RETU

PROC ATI_get1     // capta variaveis do arquivo ATIVIDA
LOCAL getlist := {}
PRIV  blk_ativida:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  nome
                       DEFINICAO 2

      @ l_s+04 ,c_s+48 GET  valor;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 3

      @ l_s+06 ,c_s+04 GET  ender
                       DEFINICAO 4

      @ l_s+06 ,c_s+40 GET  numero;
                       PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                       DEFINICAO 5

      @ l_s+06 ,c_s+48 GET  compl
                       DEFINICAO 6

      @ l_s+08 ,c_s+04 GET  bairro
                       DEFINICAO 7

      @ l_s+08 ,c_s+42 GET  cidade
                       DEFINICAO 8

      @ l_s+10 ,c_s+04 GET  cep;
                       PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                       DEFINICAO 9

      @ l_s+10 ,c_s+16 GET  tele;
                       PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                       DEFINICAO 10

      @ l_s+10 ,c_s+34 GET  ramal
                       DEFINICAO 11

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

   #ifdef COM_REDE
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #else
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #endi

   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PESSOA->(DELE()))
         msg="|"+sistema[EVAL(qualsis,"PESSOA"),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
            IF !excl_rela
               IF op_menu=INCLUSAO
                  flag_excl=' '
               ELSE
                  REPL flag_excl WITH ' '
               ENDI
            ENDI
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

PROC REN_incl     // inclusao no arquivo RENDA
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||PESSOA->tipo=[F]}                              // condicao de inclusao de registros
IF !EVAL(cond_incl_)                                         // se nao pode incluir
   IF op_menu!=INCLUSAO                                      // nao inclusao nao tem msg
      ALERTA(2)                                              // avisa o motivo
      DBOX("Dados exclusivos para Pessoa F¡sica",,,4,,"ATEN€O, "+usuario)
   ENDI
   RETU                                                      // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"RENDA")
IF AT("D",exrot[op_sis])>0
   RETU
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
DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE RENDA
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
   
   /*
      inicializa campos de relacionamentos do com os campos do arquivo
      superior (pai)
   */
   FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
      msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
      M->&msg.=&(sistema[op_sis,O_CPRELA,i])
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   REN_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   IF !EVAL(cond_incl_)
      EXIT
   ENDI
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/RENDA->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   REN_GET1(INCLUI)                                          // recebe campos
   SELE RENDA
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
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC REN_tela     // tela do arquivo RENDA
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±± Outras Rendas - Pessoa F¡sica ±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Origem da Renda ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ Valor da Renda Ä¿"
@ l_s+04,c_s+1 SAY " ³                                     ³                 ³"
@ l_s+05,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
RETU

PROC REN_gets     // mostra variaveis do arquivo RENDA
LOCAL getlist := {}
REN_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+04 ,c_s+04 GET  origem

@ l_s+04 ,c_s+42 GET  valor;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

CLEAR GETS
RETU

PROC REN_get1     // capta variaveis do arquivo RENDA
LOCAL getlist := {}
PRIV  blk_renda:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  origem
                       DEFINICAO 2

      @ l_s+04 ,c_s+42 GET  valor;
                       PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                       DEFINICAO 3

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

   #ifdef COM_REDE
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #else
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #endi

   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PESSOA->(DELE()))
         msg="|"+sistema[EVAL(qualsis,"PESSOA"),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
            IF !excl_rela
               IF op_menu=INCLUSAO
                  flag_excl=' '
               ELSE
                  REPL flag_excl WITH ' '
               ENDI
            ENDI
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

PROC REF_incl     // inclusao no arquivo REFER
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"REFER")
IF AT("D",exrot[op_sis])>0
   RETU
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
DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE REFER
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
   
   /*
      inicializa campos de relacionamentos do com os campos do arquivo
      superior (pai)
   */
   FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
      msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
      M->&msg.=&(sistema[op_sis,O_CPRELA,i])
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   REF_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/REFER->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   SELE 0                                                    // torna visiveis variaveis de memoria
   REF_GET1(INCLUI)                                          // recebe campos
   SELE REFER
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
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC REF_tela     // tela do arquivo REFER
tem_borda=.f.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± Referˆncia ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
@ l_s+03,c_s+1 SAY " Ú Nome da Referencia ÄÄÄÄÄÄÄÂ Endere‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+04,c_s+1 SAY " ³                           ³                                    ,     ³"
@ l_s+05,c_s+1 SAY " Ã Complemento ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ Bairro ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ l_s+06,c_s+1 SAY " ³                           ³                                          ³"
@ l_s+07,c_s+1 SAY " Ã Cidade ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ CEP ÄÄÄÄÄÄÄÄÂ Telefone ÄÄÄÄÄÄÄÄÄÂ Ramal Ä´"
@ l_s+08,c_s+1 SAY " ³                           ³             ³                   ³        ³"
@ l_s+09,c_s+1 SAY " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"
RETU

PROC REF_gets     // mostra variaveis do arquivo REFER
LOCAL getlist := {}
REF_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+04 ,c_s+04 GET  nome

@ l_s+04 ,c_s+32 GET  ender

@ l_s+04 ,c_s+68 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+06 ,c_s+04 GET  compl

@ l_s+06 ,c_s+32 GET  bairro

@ l_s+08 ,c_s+04 GET  cidade

@ l_s+08 ,c_s+32 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+08 ,c_s+46 GET  tele;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+08 ,c_s+66 GET  ramal

CLEAR GETS
RETU

PROC REF_get1     // capta variaveis do arquivo REFER
LOCAL getlist := {}
PRIV  blk_refer:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
   DO WHILE .t.
      rola_t=.f.
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      @ l_s+04 ,c_s+04 GET  nome
                       DEFINICAO 2

      @ l_s+04 ,c_s+32 GET  ender
                       DEFINICAO 3

      @ l_s+04 ,c_s+68 GET  numero;
                       PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                       DEFINICAO 4

      @ l_s+06 ,c_s+04 GET  compl
                       DEFINICAO 5

      @ l_s+06 ,c_s+32 GET  bairro
                       DEFINICAO 6

      @ l_s+08 ,c_s+04 GET  cidade
                       DEFINICAO 7

      @ l_s+08 ,c_s+32 GET  cep;
                       PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                       DEFINICAO 8

      @ l_s+08 ,c_s+46 GET  tele;
                       PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                       DEFINICAO 9

      @ l_s+08 ,c_s+66 GET  ramal
                       DEFINICAO 10

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

   #ifdef COM_REDE
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #else
      IF !excl_rela
         REPL flag_excl WITH '*'
      ENDI
   #endi

   DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (PESSOA->(DELE()))
         msg="|"+sistema[EVAL(qualsis,"PESSOA"),O_MENU]
         ALERTA(2)
         DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
      ELSE
            IF !excl_rela
               IF op_menu=INCLUSAO
                  flag_excl=' '
               ELSE
                  REPL flag_excl WITH ' '
               ENDI
            ENDI
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

* \\ Final de PESSOA.PRG
