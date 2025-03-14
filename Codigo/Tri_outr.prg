/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_OUTR.PRG
 \ Data....: 09-08-2003
 \ Sistema.: Triton - Controle Imobili�rio
 \ Funcao..: Define vari�veis p�blicas
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v2.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas


#ifdef COM_CALE
   PROC CALE      // Rotina para exibir calend�rio

   /*
      Simplificando a estrutura CASE   (thank you Rick Spence!)
      tbc e' um vetor bidimensional que contem as teclas a serem testadas
      e suas respectivas acoes (dentro de "code blocks")
   */
   LOCAL cale_tela:=SAVESCREEN(0,0,MAXROW(),79), cor_atual:=SETCOLOR(),;
         col_dia, dia_1, lisu_:=6, cosu_:=58, liin_:=20, coin_:=79,;
         i_, cl_, vr_cale, m_e_s, a_n_o, ult_dia,;
         tbc:={;
                {K_DOWN, {||datac:=datac-30}},;
                {K_UP,   {||datac:=datac+30}},;
                {K_RIGHT,{||datac:=datac+365}},;
                {K_LEFT, {||datac:=datac-365}};
              }
   SETCOLOR(drvtitmsg)
   vr_cale=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_)            // posicao atual do calendario
   CAIXA(mold,lisu_,cosu_,liin_,coin_)                      // monta tela de apresentacao
   SETCOLOR(drvcorenf)                                      // do calendario
   @ lisu_+2,cosu_+1 SAY "Do 2a 3a 4a 5a 6a Sa"
   SETCOLOR(drvtitmsg)
   @ lisu_+ 9,cosu_+1 SAY REPL("�",coin_-cosu_-1)
   @ lisu_+10,cosu_+2 SAY " Incrementa o MES"              // montra teclas disponiveis
   @ lisu_+11,cosu_+2 SAY " Decrementa o MES"
   @ lisu_+12,cosu_+2 SAY CHR(26)+" Incrementa o ANO"
   @ lisu_+13,cosu_+2 SAY CHR(27)+" Decrementa o ANO"
   SETCOLOR(drvcormsg)
   DO WHIL .t.
      @ lisu_+1,cosu_+1 SAY PADL(TRIM(NMES(datac))+" - "+STR(YEAR(datac)),20)
      dia_1=DOW(datac-DAY(datac)+1)              // dia da semana do 1o. dia do mes
      cl_=lisu_+3
      @ cl_,cosu_+1 CLEAR TO liin_-6,coin_-1     // limpa area dos dias
      col_dia=1+cosu_+3*(dia_1-1)                // coluna inicai do 1o. dia do mes
      m_e_s=MONTH(datac)                         // mes
      a_n_o=YEAR(datac)                          // ano
      IF INT(m_e_s/2) = m_e_s/2                  // acha ultimo dia do mes
         ult_dia=IF(m_e_s<8,IF(m_e_s=2,IF(INT(a_n_o/4)=a_n_o/4,29,28),30),31)
      ELSE
         ult_dia=IF(m_e_s<8,31,30)
      ENDI
      FOR i_=1 TO ult_dia                        // imprime os dias
         IF DAY(DATE())=i_                       // se for heje
            SETCOLOR(drvcorenf)                  // enfatiza
         ENDI
         @ cl_,col_dia SAY PADL(STR(i_,2),2)     // imprime o dia na tela
         SETCOLOR(drvcormsg)                     // retorna a cor normal
         col_dia+=3                              // proxima coluna
         IF dia_1/7=INT(dia_1/7)                 // fim da tela do calendario
            cl_++ ; col_dia=cosu_+1              // passa para proxima linha
         ENDI
         dia_1++                                 // proximo dia
      NEXT
      x=SETCURSOR(0)                             // apaga cursor, x=cursor atual

      #ifdef COM_MOUSE
         k=MOUSETECLA(lisu_+10,cosu_+2,liin_-1,cosu_+2)
      #else
         k=INKEY(0)                              // aguarda pressionar tecla
      #endi

      SETCURSOR(x)                               // volta tamanho original do cursor
      nm=ASCAN(tbc,{|ve_a| k=ve_a[1]})           // procura tecla dentro do vetor tbc (e' o CASE)
      IF nm!=0                                   // achou!
         EVAL(tbc[nm,2])                         // portanto, executa a acao...
      ELSE
         IF k=K_ALT_F8                           // muda calendario de posicao
            MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,cale_tela,.t.)
            sinal_=" "
            PUBL &vr_cale.:=STR(lisu_,2)+STR(cosu_,2)
            SAVE TO (arqconf) ALL LIKE drv*      // salva as coordenadas em disco
         ELSE                                    // tecla sem acao, portanto,
            EXIT                                 // fora...
         ENDI
      ENDI
   ENDD
   RESTSCREEN(0,0,MAXROW(),79,cale_tela)         // restaura tela e
   SETCOLOR(cor_atual)                           // o esquema de cor

   #ifdef COM_MOUSE
      IF drvmouse                                // se o mouse esta' ativo
         DO WHIL MOUSEGET(0,0)!=0                // espera que os botoes sejam
         ENDD                                    // liberados (nao pressionados)
      ENDI
   #endi

   RETU
