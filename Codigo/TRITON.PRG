/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRITON.PRG
 \ Data....: 09-08-2003
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Gerenciador geral
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VDV2, VCGC, VUF, EXT, NMES, LTOC

#include "TRI_PUBL.ch"  // contem variaveis publicas

V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN

#ifdef COM_TUTOR
   PARAM arq_mac, acao_                                    // recebe parametros
   acao_mac="D"                                            // inicializa flag
   IF !EMPT(arq_mac) .AND. !EMPT(acao_)                    // passou os dois paramentros
      acao_=UPPER(acao_)                                   // acao em maiusculo
      IF SUBS(acao_,2,1)$'LGCA'.AND.LEN(acao_)=2           // acao e' valida?
         acao_=SUBS(acao_,2,1)                             // separa so a letra
         IF acao_ $ "LCA" .AND. !FILE(arq_mac)             // leitura, se o arq
            ALERTA(2)                                      // nao existir vamos
            ? "Arquivo "+arq_mac+" n„o encontrado!"        // avisar e
            RETU                                           // voltar para os DOS
         ELSE
            IF acao_="G"                                   // gravacao de tutorial
               IF FILE(arq_mac)                            // se o arq existir
                  ALERTA(2)                                // pergunta se pode
                  x="N"                                    // mata-lo...
                  @ 10,20 SAY "Arquivo "+arq_mac+" j  existe sobrepor?" GET x PICT "!"
                  READ
                  CLEA SCREEN
                  IF LASTKEY()=K_ESC .OR. x!="S"           // nao confirmou...
                     ? "Execu‡„o interrompida!"            // da mensagem e
                     RETU                                  // retorna para o DOS
                  ENDI
                  ERASE (arq_mac)                          // mata arq antigo
               ENDI
               handle_mac=FCREATE(arq_mac)                 // cria um novo arq
            ELSE
               handle_mac=FOPEN(arq_mac,2)                 // abre arq existente
            ENDI
            IF handle_mac=-1                               // se deu erro na abertura
               ? "N„o foi poss¡vel utilizar "+arq_mac      // avisa e
               RETU                                        // retorna
            ENDI
            fat_mac=5                                      // fator de tempo default
            acao_mac=acao_                                 // seta a acao da macro
         END IF
      END IF
   ENDI
#endi

NAOPISCA()                         // habilita 256 cores (ega/vga)

/*
   rotina utilizando funcoes em assembly  para pegar o nome do programa
   que e  colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta  sendo executado. O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")                     // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                      // executa interrupt 21
x=VAL_BX()                         // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256       // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
   IF PEEK(Sg,x)=0                 // este e o primeiro ZERO
      IF PEEK(Sg,x+1)=0            // se o proximo tambem for,
         x+=2                      // entao pula ambos
         EXIT                      // e sai
      ENDI
   ENDI
   x++                             // continua procurando
ENDD
direxe=""
IF PEEK(Sg,x)=1                    // se este byte = 1, entao
   x+=2                            // o nome comeca aqui e vai
   DO WHIL PEEK(Sg,x)>0            // at‚ encontrar outro 0
      direxe+=CHR(PEEK(Sg,x))      // pega mais uma letra do nome
      x++
   ENDD
ENDI
direxe=UPPER(LEFT(direxe,RAT("\",direxe)))
arq_sos=direxe+"TRITON.SOS"        // nome do arquivo de ajuda
SET CENTURY ON                     // datas com informa‡„o do s‚culo DD/MM/AAAA
SETCANCEL(.f.)                     // desativa ALT-C/BREAK
SET DATE BRIT                      // datas no formato 'britasileiro`
SET EXAC OFF                       // comparacoes parciais habilitadas
SET SCOREBOARD OFF                 // habilita uso da linha 0
SET WRAP ON                        // habilita rolagem de menus
SET KEY K_ALT_F2  TO doscom        // ALT-F2 ativa DOS-SHELL
SETKEY(K_INS,{||;                  // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)


/*
   inicializa variaveis publicas
*/
msg:=cpord:=criterio:=chv_rela:=chv_1:=chv_2:=vr_memo := ""
op_sis:=cod_sos:=nucop:=op_posi:=op_menu :=1
nss=29
exrot:=AFILL(ARRAY(nss),""); usuario=""
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvexcl:=drvvisivel := .t.
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3
sgr_ok=SGRAFICO(ATIVO)                      // SGR esta residente?
drvcara=CHR(32); mold="ÚÄ¿³ÙÄÀ³ÃÄ´"
drvmenucen=.f.; drvfonte=18
drvporta="LPT1"
drvcortna="W+/B"; drvtittna="GR+/B"
nemp="Denny Paulista Azevedo Filho"
nsis="Triton - Automa‡„o Imobili ria"

#ifdef COM_MOUSE
   drvmouse=(MOUSE()>0)                     // verifica e inicializa mouse

   #ifdef COM_TUTOR
      IF acao_mac!="D"
         drvmouse=.f.
      ENDI
   #endi

   drvratH=8; drvratV=16                    // default da sensibilidade do mouse
   tpo_mouse=0
#endi

#ifdef COM_REDE
   ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#endi

#ifdef COM_LOCK
   pr_ok=__PPRJ(arq_sos,"ùÿáõæêñûçòæëðøàôáåýò")
   IF LEN(pr_ok)>0
      CLEAR
      ? pr_ok
      RETU
   ENDI
