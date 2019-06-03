//************************************************************************************
  {
     unit:   PGWLib
     Classe: TPGWLib

     Data de cria��o  : 20/05/2019
     Autor            :
     Descri��o        : Classe contendo Todos os Metodos de Operabilidade
   }
//************************************************************************************
unit uPGWLib;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.StrUtils, system.AnsiStrings,
  Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Types, System.TypInfo,uEnums, uLib;



Type


  //========================================================
  // Record que descreve cada membro da estrutura PW_GetData:
  //========================================================
     TPW_GetData = record
          wIdentificador : Word;
          bTipoDeDado : Byte;
          szPrompt: Array[0..83] of AnsiChar;
          bNumOpcoesMenu: Byte;
          vszTextoMenu: Array[0..39] of Array[0..40] of AnsiChar;
          vszValorMenu: Array[0..39] of Array[0..255] of AnsiChar;
          szMascaraDeCaptura: Array[0..40] of AnsiChar;
          bTiposEntradaPermitidos: Byte;
          bTamanhoMinimo: Byte;
          bTamanhoMaximo: Byte;
          ulValorMinimo : UInt32;
          ulValorMaximo : UInt32;
          bOcultarDadosDigitados: Byte;
          bValidacaoDado: Byte;
          bAceitaNulo: Byte;
          szValorInicial: Array[0..40] of AnsiChar;
          bTeclasDeAtalho: Byte;
          szMsgValidacao: Array[0..83] of AnsiChar;
          szMsgConfirmacao: Array[0..83] of AnsiChar;
          szMsgDadoMaior: Array[0..83] of AnsiChar;
          szMsgDadoMenor: Array[0..83] of AnsiChar;
          bCapturarDataVencCartao: Byte;
          ulTipoEntradaCartao: UInt32;
          bItemInicial: Byte;
          bNumeroCapturas: Byte;
          szMsgPrevia: Array[0..83] of AnsiChar;
          bTipoEntradaCodigoBarras: Byte;
          bOmiteMsgAlerta: Byte;
          bIniciaPelaEsquerda: Byte;
          bNotificarCancelamento: Byte;
          bAlinhaPelaDireita: Byte;
       end;

       PW_GetData = Array[0..10] of TPW_GetData;


       // Retorno de GetResult
       TPZ_GetData = record
            pszDataxx: Array[0..10000] of AnsiChar;
       end;

       PSZ_GetData = Array[0..0] of TPZ_GetData;


       // Tempor�rio
       TPZ_GetDisplay = record
            szDspMsg: Array[0..127] of AnsiChar;
            szAux:    Array[0..1023] of AnsiChar;
            szMsgPinPad: Array[0..33] of AnsiChar;
       end;

       PSZ_GetDisplay = Array[0..100] of TPZ_GetDisplay;


  //====================================================================
  // Estrutura para armazenamento de dados para Tipos de Opera��o
  //====================================================================
     TPW_Operations = record
         bOperType: Byte;
         szText: Array[0..21] of char;
         szValue: Array[0..21] of char;
     end;

     PW_Operations = Array[0..9] of TPW_Operations;


 //====================================================================
 // Estrutura para armazenamento de dados para confirma��o de transa��o
 //====================================================================
    TConfirmaData = record
        szReqNum: Array[0..10] of AnsiChar;
        szExtRef: Array[0..50] of AnsiChar;
        szLocRef: Array[0..50] of AnsiChar;
        szVirtMerch: Array[0..18] of AnsiChar;
        szAuthSyst: Array[0..20] of AnsiChar;
    end;

   ConfirmaData = Array[0..0] of TConfirmaData;




  TPGWLib = class
  //private
    { private declarations }
  protected
    { protected declarations }
  public

    constructor Create;
    Destructor  Destroy; Override; // declara��o do metodo destrutor

    procedure GetVersao;

    function Count: Integer;

    function Init:Integer;

    function TestaInit(iparam:Integer):Integer;

    function Instalacao:Integer;

    function venda:Integer;

    function iExecGetData(vstGetData:PW_GetData; iNumParam:Integer):Integer;

    function ConfirmaTrasacao:integer;

    function GetParamConfirma:Integer;

    function GetParamPendenteConfirma:Integer;

    function PrintReturnDescription(iReturnCode:Integer; pszDspMsg:string):Integer;

    function PrintResultParams:Integer;

    function pszGetInfoDescription(wIdentificador:Integer):string;

    function Cancelamento:Integer;

    function Reimpressao:Integer;

    function Relatorios:Integer;

    function Admin:Integer;

    function MandaMemo(Descr:string):integer;

    //function ExecTransac:Integer;



  end;


  Const


    // Auxiliar para testes
    PWINFO_AUTHMNGTUSER = '314159';
    PWINFO_POSID  = '60376';
    PWINFO_MERCHCNPJCPF = '20726059000179';
    PWINFO_DESTTCPIP = 'app.tpgw.ntk.com.br:17502';
    PWINFO_USINGPINPAD = '1';
    PWINFO_PPCOMMPORT = '0';







  //=====================================================================================*/
  //  Fun��o Auxiliar
  //=====================================================================================*/
    function tbKeyIsDown(const Key: Integer):Boolean;

  //=====================================================================================*/
  // Parametros que devem ser informados obrigatoriamente a cada transa��o
  //=====================================================================================*/
    procedure AddMandatoryParams;


  //========================================================================================================================================
    { Esta fun��o � utilizada para inicializar a biblioteca, e retorna imediatamente.
     Deve ser garantido que uma chamada dela retorne PWRET_OK antes de chamar qualquer outra fun��o.

         Entradas:
         pszWorkingDir Diret�rio de trabalho (caminho completo, com final nulo) para uso exclusivo do Pay&Go Web

         Sa�das: Nenhuma.

        Retorno: PWRET_OK .................................. Opera��o bem sucedida.
                 PWRET_WRITERR ....................... Falha de grava��o no diret�rio informado.
                 PWRET_INVCALL ......................... J� foi efetuada uma chamada � fun��o PW_iInit ap�s o carregamento da biblioteca.
                 Outro ..................................Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 78 do Manual).
                                                       Uma mensagem de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
    }
  //============================================================================================================================================
    function PW_iInit(pszWorkingDir:AnsiString):SmallInt; StdCall; External 'PGWebLib.dll';



  //=============================================================================================================================================
    { Esta fun��o deve ser chamada para iniciar uma nova transa��o atrav�s do Pay&Go Web, e retorna imediatamente.

     Entradas:
     iOper Tipo de transa��o a ser realizada (PWOPER_xxx, conforme tabela).

     Sa�das: Nenhuma

     Retorno:
               PWRET_OK .................................. Transa��o inicializada.
               PWRET_DLLNOTINIT ................... N�o foi executado PW_iInit.
               PWRET_NOTINST ........................ � necess�rio efetuar uma transa��o de Instala��o.
               Outro ................................ Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 78 Manual).
                                                      Uma mensagem de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
    }
  //==============================================================================================================================================
    function PW_iNewTransac(iOper:byte):SmallInt; StdCall; External 'PGWebLib.dll';


  //=============================================================================================================================================
    {  Esta fun��o � utilizada para alimentar a biblioteca com as informa��es da transa��o a ser realizada,
      e retorna imediatamente. Estas informa��es podem ser:
        - Pr�-fixadas na Automa��o;
        - Capturadas do operador pela Automa��o antes do acionamento do Pay&Go Web;
        - Capturadas do operador ap�s solicita��o pelo Pay&Go Web (retorno PW_MOREDATA por PW_iExecTransac).


       Entradas:
       wParam Identificador do par�metro (PWINFO_xxx, ver lista completa em �9. Dicion�rio de dados�, p�gina 72).
       pszValue Valor do par�metro (string ASCII com final nulo).

     Sa�das: Nenhuma

     Retorno:
               PWRET_OK .................................. Parametro Acrescentado com sucesso.
               PWRET_INVPARAM .................... O valor do par�metro � inv�lido
               PWRET_DLLNOTINIT ................... N�o foi executado PW_iInit
               PWRET_TRNNOTINIT .................. N�o foi executado PW_iNewTransac (ver p�gina 14).
               PWRET_NOTINST ........................ � necess�rio efetuar uma transa��o de Instala��o
               Outro ........................................... Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 78). Uma
                                                                 mensagem de erro pode ser obtida atrav�s da fun��o PW_iGetResult
                                                                 (PWINFO_RESULTMSG).
     }
  //==============================================================================================================================================
    function PW_iAddParam(wParam:SmallInt; szValue:AnsiString):Int16; StdCall; External 'PGWebLib.dll';


