/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_ATRI.PRG
 \ Data....: 09-08-2003
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas


/*
   A adicao das  definicoes dos campos (mascara, titulo, cmd esp, when/defa,
   critica, ajuda) dentro do vetor sistema e' feita atraves da funcao AADD(),
   isto previne erro "memory overbooked" do CA-Clipper, durante a compilacao,
   devido a linha ser muito extensa
*/

sistema[01]={;
            "Pessoas",;                                     // opcao do menu
            "Pessoas F¡sicas/Jur¡dicas",;                   // titulo do sistema
            {"STR(cod,08,00)","nome"},;                     // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","08"},;                                   // ordem campos chaves
            "PESSOA",;                                      // nome do DBF
            {"PESSOA1","PESSOA2"},;                         // nomes dos NTX
            {"FIRMA","ATIVIDA","RENDA","REFER"},;           // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {2,1,1,7,21,75},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo da Pessoa",;
     /* cmd especial  */    "MTAB([F-F¡sica|J-Jur¡dica],[TIPO DA PESSOA])",;
     /* default       */    "[F]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [FJ]~TIPO DA PESSOA n„o aceit vel",;
     /* help do campo */    "Informe se a Pessoa ‚ F¡sica ou Jur¡dica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "9",;
     /* titulo        */    "Cr‚dito",;
     /* cmd especial  */    "VDBF(6,45,20,77,'CREDITO',{'codigo','tipo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codcre,01,00),'CREDITO',1).or.Empty(codcre)~Cr‚dito n„o existe na tabela",;
     /* help do campo */    "INforme o c¢digo do tipo de|classifica‡„o para cr‚dito|[F8] tabela";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@!",;
     /* titulo        */    "Rg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "!EMPT(rg).AND.PES_01F9(rg)~Necess rio informar RG",;
     /* help do campo */    "Informe o RG";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "VDV2(cpf).or.Empty(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "VCGC(cgc).AND.JUR_01F9(cgc)~CGC n„o aceit vel",;
     /* help do campo */    "Informe o cadastro geral de contribuinte";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R 999.999.999.999",;
     /* titulo        */    "Inscri‡„o Estadual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da Inscri‡„o Estadual";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar o nome",;
     /* help do campo */    "Informar o nome da pessoa";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Profiss„o/rea de Atua‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a profiss„o (Pessoa F¡sica) ou| rea de atua‡„o (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Nasc./Abertura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de nascimento (Pessoa F¡sica) ou|data de abertura (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Brasileiro'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a nacionalidade";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Renda Bruta/Faturamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fatura)~Necess rio informar Faturamento",;
     /* help do campo */    "Informe a renda bruta da Pessoa F¡sica ou|o faturamento mensal da pessoa jur¡dica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "9",;
     /* titulo        */    "Estado Civil",;
     /* cmd especial  */    "MTAB([1-Solteiro|2-Casado|3-Separado|4-Divorsiado|5-Viuvo|6-Amasiado],[ESTADO CIVIL])",;
     /* default       */    "[2]",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "estcivi$[123456]~ necess rio Informar o Estado Civil",;
     /* help do campo */    "Informar o Estado Civil";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "9",;
     /* titulo        */    "Regime de Casamento",;
     /* cmd especial  */    "MTAB([1-Comunh„o Parcial|2-Comunh„o|3-Separa‡„o],[REGIME DE CASAMENTO])",;
     /* default       */    "'1'",;
     /* pre-validacao */    "tipo=[F].and.estcivi$[2]",;
     /* validacao     */    "regcasa $ [123]~Regime de Casamento n„o aceit vel",;
     /* help do campo */    "Informe o Regime do Casamento";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "99",;
     /* titulo        */    "N£mero de Dependentes",;
     /* cmd especial  */    "",;
     /* default       */    "0",;
     /* pre-validacao */    "estcivi $ [23456].and. tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de dependentes";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Conjuge",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "estcivi $ [26].and.tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do conjuge";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF - Conjuge",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "estcivi $ [26].and.tipo=[F]",;
     /* validacao     */    "(VDV2(cpfconju).or.Empty(cpfconju)).and.tipo=[F]~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Filia‡„o-Pai",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do pai da pessoa";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Filia‡„o-M„e",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome da m„e da pessoa";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar o endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~Unidade da Federe‡„o inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Tempo Residˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tempo)~Necess rio informar Tempo de Residencia",;
     /* help do campo */    "Informe o tempo de residˆncia neste endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@E 99,999,999.99",;
     /* titulo        */    "Aluguel",;
     /* cmd especial  */    "",;
     /* default       */    "0",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o aluguel pago|se for o caso";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Tel. Comercial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone comercial";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone comercial|se houver";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 32
     /* mascara       */    "",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "!EMPT(contato)~Necess rio informar contato",;
     /* help do campo */    "Informe o nome do contato da Pessoa Jur¡dica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 33
     /* mascara       */    "",;
     /* titulo        */    "Orgao Emissor",;
     /* cmd especial  */    "",;
     /* default       */    "[SSP/SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o Org„o Emissor do RG";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 34
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de emiss„o do RG";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 35
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Casamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "estcivi $ [2].and.tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data do casamento";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 36
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Tel. Residˆncial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone residˆncial";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA - 37
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Celular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o Celular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // PESSOA
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_FORMULA],{;          // PESSOA - comtipo
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[F],[¡sica],[ur¡dica]),[@!]),07)",;
     /* lin da formula*/    4,;
     /* col da formula*/    17;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // PESSOA - Nome Cr‚dito
     /* form mostrar  */    "LEFT(TRAN(CREDITO->tipo,[]),15)",;
     /* lin da formula*/    11,;
     /* col da formula*/    48;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // PESSOA - comest
     /* form mostrar  */    "LEFT(TRAN(PES_02F9(estcivi),[]),10)",;
     /* lin da formula*/    15,;
     /* col da formula*/    08;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // PESSOA - comreg
     /* form mostrar  */    "LEFT(TRAN(PES_03F9(regcasa),[]),16)",;
     /* lin da formula*/    15,;
     /* col da formula*/    26;
                         };
)