#endi

arqgeral="TRI"

#ifdef COM_REDE

   #undef COM_PROTECAO
          
   drvtempo=25
   ide_maq=RIGHT(ALLTRIM(NETNAME()),4)      // tenta pegar nome da estacao
   IF EMPTY(ide_maq)                        // se netname() retornou nulo,
      ide_maq=LEFT(GETENV("ESTACAO"),4)     // tenta variavel de ambiente ESTACAO
   ENDI

   /*
      Se rede, e se NETNAME() do Clipper ou ESTACAO retornam "", pede ao usuario
      a identificacao da estacao para gravar arquivos de configuracoes
      especificos para cada usuario da rede
   */
   IF EMPTY(ide_maq)                       // CA-Clipper nao reconheceu nome da estacao
      cod_sos=49                           // nem existe variavel ambiental,
      msgt="IDENTIFICA€ŽO DA ESTA€ŽO"      // entao, vamos solicitar ao usuario
      SET KEY K_F1 TO                      // desativa help
      ide_maq=DBOX("Nome da esta‡„o",,,,,msgt,SPAC(4),"@!",,"W+/N")
      SET KEY K_F1 TO help                 // habilita F1 (help)
      IF LASTKEY()=K_ESC .OR.;             // desistiu...
         EMPTY(ide_maq)                    // ou nao informou
         RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
         SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
         RETU                              // e volta ao DOS
      ENDI
   ENDI
   ide_maq="_"+ALLTRIM(ide_maq)
#else
   ide_maq="_temp"                         // nome do arquivo de configuracoes
#endi

ntxpw=direxe+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                         // nomes dos arquivos de senhas
arqconf=direxe+arqgeral+;                  // nome do arquivo de configuracoes
        ide_maq+".sys"
IF FILE(arqconf)
   REST FROM (arqconf) ADDI                // restaura configuracoes gravadas

   #ifdef COM_MOUSE
      IF drvmouse
         drvmouse=(MOUSE()>0)              // verifica e inicializa mouse
         MOUSERAT(drvratH,drvratV)         // ajusta sensibilidade do mouse
      ENDI
   #else
      drvmouse=.f.
   #endi

ELSE

   /*
      cria variaveis default de cores, codigos de impressao, etc...
   */
   drvmarca := "Epson 24 pinos"               // nome da configuracao/marca impressora
   drvprn =1                                  // configuracao atual
   drvpadrao="4"                              // padrao da impressora
   drvtapg="CHR(27)+'C'+CHR(NNN)"             // tamanho da pagina
   drvpcom="CHR(15)"                          // ativa comprimido (17,5 cpp)
   drvtcom="CHR(18)"                          // desativa comprimido (17,5 cpp)
   drvpc20="CHR(27)+'M'+CHR(15)"              // ativa comprimido (20 cpp)
   drvtc20="CHR(27)+'P'"                      // desativa comprimido (20 cpp)
   drvpeli="CHR(27)+'M'"                      // ativa elite
   drvteli="CHR(27)+'P'"                      // desativa elite
   drvpenf="CHR(27)+'E'"                      // ativa enfatizado
   drvtenf="CHR(27)+'F'"                      // desativa enfatizado
   drvpexp="CHR(27)+'W'+CHR(1)"               // ativa expansao
   drvtexp="CHR(27)+'W'+CHR(0)"               // desativa expansao
   drvpde8="CHR(27)+'0'"                      // ativa 8 lpp
   drvtde8="CHR(27)+'2'"                      // desativa 8 lpp
   drvland=""                                 // ativa landscape (paisagem)
   drvport=""                                 // ativa portrait (retrato)
   drvsom=.f.                                 // tipo de saida/efeitos sonoro
   drvautohelp=.f.                            // ajuda automatica em campos
   drvdbf:=drvntx:=drverr := PADR(QUALDIR(),23)
                                              // diretorio dos dbf's, ntx's e erros.dbf
   drvcorpad="W+/N*"  ; drvcorbox="W+/B"      // cores default
   drvcormsg="W+/B"   ; drvcorenf="W+/R"
   drvcorget="W+/B"   ; drvcortel="W+/N"
   drvcorhlp="W+/B"   ; drvcortna="W+/B"
   drvtitpad="GR+/N*" ; drvtitbox="GR+/B"     // cores dos titulos default
   drvtitmsg="GR+/B"  ; drvtitenf="GR+/R"
   drvtitget="GR+/B"  ; drvtittel="GR+/N"
   drvtithlp="GR+/B"  ; drvtittna="GR+/B"
   CBC1(.f.)
   ALERTA()
   cod_sos=2
   IF !PEGADIR(.t.)                        // se nao informou diretorios de trabalho
      RESTSCREEN(0,0,MAXROW(),79,v0)       // restaura tela
      SETPOS(MAXROW()-1,1)                 // cursor na penultima linha, coluna 1
      RETU                                 // de volta ao DOS
   ENDI

   /*
      cria arquivo de senha e o inicializa com o primeiro usuario
   */
   IF !FILE(dbfpw)                          // nao encontrou arquivo de senhas,
      DBCREATE(dbfpw,{;                     // entao, cria estrutura
                      {"pass"       ,"C", 6,0},;
                      {"nome"       ,"C",15,0},;
                      {"nace"       ,"C", 1,0},;
                      {"expessoa"   ,"C",20,0},;
                      {"exfirma"    ,"C",20,0},;
                      {"exativida"  ,"C",20,0},;
                      {"exrenda"    ,"C",20,0},;
                      {"exrefer"    ,"C",20,0},;
                      {"eximoveis"  ,"C",20,0},;
                      {"exfornec"   ,"C",20,0},;
                      {"excorretor" ,"C",20,0},;
                      {"exbancos"   ,"C",20,0},;
                      {"exaluguel"  ,"C",20,0},;
                      {"exvendas"   ,"C",20,0},;
                      {"exarecibo"  ,"C",20,0},;
                      {"exoutdes"   ,"C",20,0},;
                      {"exlrecibo"  ,"C",20,0},;
                      {"exmovim"    ,"C",20,0},;
                      {"expagar"    ,"C",20,0},;
                      {"exreceber"  ,"C",20,0},;
                      {"excheques"  ,"C",20,0},;
                      {"exparamet"  ,"C",20,0},;
                      {"excomissao" ,"C",20,0},;
                      {"extipoimo"  ,"C",20,0},;
                      {"exdespe"    ,"C",20,0},;
                      {"excontas"   ,"C",20,0},;
                      {"exhisto"    ,"C",20,0},;
                      {"excredito"  ,"C",20,0},;
                      {"excusto"    ,"C",20,0},;
                      {"exticheque" ,"C",20,0},;
                      {"exintere"   ,"C",20,0},;
                      {"excva"      ,"C",20,0};
                     };
      )

      #ifdef COM_REDE
         USEARQ(dbfpw,.t.,20,1,.f.)         // tenta abrir senhas, exclusivo
      #else
         USE (dbfpw)                        // abre arquivo de senhas
      #endi

      INDE ON pass TO (ntxpw)               // indexa pela password
      APPE BLAN                             // credencia usuario ficticio (1o. acesso)
      senha=PWORD(arqgeral)                 // com senha = tres primeiras letras
      REPL nome WITH ENCRIPT("Usuario        "),;
           pass WITH senha, nace WITH ENCRIPT("3")
      USE
   ENDI
