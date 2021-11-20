/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: TRI_ATR1.PRG
 \ Data....: 09-08-2003
 \ Sistema.: Triton - Controle Imobili†rio
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "triton.ch"    // inicializa constantes manifestas


sistema[11]={;
            "Efetuar Vendas",;                              // opcao do menu
            "Efetuar Vendas",;                              // titulo do sistema
            {"STR(pasta,04,00)"},;                          // chaves do arquivo
            {"pasta"},;                                     // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "VENDAS",;                                      // nome do DBF
            {"VENDAS1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,6,18,77},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "VDBF(6,25,20,77,'IMOVEIS',{'pasta','ativo','tipo','valor1','tipoimo','codpro'},1,'pasta',[(tipo='2'.and.ativo='S').or.(tipo='1'.and.opcao='S')])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(pasta,04,00),'IMOVEIS',1)~Pasta nÑo existe na tabela",;
     /* help do campo */    "Informe o n£mero da pasta do Bem|ou F8 para ver Tabela";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "IMOVEIS->valor1",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~Valor nÑo aceit†vel",;
     /* help do campo */    "Informe o valor de Venda do Im¢vel";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "@D",;
     /* titulo        */    "Data Venda",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dataven).and.TerCont(dataven)~Necess†rio informar Data da Venda",;
     /* help do campo */    "Informe a Data de Venda do Im¢vel";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "99999999",;
     /* titulo        */    "Comprador",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','nome','rg','cgc'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(comprador,08,00),'PESSOA',1).or.Empty(comprador)~Comprador nÑo existe na tabela",;
     /* help do campo */    "Informe o c¢digo da pessoa que comprou o bem|ou F8 para ver Tabela";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "99999999",;
     /* titulo        */    "C¢digo do Corretor",;
     /* cmd especial  */    "VDBF(6,11,20,77,'CORRETOR',{'cod','nome','rg'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(corretor,08,00),'CORRETOR',1)~C¢digo do Corretor nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Corretor|ou F8 para ver tabela";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "99",;
     /* titulo        */    "ComissÑo Vendedor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a percentagem de comissÑo do vendedor";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "99",;
     /* titulo        */    "ComissÑo Imobili†ria",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a percentagem de comissÑo da Imobili†ria";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "@!",;
     /* titulo        */    "Vista",;
     /* cmd especial  */    "MTAB([S-Sim|N-NÑo],[VISTA])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "vista $ [SN]~Forma de Pagamento nÑo aceitavel",;
     /* help do campo */    "Informe <S> se for pagamento a vista|e <N> se for a prazo|ou F8 para ver Tabela";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "99",;
     /* titulo        */    "Parcelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vista!=[S]",;
     /* validacao     */    "parcelas>0~Parcelas nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero de parcelas";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // VENDAS
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,32,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custos,04,00),'CUSTO',1).or.Empty(custos)~Centro de Custos nÑo existe na tabela",;
     /* help do campo */    "Informe o n£mero do Centro de Custo|[F8] para Tabela";
                         };
)
AADD(sistema[11,O_FORMULA],{;          // VENDAS - Departa
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    10,;
     /* col da formula*/    11;
                         };
)


