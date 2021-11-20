/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Solution - Consultoria & Sistemas
 \ Programa: TRI_ESTR.PRG
 \ Data....: 15-02-97
 \ Sistema.: Triton - Controle Imobili rio
 \ Funcao..: Cria estrutura dos arquivos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "triton.ch"    // inicializa constantes manifestas

PROC PES_estr     // estrutura do arquivo PESSOA
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"tipo"      ,"C",  1, 0},; // @!
               {"codcre"    ,"N",  1, 0},; // 9
               {"rg"        ,"C", 14, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"cgc"       ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"inscr"     ,"C", 12, 0},; // @R 999.999.999.999
               {"nome"      ,"C", 35, 0},; // 
               {"profis"    ,"C", 20, 0},; // 
               {"dtnasc"    ,"D",  8, 0},; // @D
               {"nacio"     ,"C", 20, 0},; // 
               {"natu"      ,"C", 20, 0},; // 
               {"fatura"    ,"N", 15, 0},; // @E 999,999,999,999.99
               {"estcivi"   ,"C",  1, 0},; // 9
               {"regcasa"   ,"C",  1, 0},; // 9
               {"numdep"    ,"N",  2, 0},; // 99
               {"conjuge"   ,"C", 35, 0},; // 
               {"cpfconju"  ,"C", 11, 0},; // @R 999.999.999-99
               {"pai"       ,"C", 25, 0},; // 
               {"mae"       ,"C", 25, 0},; // 
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 15, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"tempo"     ,"C", 10, 0},; // 
               {"aluguel"   ,"N", 11, 2},; // @E 99,999,999.99
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"contato"   ,"C", 25, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC FIR_estr     // estrutura do arquivo FIRMA
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"empr"      ,"C", 35, 0},; // 
               {"dtadm"     ,"D",  8, 0},; // @D
               {"funcao"    ,"C", 25, 0},; // 
               {"salario"   ,"N", 11, 2},; // @E 99,999,999.99
               {"tipemp"    ,"C",  1, 0},; // 9
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"compl"     ,"C", 20, 0},; // 
               {"bairro"    ,"C", 30, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC ATI_estr     // estrutura do arquivo ATIVIDA
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"nome"      ,"C", 35, 0},; // 
               {"valor"     ,"N", 12, 2},; // @E 999,999,999.99
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"compl"     ,"C", 20, 0},; // 
               {"bairro"    ,"C", 30, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC REN_estr     // estrutura do arquivo RENDA
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"origem"    ,"C", 35, 0},; // 
               {"valor"     ,"N", 12, 2},; // @E 999,999,999.99
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC REF_estr     // estrutura do arquivo REFER
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"nome"      ,"C", 25, 0},; // 
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"compl"     ,"C", 20, 0},; // 
               {"bairro"    ,"C", 30, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"flag_excl" ,"C",  1, 0};  // !
             };
)
RETU