#endi


#ifdef COM_MAQCALC
   PROC MAQCALC      // Apresenta "pop-calculadora"
   LOCAL tela_c:=SAVESCREEN(0,0,MAXROW(),79), cur_sor:=SETCURSOR(1),;
         getlist:={}, vr_calc, pg_up, pg_dn, tec_f3, tec_f4, tec_f9, tec_f8
   PRIV  sinal_:=" ", num_disp, fgpaste, cor_calc:=SETCOLOR(),;
         lisu_:=1, cosu_:=40, liin_:=9, coin_:=64, sinal_ant:=" "
   vr_calc=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_)   // pega posicao atual da calculadora
   fgpaste=(!EMPT(READVAR()).AND.;     // ve se ha campo pendente (captura)
           LEFT(READVAR(),4)!="OPC_")
   SETKEY(K_F6,NIL)                    // evita recursividade
   pg_up =SETKEY(K_PGUP,NIL)           // desabilita PgUp,
   pg_dn =SETKEY(K_PGDN,NIL)           // PgDn,
   tec_f3=SETKEY(K_F3,NIL)             // F3,
   tec_f4=SETKEY(K_F4,NIL)             // F4,
   tec_f9=SETKEY(K_F9,NIL)             // F9 e move caixa ( ALT-F8 )
   tec_f8=SETKEY(K_ALT_F8,{||sinal_dig()})

   SETKEY(35 ,{||sinal_dig()})         // #   raiz quadrada
   SETKEY(36 ,{||sinal_dig()})         // $   inteiro/flutuante
   SETKEY(37 ,{||sinal_dig()})         // %   percentual
   SETKEY(42 ,{||sinal_dig()})         // *   multiplica
   SETKEY(43 ,{||sinal_dig()})         // +   soma
   SETKEY(45 ,{||sinal_dig()})         // -   subtrai
   SETKEY(47 ,{||sinal_dig()})         // /   divide
   SETKEY(61 ,{||sinal_dig()})         // =   total
   SETKEY(94 ,{||sinal_dig()})         // ^   exponencial
   SETKEY(99 ,{||sinal_dig()})         // c   limpa display
   SETKEY(67 ,{||sinal_dig()})         // C
   IF fgpaste
      SETKEY(82 ,{||sinal_dig()})      // R   captura resultado do display
      SETKEY(114,{||sinal_dig()})      // r
   ENDI
   SETCOLOR(drvcormsg)
   CAIXA(mold,lisu_,cosu_,liin_,coin_)
   @ lisu_+1,cosu_+2 SAY "�������������������ͻ"
   @ lisu_+2,cosu_+2 SAY "�                   �"
   @ lisu_+3,cosu_+2 SAY "�                   �"
   @ lisu_+4,cosu_+2 SAY "�������������������ͼ"
   @ lisu_+5,cosu_+2 SAY " 7 8 9 C     +  -  * "
   @ lisu_+6,cosu_+2 SAY " 4 5 6 .  =  /  %  ^ "
   @ lisu_+7,cosu_+2 SAY " 1 2 3 0     "+CHR(K_ESC)+"  #  $ "
   SETCOLOR(drvcorget)
   @ lisu_+8,cosu_+2 SAY IF(fgpaste,"R, resultado no campo","")
   SETCOLOR(drvcorget+","+drvcorget+",,,"+drvcorget)
   DO WHIL .t.
      gab=IF(fgint,"   999999999999999",;             // mascara
                   "999999999999999.99")
      num_disp=0.00                                   // numero no display
      @ lisu_+2,cosu_+3 SAY "="
      @ lisu_+2,cosu_+4 GET nu_calc PICT gab          // mostra total
      CLEAR GETS
      @ lisu_+3,cosu_+3 SAY sinal_ant
      @ lisu_+3,cosu_+4 GET num_disp PICT gab         // capta operando
      READ
      DO CASE
         CASE LASTKEY()=K_ESC.OR.sinal_="R"           // finalizou
            IF fgpaste.AND.sinal_="R"
               KEYB ALLTRIM(TRAN(nu_calc,gab))        // joga resultado no campo
            ENDI
            EXIT                                      // e sai
         CASE sinal_="AF8"                            // muda calculadora de posicao
            MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,tela_c,.t.)
            sinal_=" "
            PUBL &vr_calc.:=STR(lisu_,2)+STR(cosu_,2)
            SAVE TO (arqconf) ALL LIKE drv*           // salva as coordenadas em disco
         CASE sinal_="$"                              // chaveou inteiro/decimal
            fgint=(!fgint); sinal_=" "
         CASE sinal_="C"                              // limpa display
            nu_calc=0; sinal_=" "
         CASE sinal_="#"                              // raiz quadrada
            IF !EMPTY(num_disp)                       // algum numero no display?
               IF sinal_ant="-"                       // op anterior=subtracao?
                  nu_calc-=SQRT(num_disp)             // subtrai a raiz
               ELSE                                   // do display no resultado
                  nu_calc+=SQRT(num_disp)             // senao, soma
               ENDI
            ELSE                                      // nao exite numero no
               nu_calc=SQRT(nu_calc)                  // display, porisso
            ENDI                                      // calcula raiz do total
            sinal_=" "
         OTHERWISE
            DO CASE
               CASE sinal_ant="-"                     // subtrai
                  nu_calc-=num_disp
               CASE sinal_ant="*"                     // multiplica
                  nu_calc=nu_calc*num_disp
               CASE sinal_ant="/"                     // divide
                  nu_calc=nu_calc/num_disp
               CASE sinal_ant="^"                     // eleva potencia
                  nu_calc=nu_calc^num_disp
               CASE sinal_ant="%"                     // obtem percentual
                  nu_calc=nu_calc/100*num_disp
               OTHERWISE                              // soma (+) ou sem operador
                  nu_calc+=num_disp
            ENDC
      ENDC
      sinal_=IF(sinal_="="," ",sinal_)                // igual nao pode ser exibido
      sinal_ant=sinal_; sinal_=" "                    // salva sinal digitado
   ENDD
   SETCOLOR(cor_calc)                                 // volta com as cores anteriores
   SETCURSOR(cur_sor)                                 // volta cursor com era antes
   SET KEY K_F6 TO maqcalc                            // reabilita calculadora (f6)
   SETKEY(35,NIL); SETKEY(36,NIL)                     // desabilita as teclas
   SETKEY(37,NIL); SETKEY(42,NIL)                     // utilizadas na operacao
   SETKEY(43,NIL); SETKEY(45,NIL)                     // da calculadora
   SETKEY(47,NIL); SETKEY(67,NIL)
   SETKEY(94,NIL); SETKEY(99,NIL)
   SETKEY(82,NIL); SETKEY(114,NIL)
   SETKEY(61,NIL)
   SETKEY(K_PGUP,pg_up)                               // habilita teclas PgUp,
   SETKEY(K_PGDN,pg_dn)                               // PgDn,
   SETKEY(K_F3,tec_f3)                                // F3,
   SETKEY(K_F4,tec_f4)                                // F4,
   SETKEY(K_F9,tec_f9)                                // F9 e
   SETKEY(K_ALT_F8,tec_f8)                            // ALT-F8
   RESTSCREEN(0,0,MAXROW(),79,tela_c)                 // restaura a tela
   RETU

   STATIC PROC SINAL_DIG  // Recebe sinal da calculadora
   sinal_=IF(LASTKEY()=K_ALT_F8,"AF8",;               // recebe sinal digitado e
          UPPER(CHR(LASTKEY())))                      // forca saida do get com
   KEYB CHR(K_ENTER)                                  // ENTER simulado
   RETU