sistema[12]={;
            "Recibos Locat†rios",;                          // opcao do menu
            "ManutenáÑo Recibos Locat†rios",;               // titulo do sistema
            {"STR(sequen,09,00)","STR(pasta,04,00)+DTOS(venc)"},;// chaves do arquivo
            {"Sequencia","Pasta_Màs"},;                     // titulo dos indices para consulta
            {"01","200206"},;                               // ordem campos chaves
            "ARECIBO",;                                     // nome do DBF
            {"ARECIBO1","ARECIBO2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,5,23,76},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"!PTAB(STR(codalu,06,00),'ALUGUEL',2)","ExclusÑo nÑo Ç possivel|aluguel ainda est† ativo"};// condicao de exclusao de registros
           }

AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "999999999",;
     /* titulo        */    "Sequencia",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'ALUGUEL',{'pasta','codi','inicon','fincon'},1,'pasta',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(pasta,04,00),'ALUGUEL',1)~PASTA nÑo aceit†vel",;
     /* help do campo */    "Informe o N£mero da Pasta";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "9999",;
     /* titulo        */    "N£mero Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data In°cio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(per1)~Necess†rio informar DATA IN°CIO",;
     /* help do campo */    "Informe a data inicial do periodo de aluguel";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data Final",;
     /* cmd especial  */    "",;
     /* default       */    "(per1+30)",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Vencimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(venc).and.TerCont(venc)~Necess†rio informar VENCIMENTO",;
     /* help do campo */    "Informe a data de vencimento do recibo";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "ALUGUEL->valor1",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~VALOR nÑo aceit†vel",;
     /* help do campo */    "Informe o valor do aluguel";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "IPTU",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do IPTU";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "ègua",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da èGUA";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Luz",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da LUZ";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do TELEFONE";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Outros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor de Outras Despesas";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total",;
     /* cmd especial  */    "",;
     /* default       */    "valor1+iptu+agua+luz+telefone+outros",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "valor1*(1+(M->multa/100))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do aluguel sem Desconto";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Diversos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor dos Diversos";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "CorreáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da CorreáÑo Monet†ria";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total",;
     /* cmd especial  */    "",;
     /* default       */    "valor2+iptu1+agua+luz+telefone+outros+cla20+correc",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor pago";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "pagval>0",;
     /* validacao     */    "!EMPT(datpag)~Necess†rio informar DATA PAGAMENTO",;
     /* help do campo */    "Informe a data do pagamento";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // ARECIBO
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Venc Contrato
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->fincon,[]),10)",;
     /* lin da formula*/    4,;
     /* col da formula*/    31;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - C¢digo Lacat†ri
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->codi,[99999999]),08)",;
     /* lin da formula*/    6,;
     /* col da formula*/    4;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Locat†rio
     /* form mostrar  */    "LEFT(TRAN(if(PTAB(STR(ALUGUEL->codi,8,0),'PESSOA'),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    6,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - C¢digo do Fiado
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->codf,[99999999]),08)",;
     /* lin da formula*/    8,;
     /* col da formula*/    4;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Fiador
     /* form mostrar  */    "LEFT(TRAN(If(PTAB(STR(ALUGUEL->codf,8,0),'PESSOA'),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    8,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - data ap¢s
     /* form mostrar  */    "LEFT(TRAN(venc+1,[]),10)",;
     /* lin da formula*/    10,;
     /* col da formula*/    45;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Pasta
     /* form mostrar  */    "LEFT(TRAN(pasta,[9999]),04)",;
     /* lin da formula*/    4,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - IPTU
     /* form mostrar  */    "LEFT(TRAN(iptu1,[@E 999,999.99]),10)",;
     /* lin da formula*/    12,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - ègua
     /* form mostrar  */    "LEFT(TRAN(agua,[@E 999,999.99]),10)",;
     /* lin da formula*/    13,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Luz
     /* form mostrar  */    "LEFT(TRAN(luz,[@E 999,999.99]),10)",;
     /* lin da formula*/    14,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Telefone
     /* form mostrar  */    "LEFT(TRAN(telefone,[@E 999,999.99]),10)",;
     /* lin da formula*/    15,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // ARECIBO - Outros
     /* form mostrar  */    "LEFT(TRAN(outros,[@E 999,999.99]),10)",;
     /* lin da formula*/    16,;
     /* col da formula*/    57;
                         };
)