PROC IMO_estr     // estrutura do arquivo IMOVEIS
DBCREATE(dbf,{;
               {"pasta"     ,"N",  4, 0},; // 9999
               {"tipo"      ,"C",  1, 0},; // 9
               {"valor1"    ,"N", 15, 2},; // @E 999,999,999,999.99
               {"tipoimo"   ,"N",  2, 0},; // 99
               {"codpro"    ,"N",  8, 0},; // 99999999
               {"cadpref"   ,"C", 15, 0},; // @!
               {"escritura" ,"C", 15, 0},; // @!
               {"areater"   ,"N",  8, 2},; // 99999.99
               {"uniare"    ,"C",  3, 0},; // @!
               {"areaconst" ,"N",  8, 2},; // 99999.99
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 20, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"opcao"     ,"C",  1, 0},; // @!
               {"valor2"    ,"N", 15, 2},; // @E 999,999,999,999.99
               {"obs"       ,"M", 10, 0},; // @S40
               {"dorm"      ,"N",  2, 0},; // 99
               {"wc"        ,"N",  2, 0},; // 99
               {"lavabo"    ,"N",  2, 0},; // 99
               {"hall"      ,"N",  2, 0},; // 99
               {"escrit"    ,"N",  2, 0},; // 99
               {"suite"     ,"N",  2, 0},; // 99
               {"salatv"    ,"N",  2, 0},; // 99
               {"living"    ,"N",  2, 0},; // 99
               {"salaref"   ,"N",  2, 0},; // 99
               {"copa"      ,"N",  2, 0},; // 99
               {"cozinha"   ,"N",  2, 0},; // 99
               {"areaserv"  ,"N",  2, 0},; // 99
               {"despensa"  ,"N",  2, 0},; // 99
               {"garagem"   ,"N",  2, 0},; // 99
               {"dormemp"   ,"N",  2, 0},; // 99
               {"wcemp"     ,"N",  2, 0},; // 99
               {"rancho"    ,"N",  2, 0},; // 99
               {"ativo"     ,"C",  1, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC FOR_estr     // estrutura do arquivo FORNEC
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"tipo"      ,"C",  1, 0},; // @!
               {"rg"        ,"C", 14, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"cgc"       ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"inscr"     ,"C", 12, 0},; // @R 999.999.999.999
               {"nome"      ,"C", 35, 0},; // 
               {"profis"    ,"C", 20, 0},; // 
               {"dtnasc"    ,"D",  8, 0},; // @D
               {"nacio"     ,"C", 20, 0},; // 
               {"natu"      ,"C", 20, 0},; // 
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 15, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"ramal"     ,"C",  4, 0},; // 
               {"contato"   ,"C", 25, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC COR_estr     // estrutura do arquivo CORRETOR
DBCREATE(dbf,{;
               {"cod"       ,"N",  8, 0},; // 99999999
               {"rg"        ,"C", 14, 0},; // @!
               {"cpf"       ,"C", 11, 0},; // @R 999.999.999-99
               {"nome"      ,"C", 35, 0},; // 
               {"dtnasc"    ,"D",  8, 0},; // @D
               {"ender"     ,"C", 35, 0},; // 
               {"numero"    ,"N",  5, 0},; // 99999
               {"cep"       ,"C",  8, 0},; // @R 99999-999
               {"compl"     ,"C", 15, 0},; // 
               {"bairro"    ,"C", 20, 0},; // 
               {"cidade"    ,"C", 20, 0},; // 
               {"uf"        ,"C",  2, 0},; // !!
               {"tele"      ,"C", 12, 0},; // @R (!999)!!99-9999
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC BAN_estr     // estrutura do arquivo BANCOS
DBCREATE(dbf,{;
               {"codigo"    ,"N",  2, 0},; // 99
               {"codbanco"  ,"C",  3, 0},; // 999
               {"banco"     ,"C", 18, 0},; // @R 999-!!99-!!!!!!!!!-!!
               {"descricao" ,"C", 30, 0},; // 
               {"datmov"    ,"D",  8, 0},; // @D
               {"saldoatu"  ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"valorflag" ,"N", 15, 2},; // @E 999,999,999,999.99
               {"intlan"    ,"C",  8, 0},; // 99999999
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC ALU_estr     // estrutura do arquivo ALUGUEL
DBCREATE(dbf,{;
               {"pasta"     ,"N",  4, 0},; // 9999
               {"codigo"    ,"N",  6, 0},; // 999999
               {"codcomi"   ,"N",  1, 0},; // 9
               {"valor1"    ,"N",  9, 2},; // @E 999,999.99
               {"codi"      ,"N",  8, 0},; // 99999999
               {"codf"      ,"N",  8, 0},; // 99999999
               {"inicon"    ,"D",  8, 0},; // @D
               {"fincon"    ,"D",  8, 0},; // @D
               {"venc"      ,"N",  2, 0},; // 99
               {"antcp"     ,"C",  1, 0},; // 
               {"reaju"     ,"N",  2, 0},; // 99
               {"custos"    ,"N",  4, 0},; // 9999
               {"numrec"    ,"N",  4, 0},; // 9999
               {"datrec"    ,"D",  8, 0};  // @D
             };
)
RETU

PROC VEN_estr     // estrutura do arquivo VENDAS
DBCREATE(dbf,{;
               {"pasta"     ,"N",  4, 0},; // 9999
               {"valor1"    ,"N", 15, 2},; // @E 999,999,999,999.99
               {"dataven"   ,"D",  8, 0},; // @D
               {"comprador" ,"N",  8, 0},; // 99999999
               {"corretor"  ,"N",  8, 0},; // 99999999
               {"comven"    ,"N",  2, 0},; // 99
               {"comimo"    ,"N",  2, 0},; // 99
               {"vista"     ,"C",  1, 0},; // @!
               {"parcelas"  ,"N",  2, 0},; // 99
               {"custos"    ,"N",  4, 0};  // 9999
             };
)
RETU

PROC ARE_estr     // estrutura do arquivo ARECIBO
DBCREATE(dbf,{;
               {"sequen"    ,"N",  9, 0},; // 999999999
               {"pasta"     ,"N",  4, 0},; // 9999
               {"numrec"    ,"N",  4, 0},; // 9999
               {"per1"      ,"D",  8, 0},; // @D
               {"per2"      ,"D",  8, 0},; // @D
               {"venc"      ,"D",  8, 0},; // @D
               {"valor1"    ,"N",  9, 2},; // @E 999,999.99
               {"iptu1"     ,"N",  9, 2},; // @E 999,999.99
               {"agua"      ,"N",  9, 2},; // @E 999,999.99
               {"luz"       ,"N",  9, 2},; // @E 999,999.99
               {"telefone"  ,"N",  9, 2},; // @E 999,999.99
               {"outros"    ,"N",  9, 2},; // @E 999,999.99
               {"total"     ,"N",  9, 2},; // @E 999,999.99
               {"valor2"    ,"N",  9, 2},; // @E 999,999.99
               {"cla20"     ,"N",  9, 2},; // @E 999,999.99
               {"correc"    ,"N",  9, 2},; // @E 999,999.99
               {"total2"    ,"N",  9, 2},; // @E 999,999.99
               {"pagval"    ,"N",  9, 2},; // @E 999,999.99
               {"datpag"    ,"D",  8, 0},; // @D
               {"codalu"    ,"N",  6, 0};  // 999999
             };
)
RETU

PROC OUT_estr     // estrutura do arquivo OUTDES
DBCREATE(dbf,{;
               {"pasta"     ,"N",  4, 0},; // 9999
               {"cod"       ,"N",  9, 0},; // 999999999
               {"tipdes"    ,"N",  2, 0},; // 99
               {"valdes"    ,"N",  9, 2},; // @E 999,999.99
               {"parc"      ,"N",  2, 0},; // 99
               {"dtvenc"    ,"D",  8, 0},; // @D
               {"nome"      ,"C", 35, 0};  // 
             };
)
RETU

PROC LRE_estr     // estrutura do arquivo LRECIBO
DBCREATE(dbf,{;
               {"sequen"    ,"N",  9, 0},; // 999999999
               {"pasta"     ,"N",  4, 0},; // 9999
               {"numrec"    ,"N",  4, 0},; // 9999
               {"per1"      ,"D",  8, 0},; // @D
               {"per2"      ,"D",  8, 0},; // @D
               {"venc"      ,"D",  8, 0},; // @D
               {"valor1"    ,"N",  9, 2},; // @E 999,999.99
               {"iptu1"     ,"N",  9, 2},; // @E 999,999.99
               {"agua"      ,"N",  9, 2},; // @E 999,999.99
               {"luz"       ,"N",  9, 2},; // @E 999,999.99
               {"telefone"  ,"N",  9, 2},; // @E 999,999.99
               {"outros"    ,"N",  9, 2},; // @E 999,999.99
               {"total"     ,"N",  9, 2},; // @E 999,999.99
               {"taxa"      ,"N",  2, 0},; // 99
               {"adm"       ,"N",  9, 2},; // @E 999,999.99
               {"lprop"     ,"N",  9, 2},; // @E 999,999.99
               {"valor2"    ,"N",  9, 2},; // @E 999,999.99
               {"cla20"     ,"N",  9, 2},; // @E 999,999.99
               {"correc"    ,"N",  9, 2},; // @E 999,999.99
               {"total2"    ,"N",  9, 2},; // @E 999,999.99
               {"adm2"      ,"N",  9, 2},; // @E 999,999.99
               {"lprop2"    ,"N",  9, 2},; // @E 999,999.99
               {"pagval"    ,"N",  9, 2},; // @E 999,999.99
               {"datpag"    ,"D",  8, 0},; // @D
               {"codalu"    ,"N",  6, 0};  // 999999
             };
)
RETU

PROC MOV_estr     // estrutura do arquivo MOVIM
DBCREATE(dbf,{;
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"tipo"      ,"C",  1, 0},; // @!
               {"historico" ,"N",  3, 0},; // 999
               {"complem"   ,"C", 35, 0},; // @!
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"codlan"    ,"C", 20, 0};  // !!!-99999999-999-999
             };
)
RETU

PROC PAG_estr     // estrutura do arquivo PAGAR
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"codigo"    ,"N",  4, 0},; // 9999
               {"vencimento","D",  8, 0},; // @D
               {"valpagar"  ,"N", 15, 2},; // @E 999,999,999,999.99
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"historico" ,"N",  3, 0},; // 999
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"parcelas"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"datapago"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC REC_estr     // estrutura do arquivo RECEBER
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"data"      ,"D",  8, 0},; // @D
               {"documen"   ,"C", 15, 0},; // @!
               {"codigo"    ,"N",  8, 0},; // 99999999
               {"vencimento","D",  8, 0},; // @D
               {"valpagar"  ,"N", 15, 2},; // @E 999,999,999,999.99
               {"contas"    ,"N",  4, 0},; // 9999
               {"banco"     ,"N",  2, 0},; // 99
               {"historico" ,"N",  3, 0},; // 999
               {"custo"     ,"N",  4, 0},; // 9999
               {"obs"       ,"C", 50, 0},; // 
               {"parcelas"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"datapago"  ,"D",  8, 0};  // @D
             };
)
RETU

