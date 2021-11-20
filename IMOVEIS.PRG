/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: IMOVEIS.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerenciador do subsistema de bens
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"IMOVEIS")
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
   msg="Incluso|"+;                                         // menu do subsistema
       "Manuteno|"+;
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
      CASE op_cad=01                                         // incluso
         op_menu=INCLUSAO
         IF AT("D",exrot[op_sis])=0                          // se usuario pode fazer inclusao
            IMO_INCL()                                       // neste arquivo chama prg de inclusao
         ELSE                                                // caso contrario vamos avisar que
            ALERTA()                                         // ele nao tem permissao para isto
            DBOX(msg_auto,,,3)
         ENDI

      CASE op_cad=02                                         // manuteno
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

PROC IMO_incl     // inclusao no arquivo IMOVEIS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
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
   SELE IMOVEIS
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
   IMO_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
   cabem=INT((cabem-2048)/IMOVEIS->(RECSIZE()))
   IF cabem<1                                                // mais nenhum!!!
      ALERTA()
      msg="Verifique ESPA€O EM DISCO, "+usuario
      DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")                 // vamos parar por aqui!
      EXIT
   ENDI
   M->ativo='S'
   SELE 0                                                    // torna visiveis variaveis de memoria
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   SET KEY K_ALT_F8 TO ROLATELA
   
   /*
      recebe chaves do arquivo de indice basico
   */
   @ l_s+04 ,c_s+04 GET  pasta;
                    PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                    DEFINICAO 1

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA()
      LOOP
   ENDI
   SELE IMOVEIS
   IF LASTKEY()=K_ESC                                        // cancelou ou chave em branco
      cabem=0                                                // prepara saida da inclusao
      LOOP                                                   // volta p/ menu de cadastramento
   ENDI
   SEEK STR(M->pasta,04,00)
   aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)           // vai aproveitar o registro?
   IF FOUND() .AND. !aprov_reg_                              // pesquisou e achou!
      op_menu=ALTERACAO                                      // seta flag de ateracao
      DISPBEGIN()
      IMO_GETS()                                             // mostra conteudo do registro
      INFOSIS()                                              // exibe informacao no rodape' da tela
      DISPEND()
      ALERTA()
      msg="Consultar/alterar|Retornar … incluso"            // pergunta se deseja
      op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")           // alterar o registro
      IF op_ =1                                              // caso afirmativo
         EDIT()                                              // deixa alterar
      ENDI
      op_menu=INCLUSAO
      LOOP                                                   // volta para inclusao
   ENDI
   SELE 0
   IMO_GET1(INCLUI)                                          // recebe campos
   SELE IMOVEIS
   IF LASTKEY()=K_ESC                                        // se cancelou
      ALERTA()                                               // avisa que o registro
      DBOX("Registro no incluกdo!",18,,1)                   // nao foi incluido, e volta
      LOOP
   ENDI

   #ifdef COM_REDE
      GO BOTT                                                // vamos bloquear o final do
      SKIP                                                   // arq para que nehum outro
      BLOREG(0,.5)                                           // usuario possa incluir
      SEEK STR(M->pasta,04,00)                               // se registro foi incluido
      aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)        // vai aproveitar o registro?
      IF FOUND() .AND. !aprov_reg_                           // por outro usuario, entao
         BLOREG(0,.5)
         FOR i=1 TO FCOU()
            msg=FIEL(i)
            rep[i]=&msg.
            REPL &msg. WITH M->&msg.
         NEXT
         IMO_GET1(FORM_INVERSA)                              // executa formula inversa
         RECA
         FOR i=1 TO FCOU()
            msg=FIEL(i)
            REPL &msg. WITH rep[i]
         NEXT
         ALERTA(4)                                           // beep 4 vezes
         msg="Registro acabou de ser|incluกdo por outro usu rio!"
         DBOX(msg,,,,,"ATEN€O!")                            // avisa
         SELE IMOVEIS
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
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                           // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC IMO_tela     // tela do arquivo IMOVEIS
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
   @ l_s+01,c_s+1 SAY "ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ Bens Mขveis e Imขveis ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ"
   @ l_s+03,c_s+1 SAY " ษ Pasta ั Tipo Oper. ั Valor อออออออออออออั Tipo do Bem อออออออั Prop. อออป"
   @ l_s+04,c_s+1 SAY " บ       ณ  -         ณ                    ณ   -                ณ          บ"
   @ l_s+05,c_s+1 SAY " ศอออออออฯออออออออออออฯออออออออออออออออออออฯออออออออออออออออออออฯออออออออออผ"
   @ l_s+06,c_s+1 SAY " ฺ Cad. Prefeitura ฤย Escritura ฤฤฤฤฤฤฤย rea Terreno ฤฤฤย rea Construida ฟ"
   @ l_s+07,c_s+1 SAY " ณ                  ณ                  ณ                 ณ            M2   ณ"
   @ l_s+08,c_s+1 SAY " ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
   @ l_s+09,c_s+1 SAY " ฺ Endereo ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤย Nฃmero ฤฤฤฤย CEP ฤฤฤฤฤฤฤฤฤฤฤฤฟ"
   @ l_s+10,c_s+1 SAY " ณ                                          ณ            ณ                 ณ"
   @ l_s+11,c_s+1 SAY " ร Complemento ฤฤฤฤฤฤฤฤฤย Bairro ฤฤฤฤฤฤฤฤฤฤฤมฤฤย Cidade ฤมฤฤฤฤฤฤฤฤฤฤฤฤย UF ด"
   @ l_s+12,c_s+1 SAY " ณ                      ณ                      ณ                      ณ    ณ"
   @ l_s+13,c_s+1 SAY " ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤู"
   @ l_s+14,c_s+1 SAY " ษ Opo de Operao อออออออออั Volor da Opo อออออออั Obs อัอออออออออออออป"
   @ l_s+15,c_s+1 SAY " บ   -                        ณ                       ณ      ณฑฑฑฑฑฑฑฑฑฑฑฑฑบ"
   @ l_s+16,c_s+1 SAY " ศออออออออออออออออออออออออออออฯอออออออออออออออออออออออฯออออออฯอออออออออออออผ"