sistema[02]={;
            "Empregos",;                                    // opcao do menu
            "Empregos",;                                    // titulo do sistema
            {"STR(cod,08,00)+empr"},;                       // chaves do arquivo
            {"C¢digo-Empresa"},;                            // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "FIRMA",;                                       // nome do DBF
            {"FIRMA1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"PESSOA->cod"},;                               // campos de relacionamento
            {1,1,7,5,21,76},;                               // num telas/tela atual/coordenadas
            {2,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Empresa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(empr)~Necess rio informar o nome da Empresa",;
     /* help do campo */    "Informe o nome da Empresa";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Admiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dtadm)~Necess rio informar a data de admiss„o",;
     /* help do campo */    "Informe a Data de Admiss„o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Fun‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(funcao)~Necess rio informar a fun‡„o",;
     /* help do campo */    "Informe a fun‡„o exercida";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "@E 99,999,999.99",;
     /* titulo        */    "Sal rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "salario>0~Sal rio n„o aceit vel",;
     /* help do campo */    "Informe o £litmo sal rio recebido";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "9",;
     /* titulo        */    "Tipo do Emprego",;
     /* cmd especial  */    "MTAB([1-Atual|2-Anterior|3-Conjuge],[TIPO DO EMPREGO])",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipemp $ [123]~Tipo do emprego n„o aceit vel",;
     /* help do campo */    "Informe a condi‡„o do emprego";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar o endere‡o",;
     /* help do campo */    "Informe o endere‡o da Empresa";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Taubat‚'",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // FIRMA
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_FORMULA],{;          // FIRMA - TipoEmp
     /* form mostrar  */    "LEFT(TRAN(FIR_01F9(tipemp),[]),08)",;
     /* lin da formula*/    6,;
     /* col da formula*/    60;
                         };
)