PROC CHE_estr     // estrutura do arquivo CHEQUES
DBCREATE(dbf,{;
               {"seque"     ,"N", 10, 0},; // 9999999999
               {"inter"     ,"C",  1, 0},; // @!
               {"codigo"    ,"N",  4, 0},; // 9999
               {"documen"   ,"C", 15, 0},; // @!
               {"vencimento","D",  8, 0},; // @D
               {"codbanco"  ,"N",  2, 0},; // 99
               {"valor"     ,"N", 15, 2},; // @E 999,999,999,999.99
               {"emissao"   ,"D",  8, 0},; // @D
               {"favorecido","C", 40, 0},; // @!
               {"acao"      ,"N",  4, 0},; // 9999
               {"histo"     ,"N",  3, 0},; // 999
               {"complem"   ,"C", 35, 0};  // @!
             };
)
RETU

PROC PAR_estr     // estrutura do arquivo PARAMET
DBCREATE(dbf,{;
               {"empresa"   ,"C", 35, 0},; // 
               {"cgc1"      ,"C", 14, 0},; // @R 99.999.999/9999-99
               {"creci"     ,"C",  6, 0},; // @R 999.999
               {"ender1"    ,"C", 35, 0},; // 
               {"numero1"   ,"N",  5, 0},; // 99999
               {"cep1"      ,"C",  8, 0},; // @R 99999-999
               {"compl1"    ,"C", 15, 0},; // 
               {"bairro1"   ,"C", 20, 0},; // 
               {"cidade1"   ,"C", 20, 0},; // 
               {"uf1"       ,"C",  2, 0},; // !!
               {"tele1"     ,"C", 11, 0},; // @R (!999)!99-9999
               {"fax1"      ,"C", 11, 0},; // @R (!999)!99-9999
               {"multa"     ,"N",  5, 2},; // 99.99
               {"iptu"      ,"N", 11, 4},; // 999999.9999
               {"dtinicont" ,"D",  8, 0},; // @D
               {"dtfimcont" ,"D",  8, 0},; // @D
               {"palavra"   ,"C", 20, 0},; // 
               {"operador"  ,"C", 15, 0};  // @!
             };
)
RETU