#endi

// Cria as despesas b�sicas
Procedure Chama

If Select("Despe")=0
   DbfParam=DrvDbf+"Despe"
   UseArq(DbfParam)
EndIf
If Select("Histo")=0
   DbfParam=DrvDbf+"Histo"
   UseArq(DbfParam)
EndIf
If Select("Contas")=0
   DbfParam=DrvDbf+"Contas"
   UseArq(DbfParam)
EndIf
If Select("Bancos")=0
   DbfParam=DrvDbf+"Bancos"
   UseArq(DbfParam)
EndIf
If Select("Custo")=0
   DbfParam=DrvDbf+"Custo"
   UseArq(DbfParam)
EndIf
Sele Despe
If LastRec()<1
   Append Blank
   Repl codigo With 1
   Repl tipodesp With 'IPTU'
   UnLock
   Append Blank
   Repl codigo With 2
   Repl tipodesp With 'Agua'
   UnLock
   Append Blank
   Repl codigo With 3
   Repl tipodesp With 'Luz'
   UnLock
   Append Blank
   Repl codigo With 4
   Repl tipodesp With 'Telefone'
   UnLock
EndIf
Sele Histo
If Lastrec()<1
   Append Blank
   Repl codigo  With 1
   Repl descri  With 'Saldo Inicial'
   Unlock
   Append Blank
   Repl codigo  With 10
   Repl descri  With 'Recebimento Aluguel'
   Unlock
   Append Blank
   Repl codigo  With 11
   Repl descri  With 'Repasse do Aluguel p/ Prop.'
   Unlock