sistema[13]={;
            "Outras Despesas",;                             // opcao do menu
            "Outras Despesas",;                             // titulo do sistema
            {"STR(pasta,04,00)+STR(cod,09,00)"},;           // chaves do arquivo
            {"Pasta/C¢digo"},;                              // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "OUTDES",;                                      // nome do DBF
            {"OUTDES1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,17,70},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'ALUGUEL',{'pasta','codi','inicon','fincon'},1,'pasta',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(pasta,04,00),'ALUGUEL',1)~PASTA nÑo aceit†vel",;
     /* help do campo */    "Informe o N£mero da Pasta";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "999999999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "99",;
     /* titulo        */    "Tipo de Despesa",;
     /* cmd especial  */    "VDBF(6,72,20,77,'DESPE',{'codigo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(tipdes,02,00),'DESPE',1)~TIPO DE DESPESA nÑo aceit†vel",;
     /* help do campo */    "Informe o Tipo de Despesa";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor Despesa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valdes<>0~Valor da Despesa/Desconto nÑo aceit†vel",;
     /* help do campo */    "Informe o valor a ser pago pela despesa";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "99",;
     /* titulo        */    "Parcela",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "parc>0~PARCELA nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero de ordem da parcela";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "@D",;
     /* titulo        */    "Data Vencimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dtvenc).and.TerCont(dtvenc)~Necess†rio informar DATA VENCIMENTO",;
     /* help do campo */    "Informe a data de vencimento da despesa";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // OUTDES
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess†rio informar o nome",;
     /* help do campo */    "Informar o nome do Favorecido";
                         };
)
AADD(sistema[13,O_FORMULA],{;          // OUTDES - Tipo Despesa
     /* form mostrar  */    "LEFT(TRAN(DESPE->tipodesp,[]),15)",;
     /* lin da formula*/    7,;
     /* col da formula*/    9;
                         };
)