ELSE
   @ l_s+01,c_s+1 SAY "ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ Bems Imขveis - Nฃmero de Comodos ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ"
   @ l_s+02,c_s+1 SAY " ษอออออออออออออออออออออออออออออัออออออหอออออออออออออออออออออออออออออัออออออป"
   @ l_s+03,c_s+1 SAY " บ            Comodo           ณ Qtd. บ             Comodo          ณ Qtd. บ"
   @ l_s+04,c_s+1 SAY " ฬอออออออออออออออออออออออออออออุออออออฮอออออออออออออออออออออออออออออุออออออน"
   @ l_s+05,c_s+1 SAY " บ Dormitขrio                  ณ      บ Copa                        ณ      บ"
   @ l_s+06,c_s+1 SAY " บ WC                          ณ      บ Cozinha                     ณ      บ"
   @ l_s+07,c_s+1 SAY " บ Lavabo                      ณ      บ rea Servio                ณ      บ"
   @ l_s+08,c_s+1 SAY " บ Hall                        ณ      บ Despensa                    ณ      บ"
   @ l_s+09,c_s+1 SAY " บ Escritขrio                  ณ      บ Garagem                     ณ      บ"
   @ l_s+10,c_s+1 SAY " บ Suite                       ณ      บ Dormitขrio Empregada        ณ      บ"
   @ l_s+11,c_s+1 SAY " บ Sala de TV                  ณ      บ WC Empregada                ณ      บ"
   @ l_s+12,c_s+1 SAY " บ Living                      ณ      บ Rancho                      ณ      บ"
   @ l_s+13,c_s+1 SAY " บ Sala Refeio               ณ      บ                             ณ      บ"
   @ l_s+14,c_s+1 SAY " ศอออออออออออออออออออออออออออออฯออออออสอออออออออออออออออออออออออออออฯออออออผ"
ENDI
RETU