EndIf
Close
Sele Contas
If Lastrec()<1
   Append Blank
   Repl codigo    With 1
   Repl descricao With 'Transfer�ncia de Saldo'
   Unlock
   Append Blank
   Repl codigo    With 10
   Repl descricao With 'Recebimento Aluguel'
   Unlock
   Append Blank
   Repl codigo    With 2010
   Repl descricao With 'Repasse do Aluguel'
   Unlock
EndIf
Close
Sele Custo
If Lastrec()<1
   Append Blank
   Repl Codigo With 10
   Repl Departa With 'Alugueis'
   Unlock
EndIf
Close
Sele Bancos
If Lastrec()<1
   Append Blank
   Repl codigo    With 1
   Repl banco     With '000000000000000001'
   Repl descricao With 'Caixa'
   Unlock
EndIf
Close
If Select("Paramet")=0
   DbfParam=DrvDbf+"Paramet"
   UseArq(DbfParam)
EndIf
Sele Paramet
DbGoTop()
If Empty(Paramet->Empresa)
   Do While .T.
      If Rlock()
         Exit
      EndIf
   EndDo
   Repl Empresa    With [Denny Paulista Azevedo Filho]
   Repl Cgc1       With [00011901000189]
   Repl Creci      With [101010]
   Repl ender1     With [Rua Rebou�as de Carvalho]
   Repl numero1    With 46
   Repl cidade1    With [Taubat�]
   Repl Uf1        With [SP]
   Repl Bairro1    With [Centro]
   Repl Cep1       With [12010170]
   Repl Tele1      With [ 0122215862]
   Repl Fax1       With [ 0122215862]
   Repl DtIniCont  With CtoD("10/10/77")
   Repl DtFimCont  With CtoD("31/12/03")
   Repl Palavra    With [5288031435448       ]
   Unlock
   DBox('Esta � uma vers�o Demonstra��o, v�lida at� '+DtoC(DtFimCont)+'|qualquer d�vida consulte:||Denny Paulista Azevedo Filho|Rua Rebou�as de Carvalho, 46|Taubat� - SP|TelFax (0xx12) 221-5862',,,0,.T.,,)