sistema[14]={;
            "Recibos Locadores",;                           // opcao do menu
            "ManutenáÑo Recibos Locadores",;                // titulo do sistema
            {"STR(sequen,09,00)","STR(codalu,06,00)+STR(pasta,04,00)+DTOS(venc)"},;// chaves do arquivo
            {"Sequencia","Pasta_Màs"},;                     // titulo dos indices para consulta
            {"01","250206"},;                               // ordem campos chaves
            "LRECIBO",;                                     // nome do DBF
            {"LRECIBO1","LRECIBO2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,-1,5,24,76},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"!PTAB(STR(codalu,06,00),'ALUGUEL',2)","ExclusÑo nÑo Ç possivel|aluguel ainda est† ativo"};// condicao de exclusao de registros
           }

AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "999999999",;
     /* titulo        */    "Sequencia",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "9999",;
     /* titulo        */    "Pasta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'ALUGUEL',{'pasta','codi','inicon','fincon'},1,'pasta',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(pasta,04,00),'ALUGUEL',1)~PASTA nÑo aceit†vel",;
     /* help do campo */    "Informe o N£mero da Pasta";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "9999",;
     /* titulo        */    "N£mero Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data In°cio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(per1).or.PTAB(STR(ALUGUEL->codcomi,01,00),'COMISSAO',1)~Necess†rio informar DATA IN°CIO",;
     /* help do campo */    "Informe a data inicial do periodo de aluguel";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data Final",;
     /* cmd especial  */    "",;
     /* default       */    "(per1+30)",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Vencimento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(venc).and.TerCont(venc)~Necess†rio informar VENCIMENTO",;
     /* help do campo */    "Informe a data de vencimento do recibo";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "ALUGUEL->valor1",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor1>0~VALOR nÑo aceit†vel",;
     /* help do campo */    "Informe o valor do aluguel";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "IPTU",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do IPTU";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "ègua",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da èGUA";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Luz",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da LUZ";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do TELEFONE";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Outros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor de Outras Despesas";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total",;
     /* cmd especial  */    "",;
     /* default       */    "valor1+iptu+agua+luz+telefone+outros",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "99",;
     /* titulo        */    "Taxa",;
     /* cmd especial  */    "",;
     /* default       */    "COMISSAO->comissao",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "AdministraáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "(taxa/100)*valor1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Locador",;
     /* cmd especial  */    "",;
     /* default       */    "valor1-adm",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "valor1*(1+(Par([multa])/100))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor do aluguel sem Desconto";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Claus.20",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da Clausula 20";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "CorreáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da CorreáÑo Monet†ria";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total",;
     /* cmd especial  */    "",;
     /* default       */    "valor2+iptu1+agua+luz+telefone+outros+cla20+correc",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "AdministraáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "(taxa/100)*(valor2+cla20+correc)",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Locador",;
     /* cmd especial  */    "",;
     /* default       */    "(valor2+cla20+correc)-adm2",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor pago";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "@D",;
     /* titulo        */    "Data Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "pagval>0",;
     /* validacao     */    "!EMPT(datpag)~Necess†rio informar DATA PAGAMENTO",;
     /* help do campo */    "Informe a data do pagamento";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // LRECIBO
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Venc Contrato
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->fincon,[]),10)",;
     /* lin da formula*/    3,;
     /* col da formula*/    31;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - C¢digo Lacat†ri
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->codi,[99999999]),08)",;
     /* lin da formula*/    5,;
     /* col da formula*/    4;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Locat†rio
     /* form mostrar  */    "LEFT(TRAN(if(PTAB(STR(ALUGUEL->codi,8,0),'PESSOA'),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    5,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - C¢digo do Fiado
     /* form mostrar  */    "LEFT(TRAN(ALUGUEL->codf,[99999999]),08)",;
     /* lin da formula*/    7,;
     /* col da formula*/    4;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Fiador
     /* form mostrar  */    "LEFT(TRAN(If(PTAB(STR(ALUGUEL->codf,8,0),'PESSOA'),PESSOA->nome,''),[]),35)",;
     /* lin da formula*/    7,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - data ap¢s
     /* form mostrar  */    "LEFT(TRAN(venc+1,[]),10)",;
     /* lin da formula*/    9,;
     /* col da formula*/    45;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Pasta
     /* form mostrar  */    "LEFT(TRAN(pasta,[9999]),04)",;
     /* lin da formula*/    3,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - IPTU
     /* form mostrar  */    "LEFT(TRAN(iptu1,[@E 999,999.99]),10)",;
     /* lin da formula*/    11,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - ègua
     /* form mostrar  */    "LEFT(TRAN(agua,[@E 999,999.99]),10)",;
     /* lin da formula*/    12,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Luz
     /* form mostrar  */    "LEFT(TRAN(luz,[@E 999,999.99]),10)",;
     /* lin da formula*/    13,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Telefone
     /* form mostrar  */    "LEFT(TRAN(telefone,[@E 999,999.99]),10)",;
     /* lin da formula*/    14,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Outros
     /* form mostrar  */    "LEFT(TRAN(outros,[@E 999,999.99]),10)",;
     /* lin da formula*/    15,;
     /* col da formula*/    57;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // LRECIBO - Taxa1
     /* form mostrar  */    "LEFT(TRAN(taxa,[99]),02)",;
     /* lin da formula*/    21,;
     /* col da formula*/    44;
                         };
)


