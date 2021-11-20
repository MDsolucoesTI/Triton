/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_ATR2.PRG
 \ Data....: 09-08-2003
 \ Sistema.: Triton - Controle Imobili†rio
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas


sistema[20]={;
            "ComissÑo de Alugueis",;                        // opcao do menu
            "ComissÑo de Alugueis",;                        // titulo do sistema
            {"STR(codigo,01,00)"},;                         // chaves do arquivo
            {"c¢digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "COMISSAO",;                                    // nome do DBF
            {"COMISSA1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,19,20,62,5,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {3,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[20,O_CAMPO],{;            // COMISSAO
     /* mascara       */    "9",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COMISSAO
     /* mascara       */    "99",;
     /* titulo        */    "ComissÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "comissao>0~ComissÑo nÑo aceit†vel",;
     /* help do campo */    "Informe o valor em porcentagem da comissÑo|a ser cobrada pelos alugueis|que utilizarem este c¢digo";
                         };
)


sistema[21]={;
            "Tipo de Bens",;                                // opcao do menu
            "Tipo de Bens",;                                // titulo do sistema
            {"STR(codigo,02,00)"},;                         // chaves do arquivo
            {"C¢digo Tipo Bens"},;                          // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "TIPOIMO",;                                     // nome do DBF
            {"TIPOIMO1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,19,19,63,5,9},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[21,O_CAMPO],{;            // TIPOIMO
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // TIPOIMO
     /* mascara       */    "",;
     /* titulo        */    "Tipo do Bem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipoimo)~Necess†rio informar TIPO DO BEM",;
     /* help do campo */    "Informe o Tipo do Bem";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // TIPOIMO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[22]={;
            "Tipo de Despesa",;                             // opcao do menu
            "Tipo de Despesa",;                             // titulo do sistema
            {"STR(codigo,02,00)"},;                         // chaves do arquivo
            {"C¢digo Despesa"},;                            // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "DESPE",;                                       // nome do DBF
            {"DESPE1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,21,19,64,5,7},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[22,O_CAMPO],{;            // DESPE
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // DESPE
     /* mascara       */    "",;
     /* titulo        */    "Tipo da Despesa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipodesp)~Necess†rio informar TIPO DA DESPESA",;
     /* help do campo */    "Informe o Tipo da Despesa";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // DESPE
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[23]={;
            "AáÑo Financeira",;                             // opcao do menu
            "AáÑo Financeira",;                             // titulo do sistema
            {"STR(codigo,04,00)","descricao"},;             // chaves do arquivo
            {"C¢digo Plano","DescriáÑo Plano"},;            // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "CONTAS",;                                      // nome do DBF
            {"CONTAS1","CONTAS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,18,21,64,5,3},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[23,O_CAMPO],{;            // CONTAS
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da AáÑo Financeira",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~Necess†rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da AáÑo Financeira|Abaixo de 2000, contas de entrada|e acima de 2000, contas de sa°da";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CONTAS
     /* mascara       */    "",;
     /* titulo        */    "DescriáÑo AáÑo Financeira",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Necess†rio informar DescriáÑo",;
     /* help do campo */    "Informe uma descriáÑo para a AáÑo Financeira";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CONTAS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[24]={;
            "Hist¢rico PadrÑo",;                            // opcao do menu
            "Hist¢rico PadrÑo",;                            // titulo do sistema
            {"STR(codigo,03,00)"},;                         // chaves do arquivo
            {"C¢digo Hist¢rico"},;                          // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "HISTO",;                                       // nome do DBF
            {"HISTO1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,21,68,5,9},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[24,O_CAMPO],{;            // HISTO
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~C¢DIGO nÑo aceit†vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico PadrÑo";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // HISTO
     /* mascara       */    "",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descri)~Necess†rio informar Hist¢rico",;
     /* help do campo */    "Informe o texto do hist¢rico padrÑo";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // HISTO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[25]={;
            "Tipos de CrÇdito",;                            // opcao do menu
            "Tipos de CrÇdito",;                            // titulo do sistema
            {"STR(codigo,01,00)"},;                         // chaves do arquivo
            {"c¢digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "CREDITO",;                                     // nome do DBF
            {"CREDITO1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,18,21,61,5,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[25,O_CAMPO],{;            // CREDITO
     /* mascara       */    "9",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // CREDITO
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo de CrÇdito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipo)~Necess†rio informar Tipo de CrÇdito",;
     /* help do campo */    "Informe o tipo do crÇdito|que ser† utilizado no cadastro de clientes|com o objetivo de classifica-los quanto pagamentos recebidos";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // CREDITO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[26]={;
            "Centro de Custo",;                             // opcao do menu
            "Centro de Custo",;                             // titulo do sistema
            {"STR(codigo,04,00)","departa"},;               // chaves do arquivo
            {"C¢digo C.Custo","Nome do C.Custo"},;          // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "CUSTO",;                                       // nome do DBF
            {"CUSTO1","CUSTO2"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,15,17,66},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo Centro de Custo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~C¢digo do Centro de Custo nÑo aceit†vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "",;
     /* titulo        */    "Departamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(departa)~Necess†rio informar Departamento",;
     /* help do campo */    "Informe o nome do Departamento/èrea da Empresa|relacionado com este Centro de Custo";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Receita",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da Receita";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Despesa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da Despesa";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Receber",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Rec. Vencido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Pag. Vencido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // CUSTO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[27]={;
            "Formatos dos Cheques",;                        // opcao do menu
            "Formatos dos Cheques",;                        // titulo do sistema
            {"nubanco"},;                                   // chaves do arquivo
            {"N£mero Banco"},;                              // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "TICHEQUE",;                                    // nome do DBF
            {"TICHEQU1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,6,21,76},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "N£mero Banco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nubanco)~N£nero do Banco nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero do Banco";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colval>0~DistÉncia para o Valor nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para o valor";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linval>0~DistÉncia para o Valor nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem superior para o Valor";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Extenso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colext>0~DistÉncia para o Extenso nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para o Extenso";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Extenso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linext>0~DistÉncia para o Extenso nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem superior para o Extenso";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Ordem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colord>0~DistÉncia para a Ordem nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para a Ordem";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Ordem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linord>0~DistÉncia para a Ordem nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem superior para a Ordem";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colcid>0~DistÉncia para a Cidade/Dia nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para a Cidade/Dia";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Màs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colmes>0~DistÉncia para o Màs nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para o Màs";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Ano",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colano>0~DistÉncia para o Ano nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem esquerda para o Ano";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "lincid>0~DistÉncia para a Cidade/Dia/Màs/Ano nÑo aceit†vel",;
     /* help do campo */    "Informe a distÉncia em mm|da margem superior para a Cidade/Dia/Màs/Ano";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[28]={;
            "Interessados",;                                // opcao do menu
            "Pessoas Interessadas",;                        // titulo do sistema
            {"STR(cod,08,00)","nome"},;                     // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "INTERE",;                                      // nome do DBF
            {"INTERE1","INTERE2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,20,22,64},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[28,O_CAMPO],{;            // INTERE - 01
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 02
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess†rio informar o nome",;
     /* help do campo */    "Informar o nome da pessoa interessada";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE- 03
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 04
     /* mascara       */    "@R (999)!999-9999",;
     /* titulo        */    "Celular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o Celular";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 05
     /* mascara       */    "99",;
     /* titulo        */    "Tipo do Bem",;
     /* cmd especial  */    "VDBF(6,54,20,77,'TIPOIMO',{'codigo','tipoimo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(tipoimo,02,00),'TIPOIMO',1)~Necess†rio informar TIPO DO BEM",;
     /* help do campo */    "Informe o tipo do Bem";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 06
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor M°nimo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor m°nimo do im¢vel para Compra ou Aluguel";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 07
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor M†ximo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor m†ximo do im¢vel para Compra ou Aluguel";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 08
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro de interesse";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 09
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rios M°nimo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios m°nimo";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 10
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rios M†ximo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios m†ximo";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 11
     /* mascara       */    "99",;
     /* titulo        */    "Suite M°nima",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de suites m°nima";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 12
     /* mascara       */    "99",;
     /* titulo        */    "Suite M†xima",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de suites n†xima";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 13
     /* mascara       */    "99",;
     /* titulo        */    "Garagem M°nima",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de vagas na garagem m°nima";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 14
     /* mascara       */    "99",;
     /* titulo        */    "Garagem M†xima",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de vagas na garagem m†xima";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // INTERE - 15
     /* mascara       */    "9",;
     /* titulo        */    "Tipo OperaáÑo",;
     /* cmd especial  */    "MTAB([1-Aluguel|2-Venda],[TIPO OPERAÄéO])",;
     /* default       */    "[1]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo$[12]~TIPO OPERAÄéO nÑo aceit†vel",;
     /* help do campo */    "Informe o tipo de operaáÑo";
                         };
)
AADD(sistema[28,O_FORMULA],{;          // INTERE - TipoBem
     /* form mostrar  */    "LEFT(TRAN(TIPOIMO->tipoimo,[]),15)",;
     /* lin da formula*/    10,;
     /* col da formula*/    08;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // INTERE - tiptran
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[1],[Aluguel],[Venda]),[]),07)",;
     /* lin da formula*/    10,;
     /* col da formula*/    33;
                         };
)


sistema[29]={;
            "Bens",;                                        // opcao do menu
            "Bens",;                                        // titulo do sistema
            {"STR(pasta,04,00)"},;                          // chaves do arquivo
            {"Pasta"},;                                     // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "CVA",;                                     // nome do DBF
            {"CVA1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {2,1,3,1,20,79},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "pasta>0.and.IMO_02F9(pasta)~PASTA nÑo aceit†vel",;
     /* help do campo */    "Informe  o n£mero da pasta";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "9",;
     /* titulo        */    "Tipo OperaáÑo",;
     /* cmd especial  */    "MTAB([1-Aluguel|2-Venda],[TIPO OPERAÄéO])",;
     /* default       */    "'1'",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo$[12]~TIPO OPERAÄéO nÑo aceit†vel",;
     /* help do campo */    "Informe o tipo de operaáÑo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~VALOR nÑo aceit†vel",;
     /* help do campo */    "Informe o valor do im¢vel para Venda|ou o Aluguel Mensal|deacordo com a operaáÑo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Tipo do Bem",;
     /* cmd especial  */    "VDBF(6,54,20,77,'TIPOIMO',{'codigo','tipoimo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(tipoimo,02,00),'TIPOIMO',1)~Necess†rio informar TIPO DO BEM",;
     /* help do campo */    "Informe o tipo do Bem";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo do propriet†rio",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','rg','cgc','nome','fatura'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codpro,08,00),'PESSOA',1)~C¢DIGO DO PROPRIETèRIO nÑo existe na tabela",;
     /* help do campo */    "Informe o c¢digo do propriet†rio";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Cadastro Prefeitura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do cadastro da prefeitura";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Escritura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da escritura";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999.99",;
     /* titulo        */    "èrea do Terreno",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a †rea do terreno";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Unidade da †rea",;
     /* cmd especial  */    "MTAB([M2 =Metro Quadrado|HEC=Hectare|ACR=Acre|ALQ=Alqueire],[UNIDADE DA èREA])",;
     /* default       */    "[M2]",;
     /* pre-validacao */    "",;
     /* validacao     */    "uniare $ [M2 HECACRALQ   ]~UNIDADE DA èREA nÑo aceit†vel",;
     /* help do campo */    "Informe a unidade da †rea do terreno";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999.99",;
     /* titulo        */    "èrea da ConstruáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a metragem da †rea construida";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Endereáo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess†rio informar ENDEREÄO",;
     /* help do campo */    "Informe o endereáo do Bem";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£MERO nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero da residencia ou prÇdio";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess†rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endereáo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endereáo|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endereáo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[TaubatÇ]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endereáo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~UNIDADE DA FEDERAÄéO inv†lida",;
     /* help do campo */    "Informe a sigla da unidade da federaáÑo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@!",;
     /* titulo        */    "Opcao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "opcao $ 'SN'~Necess†rio informar OPCAO",;
     /* help do campo */    "Se o Bem for para Venda coloque 'S'| se o Bem puder ser alugado| e vice-versa";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "opcao=[S]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor para a opáÑo adotada|Venda ou Aluguel";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "@S40",;
     /* titulo        */    "ObservaáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe qualquer observaáÑo sobre o Bem";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rios",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "WC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de banheiros";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Lavabo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a qunatidade de lavabos";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Hall",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Hall";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Escrit¢rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de escrit¢rios";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Suite",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de suites";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Sala de TV",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de salas de TV";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Living",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de living";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Sala de refeiáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o quantidade de salas de refeiáÑo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Copa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de copas";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Cozinha",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de cozinhas";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "èrea de Serviáo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade  de †reas de serviáo";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Despensa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de despensas";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Garagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de vagas na garagem";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Dormit¢rio Empregada",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de dormit¢rios de empregada";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "WC de Empregada",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Wc de empregada";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99",;
     /* titulo        */    "Rancho",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de ranchos";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "",;
     /* titulo        */    "Ativo",;
     /* cmd especial  */    "",;
     /* default       */    "'S'",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // IMOVEIS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_FORMULA],{;          // IMOVEIS - TipoBem
     /* form mostrar  */    "LEFT(TRAN(TIPOIMO->tipoimo,[]),15)",;
     /* lin da formula*/    4,;
     /* col da formula*/    49;
                         };
)
AADD(sistema[29,O_FORMULA],{;          // IMOVEIS - tiptran
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[1],[Aluguel],[Venda]),[]),07)",;
     /* lin da formula*/    4,;
     /* col da formula*/    14;
                         };
)
AADD(sistema[29,O_FORMULA],{;          // IMOVEIS - opope
     /* form mostrar  */    "LEFT(TRAN(IMO_01F9(tipo,opcao),[]),20)",;
     /* lin da formula*/    15,;
     /* col da formula*/    8;
                         };
)


sistema[30]={;
            "Senhas",;                                      // opcao do menu
            "Usu†rios do sistema",;                         // titulo do sistema
            {"pass"},;                                      // chaves do arquivo
            {""},;                                          // titulo dos indices para consulta
            {"02"},;                                        // ordem dos campos chvs
            "TRIPW",;                                       // nome do DBF
            {ntxpw},;                                       // nome do NTX
            {},;                                            // nome dos DBF relacionados
            {},;                                            // campos de relacionamento
            {1,1,11,19,17,51},;                             // qde telas, tela atual, coordenadas
            {3,.t.},;                                       // nivel acesso/tp chave
            {},; // campos  { mascara, titulo, when, critica }
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""};       // condicao de exclusao de registros
           }

msg="DIGITE INICIAIS DAS ROTINAS CERCEADAS AO USUèRIO|"+;
    "P. Procura    F. Filtragem    D. DigitaáÑo     ˇ|"+;
    "M. Modifica   E. Exclui       R. Recupera      ˇ|"+;
    "V. Và global  N. Nova coluna  A. Apaga coluna  ˇ|"+;
    "I. Imprime    O. Ordena       Q. Quantifica    ˇ|"+;
    "L. Localiza   G. Global       C. Congela Colunas|"+;
    "T. Tamanho    J. nova Janela ˇX. eXporta       ˇ|"+;
    "Z. totaliZa                                    ˇ|"
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "",;
     /* titulo        */    "Pass",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@!",;
     /* titulo        */    "Usu†rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(nome)~Necess†rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "9",;
     /* titulo        */    "Nivel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([1. OperaáÑo ˇ|2. ManutenáÑo|3. Gerància ˇ],[N°VEL DE ACESSO])",;
     /* validacao     */    "nace$[123]~N°VEL DE ACESSO inv†lido",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Pessoas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Empregos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outras Atividades",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outras Rendas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Referàncias",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Bens",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Fornecedores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Corretores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Caixa - Bancos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Efetuar Aluguel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Efetuar Vendas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Recibos Locat†rios",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outras Despesas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Recibos Locadores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Movimentos Financeiros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Contas Ö Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Contas a Receber",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Registro de Cheques",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Configuraáîes do sistema",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "ComissÑo de Alugueis",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Tipo de Bens",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Tipo de Despesa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "AáÑo Financeira",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Hist¢rico PadrÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Tipos de CrÇdito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Centro de Custo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Formatos dos Cheques",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Interessados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[30,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Consultas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)

* \\ Final de TRI_ATR2.PRG