EndIf
*If Senha()!=AllTrim(Paramet->Palavra)
*   DBox([Houve Viola��o na Configura��o do Sistema ou na Senha de libera��o|comunique-se com sua empresa de suporte ou com Denny Paulista Azevedo Filho|para verifica��o do ocorrido.])
*   Close All
*   KeyBoard Chr(13)
*   Do Sair
*EndIf
If !TerCont(DataC)
   Close All
   Keyboard Chr(13)
   Do Sair
EndIf
Return

//Fun��o Muda Operador

Procedure MudaOp

Local l,c,cor,cod_ant:=cod_sos

Set Key K_F2 to
l=Row()
c=Col()
Cor=SetColor()
Reg_Dbf=pointer_dbf()

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

SET INDE TO (ntxpw)
cod_sos=15
COLORSELECT(COR_GET)
v1=SAVESCREEN(0,0,MAXROW(),79)
CAIXA(mold,10,22,14,58,440)
@ 11,30 SAY "INFORME A SUA SENHA"                          // monta janela para
@ 12,35 SAY "�      �"                                     // solicitar a entrada
@ 13,26 SAY "ESC para recome�ar/Finalizar"                 // da senha de acesso
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
         DBOX("Senha inv�lida!",,,1)
         COLORSELECT(COR_GET)
         @ 12,36 SAY SPAC(6)
      ELSE                                                 // errou duas vezes!
         IF !EMPTY(senha)                                    // se informou senha errada
            ALERTA()                                         // pode ser um E.T.
            DBOX("Usu�rio n�o autorizado!",,,2)
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
         Close All
         Quit
      ENDI
   ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                             // restaura tela
USE                                                        // fecha o arquivo de senhas
pointer_dbf(reg_dbf)
Seila=Setcolor()
M->operador=usuario
cbc1(.t.)
msg_auto="Opera��o n�o autorizada, "+usuario
Setcolor(seila)
v01=savescreen(0,0,maxrow(),79)
Infosis("[F1] Help, [F2] Muda Operador, [F5] Calendario, [F6] Calculadora, [ALT+X] Sair")
Cod_Sos=Cod_Ant
Set Key K_F2 to MudaOp
Return

//Fun��o sai do sistema

Procedure Sair

Local l,c,cor,cod_ant:=Cod_Sos

Set Key K_ALT_X to
l=Row()
c=Col()
Cor=SetColor()
Alerta()
msgt="ENCERRAMENTO"
msg="Finalizar opera��es|N�o finalizar"
cod_sos=1
op_=DBOX(msg,,,E_MENU,,msgt,,,1)
If op_=1
   mudafonte(0)
   close all
   restscreen(0,0,MaxRow(),79,v0)
   setpos(MaxRow()-1,1)
   Quit
EndIf
SetColor(Cor)
Set Key K_ALT_X to Sair
Cod_Sos=Cod_Ant
Return

//Fun��o para utilizar as vari�veis de parametros de rede

Function Par(cp)

Local ar_:=Alias(),DbfParam

DbfParam=DrvDbf+"Paramet"
UseArq(DbfParam)
If Empty(Ar_)
   Sele 0
Else
   Sele (Ar_)
EndIf
Retu(Paramet->&Cp)

//Fun��o para verifica��o da data de t�rmino do contrato

Function TerCont(mData)

Local Ar_:=Alias(),mOrdem:=.T.
Static mViola:=0