sistema[15]={;
            "Movimentos Financeiros",;                      // opcao do menu
            "Movimentos Financeiros",;                      // titulo do sistema
            {"DTOS(data)+STR(banco,02,00)+STR(contas,04,00)","codlan"},;// chaves do arquivo
            {"data+Banco+Contas","Cod.Lanc"},;              // titulo dos indices para consulta
            {"010403","11"},;                               // ordem campos chaves
            "MOVIM",;                                       // nome do DBF
            {"MOVIM1","MOVIM2"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,1,18,79},;                               // num telas/tela atual/coordenadas
            {2,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Movimento",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(data).and.TerCont(data)~Necess†rio informar a Data do Movimento",;
     /* help do campo */    "Informe a Data do Movimento";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess†rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver taráos ou barras manter na digitaáÑo";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "9999",;
     /* titulo        */    "Conta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess†rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da AáÑo Financeira|Abaixo de 2000, contas de entrada|e acima de 2000, contas de sa°da|F8 Tabela Pick";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "99",;
     /* titulo        */    "Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1)~BANCO nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Caixa/Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([ENTRADA|SA°DA],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [ES]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Informe o Tipo de OperaáÑo|F8 Tabela Pick";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe C¢digo do Hist¢rico PadrÑo|F8 Tabela Pick";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do Hist¢rico|se houver";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR nÑo aceit†vel",;
     /* help do campo */    "Informe o Valor";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,30,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1) .or. Empty(custo)~CENTRO DE CUSTOS nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "",;
     /* titulo        */    "ObservaáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observaáÑo|se houver";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // MOVIM
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[15,O_FORMULA],{;          // MOVIM - Entrada/Sa°da
     /* form mostrar  */    "LEFT(TRAN(If(tipo=[S],[A°DA  ],[NTRADA]),[@!]),06)",;
     /* lin da formula*/    6,;
     /* col da formula*/    41;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // MOVIM - DescriáÑo Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    6,;
     /* col da formula*/    7;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // MOVIM - DescriáÑo Conta
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    4,;
     /* col da formula*/    40;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // MOVIM - Departamento
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    10,;
     /* col da formula*/    35;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // MOVIM - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    8,;
     /* col da formula*/    8;
                         };
)


sistema[16]={;
            "Contas a Pagar",;                              // opcao do menu
            "Contas a Pagar",;                              // titulo do sistema
            {"STR(seque,10,00)","DTOS(datapago)","STR(codigo,04,00)+documen+DTOS(vencimento)"},;// chaves do arquivo
            {"sequància","Data Pagamento","for+doc+venc"},;// titulo dos indices para consulta
            {"01","14","040305"},;                          // ordem campos chaves
            "PAGAR",;                                       // nome do DBF
            {"PAGAR1","PAGAR2","PAGAR3"},;                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,13,23,70},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequància",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess†rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver taráos ou barras manter na digitaáÑo";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "Fornecedor",;
     /* cmd especial  */    "VDBF(6,3,20,77,'FORNEC',{'codigo','razao','cgc','rg'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codigo,04,00),'FORNEC',1)~Necess†rio informar o C¢digo Fornecedor",;
     /* help do campo */    "Informe o c¢digo do Fornecedor|F8 Tabela Pick";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencimento).TerCont(vencimento)~Necess†rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Vl Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valpagar>0~Valor nÑo aceit†vel",;
     /* help do campo */    "Informe o valor a ser pago";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da AáÑo Financeira",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo>=2000])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess†rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da AáÑo Financeira|F8 Tabela Pick";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo do Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1).or.Empty(banco)~C¢DIGO DO BANCO nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~C¢digo nÑo aceit†vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico PadrÑo|F8 Tabela Pick";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,15,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1).or.Empty(custo)~Centro de Custos nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "",;
     /* titulo        */    "ObservaáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observaáÑo|se houver";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "99",;
     /* titulo        */    "N£mero da Parcela",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "parcelas>=0~N£mero da Parcela nÑo aceit†vel",;
     /* help do campo */    "Se for pagamentos parcelos|informe o n£mero da parcela|caso contr†rio digite 0";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor Pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_FORMULA],{;          // PAGAR - Nome
     /* form mostrar  */    "LEFT(TRAN(FORNEC->razao,[]),35)",;
     /* lin da formula*/    6,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[16,O_FORMULA],{;          // PAGAR - DescriáÑo Finan
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    10,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[16,O_FORMULA],{;          // PAGAR - DescriáÑo Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    9;
                         };
)
AADD(sistema[16,O_FORMULA],{;          // PAGAR - Hist¢rico Padr.
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[16,O_FORMULA],{;          // PAGAR - Centro Custo
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    11;
                         };
)


sistema[17]={;
            "Contas a Receber",;                            // opcao do menu
            "Contas a Receber",;                            // titulo do sistema
            {"STR(seque,10,00)"},;                          // chaves do arquivo
            {"Sequància"},;                                 // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "RECEBER",;                                     // nome do DBF
            {"RECEBER1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,13,23,70},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequància",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess†rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver taráos ou barras manter na digitaáÑo";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "99999999",;
     /* titulo        */    "Cliente",;
     /* cmd especial  */    "VDBF(6,3,20,77,'PESSOA',{'cod','nome','codcre','rg','cgc'},1,'cod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codigo,08,00),'PESSOA',1)~Necess†rio informar C¢digo do Cliente",;
     /* help do campo */    "Informe o c¢digo do Cliente|F8 Tabela Pick";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencimento).and.TerCont(vencimento)~Necess†rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Vl Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valpagar>0~Valor nÑo aceit†vel",;
     /* help do campo */    "Informe o valor a ser pago";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da Conta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo<2000])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess†rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da AáÑo Financeira|F8 Tabela Pick";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo do Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1).or.Empty(banco)~C¢DIGO DO BANCO nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~C¢DIGO nÑo aceit†vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico PadrÑo|F8 Tabela Pick";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,30,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1) .or. Empty(custo)~CENTRO DE CUSTOS nÑo existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "",;
     /* titulo        */    "ObservaáÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observaáÑo|se houver";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "99",;
     /* titulo        */    "N£mero da Parcela",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "parcelas>=0~N£mero da Parcela nÑo aceit†vel",;
     /* help do campo */    "Se for pagamentos parcelos|informe o n£mero da parcela|caso contr†rio digite 0";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor Pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_FORMULA],{;          // RECEBER - RazÑo Social
     /* form mostrar  */    "LEFT(TRAN(PESSOA->nome,[]),35)",;
     /* lin da formula*/    6,;
     /* col da formula*/    14;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // RECEBER - DescriáÑo Finan
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    10,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // RECEBER - DescriáÑo Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    9;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // RECEBER - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // RECEBER - Departamento
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    13;
                         };
)