ENDI

#ifdef COM_TUTOR
   IF acao_mac!="D"
      drvmouse=.f.
   ENDI
#endi

arq_prn=drverr+"PRINTERS.DBF"                    // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                                // se o arquivo de "drivers"
   DBCREATE(arq_prn,{;                           // de impressoras nao existir
                     {"marca" ,"C",15,0},;        // entao vamos cria-lo
                     {"porta" ,"C", 4,0},;
                     {"padrao","C", 1,0},;
                     {"tapg"  ,"C",40,0},;
                     {"pcom"  ,"C",40,0},;
                     {"tcom"  ,"C",40,0},;
                     {"pc20"  ,"C",40,0},;
                     {"tc20"  ,"C",40,0},;
                     {"peli"  ,"C",40,0},;
                     {"teli"  ,"C",40,0},;
                     {"penf"  ,"C",40,0},;
                     {"tenf"  ,"C",40,0},;
                     {"pexp"  ,"C",40,0},;
                     {"texp"  ,"C",40,0},;
                     {"pde8"  ,"C",40,0},;
                     {"tde8"  ,"C",40,0},;
                     {"land"  ,"C",40,0},;
                     {"port"  ,"C",40,0};
                    };
   )

   #ifdef COM_REDE
      USEARQ(arq_prn,.t.,20,1,.f.)          // tenta abrir configuracoes, exclusivo
   #else
      USE (arq_prn)                         // abre arquivo de configuracoes
   #endi

   APPE BLAN                                // inclui uma configuracao
   REPL marca  WITH drvmarca,;              // marca da impressora
        porta  WITH drvporta,;              // porta de saida
        padrao WITH drvpadrao,;             // padrao da impressora
        tapg   WITH drvtapg,;               // tamanho da pagina
        pcom   WITH drvpcom,;               // ativa comprimido (17,5 cpp)
        tcom   WITH drvtcom,;               // desativa comprimido (17,5 cpp)
        pc20   WITH drvpc20,;               // ativa comprimido (20 cpp)
        tc20   WITH drvtc20,;               // desativa comprimido (20 cpp)
        peli   WITH drvpeli,;               // ativa elite
        teli   WITH drvteli,;               // desativa elite
        penf   WITH drvpenf,;               // ativa enfatizado
        tenf   WITH drvtenf,;               // desativa enfatizado
        pexp   WITH drvpexp,;               // ativa expansao
        texp   WITH drvtexp,;               // desativa expansao
        pde8   WITH drvpde8,;               // ativa 8 lpp
        tde8   WITH drvtde8,;               // desativa 8 lpp
        land   WITH drvland,;               // ativa landscape
        port   WITH drvport                 // ativa portrait
   USE
ENDI
MUDAFONTE(drvfonte)                         // troca a fonte de caracteres
corcampo=drvtittel                          // cor "unselected"
SETCOLOR(drvcorpad+","+drvcorget+",,,"+corcampo)
SET(_SET_DELETED,!drvvisivel)               // visibilidade dos reg excluidos
CBC1(.f.)

/*
   se informado drive A para criar arquivo, previne preparo do disquete
*/
IF ASC(drvdbf)=65.OR.ASC(drvntx)=65         // informou drive A
   ALERTA()
   cod_sos=1
   op_a=DBOX("Disco pronto|Cancelar a opera‡„o",,,E_MENU,,"DISCO DE DADOS EM "+LEFT(drvdbf,1))
   IF op_a!=1
      RESTSCREEN(0,0,MAXROW(),79,v0)        // restaura tela
      SETPOS(MAXROW()-1,1)                  // cursor na penultima linha, coluna 1
      RETU
   ENDI