//=============================================================================================================================================
  {  Esta fun��o tenta realizar uma transa��o atrav�s do Pay&Go Web, utilizando os par�metros
    previamente definidos atrav�s de PW_iAddParam. Caso algum dado adicional precise ser informado,
    o retorno ser� PWRET_MOREDATA e o par�metro pvstParam retornar� informa��es dos dados que
    ainda devem ser capturados.

    Esta fun��o, por se comunicar com a infraestrutura Pay&Go Web, pode demorar alguns segundos
    para retornar.


    Entradas:
      piNumParam Quantidade m�xima de dados que podem ser capturados de uma vez, caso o retorno
      seja PW_MOREDATA. (Deve refletir o tamanho da �rea de mem�ria apontada por
      pvstParam.) Valor sugerido: 9.

    Sa�das:
      pvstParam  Lista e caracter�sticas dos dados que precisam ser informados para executar a transa��o.
      Consultar �8.Captura de dados� (p�gina 65) para a descri��o da estrutura
      e instru��es para a captura de dados adicionais. piNumParam Quantidade de dados adicionais que precisam ser capturados
      (quantidade de ocorr�ncias preenchidas em pvstParam

      Retorno:
          PWRET_OK .................................. Transa��o realizada com sucesso. Os resultados da transa��o devem ser obtidos atrav�s da fun��o PW_iGetResult.
          PWRET_NOTHING ....................... Nada a fazer, fazer as valida��es locais necess�rias e chamar a fun��o PW_iExecTransac novamente.
          PWRET_MOREDATA ................... Mais dados s�o requeridos para executar a transa��o.
          PWRET_DLLNOTINIT ................... N�o foi executado PW_iInit.
          PWRET_TRNNOTINIT .................. N�o foi executado PW_iNewTransac (ver p�gina 14).
          PWRET_NOTINST ........................ � necess�rio efetuar uma transa��o de Instala��o.
          PWRET_NOMANDATORY ........... Algum dos par�metros obrigat�rios n�o foi adicionado (ver p�gina 17).
          Outro ........................................... Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 78 Manual).
                                                            Uma mensagem de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=============================================================================================================================================
  function PW_iExecTransac(var pvstParam: PW_GetData; piNumParam : pointer) : Int16; stdCall; External 'PGWebLib.dll';




//=========================================================================================================*\
  {  Funcao     :  PW_iGetResult

     Descricao  :  Esta fun��o pode ser chamada para obter informa��es que resultaram da transa��o efetuada,
                   independentemente de ter sido bem ou mal sucedida, e retorna imediatamente.

     Entradas   :  iInfo:	   C�digo da informa��o solicitada sendo requisitada (PWINFO_xxx, ver lista completa
                               em �9. Dicion�rio de dados�, p�gina 36).
                   ulDataSize:	Tamanho (em bytes) da �rea de mem�ria apontada por pszData. Prever um tamanho maior
                               que o m�ximo previsto para o dado solicitado.


     Saidas     :  pszData:	   Valor da informa��o solicitada (string ASCII com terminador nulo).

     Retorno    :  PWRET_OK	         Sucesso. pszData cont�m o valor solicitado.
                   PWRET_NODATA	   A informa��o solicitada n�o est� dispon�vel.
                   PWRET_BUFOVFLW 	O valor da informa��o solicitada n�o cabe em pszData.
                   PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                   PWRET_TRNNOTINIT	N�o foi executado PW_iNewTransac (ver p�gina 10).
                   PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
                   Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                     de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
  }
//=========================================================================================================*/
  function PW_iGetResult(iInfo:Int16; var pszData: PSZ_GetData;   ulDataSize: UInt32):Int16; StdCall; External 'PGWebLib.dll';
  //function PW_iGetResult(iInfo:Int16; var pszData: PSZ_GetData;   ulDataSize: UInt32):Int16; StdCall; External 'PGWebLib.dll';


//=========================================================================================================
{
 Funcao     :  PW_iConfirmation

 Descricao  :  Esta fun��o informa ao Pay&Go Web o status final da transa��o em curso (confirmada ou desfeita).
               Consultar �7. Confirma��o de transa��o� (p�gina 28) para informa��es adicionais.

 Entradas   :  ulStatus:   	Resultado da transa��o (PWCNF_xxx, ver lista abaixo).
               pszReqNum:  	Refer�ncia local da transa��o, obtida atrav�s de PW_iGetResult (PWINFO_REQNUM).
               pszLocRef:  	Refer�ncia da transa��o para a infraestrutura Pay&Go Web, obtida atrav�s de PW_iGetResult (PWINFO_AUTLOCREF).
               pszExtRef:  	Refer�ncia da transa��o para o Provedor, obtida atrav�s de PW_iGetResult (PWINFO_AUTEXTREF).
               pszVirtMerch:	Identificador do Estabelecimento, obtido atrav�s de PW_iGetResult (PWINFO_VIRTMERCH).
               pszAuthSyst:   Nome do Provedor, obtido atrav�s de PW_iGetResult (PWINFO_AUTHSYST).

 Saidas     :  n�o h�.

 Retorno    :  PWRET_OK	         O status da transa��o foi atualizado com sucesso.
               PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
               PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
               Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                 de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
}
//=========================================================================================================
  function PW_iConfirmation(ulResult:Uint32; pszReqNum: AnsiString; pszLocRef:AnsiString ; pszExtRef:AnsiString;
                                             pszVirtMerch:AnsiString; pszAuthSyst:AnsiString):Int16; StdCall; External 'PGWebLib.dll';


//=========================================================================================================*\
{   Funcao     :  PW_iIdleProc

    Descricao  :  Para o correto funcionamento do sistema, a biblioteca do Pay&Go Web precisa de tempos em tempos
                  executar tarefas autom�ticas enquanto n�o est� realizando nenhuma transa��o a pedido da Automa��o.

    Entradas   :  n�o h�.

    Saidas     :  n�o h�.

    Retorno    :  PWRET_OK	         Opera��o realizada com �xito.
                  PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                  PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
                  Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                    de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
}
//=========================================================================================================*/
  function PW_iIdleProc():Int16; StdCall; External 'PGWebLib.dll';




//=========================================================================================================
{
 Funcao     :  PW_iGetOperations

 Descricao  :  Esta fun��o pode ser chamada para obter quais opera��es o Pay&Go WEB disponibiliza no momento,
               sejam elas administrativas, de venda ou ambas.

 Entradas   :              bOperType	      Soma dos tipos de opera��o a serem inclu�dos na estrutura de
                                             retorno (PWOPTYPE_xxx).
                           piNumOperations	N�mero m�ximo de opera��es que pode ser retornado. (Deve refletir
                                             o tamanho da �rea de mem�ria apontada por pvstOperations).

 Sa�das     :              piNumOperations	N�mero de opera��es dispon�veis no Pay&Go WEB.
                           vstOperations	   Lista das opera��es dispon�veis e suas caracter�sticas.


 Retorno    :  PWRET_OK	         Opera��o realizada com �xito.
               PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
               PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
               Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                 de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
}
//=========================================================================================================
  function PW_iGetOperations(bOperType:Byte; var vstOperatios: PW_Operations; piNumOperations:Int16):Int16; StdCall; External 'PGWebLib.dll';


//=========================================================================================================*\
  { Funcao     :  PW_iPPAbort

   Descricao  :  Esta fun��o pode ser utilizada pela Automa��o para interromper uma captura de dados no PIN-pad
                 em curso, e retorna imediatamente.

   Entradas   :  n�o h�.

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Opera��o interrompida com sucesso.
                 PWRET_PPCOMERR	   Falha na comunica��o com o PIN-pad.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPAbort():Int16; StdCall; External 'PGWebLib.dll';




//=========================================================================================================*\
  { Funcao     :  PW_iPPEventLoop

   Descricao  :  Esta fun��o dever� ser chamada em �loop� at� que seja retornado PWRET_OK (ou um erro fatal). Nesse
                 �loop�, caso o retorno seja PWRET_DISPLAY o ponto de captura dever� atualizar o �display� com as
                 mensagens recebidas da biblioteca.

   Entradas   :  ulDisplaySize	Tamanho (em bytes) da �rea de mem�ria apontada por pszDisplay.
                                Tamanho m�nimo recomendado: 100 bytes.

   Saidas     :  pszDisplay	   Caso o retorno da fun��o seja PWRET_DISPLAY, cont�m uma mensagem de texto
                                (string ASCII com terminal nulo) a ser apresentada pela Automa��o na interface com
                                o usu�rio principal. Para o formato desta mensagem, consultar �4.3.Interface com o
                                usu�rio�, p�gina 8.

   Retorno    :  PWRET_NOTHING	   Nada a fazer, continuar aguardando o processamento do PIN-pad.
                 PWRET_DISPLAY	   Apresentar a mensagem recebida em pszDisplay e continuar aguardando o processamento do PIN-pad.
                 PWRET_OK	         Captura de dados realizada com �xito, prosseguir com a transa��o.
                 PWRET_CANCEL	   A opera��o foi cancelada pelo Cliente no PIN-pad (tecla [CANCEL]).
                 PWRET_TIMEOUT	   O Cliente n�o realizou a captura no tempo limite.
                 PWRET_FALLBACK	   Ocorreu um erro na leitura do cart�o, passar a aceitar a digita��o do n�mero do cart�o, caso j� n�o esteja aceitando.
                 PWRET_PPCOMERR	   Falha na comunica��o com o PIN-pad.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 PWRET_INVCALL	   N�o h� captura de dados no PIN-pad em curso.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPEventLoop(var pszDisplay; ulDisplaySize:UInt32):Int16; StdCall; External 'PGWebLib.dll';

//=========================================================================================================*\
  { Funcao     :  PW_iPPGetCard

   Descricao  :  Esta fun��o � utilizada para realizar a leitura de um cart�o (magn�tico, com chip com contato,
                 ou sem contato) no PIN-pad.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPGetCard(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPGetPIN

   Descricao  :  Esta fun��o � utilizada para realizar a captura no PIN-pad da senha (ou outro dado criptografado)
                 do Cliente.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPGetPIN(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPGetData

   Descricao  :  Esta fun��o � utilizada para fazer a captura no PIN-pad de um dado n�o sens�vel do Cliente..

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  nao ha.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPGetData(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';




//=========================================================================================================*\
  { Funcao     :  PW_iPPGoOnChip

   Descricao  :  Esta fun��o � utilizada para realizar o processamento off-line (antes da comunica��o com o Provedor)
                 de um cart�o com chip no PIN-pad.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPGoOnChip(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPFinishChip

   Descricao  :  Esta fun��o � utilizada para finalizar o processamento on-line (ap�s comunica��o com o Provedor)
                 de um cart�o com chip no PIN-pad.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPFinishChip(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';




//=========================================================================================================*\
  { Funcao     :  PW_iPPConfirmData

   Descricao  :  Esta fun��o � utilizada para obter do Cliente a confirma��o de uma informa��o no PIN-pad.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPConfirmData(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPRemoveCard

   Descricao  :  Esta fun��o � utilizada para fazer uma remo��o de cart�o do PIN-pad.

   Entradas   :  n�o h�.

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_INVPARAM	   O valor de uiIndex informado n�o corresponde a uma captura de dados deste tipo.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPRemoveCard():Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPDisplay

   Descricao  :  Esta fun��o � utilizada para apresentar uma mensagem no PIN-pad

   Entradas   :  pszMsg   Mensagem a ser apresentada no PIN-pad. O caractere �\r� (0Dh) indica uma quebra de linha.

   Saidas     :  n�o h�.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPDisplay(const pszMsg:Char):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iPPWaitEvent

   Descricao  :  Esta fun��o � utilizada para aguardar a ocorr�ncia de um evento no PIN-pad.

   Entradas   :  n�o h�.

   Saidas     :  pulEvent	         Evento ocorrido.

   Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPWaitEvent(pulEvent:UInt32):Int16; StdCall; External 'PGWebLib.dll';




//===========================================================================*\
  { Funcao   : PW_iPPGenericCMD

   Descricao  :  Realiza comando gen�rico de PIN-pad.

   Entradas   :  uiIndex	�ndice (iniciado em 0) do dado solicitado na �ltima execu��o de PW_iExecTransac
                          (�ndice do dado no vetor pvstParam).

   Saidas     :  N�o h�.

   Retorno    :  PWRET_xxx.
   }
//===========================================================================*/
  function PW_iPPGenericCMD(uiIndex:UInt16):Int16; StdCall; External 'PGWebLib.dll';



//===========================================================================*\
  { Funcao     : PW_iTransactionInquiry

   Descricao  :  Esta fun��o � utilizada para realizar uma consulta de transa��es
                 efetuadas por um ponto de captura junto ao Pay&Go WEB.

   Entradas   :  pszXmlRequest	Arquivo de entrada no formato XML, contendo as informa��es
                                necess�rias para fazer a consulta pretendida.
                 ulXmlResponseLen Tamanho da string pszXmlResponse.

   Saidas     :  pszXmlResponse	Arquivo de sa�da no formato XML, contendo o resultado da consulta
                                efetuada, o arquivo de sa�da tem todos os elementos do arquivo de entrada.

   Retorno    :  PWRET_xxx.
   }
//===========================================================================*/
  function PW_iTransactionInquiry (const pszXmlRequest:Char; pszXmlResponse:Char; ulXmlResponseLen:UInt32):Int16; StdCall; External 'PGWebLib.dll';



//=========================================================================================================*\
  { Funcao     :  PW_iGetUserData

   Descricao  :  Esta fun��o � utilizada para obter um dado digitado pelo portador do cart�o no PIN-pad.

   Entradas   :  uiMessageId : Identificador da mensagem a ser exibida como prompt para a captura.
                 bMinLen     : Tamanho m�nimo do dado a ser digitado.
                 bMaxLen     : Tamanho m�ximo do dado a ser digitado.
                 iToutSec    : Tempo limite para a digita��o do dado em segundos.

   Sa�das     :  pszData     : Dado digitado pelo portador do cart�o no PIN-pad.

   Retorno    :  PWRET_OK	         Opera��o realizada com �xito.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
                 PWRET_CANCEL	   A opera��o foi cancelada pelo Cliente no PIN-pad (tecla [CANCEL]).
                 PWRET_TIMEOUT	   O Cliente n�o realizou a captura no tempo limite.
                 PWRET_PPCOMERR	   Falha na comunica��o com o PIN-pad.
                 PWRET_INVCALL	   N�o � poss�vel capturar dados em um PIN-pad n�o ABECS.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40). Uma mensagem
                                   de erro pode ser obtida atrav�s da fun��o PW_iGetResult (PWINFO_RESULTMSG).
   }
//=========================================================================================================*/
  function PW_iPPGetUserData(uiMessageId:UInt16; bMinLen:Byte; bMaxLen:Byte; iToutSec:Int16; pszData:Char):Int16; StdCall; External 'PGWebLib.dll';




//=========================================================================================================*\
  { Funcao     :  PW_iPPGetPINBlock

   Descricao  :  Esta fun��o � utilizada para obter o PIN block gerado a partir de um dado digitado pelo usu�rio no PIN-pad.

   Entradas   :  bKeyID	      : �ndice da Master Key (para chave PayGo, utilizar o �ndice �12�).
                 pszWorkingKey	: Sequ�ncia 32 caracteres utilizados para a gera��o do PIN block (dois valores iguais digitados pelo usu�rio com duas pszWorkingKey diferentes ir�o gerar dois PIN block diferentes.
                 bMinLen	      : Tamanho m�nimo do dado a ser digitado (a partir de 4).
                 bMaxLen     	: Tamanho m�ximo do dado a ser digitado.
                 iToutSec    	: Tempo limite para a digita��o do dado em segundos.
                 pszPrompt	   : Mensagem de 32 caracteres (2 linhas com 16 colunas) para apresenta��o no momento do pedido do dado do usu�rio.


   Sa�das     :  pszData        : PIN block gerado com base nos dados fornecidos na fun��o combinados com o dado digitado pelo usu�rio no PIN-pad.

   Retorno    :  PWRET_OK	         Opera��o realizada com �xito.
                 PWRET_DLLNOTINIT	N�o foi executado PW_iInit.
                 PWRET_NOTINST	   � necess�rio efetuar uma transa��o de Instala��o.
                 PWRET_CANCEL	   A opera��o foi cancelada pelo Cliente no PIN-pad (tecla [CANCEL]).
                 PWRET_TIMEOUT	   O Cliente n�o realizou a captura no tempo limite.
                 PWRET_PPCOMERR	   Falha na comunica��o com o PIN-pad.
                 Outro	            Outro erro de execu��o (ver �10. C�digos de retorno�, p�gina 40).
   }
//=========================================================================================================*/
  function PW_iPPGetPINBlock(bKeyID:Byte; const pszWorkingKey:Char; bMinLen:Byte;
                                    bMaxLen:Byte; iToutSec:Int16; const pszPrompt:Char; pszData:Char):Int16; StdCall; External 'PGWebLib.dll';


//  end;




  //published
    { published declarations }
  //end;



implementation


uses Principal;


  var

    xpszData: Array[0..20] of char;
    iRetorno: SmallInt;
    PWRET_OK: SmallInt;
    vGetdataArray : PW_GetData;
    vstGetData : PW_GetData;
    vGetpszData : PSZ_GetData;
    vGetpszErro : PSZ_GetData;

    vGetpszDisplay : PSZ_GetDisplay;
   	xNumParam : int16;
    xSzValue: AnsiString;
    pvstParam:PW_GetData;


    gstConfirmData: ConfirmaData;


{    gstConfirmDataR: ConfirmaDataR;
    gstConfirmDataE: ConfirmaDataE;
    gstConfirmDataL: ConfirmaDataL;
    gstConfirmDataV: ConfirmaDataV;
    gstConfirmDataA: ConfirmaDataA;
}


    iNumParam: Int16;
    iRet: Int16;


    PWEnums : TCEnums;




//============================================================================
  {
    Busca Parametros para confirma��o automatica da Ultima Transa��o de Venda.
  }
//============================================================================
function TPGWLib.GetParamConfirma: Integer;
var
  I:Integer;

begin

      iRetorno := PW_iGetResult(PWEnums.PWINFO_REQNUM, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to  SizeOf(gstConfirmData[0].szReqNum) do
        begin
          gstConfirmData[0].szReqNum[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_AUTEXTREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szExtRef) do
        begin
          gstConfirmData[0].szExtRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_AUTLOCREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szLocRef) do
        begin
          gstConfirmData[0].szLocRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_VIRTMERCH, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szVirtMerch) do
        begin
          gstConfirmData[0].szVirtMerch[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_AUTHSYST, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szAuthSyst) do
        begin
          gstConfirmData[0].szAuthSyst[I] := vGetpszData[0].pszDataxx[I];
        end;


      Result := iRetorno;


end;


//============================================================================
  {
    Busca Parametros para confirma��o automatica da Ultima Transa��o de Venda.
  }
//============================================================================
function TPGWLib.GetParamPendenteConfirma: Integer;
var
  I:Integer;

begin

      iRetorno := PW_iGetResult(PWEnums.PWINFO_PNDREQNUM, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to  SizeOf(gstConfirmData[0].szReqNum) do
        begin
          gstConfirmData[0].szReqNum[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_PNDAUTEXTREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szExtRef) do
        begin
          gstConfirmData[0].szExtRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_PNDAUTLOCREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szLocRef) do
        begin
          gstConfirmData[0].szLocRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_PNDVIRTMERCH, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szVirtMerch) do
        begin
          gstConfirmData[0].szVirtMerch[I] := vGetpszData[0].pszDataxx[I];
        end;

      iRetorno := PW_iGetResult(PWEnums.PWINFO_PNDAUTHSYST, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szAuthSyst) do
        begin
          gstConfirmData[0].szAuthSyst[I] := vGetpszData[0].pszDataxx[I];
        end;


      Result := iRetorno;


end;


procedure  TPGWLib.GetVersao();
var
    iParam : Int16;
    Volta : String;
    vRetorno: Integer;
    winfo:Integer;
    wvolta: PChar;
    wxyvolta : string;
    xNumParam : integer;
    Wretornaerro: PSZ_GetData;
begin







    PPrincipal.Memo1.Lines.Clear;
    PPrincipal.Memo1.Visible := False;



    xNumParam := 10;

    //AddMandatoryParams();
    winfo := PWEnums.PWINFO_RESULTMSG;

    // Nova Transa��o para PWOPER_VERSION
    iparam := PW_iNewTransac(PWEnums.PWOPER_VERSION);

    // Executa Transa��o
    vRetorno := PW_iExecTransac(vGetdataArray, @xNumParam);


    //winfo := PWEnums.PWINFO_SERVERPND;
    //iRet := PW_iGetResult(winfo, vGetpszData, SizeOf(vGetpszData));
    //iRet := PW_iGetResult(PWEnums.PWINFO_SERVERPND, vGetpszErro, SizeOf(vGetpszErro));


    //PrintResultParams();



    // Captura Informa��o
    iRet := PW_iGetResult(winfo, vGetpszData, SizeOf(vGetpszData));
    wxyvolta := vGetpszData[0].pszDataxx;
    Application.MessageBox(PChar(wxyvolta),'Vers�o da DLL',mb_OK+mb_IconInformation);

    PPrincipal.Label1.Visible := False;
    Application.ProcessMessages;



end;



{ TPGWLib }




//=====================================================================================
  {
      Administrativo
  }
//=====================================================================================
function TPGWLib.Admin: Integer;
  var
      iParam : Integer;
      Volta : String;
      iRet:Integer;
      iRetI: Integer;
      iRetErro : integer;
      strNome : String;
      I:Integer;
      xloop:integer;
      voltaA:AnsiChar;
begin


        I := 0;

        iRet := PW_iNewTransac(PWEnums.PWOPER_ADMIN);

        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);
            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin


                   // Guardar Informa��es para Confirma��o e Mostrar no finanl da transa��o:

                      {
                      GetParamConfirma();

                      ShowMessage('ReqNum: ' + gstConfirmData[0].szReqNum);
                      ShowMessage('Extref: ' + gstConfirmData[0].szExtRef);
                      ShowMessage('Locref: ' + gstConfirmData[0].szLocRef);
                      ShowMessage('VirtMerch: ' + gstConfirmData[0].szVirtMerch);
                      ShowMessage('AuthSyst: ' + gstConfirmData[0].szAuthSyst);
                      }



                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end
                  else
                    begin
                      Break;
                    end;

              end;


        end;


end;


//=====================================================================================
  {

      Cancelamento


  }
//=====================================================================================
function TPGWLib.Cancelamento: Integer;
  var
      iParam : Integer;
      Volta : String;
      iRet:Integer;
      iRetI: Integer;
      iRetErro : integer;
      strNome : String;
      I:Integer;
      xloop:integer;
      voltaA:AnsiChar;

  begin

        I := 0;

        iRet := PW_iNewTransac(PWEnums.PWOPER_SALEVOID);

        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);
            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin

                   // Guardar Informa��es para Confirma��o e Mostrar no final da transa��o:
                      {
                      GetParamConfirma();

                      ShowMessage('ReqNum: ' + gstConfirmData[0].szReqNum);
                      ShowMessage('Extref: ' + gstConfirmData[0].szExtRef);
                      ShowMessage('Locref: ' + gstConfirmData[0].szLocRef);
                      ShowMessage('VirtMerch: ' + gstConfirmData[0].szVirtMerch);
                      ShowMessage('AuthSyst: ' + gstConfirmData[0].szAuthSyst);
                      }

                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end;


                  if iRet <> PWEnums.PWRET_OK then
                     begin

                        if (PPrincipal.Memo1.Visible = False) then
                           begin
                             PPrincipal.Memo1.Visible := True;
                           end;
                             PPrincipal.Memo1.Lines.Add('Erro : ...' + IntToStr(iRet));
                             PPrincipal.Memo1.Lines.Add(' ');

                             Exit;

                     end;


                  if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                      begin
                          // Busca Parametros da Transa��o Pendente
                          GetParamPendenteConfirma();
                      end
                  else
                      begin
                          // Busca Parametros da Transa��o Atual
                          GetParamConfirma();
                      end;


                  // Busca necessidade de Confirma��o.
                  iRet := PW_iGetResult(PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                  Volta := vGetpszData[0].pszDataxx;
                  if (Volta = '1') then
                     begin
                        if (PPrincipal.Memo1.Visible = False) then
                           begin
                             PPrincipal.Memo1.Visible := True;
                           end;
                             PPrincipal.Memo1.Lines.Add(' PWINFO_CNFREQ = 1');
                             PPrincipal.Memo1.Lines.Add(' ');
                             PPrincipal.Memo1.Lines.Add('� Necess�rio Confirmar esta Transa��o !');
                             PPrincipal.Memo1.Lines.Add(' ');
                     end;


                     Break;

              end;


        end;




  end;




//=====================================================================================
  {
   Funcao     :  ConfirmaTransacao

   Descricao  : Esta fun��o informa ao Pay&Go Web o status final da transa��o
                em curso (confirmada ou desfeita).Confirma��o de transa��o�
 }
//=====================================================================================*/
function TPGWLib.ConfirmaTrasacao: integer;
var
  strTagNFCe : String;
  strTagOP   : AnsiString;
  falta : string;
  iRet : Integer;
  iRetorno : Integer;
  ulStatus:Integer;
  Menu:Byte;
  Volta : String;
  winfo:Integer;
  I:Integer;
  iRetI:Integer;
  Cont:string;
  tamanho:Integer;
  passou:Integer;
  testeNum: Array[0..10] of Char;

begin



  {

      Descri��o das Confirma��es:

   ' 1 - PWCNF_CNF_AUT         A transa��o foi confirmada pelo Ponto de Captura, sem interven��o do usu�rio '
   ' 2 - PWCNF_CNF_MANU_AUT    A transa��o foi confirmada manualmente na Automa��o
   ' 3 - PWCNF_REV_MANU_AUT    A transa��o foi desfeita manualmente na Automa��o
   ' 4 - PWCNF_REV_PRN_AU      A transa��o foi desfeita pela Automa��o, devido a uma falha na impress�o
                                 do comprovante (n�o fiscal). A priori, n�o usar.
                                 Falhas na impress�o n�o devem gerar desfazimento,
                                 deve ser solicitada a reimpress�o da transa�� '
   ' 5 - PWCNF_REV_DISP_AUT    A transa��o foi desfeita pela Automa��o, devido a uma falha no
                                 mecanismo de libera��o da mercadoria
   ' 6 - PWCNF_REV_COMM_AUT    A transa��o foi desfeita pela Automa��o, devido a uma falha de
                                 comunica��o/integra��o com o ponto de captura (Cliente Pay&Go Web'
   ' 7 - PWCNF_REV_ABORT       A transa��o n�o foi finalizada, foi interrompida durante a captura de dados'
   ' 8 - PWCNF_REV_OTHER_AUT   A transa��o foi desfeita a pedido da Automa��o, por um outro motivo n�o previsto.
   ' 9 - PWCNF_REV_PWR_AUT     A transa��o foi desfeita automaticamente pela Automa��o,
                                 devido a uma queda de energia (rein�cio abrupto do sistema).
   '10 - PWCNF_REV_FISC_AUT    A transa��o foi desfeita automaticamente pela Automa��o,
                                 devido a uma falha de registro no sistema fiscal (impressora S@T, on-line, etc.).
}



   falta :=
   ' 1 - PWCNF_CNF_AUT       '  + chr(13) +
   ' 2 - PWCNF_CNF_MANU_AUT  '  + chr(13) +
   ' 3 - PWCNF_REV_MANU_AUT  '  + chr(13) +
   ' 4 - PWCNF_REV_PRN_AU    '  + chr(13) +
   ' 5 - PWCNF_REV_DISP_AUT  '  + chr(13) +
   ' 6 - PWCNF_REV_COMM_AUT  '  + chr(13) +
   ' 7 - PWCNF_REV_ABORT     '  + chr(13) +
   ' 8 - PWCNF_REV_OTHER_AUT '  + chr(13) +
   ' 9 - PWCNF_REV_PWR_AUT   '  + chr(13) +
   '10 - PWCNF_REV_FISC_AUT  '  + chr(13);



    StrTagNFCe:= vInputBox('Escolha Confirma��o: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
    Menu := StrToInt(strTagNFCe);



    case Menu of

         1:
           begin
             ulStatus := PWEnums.PWCNF_CNF_AUTO;
           end;

         2:
           begin
            ulStatus  := PWEnums.PWCNF_CNF_MANU_AUT;
           end;
         3:
           begin
            ulStatus := PWEnums.PWCNF_REV_MANU_AUT;
           end;
         4:
           begin
            ulStatus := PWEnums.PWCNF_REV_DISP_AUT;
           end;

         5:
           begin
            ulStatus := PWEnums.PWCNF_REV_DISP_AUT;
           end;

         6:
           begin
            ulStatus := PWEnums.PWCNF_REV_COMM_AUT;
           end;

         7:
           begin
            ulStatus := PWEnums.PWCNF_REV_ABORT;
           end;

         8:
           begin
            ulStatus := PWEnums.PWCNF_REV_OTHER_AUT;
           end;

         9:
           begin
            ulStatus := PWEnums.PWCNF_REV_PWR_AUT;
           end;

         10:
           begin
            ulStatus := PWEnums.PWCNF_REV_FISC_AUT;
           end;


    end;



     falta := '0 - Confirmar Ultima Transa��o ' + chr(13) +
              '1 - Informar Dados Manualmente ';

     while (X < 5) do
     begin

          strTagNFCe:= vInputBox('Escolha Op��o: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);

          if  (StrToInt(strTagNFCe) = 0) or (StrToInt(strTagNFCe) = 1)  then
               begin
                 Break;
               end
          else
               begin
                 ShowMessage('Op��o Invalida');
                 Continue
               end;


     end;




    if (strTagNFCe = '1') then
       begin

          falta := '';

          strTagOP:= vInputBox('Digite valor de PWINFO_REQNUM: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
          StrLCopy(@gstConfirmData[0].szReqNum, PChar(strTagOP), SizeOf(gstConfirmData[0].szReqNum));        // 11

          strTagOP:= vInputBox('Digite valor de PWINFO_AUTLOCREF: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
          StrLCopy(@gstConfirmData[0].szLocRef, PChar(strTagOP), SizeOf(gstConfirmData[0].szLocRef));      //11

          strTagOP:= vInputBox('Digite valor de PWINFO_AUTEXTREF: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
          StrLCopy(@gstConfirmData[0].szExtRef, PChar(strTagOP), SizeOf(gstConfirmData[0].szExtRef));   // 50

          strTagOP:= vInputBox('Digite valor de PWINFO_VIRTMERCH: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
          StrLCopy(@gstConfirmData[0].szVirtMerch, PChar(strTagOP), SizeOf(gstConfirmData[0].szVirtMerch));  // 18

          strTagOP:= vInputBox('Digite valor de PWINFO_AUTHSYST: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);
          StrLCopy(@gstConfirmData[0].szAuthSyst, PChar(strTagOP), SizeOf(gstConfirmData[0].szAuthSyst));  // 20

       end
    else
       begin
         // Busca Parametros para Confirma��o da Transa��o
         // GetParamConfirma();
       end;


    // Executa Confirma��o
    iRet := PW_iConfirmation(ulStatus, gstConfirmData[0].szReqNum,gstConfirmData[0].szLocRef,gstConfirmData[0].szExtRef,gstConfirmData[0].szVirtMerch,gstConfirmData[0].szAuthSyst);


    if (iRet <> PWRET_OK) then
       begin


          // Verifica se Foi inicializada a biblioteca
          if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
              begin
                  iRetorno := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                  Volta := vGetpszData[0].pszDataxx;
                  if (PPrincipal.Memo1.Visible = False) then
                     begin
                       PPrincipal.Memo1.Visible := True;
                     end;
                       PPrincipal.Memo1.Lines.Add(Volta);
                       PPrincipal.Memo1.Lines.Add(' ');
              end;

          // verifica se foi feito instala��o
          if (iRet = PWEnums.PWRET_NOTINST)  then
              begin
                  iRetorno := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                  Volta := vGetpszData[0].pszDataxx;
                  if (PPrincipal.Memo1.Visible = False) then
                     begin
                       PPrincipal.Memo1.Visible := True;
                     end;
                       PPrincipal.Memo1.Lines.Add(Volta);
                       PPrincipal.Memo1.Lines.Add(' ');
              end;



              ShowMessage('Outros Erros: ' + IntToStr(iRet));

              // Verificar Outros erros

              Exit;

       end;





    iRetorno := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
    volta := vGetpszData[0].pszDataxx;



    if (PPrincipal.Memo1.Visible = False) then
       begin
         PPrincipal.Memo1.Visible := True;
       end;
      PPrincipal.Memo1.Lines.Add(Volta);
      PPrincipal.Memo1.Lines.Add(' ');





end;

function TPGWLib.Count: Integer;
begin

end;

constructor TPGWLib.Create;
begin

 inherited Create;
  PWEnums := TCEnums.Create;

end;

destructor TPGWLib.Destroy;
begin
  inherited;
end;



//=====================================================================================
  {
   Funcao     :  AddMandatoryParams

   Descricao  :  Esta fun��o adiciona os par�metros obrigat�rios de toda mensagem para o
                 Pay&Go Web.
  }
//=====================================================================================*/
procedure AddMandatoryParams;
begin

  PW_iAddParam(PWEnums.PWINFO_AUTDEV,PWEnums.PGWEBLIBTEST_AUTDEV);
  PW_iAddParam(PWEnums.PWINFO_AUTVER, PWEnums.PGWEBLIBTEST_VERSION);
  PW_iAddParam(PWEnums.PWINFO_AUTNAME, PWEnums.PGWEBLIBTEST_AUTNAME);
  PW_iAddParam(PWEnums.PWINFO_AUTCAP, PWEnums.PGWEBLIBTEST_AUTCAP);
  PW_iAddParam(PWEnums.PWINFO_AUTHTECHUSER, PWEnums.PGWEBLIBTEST_AUTHTECHUSER);

end;


//=====================================================================================*\
  {
     function  :  Init

     Descricao  :  Captura os dados neces�rios e executa PW_iInit.

     Sugest�o de Pasta C:\PAYGO (Deve ser Criada)
     "." Gera as Pastas de Dados e Log no Raiz da Aplica��o.

  }
//=====================================================================================*/
   function TPGWLib.Init:Integer;
    var
      StrTagNFCe: string;
      Volta : String;
      iRet:Integer;
      iParam : Int16;
      iretornar:integer;
    begin

        StrTagNFCe := vInputBox('Pasta', 'Informe Diretorio:', 'c:\PAYGO',PWEnums.WInputH,PWEnums.WInputV);

        //StrTagNFCe:= vInputBox('Pasta', 'Informe Diretorio:', 'c:\PAYGO');
        //StrTagNFCe:= InputBox('Pasta', 'Informe Diretorio:', 'c:\PAYGO');
        iRetornar := PW_iInit(StrTagNFCe);

        MandaMemo(' ');
        PrintReturnDescription(iretornar,'');

        if (iRetornar = PWEnums.PWRET_WRITERR)  then
            begin
                iRet := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                Volta := vGetpszData[0].pszDataxx;
                //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);

                MandaMemo(Volta);

            end;


        Result := iRetornar;

   end;



//=====================================================================================*\
  {
     function  :  Instalacao

     Descricao  :  Instala��o de um Ponto de Captura.

  }
//=====================================================================================*/
function TPGWLib.Instalacao: Integer;
var
    szAux: Char;
    StrTagNFCe: string;
    StrValorTagNFCe: AnsiString;
    msg: AnsiString;
    pszData:Char;
    iParam : Int16;
    Volta : String;
    xxxparam: SmallInt;
    I:integer;
    comando: array[0..39] of Char;
    winfo:Integer;
    falta:string;
    iRet:Integer;
    iRetErro : integer;
begin


         //===============================================
         // Evento de Instala��o
         //===============================================


         //===============================================
         // Nova Transa��o - Instala��o
         //===============================================
          iRet := PW_iNewTransac(PWEnums.PWOPER_INSTALL);



        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);


            MandaMemo(' ');
            PrintReturnDescription(iRet,'');


            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin

                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end;


                  if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                      begin
                          // Busca Parametros da Transa��o Pendente
                          GetParamPendenteConfirma();
                      end
                  else
                      begin
                          // Busca Parametros da Transa��o Atual
                          GetParamConfirma();
                          //ShowMessage('Parametros Atuais');
                      end;

                  iRet := PW_iGetResult(PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                  Volta := vGetpszData[0].pszDataxx;
                  if (Volta = '1') then
                     begin
                        if (PPrincipal.Memo1.Visible = False) then
                           begin
                             PPrincipal.Memo1.Visible := True;
                           end;
                             PPrincipal.Memo1.Lines.Add(' PWINFO_CNFREQ = 1');
                             PPrincipal.Memo1.Lines.Add(' ');
                             PPrincipal.Memo1.Lines.Add('� Necess�rio Confirmar esta Transa��o !');
                             PPrincipal.Memo1.Lines.Add(' ');
                     end;



                  Break;


              end;


        end;



         //===============================================
         // Testa se Biblioteca foi Inicializada - PWInit
         //===============================================
{            iRet := TestaInit(iparam);
            if (iRet <> PWRET_OK) then
               begin
                 Exit;
               end;



         // OK - Continua




           I := 0;

        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 10 do
        begin

            // Dados Obrigat�rios
            AddMandatoryParams;

            // inicializar sempre com 10
            xNumParam := 10;
            // Executa Transa��o
            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);


            MandaMemo(' ');
            PrintReturnDescription(iRet,'');

            // caso exista Dados faltantes
            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
              end
            else
              begin
                PPrincipal.Label1.Visible := False;
                Exit;
              end;

            I := I+1;

        end;

}










end;


function TPGWLib.MandaMemo(Descr:string): integer;
begin

    if (PPrincipal.Memo1.Visible = False) then
       begin
         PPrincipal.Memo1.Visible := True;
       end;
         PPrincipal.Memo1.Lines.Add(Descr);
         //PPrincipal.Memo1.Lines.Add(' ');

     Result := 0;


end;

//=====================================================================================
  {
     Reimpress�o
  }
//======================================================================================
function TPGWLib.Reimpressao: Integer;
var
    iParam : Integer;
    Volta : String;
    iRet:Integer;
    iRetI: Integer;
    iRetErro : integer;
    strNome : String;
    I:Integer;
    xloop:integer;
    voltaA:AnsiChar;
begin

        I := 0;

        iRet := PW_iNewTransac(PWEnums.PWOPER_REPRINT);

        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);


            MandaMemo(' ');
            PrintReturnDescription(iRet,'');


            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin


                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end;


                  if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                      begin
                          // Busca Parametros da Transa��o Pendente
                          GetParamPendenteConfirma();
                      end
                  else
                      begin
                          // Busca Parametros da Transa��o Atual
                          GetParamConfirma();
                      end;


                    // Busca Todos os codigos e seus conteudos
                    // PrintResultParams();


                  // Retorna o recibo Via do Estabelecimento
                  iRet := PW_iGetResult(PWEnums.PWINFO_RCPTMERCH , vGetpszErro, SizeOf(vGetpszData));
                  Volta := vGetpszErro[0].pszDataxx;
                  //ShowMessage('Retorno ' + Volta);

                  // Retorna o recibo Via do Cliente
                  iRet := PW_iGetResult(PWEnums.PWINFO_RCPTCHOLDER , vGetpszErro, SizeOf(vGetpszData));
                  Volta := vGetpszErro[0].pszDataxx;
                  //ShowMessage('Retorno ' + Volta);

                  Break;


              end;


        end;


end;


//=====================================================================================
  {
     Relat�rios
  }
//======================================================================================
function TPGWLib.Relatorios: Integer;
var
    iParam : Integer;
    Volta : String;
    iRet:Integer;
    iRetI: Integer;
    iRetErro : integer;
    strNome : String;
    I:Integer;
    xloop:integer;
    voltaA:AnsiChar;
begin


        I := 0;

        iRet := PW_iNewTransac(PWEnums.PWOPER_RPTDETAIL);

        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);
            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin


                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end
                  else
                    begin
                      Break;
                    end;

              end;


        end;




end;

//=====================================================================================
  {
     Fun��o Auxiliar. "n�o esta sendo usada no momento"
  }
//======================================================================================
function tbKeyIsDown(const Key: Integer): Boolean;
begin
   Result := GetKeyState(Key) and 128 > 0;
end;


//=====================================================================================*\
  {
     function  :  TestaInit

     Descricao  :  Verifica se PW_iInit j� foi executado.

     Entradas   :  Resultado da Opera��o

     Saidas     :  nao ha.

     Retorno    :  C�digo de resultado da opera��o.

  }
//=====================================================================================*/
function TPGWLib.TestaInit(iparam:Integer): Integer;
var
    //iParam : Int16;
    Volta : String;
    iRet:Integer;
begin

     if (iParam = PWEnums.PWRET_DLLNOTINIT)  then
        begin
            iRet := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
            Volta := vGetpszData[0].pszDataxx;
//            Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);

            if (PPrincipal.Memo1.Visible = False) then
               begin
                 PPrincipal.Memo1.Visible := True;
               end;
            PPrincipal.Memo1.Lines.Add(Volta);
            PPrincipal.Memo1.Lines.Add(' ');


            Result := iParam;
        end
        else
        begin
          Result := PWEnums.PWRET_OK;
        end;


end;


//========================================================
  {

    Executa Nova Transa�ao de Venda  PWEnums.PWOPER_SALE

  }
//========================================================
function TPGWLib.venda: Integer;
var
    iParam : Integer;
    Volta : String;
    iRet:Integer;
    iRetI: Integer;
    iRetErro : integer;
    strNome : String;
    I:Integer;
    xloop:integer;
    voltaA:AnsiChar;

begin


        I := 0;

        iRet := PW_iNewTransac(PWEnums.PWOPER_SALE);

        //iRetErro := PW_iGetResult(PWEnums.PWINFO_SERVERPND, vGetpszErro, SizeOf(vGetpszErro));

       // iRetErro := PW_iGetResult(PWEnums.PWINFO_SERVERPND, vGetpszData, SizeOf(vGetpszData));


        if (iRet <> PWRET_OK) then
           begin


              // Verifica se Foi inicializada a biblioteca
              if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                           //Application.MessageBox(PChar(Volta),'Erro',mb_OK+mb_IconInformation);
                  end;

              // verifica se foi feito instala��o
              if (iRet = PWEnums.PWRET_NOTINST)  then
                  begin
                      iRetErro := PW_iGetResult(PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                      Volta := vGetpszData[0].pszDataxx;
                      if (PPrincipal.Memo1.Visible = False) then
                         begin
                           PPrincipal.Memo1.Visible := True;
                         end;
                           PPrincipal.Memo1.Lines.Add(Volta);
                           PPrincipal.Memo1.Lines.Add(' ');
                  end;


                  // Verificar Outros erros

                  Exit;

           end;




        AddMandatoryParams;  // Parametros obrigat�rios


        //=====================================================
        //  Loop Para Capturar Dados e executar Transa��o
        //=====================================================
        while I < 100 do
        begin

            // Coloca o valor 10 (tamanho da estrutura de entrada) no par�metro iNumParam
            xNumParam := 10;



            // Tenta executar a transa��o
            if(iRet <> PWEnums.PWRET_NOTHING) then
              begin
                //ShowMessage('Processando...');
              end;

            iRet := PW_iExecTransac(vGetdataArray, @xNumParam);


            MandaMemo(' ');
            PrintReturnDescription(iRet,'');


            if (iRet = PWEnums.PWRET_MOREDATA) then
              begin

                 MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


                 // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                 iRetErro := iExecGetData(vGetdataArray,xNumParam);
                 if (iRetErro <> 0) then
                    begin
                      Exit;
                    end
                 else
                    begin
                      I := I+1;
                      Continue;
                    end;

              end
            else
              begin





                  if(iRet = PWEnums.PWRET_NOTHING) then
                    begin
                      I := I+1;
                      Continue;
                    end;


                  if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                      begin
                          // Busca Parametros da Transa��o Pendente
                          GetParamPendenteConfirma();

                          //ShowMessage('Parametros Pendentes');

                          {ShowMessage('ReqNum: ' + gstConfirmData[0].szReqNum);
                          ShowMessage('Extref: ' + gstConfirmData[0].szExtRef);
                          ShowMessage('Locref: ' + gstConfirmData[0].szLocRef);
                          ShowMessage('VirtMerch: ' + gstConfirmData[0].szVirtMerch);
                          ShowMessage('AuthSyst: ' + gstConfirmData[0].szAuthSyst);
                          }
                      end
                  else
                      begin
                          // Busca Parametros da Transa��o Atual
                          GetParamConfirma();
                          //ShowMessage('Parametros Atuais');
                      end;

                  iRet := PW_iGetResult(PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                  Volta := vGetpszData[0].pszDataxx;
                  if (Volta = '1') then
                     begin
                        if (PPrincipal.Memo1.Visible = False) then
                           begin
                             PPrincipal.Memo1.Visible := True;
                           end;
                             PPrincipal.Memo1.Lines.Add(' PWINFO_CNFREQ = 1');
                             PPrincipal.Memo1.Lines.Add(' ');
                             PPrincipal.Memo1.Lines.Add('� Necess�rio Confirmar esta Transa��o !');
                             PPrincipal.Memo1.Lines.Add(' ');
                     end;


                  Break;


              end;


        end;




end;






//=====================================================================================*\
  { Funcao     :  iExecGetData

     Descricao  :  Esta fun��o obt�m dos usu�rios os dados requisitado pelo Pay&Go Web.

     Entradas   :  vstGetData  :  Vetor com as informa��es dos dados a serem obtidos.
                   iNumParam   :  N�mero de dados a serem obtidos.

     Saidas     :  nao ha.

     Retorno    :  C�digo de resultado da opera��o.
   }
//=====================================================================================*/
function TPGWLib.iExecGetData( vstGetData:PW_GetData; iNumParam:Integer):Integer;
var
  I : integer;
  StrTagNFCe: string;
  falta:string;
  iRet:Integer;
  iRetErro : integer;
  Volta : String;
  strNome:string;
  xloop: integer;
  ulEvent:UInt32;
  x:integer;
  iRetStr: string;

begin



               ulEvent := 0;
               I := 0;


              //==========================================================
              // Loop Para Capturar e Adicionar dados solicitados pela DLL.
              // Enquanto houverem dados para capturar
              //==========================================================
              while I < iNumParam do

                begin

                     // Imprime na tela qual informa��o est� sendo capturada
                     iRetStr := pszGetInfoDescription(vstGetData[I].wIdentificador);
                     MandaMemo('dado a Capturar: ' + iRetStr + ' ' + IntToStr(vstGetData[I].wIdentificador));

                     case (vstGetData[I].bTipoDeDado) of


                       // Dados de Menu

                       PWEnums.PWDAT_MENU:

                             begin

                                 MandaMemo('Tipo de dados = MENU');
                                 MandaMemo(vstGetData[i].szPrompt);

                                 falta := vstGetData[I].szPrompt + chr(13);
                                 falta := falta + ' ' + chr(13);

                                 x := 0;

                                 while (X < vstGetData[I].bNumOpcoesMenu) do
                                     begin

                                        falta := falta + IntToStr(x) + ' - ' + vstGetData[I].vszTextoMenu[x] + chr(13);

                                        x := x+1;
                                     end;


                                 x := 0;

                                 strNome := '';

                                 while (X < 5) do
                                     begin
                                       strNome := vInputBox('Selecione Op��o', falta, '',PWEnums.WInputH,PWEnums.WInputV);


                                       try
                                          iRetErro := StrToInt(strNome);
                                       Except
                                          ShowMessage('Escolha uma op��o V�lida');
                                          Continue;
                                       end;

                                       if (StrToInt(strNome) > (vstGetData[I].bNumOpcoesMenu - 1)) then
                                           begin
                                             ShowMessage('Op��o Inexistente');
                                             Continue;
                                           end;

                                        // Busca C�digo Referente em vszValorMenu
                                        strNome := vstGetData[I].vszValorMenu[StrToInt(strNome)];

                                        Break;

                                     end;



                                 iRet := PW_iAddParam(vstGetData[I].wIdentificador,strNome);
                                 if (iRet = PWEnums.PWRET_OK) then
                                    begin
                                      Result := PWRET_OK;
                                    end
                                 else
                                    begin
                                      Result := iRet;
                                    end;

                                 Break;

                             end;



                       // Entrada Digitada

                       PWEnums.PWDAT_TYPED:
                             begin

                               MandaMemo('Tipo de dados = DIGITADO');
                               MandaMemo(vstGetData[i].szPrompt);
                               MandaMemo('Tamanho Minimo: ' + IntToStr(vstGetData[I].bTamanhoMinimo));
                               MandaMemo('Tamanho Maximo: ' + IntToStr(vstGetData[I].bTamanhoMaximo));
                               iRetStr := vstGetData[I].szValorInicial;
                               MandaMemo('Valor Atual: ' + iRetStr);
                               MandaMemo(' ');


                               falta := vstGetData[I].szPrompt;

                               x := 0;

                               while (X < 5) do
                                   begin

                                       //ShowMessage('Mascara: ' + vstGetData[I].szMascaraDeCaptura);
                                       StrTagNFCe:= vInputBox('Informar: ',falta,'',PWEnums.WInputH,PWEnums.WInputV);

                                       if (Length(StrTagNFCe) > vstGetData[I].bTamanhoMaximo) then
                                          begin
                                              ShowMessage('Valor Maior que Tamanho Maximo');
                                              Continue;
                                          end;

                                       if (Length(StrTagNFCe) < vstGetData[I].bTamanhoMinimo) then
                                          begin
                                              ShowMessage('Valor Menor que Tamanho Minimo');
                                              Continue;
                                          end;

                                      { if (vstGetData[I].bValidacaoDado = 1) then
                                          begin
                                           if (StrToIntDef(StrTagNFCe,0) = 0) then
                                              begin
                                                ShowMessage('Informar Somente Numeros');
                                                Continue;
                                              end;
                                          end;
                                       }

                                          iRet := PW_iAddParam(vstGetData[I].wIdentificador,StrTagNFCe);
                                          if (iRet <> 0) then
                                             begin
                                                ShowMessage('Erro ao Adicionar Parametros');
                                                Result := iRet;
                                                Exit;
                                              end
                                          else
                                              begin
                                                Result := PWEnums.PWRET_OK;
                                                Break;
                                              end;

                                   end;


                              I := I+1;

                              continue;


                             end;


                       // Dados do Cart�o

                       PWEnums.PWDAT_CARDINF:
                             begin

                             MandaMemo('Tipo de dados = DADOS DO CARTAO');
                             //MandaMemo(vstGetData[i].szPrompt);

                             if(vstGetData[I].ulTipoEntradaCartao = 1) then
                               begin
                                 //ShowMessage('ulTipoEntrada = 1');
                               end;

                                 iRet := PW_iPPGetCard(I);

                                 if (iRet <> PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;



                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin

                                   iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          if (PPrincipal.Memo1.Visible = False) then
                                             begin
                                               PPrincipal.Memo1.Visible := True;
                                             end;
                                          PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                          PPrincipal.Memo1.Lines.Add(' ');

                                      end;

                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                    xloop := xloop+1;



                                   Sleep(1000);

                                 end;




                             end;



                            // Remo��o do cart�o do PIN-pad.

                            PWEnums.PWDAT_PPREMCRD:
                              begin

                                 MandaMemo('Tipo de dados = PWDAT_PPREMCRD');

                                 iRet := PW_iPPRemoveCard();

                                 if (iRet <> PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;

                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin

                                   iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          if (PPrincipal.Memo1.Visible = False) then
                                             begin
                                               PPrincipal.Memo1.Visible := True;
                                               // Memo1.Lines.Clear;
                                             end;
                                          PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                          PPrincipal.Memo1.Lines.Add(' ');
                                      end;

                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                    xloop := xloop+1;


                                   Sleep(1000);


                                  end;


                              end;




                            // Captura da senha criptografada

                            PWEnums.PWDAT_PPENCPIN:
                               begin

                                 MandaMemo('Tipo de dados = SENHA');

                                 iRet := PW_iPPGetPIN(I);
                                 if (iRet <> PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;


                                 while xloop < 1000 do
                                 begin


                                   iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          if (PPrincipal.Memo1.Visible = False) then
                                             begin
                                               PPrincipal.Memo1.Visible := True;
                                             end;
                                          PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                          PPrincipal.Memo1.Lines.Add(' ');
                                      end;


                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;

                                   if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;

                                    xloop := xloop+1;



                                   Sleep(1000);

                                 end;





                               end;



                            // processamento off-line de cart�o com chip

                            PWEnums.pWDAT_CARDOFF:

                                begin

                                 MandaMemo('Tipo de dados = CHIP OFFLINE');


                                 iRet := PW_iPPGoOnChip(I);

                                 if (iRet <> PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;

                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin

                                   iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          if (PPrincipal.Memo1.Visible = False) then
                                             begin
                                               PPrincipal.Memo1.Visible := True;
                                             end;
                                          PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                          PPrincipal.Memo1.Lines.Add(' ');
                                      end;


                                   if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                    xloop := xloop+1;



                                   Sleep(1000);


                                  end;



                                end;



                                // Captura de dado digitado no PIN-pad

                                PWEnums.PWDAT_PPENTRY:
                                  begin

                                     MandaMemo('Tipo de dados = DADO DIGITADO NO PINPAD');

                                     iRet := PW_iPPGetData(I);

                                     if (iRet <> PWRET_OK) then
                                        begin
                                           Result := iRet;
                                           Exit;
                                        end;

                                     xloop := 0;


                                     while xloop < 10000 do
                                     begin

                                       iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                       if (iRet = PWEnums.PWRET_DISPLAY) then
                                          begin
                                              if (PPrincipal.Memo1.Visible = False) then
                                                 begin
                                                   PPrincipal.Memo1.Visible := True;
                                                 end;
                                              PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                              PPrincipal.Memo1.Lines.Add(' ');
                                          end;


                                       if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                         begin
                                           Result := iRet;
                                           Exit;
                                         end;


                                       //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                       if (iRet = PWEnums.PWRET_OK)  then
                                         begin
                                           Result := iRet;
                                           Exit;
                                         end;


                                        xloop := xloop+1;



                                        Sleep(1000);

                                  end;


                                  end;


                                  // Processamento online do cart�o com chip

                                  PWEnums.PWDAT_CARDONL:
                                    begin

                                       MandaMemo('Tipo de dados = CHIP ONLINE');


                                       iRet := PW_iPPFinishChip(I);

                                       if (iRet <> PWRET_OK) then
                                          begin
                                             Result := iRet;
                                             Exit;
                                          end;

                                       xloop := 0;

                                       while xloop < 10000 do
                                       begin

                                         iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                         if (iRet = PWEnums.PWRET_DISPLAY) then
                                            begin
                                                if (PPrincipal.Memo1.Visible = False) then
                                                   begin
                                                     PPrincipal.Memo1.Visible := True;
                                                     // Memo1.Lines.Clear;
                                                   end;
                                                PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                                PPrincipal.Memo1.Lines.Add(' ');
                                            end;


                                         if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                         //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                         if (iRet = PWEnums.PWRET_OK)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                          xloop := xloop+1;



                                         Sleep(1000);


                                       end;




                                    end;



                                  // Confirma��o de dado no PIN-pad

                                  PWEnums.PWDAT_PPCONF:
                                  begin

                                       MandaMemo('Tipo de dados = CONFIRMA DADO');

                                       iRet := PW_iPPConfirmData(I);

                                       if (iRet <> PWRET_OK) then
                                          begin
                                             Result := iRet;
                                             Exit;
                                          end;

                                       xloop := 0;

                                       while xloop < 10000 do
                                       begin

                                         iRet := PW_iPPEventLoop(vGetpszDisplay, sizeof(vGetpszDisplay));
                                         if (iRet = PWEnums.PWRET_DISPLAY) then
                                            begin
                                                if (PPrincipal.Memo1.Visible = False) then
                                                   begin
                                                     PPrincipal.Memo1.Visible := True;
                                                     // Memo1.Lines.Clear;
                                                   end;
                                                PPrincipal.Memo1.Lines.Add(vGetpszDisplay[0].szDspMsg);
                                                PPrincipal.Memo1.Lines.Add(' ');
                                            end;


                                         if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                         //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                         if (iRet = PWEnums.PWRET_OK)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                          xloop := xloop+1;



                                         Sleep(1000);


                                       end;



                                  end;



                                else


                                  begin

                                      ShowMessage('TIPO DE DADOS DESCONHECIDO : ' + IntToStr(vstGetData[I].bTipoDeDado));

                                  end;





                     end;





                    I := I+1;

                    continue;


                end;

                Result := PWRET_OK;

                PPrincipal.Label1.Visible := True;
                PPrincipal.Label1.Caption := 'PROCESSANDO ...';
                Application.ProcessMessages;


          end;


//=====================================================================================*\
  {
     Funcao     :  PrintResultParams

     Descricao  :  Esta fun��o exibe na tela todas as informa��es de resultado dispon�veis
                   no momento em que foi chamada.

     Entradas   :  nao ha.

     Saidas     :  nao ha.

     Retorno    :  nao ha.
  }
//=====================================================================================*/
function TPGWLib.PrintResultParams: Integer;
var
  I:Int16;
  Ir:Integer;
  iRet:Integer;
  szAux : PSZ_GetData;
  volta:AnsiString;

begin

   I := 0;

   while I < 32767 do   // MAXINT16
   begin


       iRet := PW_iGetResult( I, szAux, sizeof(szAux));
       if( iRet = PWEnums.PWRET_OK) then
          begin


               MandaMemo('<0x ' +  pszGetInfoDescription(I));
               volta := szAux[0].pszDataxx;
               MandaMemo(volta);

        //       printf( "\n\n%s<0x%X> =\n%s", pszGetInfoDescription(i), i, szAux);

          end;

          I := I+1;



   end;

end;



//=====================================================================================*\
  {
   Funcao     :  PrintReturnDescription

   Descricao  :  Esta fun��o recebe um c�digo PWRET_XXX e imprime na tela a sua descri��o.

   Entradas   :  iResult :   C�digo de resultado da transa��o (PWRET_XXX).

   Saidas     :  nao ha.

   Retorno    :  nao ha.
  }
//=====================================================================================*/
function TPGWLib.PrintReturnDescription(iReturnCode:Integer; pszDspMsg:string):Integer;
  var
    I : integer;
  begin

       case iReturnCode of


         PWEnums.PWRET_OK:
           begin
            MandaMemo('PWRET_OK');
           end;

         PWEnums.PWRET_INVCALL:
           begin
            MandaMemo('PWRET_INVCALL');
           end;

         PWEnums.PWRET_INVPARAM:
           begin
            MandaMemo('PWRET_INVPARAM');
           end;

         PWEnums.PWRET_NODATA:
           begin
            MandaMemo('PWRET_NODATA');
           end;

         PWEnums.PWRET_BUFOVFLW:
           begin
            MandaMemo('PWRET_BUFOVFLW');
           end;

         PWEnums.PWRET_MOREDATA:
           begin
            MandaMemo('PWRET_MOREDATA');
           end;

         PWEnums.PWRET_DLLNOTINIT:
           begin
            MandaMemo('PWRET_DLLNOTINIT');
           end;

         PWEnums.PWRET_NOTINST:
           begin
            MandaMemo('PWRET_NOTINST');
           end;

         PWEnums.PWRET_TRNNOTINIT:
           begin
            MandaMemo('PWRET_TRNNOTINIT');
           end;

         PWEnums.PWRET_NOMANDATORY:
           begin
            MandaMemo('PWRET_NOMANDATORY');
           end;

         PWEnums.PWRET_TIMEOUT:
           begin
            MandaMemo('PWRET_TIMEOUT');
           end;

         PWEnums.PWRET_CANCEL:
           begin
            MandaMemo('PWRET_CANCEL');
           end;

         PWEnums.PWRET_FALLBACK:
           begin
            MandaMemo('PWRET_FALLBACK');
           end;

         PWEnums.PWRET_DISPLAY:
           begin
            MandaMemo('PWRET_DISPLAY');
           end;
         //printf("\nRetorno = PWRET_DISPLAY");
         //InputCR(pszDspMsg);
         //printf("\n%s", pszDspMsg);

         PWEnums.PWRET_NOTHING:
           begin
            MandaMemo('PWRET_NOTHING');
           end;

         PWEnums.PWRET_FROMHOST:
         //printf("\nRetorno = ERRO DO HOST");
           begin
            MandaMemo('PWRET_FROMHOST');
           end;

         PWEnums.PWRET_SSLCERTERR:
           begin
            MandaMemo('PWRET_SSLCERTERR');
           end;

         PWEnums.PWRET_SSLNCONN:
           begin
            MandaMemo('PWRET_SSLNCONN');
           end;

         PWEnums.PWRET_FROMHOSTPENDTRN:
           begin
            MandaMemo('PWRET_FROMHOSTPENDTRN');
           end;

      else

         begin
          //printf("\nRetorno = OUTRO ERRO <%d>", iReturnCode);
           begin
            MandaMemo('OUTRO ERRO: ' + IntToStr(iReturnCode));
           end;

         end;



         if(iReturnCode <> PWEnums.PWRET_MOREDATA) and (iReturnCode <> PWEnums.PWRET_DISPLAY) and
             (iReturnCode <> PWEnums.PWRET_NOTHING) and (iReturnCode <> PWEnums.PWRET_FALLBACK) then
            begin
              //PrintResultParams();
            end;




       end;



  end;




//=====================================================================================*\
  {
   Funcao     :  pszGetInfoDescription

   Descricao  :  Esta fun��o recebe um c�digo PWINFO_XXX e retorna uma string com a
                 descri��o da informa��o representada por aquele c�digo.

   Entradas   :  wIdentificador :  C�digo da informa��o (PWINFO_XXX).

   Saidas     :  nao ha.

   Retorno    :  String representando o c�digo recebido como par�metro.
  }
//=====================================================================================*/
  function TPGWLib.pszGetInfoDescription(wIdentificador:Integer):string;
  begin

       case wIdentificador of

        PWEnums.PWINFO_OPERATION:  Result := 'PWINFO_OPERATION';

        PWEnums.PWINFO_POSID            :  Result := 'PWINFO_POSID';
        PWEnums.PWINFO_AUTNAME          :  Result := 'PWINFO_AUTNAME';
        PWEnums.PWINFO_AUTVER           :  Result := 'PWINFO_AUTVER';
        PWEnums.PWINFO_AUTDEV           :  Result := 'PWINFO_AUTDEV';
        PWEnums.PWINFO_DESTTCPIP        : Result := 'PWINFO_DESTTCPIP';
        PWEnums.PWINFO_MERCHCNPJCPF     : Result := 'PWINFO_MERCHCNPJCPF';
        PWEnums.PWINFO_AUTCAP           : Result := 'PWINFO_AUTCAP';
        PWEnums.PWINFO_TOTAMNT          : Result := 'PWINFO_TOTAMNT';
        PWEnums.PWINFO_CURRENCY         : Result := 'PWINFO_CURRENCY';
        PWEnums.PWINFO_CURREXP          : Result := 'PWINFO_CURREXP';
        PWEnums.PWINFO_FISCALREF        : Result := 'PWINFO_FISCALREF';
        PWEnums.PWINFO_CARDTYPE         : Result := 'PWINFO_CARDTYPE';
        PWEnums.PWINFO_PRODUCTNAME      : Result := 'PWINFO_PRODUCTNAME';
        PWEnums.PWINFO_DATETIME         : Result := 'PWINFO_DATETIME';
        PWEnums.PWINFO_REQNUM           : Result := 'PWINFO_REQNUM';
        PWEnums.PWINFO_AUTHSYST         : Result := 'PWINFO_AUTHSYST';
        PWEnums.PWINFO_VIRTMERCH        : Result := 'PWINFO_VIRTMERCH';
        PWEnums.PWINFO_AUTMERCHID       : Result := 'PWINFO_AUTMERCHID';
        PWEnums.PWINFO_PHONEFULLNO      : Result := 'PWINFO_PHONEFULLNO';
        PWEnums.PWINFO_FINTYPE          : Result := 'PWINFO_FINTYPE';
        PWEnums.PWINFO_INSTALLMENTS     : Result := 'PWINFO_INSTALLMENTS';
        PWEnums.PWINFO_INSTALLMDATE     : Result := 'PWINFO_INSTALLMDATE';
        PWEnums.PWINFO_PRODUCTID        : Result := 'PWINFO_PRODUCTID';
        PWEnums.PWINFO_RESULTMSG        : Result := 'PWINFO_RESULTMSG';
        PWEnums.PWINFO_CNFREQ           : Result := 'PWINFO_CNFREQ';
        PWEnums.PWINFO_AUTLOCREF        : Result := 'PWINFO_AUTLOCREF';
        PWEnums.PWINFO_AUTEXTREF        : Result := 'PWINFO_AUTEXTREF';
        PWEnums.PWINFO_AUTHCODE         : Result := 'PWINFO_AUTHCODE';
        PWEnums.PWINFO_AUTRESPCODE      : Result := 'PWINFO_AUTRESPCODE';
        PWEnums.PWINFO_DISCOUNTAMT      : Result := 'PWINFO_DISCOUNTAMT';
        PWEnums.PWINFO_CASHBACKAMT      : Result := 'PWINFO_CASHBACKAMT';
        PWEnums.PWINFO_CARDNAME         : Result := 'PWINFO_CARDNAME';
        PWEnums.PWINFO_ONOFF            : Result := 'PWINFO_ONOFF';
        PWEnums.PWINFO_BOARDINGTAX      : Result := 'PWINFO_BOARDINGTAX';
        PWEnums.PWINFO_TIPAMOUNT        : Result := 'PWINFO_TIPAMOUNT';
        PWEnums.PWINFO_INSTALLM1AMT     : Result := 'PWINFO_INSTALLM1AMT';
        PWEnums.PWINFO_INSTALLMAMNT     : Result := 'PWINFO_INSTALLMAMNT';
        PWEnums.PWINFO_RCPTFULL         : Result := 'PWINFO_RCPTFULL';
        PWEnums.PWINFO_RCPTMERCH        : Result := 'PWINFO_RCPTMERCH';
        PWEnums.PWINFO_RCPTCHOLDER      : Result := 'PWINFO_RCPTCHOLDER';
        PWEnums.PWINFO_RCPTCHSHORT      : Result := 'PWINFO_RCPTCHSHORT';
        PWEnums.PWINFO_TRNORIGDATE      : Result := 'PWINFO_TRNORIGDATE';
        PWEnums.PWINFO_TRNORIGNSU       : Result := 'PWINFO_TRNORIGNSU';
        PWEnums.PWINFO_TRNORIGAMNT      : Result := 'PWINFO_TRNORIGAMNT';
        PWEnums.PWINFO_TRNORIGAUTH      : Result := 'PWINFO_TRNORIGAUTH';
        PWEnums.PWINFO_TRNORIGREQNUM    : Result := 'PWINFO_TRNORIGREQNUM';
        PWEnums.PWINFO_TRNORIGTIME      : Result := 'PWINFO_TRNORIGTIME';
        PWEnums.PWINFO_CARDFULLPAN      : Result := 'PWINFO_CARDFULLPAN';
        PWEnums.PWINFO_CARDEXPDATE      : Result := 'PWINFO_CARDEXPDATE';
        PWEnums.PWINFO_CARDNAMESTD      : Result := 'PWINFO_CARDNAMESTD';
        PWEnums.PWINFO_CARDPARCPAN      : Result := 'PWINFO_CARDPARCPAN';
        PWEnums.PWINFO_BARCODENTMODE    : Result := 'PWINFO_BARCODENTMODE';
        PWEnums.PWINFO_BARCODE          : Result := 'PWINFO_BARCODE';
        PWEnums.PWINFO_MERCHADDDATA1    : Result := 'PWINFO_MERCHADDDATA1';
        PWEnums.PWINFO_MERCHADDDATA2    : Result := 'PWINFO_MERCHADDDATA2';
        PWEnums.PWINFO_MERCHADDDATA3    : Result := 'PWINFO_MERCHADDDATA3';
        PWEnums.PWINFO_MERCHADDDATA4    : Result := 'PWINFO_MERCHADDDATA4';
        PWEnums.PWINFO_PAYMNTTYPE       : Result := 'PWINFO_PAYMNTTYPE';
        PWEnums.PWINFO_USINGPINPAD      : Result := 'PWINFO_USINGPINPAD';
        PWEnums.PWINFO_PPCOMMPORT       : Result := 'PWINFO_PPCOMMPORT';
        PWEnums.PWINFO_IDLEPROCTIME     : Result := 'PWINFO_IDLEPROCTIME';
        PWEnums.PWINFO_PNDAUTHSYST		  : Result := 'PWINFO_PNDAUTHSYST';
        PWEnums.PWINFO_PNDVIRTMERCH     : Result := 'PWINFO_PNDVIRTMERCH';
        PWEnums.PWINFO_PNDREQNUM        : Result := 'PWINFO_PNDREQNUM';
        PWEnums.PWINFO_PNDAUTLOCREF     : Result := 'PWINFO_PNDAUTLOCREF';
        PWEnums.PWINFO_PNDAUTEXTREF     : Result := 'PWINFO_PNDAUTEXTREF';
        else
        begin
          Result := 'PWINFO_XXX';
        end;

      end;


      end;



end.