PROC IMO_gets     // mostra variaveis do arquivo IMOVEIS
LOCAL getlist := {}, ctl_c, ctl_r, t_f7_
IMO_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(TIPOIMO,02,00),'TIPOIMO',1)
IF sistema[op_sis,O_TELA,O_ATUAL]=1
   @ l_s+04 ,c_s+04 GET  pasta;
                    PICT sistema[op_sis,O_CAMPO,01,O_MASC]

   @ l_s+04 ,c_s+12 GET  tipo;
                    PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"2")

   @ l_s+04 ,c_s+25 GET  valor1;
                    PICT sistema[op_sis,O_CAMPO,03,O_MASC]

   @ l_s+04 ,c_s+46 GET  tipoimo;
                    PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,04,O_CRIT],,"1")

   @ l_s+04 ,c_s+67 GET  codpro;
                    PICT sistema[op_sis,O_CAMPO,05,O_MASC]

   @ l_s+07 ,c_s+04 GET  cadpref;
                    PICT sistema[op_sis,O_CAMPO,06,O_MASC]

   @ l_s+07 ,c_s+23 GET  escritura;
                    PICT sistema[op_sis,O_CAMPO,07,O_MASC]

   @ l_s+07 ,c_s+42 GET  areater;
                    PICT sistema[op_sis,O_CAMPO,08,O_MASC]

   @ l_s+07 ,c_s+53 GET  uniare;
                    PICT sistema[op_sis,O_CAMPO,09,O_MASC]

   @ l_s+07 ,c_s+60 GET  areaconst;
                    PICT sistema[op_sis,O_CAMPO,10,O_MASC]

   @ l_s+10 ,c_s+04 GET  ender

   @ l_s+10 ,c_s+47 GET  numero;
                    PICT sistema[op_sis,O_CAMPO,12,O_MASC]

   @ l_s+10 ,c_s+60 GET  cep;
                    PICT sistema[op_sis,O_CAMPO,13,O_MASC]

   @ l_s+12 ,c_s+04 GET  compl

   @ l_s+12 ,c_s+27 GET  bairro

   @ l_s+12 ,c_s+50 GET  cidade

   @ l_s+12 ,c_s+73 GET  uf;
                    PICT sistema[op_sis,O_CAMPO,17,O_MASC]

   @ l_s+15 ,c_s+04 GET  opcao;
                    PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                    CRIT(sistema[op_sis,O_CAMPO,18,O_CRIT],,"3")

   @ l_s+15 ,c_s+34 GET  valor2;
                    PICT sistema[op_sis,O_CAMPO,19,O_MASC]

   @ l_s+15 ,c_s+57 SAY "{M} "

ELSE
   @ l_s+05 ,c_s+35 GET  dorm;
                    PICT sistema[op_sis,O_CAMPO,21,O_MASC]

   @ l_s+06 ,c_s+35 GET  wc;
                    PICT sistema[op_sis,O_CAMPO,22,O_MASC]

   @ l_s+07 ,c_s+35 GET  lavabo;
                    PICT sistema[op_sis,O_CAMPO,23,O_MASC]

   @ l_s+08 ,c_s+35 GET  hall;
                    PICT sistema[op_sis,O_CAMPO,24,O_MASC]

   @ l_s+09 ,c_s+35 GET  escrit;
                    PICT sistema[op_sis,O_CAMPO,25,O_MASC]

   @ l_s+10 ,c_s+35 GET  suite;
                    PICT sistema[op_sis,O_CAMPO,26,O_MASC]

   @ l_s+11 ,c_s+35 GET  salatv;
                    PICT sistema[op_sis,O_CAMPO,27,O_MASC]

   @ l_s+12 ,c_s+35 GET  living;
                    PICT sistema[op_sis,O_CAMPO,28,O_MASC]

   @ l_s+13 ,c_s+35 GET  salaref;
                    PICT sistema[op_sis,O_CAMPO,29,O_MASC]

   @ l_s+05 ,c_s+72 GET  copa;
                    PICT sistema[op_sis,O_CAMPO,30,O_MASC]

   @ l_s+06 ,c_s+72 GET  cozinha;
                    PICT sistema[op_sis,O_CAMPO,31,O_MASC]

   @ l_s+07 ,c_s+72 GET  areaserv;
                    PICT sistema[op_sis,O_CAMPO,32,O_MASC]

   @ l_s+08 ,c_s+72 GET  despensa;
                    PICT sistema[op_sis,O_CAMPO,33,O_MASC]

   @ l_s+09 ,c_s+72 GET  garagem;
                    PICT sistema[op_sis,O_CAMPO,34,O_MASC]

   @ l_s+10 ,c_s+72 GET  dormemp;
                    PICT sistema[op_sis,O_CAMPO,35,O_MASC]

   @ l_s+11 ,c_s+72 GET  wcemp;
                    PICT sistema[op_sis,O_CAMPO,36,O_MASC]

   @ l_s+12 ,c_s+72 GET  rancho;
                    PICT sistema[op_sis,O_CAMPO,37,O_MASC]