ENDI
AFILL(sistema:=ARRAY(nss+1),{})             // enche sistema[] com vetores nulos
TRI_ATRI()                                  // enche sistema[] com atributos dos arquivos
TRI_ATR1()
TRI_ATR2()

/*
   verifica qual subscricao do vetor SISTEMA corresponde ao arquivo
   aberto na area selecionada
*/
qualsis={|db_f|db_:=db_f,ASCAN(sistema,{|si|si[O_ARQUI]==db_})}

#ifdef COM_PROTECAO

   /*
      protege arquivo de dados contra acesso dBase e muda para "read-only"
      vamos comentar este "code block" ...
   */
   protdbf={|fg|pt:=fg,;                                   // torna a flag visivel no proximo "code block"
             tel_p:=SAVESCREEN(0,0,MAXROW(),79),;          // salva a tela
             DBOX("Um momento!",,,,NAO_APAGA),;            // mensagem ao usuario
             AEVAL(sistema,{|sis|;                         // executa o "code block" para cada
                             EDBF(drvdbf+;                 // um dos arquivos do vetor sistema
                                  sis[O_ARQUI],pt);        // (se pt, desprotege; senao, protege)
                           };
             ),;
             RESTSCREEN(0,0,MAXROW(),79,tel_p);            // restaura a tela
           }
#endi

IF !FILE(dbfpw)                                            // se nao existir arquivo de
   ALERTA()                                                // senhas, avisa
   DBOX("Arquivo de senhas ausente!",,,2)
   RESTSCREEN(0,0,MAXROW(),79,v0)                          // restaura a tela
   SETPOS(MAXROW()-1,1)                                    // cursor na penultima linha, coluna 1
   RETU                                                    // retorna ao DOS
ENDI

#ifdef COM_REDE
   IF ! USEARQ(dbfpw,.f.,20,1,.f.)                         // falhou abertura modo compartilhado,
      RESTSCREEN(0,0,MAXROW(),79,v0)                       // restaura tela
      SETPOS(MAXROW()-1,1)                                 // cursor na penultima linha, coluna 1
      RETU                                                 // retorna ao DOS
   ENDI
#else
   EDBF(dbfpw,.t.)                                         // desprotege arquivo de
   USE (dbfpw)                                             // senhas e o utiliza
#endi

IF !FILE(ntxpw+".ntx")                                     // se nao ha indice,
   INDE ON pass TO (ntxpw)                                 // cria o arquivo indice
ENDI
SET INDE TO (ntxpw)
IF ASC(nace)>48 .AND. ASC(nace)<52                         // previne erro

   #ifdef COM_REDE
      IF !BLOARQ(3,.5)                                     // se nao conseguiu bloquear o arquivo,
         RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
         SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
         RETU                                              // retorna ao DOS
      ENDI
   #endi

   REPL ALL nace WITH ENCRIPT(nace),;                      // manipulacao das senhas
            nome WITH ENCRIPT(nome)                        // criptografando o nivel e nome

   #ifdef COM_REDE
      UNLOCK                                               // libera arquivo
   #endi

ENDI
cod_sos=15
COLORSELECT(COR_GET)
v1=SAVESCREEN(0,0,MAXROW(),79)
CAIXA(mold,10,22,14,58,440)
@ 11,30 SAY "INFORME A SUA SENHA"                          // monta janela para
@ 12,35 SAY "Þ      Ý"                                     // solicitar a entrada
@ 13,26 SAY "ESC para recome‡ar/finalizar"                 // da senha de acesso
cp_=1
DO WHIL .t.
   COLORSELECT(COR_GET)
   senha=PADR(PWORD(12,36),6)                              // recebe a senha do usuario
   COLORSELECT(COR_PADRAO)
   SEEK senha                                              // ve se esta' credenciado
   IF FOUND()                                              // OK!
      usuario=TRIM(DECRIPT(nome))                          // nome do usuario
      senhatu=senha                                        // sua senha
      nivelop=VAL(DECRIPT(nace))                           // seu nivel
      FOR t=1 TO nss                                       // exrot[] contera' as
         msg=sistema[t,O_ARQUI]                            // rotinas nao acessadas
         exrot[t]=ex&msg.                                  // de cada subsistema
      NEXT
      IF nivelop>0.AND.nivelop<4                           // de 1 a 3...
         DBOX("Bom trabalho, "+usuario,13,45,2)            // boas vindas!
         EXIT                                              // use e abuse...
      ENDI
   ELSE
      IF cp_<2 .AND. !EMPTY(senha)                         // epa! senha invalida
         cp_++                                             // vamos dar outra chance
         ALERTA()                                          // estamos avisando!
         DBOX("Senha inv lida!",,,1)
         COLORSELECT(COR_GET)
         @ 12,36 SAY SPAC(6)
      ELSE                                                 // errou duas vezes!
         IF !EMPTY(senha)                                    // se informou senha errada
            ALERTA()                                         // pode ser um E.T.
            DBOX("Usu rio n„o autorizado!",,,2)
         ENDI

         #ifndef COM_REDE
            EDBF(dbfpw,.f.)                                // protege o arquivo de senhas
         #endi

         #ifdef COM_PROTECAO
            EVAL(protdbf,.f.)                              // protege DBF
         #endi

         RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela,
         SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
         MUDAFONTE(0)                                      // retorna com a fonte normal
         RETU                                              // e tchau!
      ENDI
   ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                             // restaura tela