sistema[18]={;
            "Registro de Cheques",;                         // opcao do menu
            "Registro de Cheques",;                         // titulo do sistema
            {"STR(seque,10,00)","STR(codigo,04,00)+documen+DTOS(vencimento)"},;// chaves do arquivo
            {"Sequància","Fornec/Doc/Venc"},;               // titulo dos indices para consulta
            {"01","030405"},;                               // ordem campos chaves
            "CHEQUES",;                                     // nome do DBF
            {"CHEQUES1","CHEQUES2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,14,22,68},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequància",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "InterligaáÑo",;
     /* cmd especial  */    "MTAB([Sim|NÑo],[INTERLIGAÄéO])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "inter $ [SN]~Resposta inv†lida",;
     /* help do campo */    "Informe se o cheque emitido Ç de uma conta|registrada no Contas Ö Pagar";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999",;
     /* titulo        */    "Fornecedor",;
     /* cmd especial  */    "VDBF(6,27,20,77,'FORNEC',{'codigo','razao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "PTAB(STR(codigo,04,00),'FORNEC',1)~Necess†rio informar C¢digo do Fornecedor",;
     /* help do campo */    "Informe o c¢digo do Fornecedor|F8 Tabela Pick";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "!EMPT(documen)~Necess†rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver taráos ou barras manter na digitaáÑo";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@D",;
     /* titulo        */    "Vencimento",;
     /* cmd especial  */    "VDBF(6,13,20,77,'PAGAR',{'codigo','documen','vencimento','valpagar'},3,'vencimento',[])",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "PTAB(STR(codigo,04,00)+documen+DTOS(vencimento),'PAGAR',3)~Necess†rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[codigo>1])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codbanco,02,00),'BANCOS',1)~C¢digo do Banco nÑo existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Banco/Conta|do qual ser† emitido o cheque";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "PAGAR->valpagar",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~Valor nÑo aceit†vel",;
     /* help do campo */    "Informe o valor do cheque|ou enter para aceitar o valor sugerido";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@D",;
     /* titulo        */    "EmissÑo",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao)~Necess†rio informar a data de emissÑo",;
     /* help do campo */    "Informe a data de emissÑo do cheque";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Favorecido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[N]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do Favorecido";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da AáÑo Financeira",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "M->lancmov=[S]",;
     /* validacao     */    "PTAB(STR(acao,04,00),'CONTAS',1)~Necess†rio informar C¢digo da AáÑo Financeira",;
     /* help do campo */    "Informe o C¢digo da AáÑo Financeira|[F8] Tabela";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,33,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "M->lancmov=[S]",;
     /* validacao     */    "PTAB(STR(histo,03,00),'HISTO',1)~C¢digo nÑo aceit†vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico PadrÑo|[F8] Tabela";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "M->lancmov=[S]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do Hist¢rico|se houver";
                         };
)
AADD(sistema[18,O_FORMULA],{;          // CHEQUES - Fornecedor
     /* form mostrar  */    "LEFT(TRAN(FORNEC->razao,[]),40)",;
     /* lin da formula*/    6,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // CHEQUES - cominter
     /* form mostrar  */    "LEFT(TRAN(If(inter=[S],[im],[Ño]),[]),02)",;
     /* lin da formula*/    4,;
     /* col da formula*/    31;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // CHEQUES - DescriáÑo AáÑo
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // CHEQUES - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    11;
                         };
)