DbfParam=DrvDbf+"Paramet"
UseArq(DbfParam)

*If (mData>Paramet->DtFimCont)
*   If("Demonstra��o"$Paramet->Empresa)
*      DBox('ATEN��O !!!|Esta � uma vers�o demonstra��o v�lida at� '+DtoC(DtFimCont)+'|para maiores informa��es consulte:|Denny Paulista Azevedo Filho|Rua Rebou�as de Carvalho, 46|Taubat� - SP|TelFax (0xx12) 221-5862.',,,0,.T.,,)
*   Else
*      DBOX('ATEN��O !!!|A Data que foi fornecida n�o � v�lida|sua altoriza��o de uso vai at� '+DtoC(Paramet->DtFimCont)+'.|Qualquer d�vida entre em contato com sua empresa de suporte|ou diretamente com Denny Paulista Azevedo Filho',,,0,.T.,,)
*   EndIf
*   mViola++
*   mOrdem=.F.
*   If mViola>3
*      close All
*      Keyboard Chr(13)
*      Do Sair
*   EndIf
*endif
If !Empty(Ar_)
   Sele &Ar_
EndIf
Return(mOrdem)

//Fun��o para verifica��o da senha

Function Senha(Area)
If Select("Paramet")=0
   DbfParam=DrvDbf+"Paramet"
   UseArq(DbfParam)
EndIf
simnao:=0
sim=0
nao=0

simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),01,01)))+17)+sim-nao)*2
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),02,01)))+17)+sim-nao)*3
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),04,01)))+17)+sim-nao)*4
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),05,01)))+17)+sim-nao)*5
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),07,01)))+17)+sim-nao)*7
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),08,01)))+17)+sim-nao)*8
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),09,01)))+17)+sim-nao)*9
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtinicont),10,01)))+17)+sim-nao)*10

simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),01,01)))+30)-sim+nao)*9
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),02,01)))+30)-sim+nao)*8
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),04,01)))+30)-sim+nao)*7
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),05,01)))+30)-sim+nao)*6
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),07,01)))+30)-sim+nao)*5
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),08,01)))+30)-sim+nao)*4
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),09,01)))+30)-sim+nao)*3
simnao=simnao+(((asc(Substr(DtoC(Paramet->Dtfimcont),10,01)))+30)-sim+nao)*2

For I:=1 to 35
   simnao=simnao+(Asc(Substr((Paramet->Empresa),I,01)))
Next
For I:=1 to 14
   simnao=simnao+Asc(Substr((Paramet->Cgc1),I,01))
Next
For I:=1 to 06
   simnao=simnao+Asc(Substr((Paramet->Creci),I,01))
Next
For I:=1 to 35
   simnao=simnao+Asc(Substr((Paramet->ender1),I,01))
next
For I:=1 to 5
   simnao=simnao+Asc(Substr(Str(Paramet->numero1),I,01))
next
For I:=1 to 18
   simnao=simnao+Asc(Substr((Paramet->bairro1),I,01))
next
For I:=1 to 20
   simnao=simnao+Asc(Substr((Paramet->cidade1),I,01))
next
For I:=1 to 15
   simnao=simnao+Asc(Substr((Paramet->Compl1),I,01))
next
For I:=1 to 2
   simnao=simnao+Asc(Substr((Paramet->uf1),I,01))
next
For I:=1 to 08
   simnao=simnao+Asc(Substr((Paramet->cep1),I,01))
next
For I:=1 to 12
   simnao=simnao+Asc(Substr((Paramet->tele1),I,01))
next
For I:=1 to 12
   simnao=simnao+Asc(Substr((Paramet->fax1),I,01))
next
simnao=simnao*simnao*simnao
Return(AllTrim(Str(SimNao)))

//Fun��o retorna p/ calculo do posicionamento do cheque

Function Linha(Valorl)
Local Vall
Vall=int((valorl/3)+0.5)-1
Return(Vall)

Function Coluna(Valorc)
Local Valc
Valc=Int((valorc/1.45)+0.5)
Return(Valc)