USE                                                        // fecha o arquivo de senhas

#ifdef COM_PROTECAO
   EVAL(protdbf,.t.)                                       // desprotege DBFs
#endi

msg_auto="Opera‡„o n„o autorizada, "+usuario
IF !CRIADBF()                                              // se DBF nao criado,

   #ifdef COM_PROTECAO
      EVAL(protdbf,.f.)                                      // protege DBF
   #endi

   RESTSCREEN(0,0,MAXROW(),79,v0)                          // restaura tela
   SETPOS(MAXROW()-1,1)                                    // cursor na penultima linha, coluna 1
   RETU                                                    // volta ao DOS
ENDI
IF ! sgr_ok                                                // se o SGR nao esta residente
   ALERTA(2)                                               // vamos avisar
   msg_sgr="SGR (Servidor Gr fico Residente) n„o est  residente!"
   DBOX(msg_sgr)
ENDI
SET CONF (drvconf)                                         // ajusta SET CONFIRM
cod_sos=1
ALERTA(1)
msg="Atualize a data de hoje"
datac=DBOX(msg,,,,,"ATEN€ŽO!",datac,"99/99/99")            // confirma a data
IF UPDATED()                                               // se modificou sugestao,
   DOSDATA(DTOC(datac))                                    // vamos atualizar o DOS
ENDI
dbfparam=drvdbf+"PARAMET"
SELE A

#ifdef COM_REDE
   USEARQ(dbfparam,.t.,,,.f.)
#else
   USE (dbfparam)
#endi

Do Chama

/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i=1 TO FCOU()
   msg=FIEL(i)
   M->&msg.=&msg.