sistema[19]={;
            "Configuraáîes do sistema",;                    // opcao do menu
            "Configuraáîes do sistema",;                    // titulo do sistema
            {},;                                            // chaves do arquivo
            {},;                                            // titulo dos indices para consulta
            {},;                                            // ordem campos chaves
            "PARAMET",;                                     // nome do DBF
            {},;                                            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {2,1,4,4,19,77},;                               // num telas/tela atual/coordenadas
            {3,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""};                                        // condicao de exclusao de registros
           }

AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(empresa)~Necess†rio informar a Empresa",;
     /* help do campo */    "Informar o nome da Empresa";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VCGC(cgc1)~CGC nÑo aceit†vel",;
     /* help do campo */    "Informe o cadastro geral de contribuinte";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@R 999.999",;
     /* titulo        */    "CRECI",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o numero do CRECI";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Endereáo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender1)~Necess†rio informar ENDEREÄO",;
     /* help do campo */    "Informe o endereáo da Empresa";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero1>0~N£MERO nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero da residencia ou prÇdio";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep1)~Necess†rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endereáo";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endereáo|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endereáo";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[TaubatÇ]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endereáo";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf1)~Unidade da FederaáÑo inv†lida",;
     /* help do campo */    "Informe a sigla da unidade da federaáÑo";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@R (!999)!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@R (!999)!99-9999",;
     /* titulo        */    "Fax",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do Fax";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "99.99",;
     /* titulo        */    "Multa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a % da Multa por atraso";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "999999.9999",;
     /* titulo        */    "Iptu",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o °ndice para c†lculo do IPTU";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@D",;
     /* titulo        */    "Data Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dtinicont)~Necess†rio informar DATA INICIAL",;
     /* help do campo */    "Informe a data inicial do contrato";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@D",;
     /* titulo        */    "Data Final",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dtfimcont)~Necess†rio informar DATA FINAL",;
     /* help do campo */    "Informe a data final do contrato";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "",;
     /* titulo        */    "Senha",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "Palavra=Senha()~Necess†rio informar Senha|ou Senha Incorreta",;
     /* help do campo */    "Informe o senha de liberaáÑo para o Sistema";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // PARAMET
     /* mascara       */    "@!",;
     /* titulo        */    "Operador",;
     /* cmd especial  */    "",;
     /* default       */    "[USUARIO]",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)

* \\ Final de TRI_ATR1.PRG