// Funcao para verificacao de datas dos Recibos

Function VerData(mAnt,mDia,mMes,mAno)

Local mNData:=CtoD('  /  /    '),mVData:=Ctod('  /  /    ')

If mMes==2
   If mDia>=29
      If Mod((mAno),4)==0
         mDia = 29
      Else
         mDia = 28
      EndIf
   EndIf
EndIf
If (mDia==31).And.((mMes==4).Or.(mMes==6).Or.(mMes==9).Or.(mMes==11))
   mDia = 30
EndIf
mVData=CtoD(Str(mDia,02,00)+"/"+Str(mMes,02,00)+"/"+Str(mAno,04,00))
If mAnt=[N]
   mNData = RetData(mVData,30)
Else
   mNData = mVData
EndIf

Return(mNData)


// Fun��o para calculo da Data de Vencimento do C.P. e do C.R.

Function CalData(mData,mSoma)

Local mD,mM,mA,mNData:=CtoD('  /  /    ')

If (mSoma>=30)
   mD = Day(mData)
   mM = Month(mData)
   mA = Year(mData)
   For x=1 To (mSoma/30)
      mM++
      If (mM==13)
         mA++
         mM=1
      EndIf
   Next
   If ((mD<=31).And.(mD>=29)).And.(mM==2)
      If Mod(Year(mData),4)==0
         mD=29
      Else
         mD=28
      EndIF
   EndIf
   If (mD==31).And.((mM==4).Or.(mM==6).Or.(mM==9).Or.(mM==11))
      mD=30
   EndIf
/*   If mD < venc
      If mM != 2
         If ((mM==4).Or.(mM==6).Or.(mM==9).Or.(mM==11))
            If venc == 31
               mD = 30
            Else
               mD = venc
            EndIf
         Else
            mD = Venc
         EndIf
      EndIf
   EndIf*/
   mNData=CtoD(Str(mD,02,00)+"/"+Str(mM,02,00)+"/"+Str(mA,04,00))
Else
   mNData=mData+mSoma
EndIf

Return(mNData)

// Fun��o para calculo de Data Retroativa

Function RetData(mData,mSoma)

Local mD,mM,mA,mNData:=CtoD('  /  /    ')

If (mSoma>=30)
   mD = Day(mData)
   mM = Month(mData)
   mA = Year(mData)
   For x=1 To (mSoma/30)
      mM--
      If (mM==0)
         mA--
         mM=12
      EndIf
   Next
   If ((mD<=31).And.(mD>=29)).And.(mM==2)
      If Mod(Year(mData),4)==0
         mD=29
      Else
         mD=28
      EndIF
   EndIf
   If (mD==31).And.((mM==4).Or.(mM==6).Or.(mM==9).Or.(mM==11))
      mD=30
   EndIf
/*   If mD < venc
      If mM != 2
         If ((mM==4).Or.(mM==6).Or.(mM==9).Or.(mM==11))
            If venc == 31
               mD = 30
            Else
               mD = venc
            EndIf
         Else
            mD = Venc
         EndIf
      EndIf
   EndIf*/
   mNData=CtoD(Str(mD,02,00)+"/"+Str(mM,02,00)+"/"+Str(mA,04,00))
Else
   mNData=mData-mSoma
EndIf

Return(mNData)

Procedure Balao(Vl)
Do Case
   Case Vl=1
      XXX=MTab([SIM|N�O],[Dar baixa nesta conta a pagar ?])
   Case Vl=2
      XXX=MTab([SIM|N�O],[Dar baixa nesta conta a receber ?])
   Case Vl=3
      XXX=MTab([SIM|N�O],[Estornar esta conta a pagar ?])
   Case Vl=4
      XXX=MTab([SIM|N�O],[Estornar esta conta a receber ?])
   Case Vl=5
      XXX=MTab([SIM|N�O],[Deletar esta conta ?])
EndCase
Keyboard Chr(13)
Return(.T.)
* \\ Final de TRI_OUTR.PRG