NEXT
USE
M->operador=usuario
CBC1(.t.)
opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
Set Key K_ALT_X to Sair
DO WHIL opc_01!=0
   cod_sos=3
   RESTSCREEN(0,0,MAXROW(),79,v01)
   Infosis("[F1] Help, [F2] Muda Operador, [F5] Calendario, [F6] Calculadora, [ALT+X] Sair")
   menu01="Arquivos|"+;
          "Opera‡”es|"+;
          "Consultas|"+;
          "Relat¢rios|"+;
          "Configura‡”es|"+;
          "Utilit rios"
   opc_01=DBOX(menu01,0,,E_POPMENU,NAO_APAGA,,,,opc_01)
   Set Key K_F2 to
   BEGIN SEQUENCE
      DO CASE
         CASE opc_01=0      // retornar ao DOS
            ALERTA()
            msgt="ENCERRAMENTO"
            msg ="Finalizar opera‡”es|N„o finalizar"
            cod_sos=1
            op_=DBOX(msg,,,E_MENU,,msgt,,,1)
            IF op_=1
               MUDAFONTE(0)
            ELSE
               opc_01=1
            ENDI

         CASE opc_01=1     // arquivos
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=60
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Pessoas        |"+;
                      "Bens           |"+;
                      "Interessados   |"+;
                      "Fornecedores   |"+;
                      "Corretores     |"+;
                      "Caixa - Bancos "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,2,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // pessoas
                     PESSOA(3,10)

                  CASE opc_02=2     // bens
                     IMOVEIS(3,10)

                  CASE opc_02=3     // interessados
                     INTERE(3,10)

                  CASE opc_02=4     // fornecedores
                     FORNEC(3,10)

                  CASE opc_02=5     // corretores
                     CORRETOR(3,10)

                  CASE opc_02=6     // caixa - bancos
                     BANCOS(3,10)

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=2     // opera‡”es
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=61
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Bens        |"+;
                      "Financeiras "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,12,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // bens
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Efetuar Aluguel          |"+;
                               "Efetuar Vendas           |"+;
                               "Recibos Locat rios       |"+;
                               "Gerar Recibos Locat rios|"+;
                               "Gerar Recibo Locat rio|"+;
                               "Baixa Recibo Locat rio|"+;
                               "Outras Despesas          |"+;
                               "Gerar Outras Despesas|"+;
                               "Recibos Locadores        |"+;
                               "Gerar Recibos Locadores|"+;
                               "Gerar Recibo Locador|"+;
                               "Baixa Recibo Locador"
                        opc_03=DBOX(menu03,3,20,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // efetuar aluguel
                              ALUGUEL(5,28)

                           CASE opc_03=2     // efetuar vendas
                              VENDAS(5,28)

                           CASE opc_03=3     // recibos locat rios
                              ARECIBO(5,28)

                           CASE opc_03=4     // gerar recibos locat rios
                              TRI_P001(5,28)

                           CASE opc_03=5     // gerar recibo locat rio
                              TRI_P003(5,28)

                           CASE opc_03=6     // baixa recibo locat rio
                              TRI_P031(5,28)

                           CASE opc_03=7     // outras despesas
                              OUTDES(5,28)

                           CASE opc_03=8     // gerar outras despesas
                              TRI_P002(5,28)

                           CASE opc_03=9     // recibos locadores
                              LRECIBO(5,28)

                           CASE opc_03=10     // gerar recibos locadores
                              TRI_P035(5,28)

                           CASE opc_03=11     // gerar recibo locador
                              TRI_P033(5,28)

                           CASE opc_03=12     // baixa recibo locador
                              TRI_P037(5,28)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=2     // financeiras
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Movimentos Financeiros   |"+;
                               "Fechamento Financeiro|"+;
                               "Contas … Pagar           |"+;
                               "Gera Parcelas a Pagar|"+;
                               "Baixa de Contas a Pagar|"+;
                               "Estorno Contas a Pagar|"+;
                               "Contas a Receber         |"+;
                               "Gera Parcelas a Receber|"+;
                               "Baixa Contas a Receber|"+;
                               "Recibo Cliente|"+;
                               "Estorno Contas a Receber|"+;
                               "Gerar Posi‡„o Financeira"
                        opc_03=DBOX(menu03,3,20,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // movimentos financeiros
                              MOVIM(5,28)

                           CASE opc_03=2     // fechamento financeiro
                              TRI_P007(5,28)

                           CASE opc_03=3     // contas … pagar
                              PAGAR(5,28)

                           CASE opc_03=4     // gera parcelas a pagar
                              TRI_P013(5,28)

                           CASE opc_03=5     // baixa de contas a pagar
                              TRI_P015(5,28)

                           CASE opc_03=6     // estorno contas a pagar
                              TRI_P017(5,28)

                           CASE opc_03=7     // contas a receber
                              RECEBER(5,28)

                           CASE opc_03=8     // gera parcelas a receber
                              TRI_P019(5,28)

                           CASE opc_03=9     // baixa contas a receber
                              TRI_P021(5,28)

                           CASE opc_03=10     // recibo cliente
                              TRI_R021(5,28)

                           CASE opc_03=11     // estorno contas a receber
                              TRI_P023(5,28)

                           CASE opc_03=12     // gerar posi‡„o financeira
                              TRI_P025(5,28)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=3     // consultas
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=62
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Bens de Aluguel          |"+;
                      "Bens para Venda          |"+;
                      "Alugueis a Receber - Dia|"+;
                      "Contas a Pagar           |"+;
                      "Contas a Receber         |"+;
                      "D¡vida Cliente|"+;
                      "Alugueis em Atraso|"+;
                      "Movimentos Financeiros"
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,23,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // bens de aluguel
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Tipo|"+;
                               "Valor|"+;
                               "Rua|"+;
                               "Bairro|"+;
                               "Qtd de C“modos|"+;
                               "Completa"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // bens por tipo
                              CO1(5,12)

                           CASE opc_03=2     //bens por Valor
                              CO6(5,12)

                           CASE opc_03=3     //bens por Rua
                              CO5(5,12)

                           CASE opc_03=4     // bens por bairro
                              CO2(5,12)

                           CASE opc_03=5     // bens por qtd de c“modos
                              CO3(5,12)

                           CASE opc_03=6     // Completa
                              CO4(5,12)
                              
                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=2     // bens para venda
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Tipo|"+;
                               "Valor|"+;
                               "Rua|"+;
                               "Bairro|"+;
                               "Qtd de C“modos|"+;
                               "Completa"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // bens por tipo
                              CV1(5,12)

                           CASE opc_03=2     //bens por Valor
                              CV6(5,12)

                           CASE opc_03=3     //bens por Rua
                              CV5(5,12)

                           CASE opc_03=4     // bens por bairro
                              CV2(5,12)

                           CASE opc_03=5     // bens por qtd de c“modos
                              CV3(5,12)

                           CASE opc_03=6     // Completa
                              CV4(5,12)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=3     // alugueis a receber - dia
                     CA1(3,31)

                  CASE opc_02=4     // contas a pagar
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores Pagos|"+;
                               "Valores em Aberto"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores pagos
                              CONABER(5,39)

                           CASE opc_03=2     // valores em aberto
                              CONPAGAR(5,39)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDDO

                  CASE opc_02=5     // contas a receber
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDIF
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores Pagos|"+;
                               "Valores em Aberto"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores pagos
                              RECPAG(5,39)

                           CASE opc_03=2     // valores em aberto
                              CONRECEB(5,39)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=6     // d¡vida cliente
                     DIVCLI(3,31)

                  CASE opc_02=7     // alugueis em atraso
                     ALUABER(3,31)

                  CASE opc_02=8     // movimentos financeiros
                     CONMOVIM(3,31)

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=4     // relat¢rios
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=63
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Emiss„o de Cheques      |"+;
                      "Relat¢rios Gerais       |"+;
                      "Relat¢rios Imobili rios |"+;
                      "Relat¢rios Financeiros  |"+;
                      "Contas a Receber        |"+;
                      "Contas a Pagar          |"+;
                      "Posi‡„o Financeira      "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,34,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // emiss„o de cheques
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Registro de Cheques  |"+;
                               "Impress„o de Cheques  |"+;
                               "Contra Cheques"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // registro de cheques
                              CHEQUES(5,50)

                           CASE opc_03=2     // impress„o de cheques
                              TRI_R022(5,50)

                           CASE opc_03=3     // contra cheques
                              TRI_R023(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=2     // relat¢rios gerais
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Listagem das Pessoas|"+;
                               "Mala Direta - Pessoas|"+;
                               "Listagem de Fornecedores|"+;
                               "Mala Direta - Fornecedor|"+;
                               "Rela‡„o de Impostos|"+;
                               "Rendimentos Anuais"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // listagem das pessoas
                              TRI_R012(5,50)

                           CASE opc_03=2     // mala direta - pessoas
                              TRI_E001(5,50)

                           CASE opc_03=3     // listagem de fornecedores
                              TRI_R015(5,50)

                           CASE opc_03=4     // mala direta - fornecedor
                              TRI_E002(5,50)

                           CASE opc_03=5     // rela‡„o de impostos
                              TRI_R005(5,50)

                           CASE opc_03=6     // rendimentos anuais
                              TRI_R006(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=3     // relat¢rios imobili rios
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Rela‡„o de Locat rios|"+;
                               "Recibos Locat rio|"+;
                               "Rela‡„o de Locadores|"+;
                               "Recibos Locador|"+;
                               "Rela‡„o de Alugueis|"+;
                               "Alugueis a Receber - Dia|"+;
                               "Rela‡„o de Reajustes|"+;
                               "Vencimentos Contratos|"+;
                               "Rendimentos de Vendas"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // rela‡„o de locat rios
                              TRI_R002(5,50)

                           CASE opc_03=2     // recibos locat rio
                              TRI_R001(5,50)

                           CASE opc_03=3     // rela‡„o de locadores
                              TRI_R009(5,50)

                           CASE opc_03=4     // recibos locador
                              TRI_R024(5,50)

                           CASE opc_03=5     // rela‡„o de alugueis
                              TRI_R003(5,50)

                           CASE opc_03=6     // alugueis a receber - dia
                              TRI_R011(5,50)

                           CASE opc_03=7     // rela‡„o de reajustes
                              TRI_R004(5,50)

                           CASE opc_03=8     // vencimentos contratos
                              TRI_R026(5,50)

                           CASE opc_03=9     // rendimentos de vendas
                              TRI_R007(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=4     // relat¢rios financeiros
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Emiss„o Nota Promissoria|"+;
                               "Movimentos Financeiros|"+;
                               "Posi‡„o Banc ria|"+;
                               "Pagamentos em Aberto"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // emiss„o nota promissoria
                              TRI_R025(5,50)

                           CASE opc_03=2     // movimentos financeiros
                              TRI_R018(5,50)

                           CASE opc_03=3     // posi‡„o banc ria
                              TRI_R019(5,50)

                           CASE opc_03=4     // pagamentos em aberto
                              TRI_R010(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=5     // contas a receber
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores a Receber|"+;
                               "Valores Recebidos"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores a receber
                              TRI_R013(5,50)

                           CASE opc_03=2     // valores recebidos
                              TRI_R014(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=6     // contas a pagar
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores em Aberto|"+;
                               "Valores Pagos"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores em aberto
                              TRI_R016(5,50)

                           CASE opc_03=2     // valores pagos
                              TRI_R017(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=7     // posi‡„o financeira
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Relat¢rio|"+;
                               "Gr fico"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // relat¢rio
                              TRI_R020(5,50)

                           CASE opc_03=2     // gr fico
                              IF sgr_ok
                                 TRI_G001(5,50)
                              ELSE
                                 ALERTA(2)
                                 DBOX(msg_sgr)
                              ENDI

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=5     // configura‡”es
            IF nivelop < 2     // usuario pode acessar esta opcap?...
               ALERTA()
               DBOX(msg_auto,,,3)
               BREAK
            ENDI
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=4
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Gerais      |"+;
                      "Financeiros "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,46,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // gerais
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Configura‡”es do sistema  |"+;
                               "Comiss„o de Alugueis     |"+;
                               "Tipo de Bens             |"+;
                               "Tipo de Despesa          "
                        opc_03=DBOX(menu03,3,54,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // configura‡”es do sistema
                              PARAMET(5,62)

                           CASE opc_03=2     // comiss„o de alugueis
                              COMISSAO(5,62)

                           CASE opc_03=3     // tipo de bens
                              TIPOIMO(5,62)

                           CASE opc_03=4     // tipo de despesa
                              DESPE(5,62)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=2     // financeiros
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="A‡„o Financeira      |"+;
                               "Hist¢rico Padr„o     |"+;
                               "Tipos de Cr‚dito     |"+;
                               "Centro de Custo      |"+;
                               "Formatos dos Cheques "
                        opc_03=DBOX(menu03,3,54,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // a‡„o financeira
                              CONTAS(5,62)

                           CASE opc_03=2     // hist¢rico padr„o
                              HISTO(5,62)

                           CASE opc_03=3     // tipos de cr‚dito
                              CREDITO(5,62)

                           CASE opc_03=4     // centro de custo
                              CUSTO(5,62)

                           CASE opc_03=5     // formatos dos cheques
                              TICHEQUE(5,62)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=6     // utilit rios
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               op_menu=PROJECOES
               cod_sos=9
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Backup|"+;
                      "Restaura backup|"+;
                      "Reconstr¢i ¡ndices|"+;
                      "Elimina reg apagados|"+;
                      "Vˆ relat¢rio gravado|"+;
                      "Configura ambiente   |"+;
                      "Plano de senhas"
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,61,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // backup
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     GBAK()

                  CASE opc_02=2     // restaura backup
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     RBAK()

                  CASE opc_02=3     // reconstr¢i ¡ndices
                     cod_sos=39
                     RCLA()

                  CASE opc_02=4     // elimina reg apagados
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     cod_sos=40
                     COMPACTA()

                  CASE opc_02=5     // vˆ relat¢rio gravado
                     VE_REL()

                  CASE opc_02=6     // configura ambiente
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=41
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="ÿ Impressoraÿÿÿÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Pano de fundoÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Fontes de caracteresÿ|"+;
                               "ÿ Esquemas de coresÿÿÿÿ|"+;
                               IF(drvconf,"û ","ÿ ")+"Confirma em camposÿÿÿ|"+;
                               IF(drvexcl,"û ","ÿ ")+"Confirma exclus”esÿÿÿ|"+;
                               IF(drvvisivel,"û ","ÿ ")+"Excluidos vis¡veisÿÿÿ|"+;
                               IF(drvincl,"û ","ÿ ")+"Confirma inclus”esÿÿÿ|"+;
                               IF(drvsom,"û ","ÿ ")+"Efeitos sonorosÿÿÿÿÿÿ|"+;
                               IF(drvautohelp,"û ","ÿ ")+"Ajuda de campo ativaÿ|"+;
                               IF(drvmouse,"û ","ÿ ")+"Utiliza mouseÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Sensibilidade mouseÿÿ"
                        opc_03=DBOX(menu03,3,69,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // impressora
                              IF nivelop < 2     // usuario pode acessar esta opcap?...
                                 ALERTA()
                                 DBOX(msg_auto,,,3)
                                 LOOP
                              ENDI
                              CONFPRN()

                           CASE opc_03=2     // pano de fundo
                              cod_sos=43; msg=""                      // menu de caracteres para fundo
                              FOR t=1 TO 255                          // enche msg com as opcoes
                                 IF t!=124                            // exceto o '|` que e o
                                    msg+="|"+STR(t,3)+" - "+CHR(t)    // caracter separador das
                                 ENDI                                 // opcoes da DBOX(
                              NEXT
                              t=ASC(drvcara)-IF(ASC(drvcara)>123,1,0)
                              op_x=DBOX(SUBS(msg,2),,77,E_MENU,,,,,t)
                              IF op_x!=0                              // escolhido um caracter
                                 op_x+=IF(op_x>123,1,0)               // desconta o '|`
                                 IF drvcara!=CHR(op_x)                // se caracter
                                    drvcara=CHR(op_x)                 // diferente do atual
                                    SAVE TO (arqconf) ALL LIKE drv*   // grava configuracoes,
                                    CBC1(.t.)                         // monta tela principal e
                                    v01=SAVESCREEN(0,0,MAXROW(),79)   // salva para o break
                                    BREAK                             // que foi configurado
                                 ENDI
                              ENDI

                           CASE opc_03=3     // fontes de caracteres
                              op_x=1; cod_sos=53
                              msgf=MUDAFONTE(999)
                              DO WHILE op_x!=0 .AND.LEN(msgf)>0
                                 msgf=STRTRAN(msgf,CHR(251)," ")
                                 msgf=LEFT(msgf,13*drvfonte)+CHR(251)+SUBS(msgf,13*drvfonte+2)
                                 op_x=DBOX(msgf,05,77,E_MENU,,,,,drvfonte+1)
                                 IF op_x>0
                                    drvfonte=op_x-1
                                    MUDAFONTE(drvfonte)
                                 ENDI
                              ENDD

                           CASE opc_03=4     // esquemas de cores
                              CONFCORES()

                           CASE opc_03=5     // confirma em campos
                              drvconf=!drvconf
                              SET(_SET_CONFIRM,drvconf)

                           CASE opc_03=6     // confirma exclus”es
                              drvexcl=!drvexcl

                           CASE opc_03=7     // excluidos vis¡veis
                              drvvisivel=!drvvisivel
                              SET(_SET_DELETED,!drvvisivel)

                           CASE opc_03=8     // confirma inclus”es
                              drvincl=!drvincl

                           CASE opc_03=9     // efeitos sonoros
                              drvsom=!drvsom

                           CASE opc_03=10     // ajuda de campo ativa
                              drvautohelp=!drvautohelp

                           CASE opc_03=11     // utiliza mouse
                              IF MOUSE()>0
                                 drvmouse=!drvmouse
                              ENDI

                              #ifdef COM_TUTOR
                                 IF acao_mac!="D"
                                    drvmouse=.f.
                                 ENDI
                              #endi

                           CASE opc_03=12     // sensibilidade mouse
                              cod_sos=45
                              AJMOUSE()

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD
                     SAVE TO (arqconf) ALL LIKE drv*         // diferente do atual

                  CASE opc_02=7     // plano de senhas
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     cod_sos=17
                     MASENHA(1,69)
               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

      ENDCASE
   END
   Set Key K_F2 to MudaOp
   CLEA GETS
   CLOS ALL
ENDD

#ifndef COM_REDE
   EDBF(dbfpw,.f.)                                         // protege arquivo senhas
#endi

#ifdef COM_PROTECAO
   EVAL(protdbf,.f.)                                       // protege DBF
#endi

#ifdef COM_TUTOR
   IF acao_mac!="D"
      FCLOSE(handle_mac)
      acao_mac="D"
   END IF
#endi

RESTSCREEN(0,0,MAXROW(),79,v0)                             // s'imbora
SETPOS(MAXROW()-1,1)                                       // e cursor na penultima linha, coluna 1
RETU                                                       // volta ao DOS

* \\ Final de TRITON.PRG