ENDI
CLEAR GETS
RETU

PROC IMO_get1     // capta variaveis do arquivo IMOVEIS
LOCAL getlist := {}, ctl_c, ctl_r, t_f7_
PRIV  blk_imoveis:=.t.
PARA tp_mov
IF tp_mov=INCLUI
   ctl_r=SETKEY(K_CTRL_R,{||tela_ant()})
   IF op_menu!=INCLUSAO
      ctl_c=SETKEY(K_CTRL_C,{||tela_seg()})
   ENDI
   DO WHILE sistema[op_sis,O_TELA,O_ATUAL]<=sistema[op_sis,O_TELA,O_DEF]
      volta=0; rola_t=.f.
      memo20:="{F7}"
      t_f7_=SETKEY(K_F7,{||IMO_memo()})
      SET KEY K_ALT_F8 TO ROLATELA
      SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
      IF sistema[op_sis,O_TELA,O_ATUAL]=1
         @ l_s+04 ,c_s+12 GET  tipo;
                          PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                          DEFINICAO 2
                          MOSTRA sistema[op_sis,O_FORMULA,2]

         @ l_s+04 ,c_s+25 GET  valor1;
                          PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                          DEFINICAO 3

         @ l_s+04 ,c_s+46 GET  tipoimo;
                          PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                          DEFINICAO 4
                          MOSTRA sistema[op_sis,O_FORMULA,1]

         @ l_s+04 ,c_s+67 GET  codpro;
                          PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                          DEFINICAO 5

         @ l_s+07 ,c_s+04 GET  cadpref;
                          PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                          DEFINICAO 6

         @ l_s+07 ,c_s+23 GET  escritura;
                          PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                          DEFINICAO 7

         @ l_s+07 ,c_s+42 GET  areater;
                          PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                          DEFINICAO 8

         @ l_s+07 ,c_s+53 GET  uniare;
                          PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                          DEFINICAO 9

         @ l_s+07 ,c_s+60 GET  areaconst;
                          PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                          DEFINICAO 10

         @ l_s+10 ,c_s+04 GET  ender
                          DEFINICAO 11

         @ l_s+10 ,c_s+47 GET  numero;
                          PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                          DEFINICAO 12

         @ l_s+10 ,c_s+60 GET  cep;
                          PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                          DEFINICAO 13

         @ l_s+12 ,c_s+04 GET  compl
                          DEFINICAO 14

         @ l_s+12 ,c_s+27 GET  bairro
                          DEFINICAO 15

         @ l_s+12 ,c_s+50 GET  cidade
                          DEFINICAO 16

         @ l_s+12 ,c_s+73 GET  uf;
                          PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                          DEFINICAO 17

         @ l_s+15 ,c_s+04 GET  opcao;
                          PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                          DEFINICAO 18
                          MOSTRA sistema[op_sis,O_FORMULA,3]

         @ l_s+15 ,c_s+34 GET  valor2;
                          PICT sistema[op_sis,O_CAMPO,19,O_MASC]
                          DEFINICAO 19

         @ l_s+15 ,c_s+57 GET  memo20;
                          PICT "@!"
                          DEFINICAO 20

      ELSE
         @ l_s+05 ,c_s+35 GET  dorm;
                          PICT sistema[op_sis,O_CAMPO,21,O_MASC]
                          DEFINICAO 21

         @ l_s+06 ,c_s+35 GET  wc;
                          PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                          DEFINICAO 22

         @ l_s+07 ,c_s+35 GET  lavabo;
                          PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                          DEFINICAO 23

         @ l_s+08 ,c_s+35 GET  hall;
                          PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                          DEFINICAO 24

         @ l_s+09 ,c_s+35 GET  escrit;
                          PICT sistema[op_sis,O_CAMPO,25,O_MASC]
                          DEFINICAO 25

         @ l_s+10 ,c_s+35 GET  suite;
                          PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                          DEFINICAO 26

         @ l_s+11 ,c_s+35 GET  salatv;
                          PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                          DEFINICAO 27

         @ l_s+12 ,c_s+35 GET  living;
                          PICT sistema[op_sis,O_CAMPO,28,O_MASC]
                          DEFINICAO 28

         @ l_s+13 ,c_s+35 GET  salaref;
                          PICT sistema[op_sis,O_CAMPO,29,O_MASC]
                          DEFINICAO 29

         @ l_s+05 ,c_s+72 GET  copa;
                          PICT sistema[op_sis,O_CAMPO,30,O_MASC]
                          DEFINICAO 30

         @ l_s+06 ,c_s+72 GET  cozinha;
                          PICT sistema[op_sis,O_CAMPO,31,O_MASC]
                          DEFINICAO 31

         @ l_s+07 ,c_s+72 GET  areaserv;
                          PICT sistema[op_sis,O_CAMPO,32,O_MASC]
                          DEFINICAO 32

         @ l_s+08 ,c_s+72 GET  despensa;
                          PICT sistema[op_sis,O_CAMPO,33,O_MASC]
                          DEFINICAO 33

         @ l_s+09 ,c_s+72 GET  garagem;
                          PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                          DEFINICAO 34

         @ l_s+10 ,c_s+72 GET  dormemp;
                          PICT sistema[op_sis,O_CAMPO,35,O_MASC]
                          DEFINICAO 35

         @ l_s+11 ,c_s+72 GET  wcemp;
                          PICT sistema[op_sis,O_CAMPO,36,O_MASC]
                          DEFINICAO 36

         @ l_s+12 ,c_s+72 GET  rancho;
                          PICT sistema[op_sis,O_CAMPO,37,O_MASC]
                          DEFINICAO 37

      ENDI
      READ
      SETKEY(K_F7,t_f7_)
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
         IMO_TELA()
         IF op_menu=ALTERACAO .OR. volta=1
            IMO_GETS()
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
PTAB(STR(TIPOIMO,02,00),'TIPOIMO',1)
PTAB(STR(CODPRO,08,00),'PESSOA',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
   IF intref>0 .AND. tp_mov=EXCLUI
      ALERTA()   // existe registro validado aqui!
      msg=LTRIM(STR(intref))+" validao(”es) neste registro"
      DBOX(msg,,,,,"IMPOSSกVEL EXCLUIR!")
   ELSE
      MANUREF(STR(TIPOIMO,02,00),'TIPOIMO',1,DECREMENTA)
      MANUREF(STR(CODPRO,08,00),'PESSOA',1,DECREMENTA)
      DELE
   ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
   IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
      IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (TIPOIMO->(DELE()) .OR. PESSOA->(DELE()))
         msg=""
         IF TIPOIMO->(DELE())
            msg="|"+sistema[EVAL(qualsis,"TIPOIMO"),O_MENU]
         ENDI
         IF PESSOA->(DELE())
            msg+="|"+sistema[EVAL(qualsis,"PESSOA"),O_MENU]
         ENDI
         ALERTA(2)
         DBOX("Registro excluกdo em:"+msg+"|*",,,,,"IMPOSSกVEL RECUPERAR!")
      ELSE
         MANUREF(STR(TIPOIMO,02,00),'TIPOIMO',1,INCREMENTA)
         MANUREF(STR(CODPRO,08,00),'PESSOA',1,INCREMENTA)
         IF op_menu!=INCLUSAO
            RECA
         ENDI
      ENDI
   ENDI
ENDI
RETU

PROC IMO_MEMO
IF READVAR()="MEMO20"
   EDIMEMO("obs",sistema[op_sis,O_CAMPO,20,O_TITU],4,2,13,42)
ENDI
RETU

* \\ Final de IMOVEIS.PRG