sistema[03]={;
            "Outras Atividades",;                           // opcao do menu
            "Outras Atividades",;                           // titulo do sistema
            {"STR(cod,08,00)+nome"},;                       // chaves do arquivo
            {"C¢digo-Atividade"},;                          // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "ATIVIDA",;                                     // nome do DBF
            {"ATIVIDA1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"PESSOA->cod"},;                               // campos de relacionamento
            {1,1,9,5,21,76},;                               // num telas/tela atual/coordenadas
            {9,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Nome da Atividade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar o nome da atividade",;
     /* help do campo */    "Informe a outra atividade exercida";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "@E 999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor recebido";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // ATIVIDA
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[04]={;
            "Outras Rendas",;                               // opcao do menu
            "Outras Rendas",;                               // titulo do sistema
            {"STR(cod,08,00)+origem"},;                     // chaves do arquivo
            {"C¢digo-Renda"},;                              // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "RENDA",;                                       // nome do DBF
            {"RENDA1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"PESSOA->cod"},;                               // campos de relacionamento
            {1,1,11,11,17,71},;                             // num telas/tela atual/coordenadas
            {2,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[04,O_CAMPO],{;            // RENDA
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // RENDA
     /* mascara       */    "",;
     /* titulo        */    "Origem da Renda",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(origem)~Necess rio informar a origem da renda",;
     /* help do campo */    "Informe a outra renda recebida";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // RENDA
     /* mascara       */    "@E 999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor recebido";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // RENDA
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[05]={;
            "Referˆncias",;                                 // opcao do menu
            "Referˆncias",;                                 // titulo do sistema
            {"STR(cod,08,00)+nome"},;                       // chaves do arquivo
            {"C¢digo-Referencia"},;                         // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "REFER",;                                       // nome do DBF
            {"REFER1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"PESSOA->cod"},;                               // campos de relacionamento
            {1,1,11,3,21,78},;                              // num telas/tela atual/coordenadas
            {2,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Nome Referˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar o nome da referˆncia",;
     /* help do campo */    "Informe o nome da referˆncia";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar o endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa ou empresa";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Taubat‚'",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // REFER
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[06]={;
            "Bens",;                                        // opcao do menu
            "Bens",;                                        // titulo do sistema
            {"STR(pasta,04,00)"},;                          // chaves do arquivo
            {"Pasta"},;                                     // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "IMOVEIS",;                                     // nome do DBF
            {"IMOVEIS1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {2,1,3,1,20,79},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"PTAB(STR(pasta,04,00),'ALUGUEL',1)","O Bem est  Alugado, n„o pode ser excluido"};// condicao de exclusao de registros
           }

AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "pasta>0.and.IMO_02F9(pasta)~PASTA n„o aceit vel",;
     /* help do campo */    "Informe  o n£mero da pasta";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "9",;
     /* titulo        */    "Tipo Opera‡„o",;
     /* cmd especial  */    "MTAB([1-Aluguel|2-Venda],[TIPO OPERA€ŽO])",;
     /* default       */    "'1'",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo$[12]~TIPO OPERA€ŽO n„o aceit vel",;
     /* help do campo */    "Informe o tipo de opera‡„o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~VALOR n„o aceit vel",;
     /* help do campo */    "Informe o valor do im¢vel para Venda|ou o Aluguel Mensal|deacordo com a opera‡„o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Tipo do Bem",;
     /* cmd especial  */    "VDBF(6,54,20,77,'TIPOIMO',{'codigo','tipoimo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(tipoimo,02,00),'TIPOIMO',1)~Necess rio informar TIPO DO BEM",;
     /* help do campo */    "Informe o tipo do Bem";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo do propriet rio",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','rg','cgc','nome','fatura'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codpro,08,00),'PESSOA',1)~C¢DIGO DO PROPRIETRIO n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do propriet rio";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Cadastro Prefeitura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do cadastro da prefeitura";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Escritura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da escritura";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999.99",;
     /* titulo        */    "rea do Terreno",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a  rea do terreno";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Unidade da  rea",;
     /* cmd especial  */    "MTAB([M2 =Metro Quadrado|HEC=Hectare|ACR=Acre|ALQ=Alqueire],[UNIDADE DA REA])",;
     /* default       */    "[M2]",;
     /* pre-validacao */    "",;
     /* validacao     */    "uniare $ [M2 HECACRALQ   ]~UNIDADE DA REA n„o aceit vel",;
     /* help do campo */    "Informe a unidade da  rea do terreno";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999.99",;
     /* titulo        */    "rea da Constru‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a metragem da  rea construida";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar ENDERE€O",;
     /* help do campo */    "Informe o endere‡o do Bem";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£MERO n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Opcao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "opcao $ 'SN'~Necess rio informar OPCAO",;
     /* help do campo */    "Se o Bem for para Venda coloque 'S'| se o Bem puder ser alugado| e vice-versa";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "opcao=[S]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor para a op‡„o adotada|Venda ou Aluguel";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@S40",;
     /* titulo        */    "Observa‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe qualquer observa‡„o sobre o Bem";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rios",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "WC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de banheiros";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Lavabo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a qunatidade de lavabos";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Hall",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Hall";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Escrit¢rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de escrit¢rios";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Suite",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de suites";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Sala de TV",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de salas de TV";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Living",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de living";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Sala de refei‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o quantidade de salas de refei‡„o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Copa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de copas";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Cozinha",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de cozinhas";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "rea de Servi‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade  de  reas de servi‡o";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Despensa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de despensas";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Garagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de vagas na garagem";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rio Empregada",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios de empregada";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "WC de Empregada",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Wc de empregada";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Rancho",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de ranchos";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Ativo",;
     /* cmd especial  */    "",;
     /* default       */    "'S'",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_FORMULA],{;          // IMOVEIS - TipoBem
     /* form mostrar  */    "LEFT(TRAN(TIPOIMO->tipoimo,[]),15)",;
     /* lin da formula*/    4,;
     /* col da formula*/    49;
                         };
)
AADD(sistema[06,O_FORMULA],{;          // IMOVEIS - tiptran
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[1],[Aluguel],[Venda]),[]),07)",;
     /* lin da formula*/    4,;
     /* col da formula*/    14;
                         };
)
AADD(sistema[06,O_FORMULA],{;          // IMOVEIS - opope
     /* form mostrar  */    "LEFT(TRAN(IMO_01F9(tipo,opcao),[]),20)",;
     /* lin da formula*/    15,;
     /* col da formula*/    8;
                         };
)


sistema[07]={;
            "Pessoas",;                                     // opcao do menu
            "Pessoas F¡sicas/Jur¡dicas",;                   // titulo do sistema
            {"STR(codigo,04,00)","nome"},;                  // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","07"},;                                   // ordem campos chaves
            "FORNEC",;                                      // nome do DBF
            {"FORNEC1","FORNEC2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,5,22,78},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo da Pessoa",;
     /* cmd especial  */    "MTAB([F-F¡sica|J-Jur¡dica],[TIPO DA PESSOA])",;
     /* default       */    "[F]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [FJ]~Tipo da Pessoa n„o aceit vel",;
     /* help do campo */    "Informe se a Pessoa ‚ F¡sica ou Jur¡dica";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@!",;
     /* titulo        */    "Rg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "!EMPT(rg).AND.FOR_01F9(rg)~Necess rio informar RG",;
     /* help do campo */    "Informe o RG";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "VDV2(cpf).or.Empty(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "VCGC(cgc).AND.FOR_04F9(cgc)~CGC n„o aceit vel",;
     /* help do campo */    "Informe o cadastro geral de contribuinte";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 999.999.999.999",;
     /* titulo        */    "Inscri‡„o Estadual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o numero da Inscri‡„o Estadual";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar o nome",;
     /* help do campo */    "Informar o nome da pessoa";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Profiss„o/rea de Atua‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a profiss„o (Pessoa F¡sica) ou| rea de atua‡„o (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Nasc./Abertura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de nascimento (Pessoa F¡sica) ou|data de abertura (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Brasileiro'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a nacionalidade";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Taubat‚'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a naturalidade";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar Endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~Unidade da Federe‡„o inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "!EMPT(contato)~Necess rio informar Contato",;
     /* help do campo */    "Informe o nome do contato da Pessoa Jur¡dica";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // FORNEC
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_FORMULA],{;          // FORNEC - comtipo
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[F],[¡sica],[ur¡dica]),[@!]),07)",;
     /* lin da formula*/    5,;
     /* col da formula*/    17;
                         };
)


sistema[08]={;
            "Corretores",;                                  // opcao do menu
            "Corretores",;                                  // titulo do sistema
            {"STR(cod,08,00)","nome"},;                     // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","04"},;                                   // ordem campos chaves
            "CORRETOR",;                                    // nome do DBF
            {"CORRETO1","CORRETO2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,15,19,72},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "@!",;
     /* titulo        */    "Rg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "COR_01F9(rg).and.!Empty(rg)~Necess rio informar RG",;
     /* help do campo */    "Informe o RG";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).or.Empty(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar o nome",;
     /* help do campo */    "Informar o nome da pessoa";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Nasc.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de nascimento";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar ENDERE€O",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£MERO n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // CORRETOR
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[09]={;
            "Caixa - Bancos",;                              // opcao do menu
            "Caixa - Bancos",;                              // titulo do sistema
            {"STR(codigo,02,00)","banco"},;                 // chaves do arquivo
            {"c¢digo","C/Corrente"},;                       // titulo dos indices para consulta
            {"01","03"},;                                   // ordem campos chaves
            "BANCOS",;                                      // nome do DBF
            {"BANCOS1","BANCOS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,17,16,65},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "2",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo Banco",;
     /* cmd especial  */    "VDBF(6,71,20,77,'TICHEQUE',{'nubanco'},1,'nubanco',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codbanco,'TICHEQUE',1)~C¢digo do Banco n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Banco/Conta|do qual ser  emitido o cheque";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@R 999-!!99-!!!!!!!!!-!!",;
     /* titulo        */    "Banco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(banco)~Necess rio informar BANCO",;
     /* help do campo */    "Informe o Banco/Agˆncia/C.Corrente/Digito|Se o campo no v¡deo for maior que os n£meros a serem digitados|use espa‡os para reduzir o tamanho do campo";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Necess rio informar DESCRI€ŽO",;
     /* help do campo */    "Informe o nome do banco";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data do £ltimo Movimento",;
     /* cmd especial  */    "",;
     /* default       */    "Datac",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(datmov)~Necess rio informar Data do £ltimo Movimento",;
     /* help do campo */    "Informe a data do £ltimo movimento|ou a data do saldo atual";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Saldo Atual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o Saldo Atual da Conta Corrente|o valor informado ser  lan‡ado como saldo inicial do movimento de Hoje.";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[10]={;
            "Efetuar Aluguel",;                             // opcao do menu
            "Efetuar Aluguel",;                             // titulo do sistema
            {"STR(pasta,04,00)","STR(codigo,06,00)"},;      // chaves do arquivo
            {"Pasta","C¢digo"},;                            // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "ALUGUEL",;                                     // nome do DBF
            {"ALUGUEL1","ALUGUEL2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,0,12,23,67},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "VDBF(6,34,20,77,'IMOVEIS',{'pasta','tipo','valor1','codpro'},1,'pasta',[(tipo='1'.or.(tipo='2'.and.opcao='S')).and.ativo='S'])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(pasta,04,00),'IMOVEIS',1)~Pasta n„o existe na tabela",;
     /* help do campo */    "Informe o n£mero da pasta do Bem";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "9",;
     /* titulo        */    "C¢digo Comiss„o",;
     /* cmd especial  */    "VDBF(6,68,20,77,'COMISSAO',{'codigo','comissao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codcomi,01,00),'COMISSAO',1)~Necess rio informar C¢digo da Comiss„o",;
     /* help do campo */    "Informe o c¢digo da comiss„o a ser cobrada|[F8] Tabela";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "IMOVEIS->valor1",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor do aluguel";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo Lacat rio",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','tipo','nome','rg','cgc','fatura'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codi,08,00),'PESSOA',1)~C¢digo do Locat rio n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Locat rio";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo Fiador",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','tipo','nome','rg','cgc','fatura'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codf,08,00),'PESSOA',1)~C¢digo do Fiador n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Fiador";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "@D",;
     /* titulo        */    "In¡cio Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(inicon).and.TerCont(inicon)~Necess rio informar In¡cio do Contrato",;
     /* help do campo */    "Informe a data de in¡cio do contrato|de aluguel";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "@D",;
     /* titulo        */    "Fim Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fincon)~Necess rio informar Fim do Contrato",;
     /* help do campo */    "Informe a data de Termino do Contrato|de aluguel";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "99",;
     /* titulo        */    "Vencimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "venc>0.and.venc<=31~Vencimento n„o aceit vel",;
     /* help do campo */    "Informe o dia de vencimento do aluguel";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "",;
     /* titulo        */    "Antecipado",;
     /* cmd especial  */    "",;
     /* default       */    "[N]",;
     /* pre-validacao */    "",;
     /* validacao     */    "antcp$[SN]~Informa‡„o n„o aceit vel",;
     /* help do campo */    "Informe 'S' se o aluguel for paga antecipado|e 'N' caso contr rio";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "99",;
     /* titulo        */    "Reajuste",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "reaju>0~Per¡odo de Reajuste n„o aceit vel",;
     /* help do campo */    "Informe o n£mero de meses ap¢s assinatura|do contrato, para efetuar o reajuste do aluguel";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,32,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custos,04,00),'CUSTO',1).or.Empty(custos)~Centro de Custos n„o existe na tabela",;
     /* help do campo */    "Informe o n£mero do Centro de Custo|[F8] para Tabela";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "9999",;
     /* titulo        */    "N£mero Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "0",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // ALUGUEL
     /* mascara       */    "@D",;
     /* titulo        */    "Data Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_FORMULA],{;          // ALUGUEL - nome locat rio
     /* form mostrar  */    "LEFT(TRAN(IF(PTAB(STR(Codi,08,00),'PESSOA',1),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    7,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // ALUGUEL - Nome Fiador
     /* form mostrar  */    "LEFT(TRAN(If(PTAB(STR(codf,8,0),'PESSOA'),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    9,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // ALUGUEL - Comiss„o
     /* form mostrar  */    "LEFT(TRAN(COMISSAO->comissao,[99]),02)",;
     /* lin da formula*/    4,;
     /* col da formula*/    48;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // ALUGUEL - departa
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    18,;
     /* col da formula*/    11;
                         };
)

* \\ Final de TRI_ATRI.PRG