PROC COM_estr     // estrutura do arquivo COMISSAO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  1, 0},; // 9
               {"comissao"  ,"N",  2, 0};  // 99
             };
)
RETU

PROC TIP_estr     // estrutura do arquivo TIPOIMO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  2, 0},; // 99
               {"tipoimo"   ,"C", 15, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC DES_estr     // estrutura do arquivo DESPE
DBCREATE(dbf,{;
               {"codigo"    ,"N",  2, 0},; // 99
               {"tipodesp"  ,"C", 15, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CON_estr     // estrutura do arquivo CONTAS
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"descricao" ,"C", 30, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC HIS_estr     // estrutura do arquivo HISTO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  3, 0},; // 999
               {"descri"    ,"C", 35, 0},; // 
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CRE_estr     // estrutura do arquivo CREDITO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  1, 0},; // 9
               {"tipo"      ,"C", 15, 0},; // @!
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC CUS_estr     // estrutura do arquivo CUSTO
DBCREATE(dbf,{;
               {"codigo"    ,"N",  4, 0},; // 9999
               {"departa"   ,"C", 35, 0},; // 
               {"receita"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"despesa"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"receber"   ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"recebvenc" ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"pagar"     ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"pagovenc"  ,"N", 15, 2},; // @E@X@C 999,999,999,999.99
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

PROC TIC_estr     // estrutura do arquivo TICHEQUE
DBCREATE(dbf,{;
               {"nubanco"   ,"C",  3, 0},; // 999
               {"colval"    ,"N",  3, 0},; // 999
               {"linval"    ,"N",  3, 0},; // 999
               {"colext"    ,"N",  3, 0},; // 999
               {"linext"    ,"N",  3, 0},; // 999
               {"colord"    ,"N",  3, 0},; // 999
               {"linord"    ,"N",  3, 0},; // 999
               {"colcid"    ,"N",  3, 0},; // 999
               {"colmes"    ,"N",  3, 0},; // 999
               {"colano"    ,"N",  3, 0},; // 999
               {"lincid"    ,"N",  3, 0},; // 999
               {"intref"    ,"N",  8, 0};  // 99999999
             };
)
RETU

* \\ Final de TRI_ESTR.PRG
