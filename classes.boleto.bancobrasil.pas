unit classes.boleto.bancobrasil;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  DataSet.Serialize,
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Horse.BasicAuthentication,
  Data.Win.ADODB,
  DataSet.Serialize.Config,
  FireDAC.Comp.Client,
  System.NetEncoding,
  System.Net.HttpClient,
  System.MaskUtils,
  lookti.criptografia,
  ACBrBase,
  ACBrDFe,
  ACBrNFSe,
  RESTRequest4D,
  pnfsConversao ,
  pcnConversao,
  System.Math,
  System.IniFiles,
  ACBrDFeSSL,
  ACBrBoleto,
  ACBrNFSeConfiguracoes,
  Blcksock;

type
  TTipoInscricao    = ( tiCPF = 1 , tiCNPJ = 2 );
  TTipoJuros        = ( tjDispensar , tjDiario , tjMensal );
  TTipoMulta        = ( tmDispensar , tmValor  , tmPorcentagem );
  TTipoDesconto     = ( tdSemDesconto , tdFixo , tdPorcentagem , tdDiario );
  TTipoModalidade   = ( tpmSimples , tpmVinculada );
  TOrgaoNegativador = ( tonSerasa = 10 );
  TTipoTitulo       = ( ttCHEQUE = 1,
                        ttDUPLICATAMERCANTIL = 2,
                        ttDUPLICATAMTILPORINDICACAO = 3,
                        ttDUPLICATADESERVICO = 4,
                        ttDUPLICATADESRVCPINDICACAO = 5,
                        ttDUPLICATARURAL = 6,
                        ttLETRADECAMBIO = 7,
                        ttNOTADECREDITOCOMERCIAL = 8,
                        ttNOTADECREDITOAEXPORTACAO = 9,
                        ttNOTADECREDITOINDULTRIAL = 10,
                        ttNOTADECREDITORURA = 11,
                        ttNOTAPROMISSORIA = 12,
                        ttNOTAPROMISSORIARURAL = 13,
                        ttTRIPLICATAMERCANTIL = 14,
                        ttTRIPLICATADESERVICO = 15,
                        ttNOTADESEGURO = 16,
                        ttRECIBO = 17,
                        ttFATURA = 18,
                        ttNOTADEDEBITO = 19,
                        ttAPOLICEDESEGURO = 20 ,
                        ttMENSALIDADEESCOLAR = 21,
                        ttPARCELADECONSORCIO = 22,
                        ttDIVIDAATIVADAUNIAO = 23,
                        ttDIVIDAATIVADEESTADO = 24,
                        ttDIVIDAATIVADEMUNICIPIO = 25,
                        ttCARTAODECREDITO = 31,
                        ttBOLETOPROPOSTA = 32,
                        ttBOLETOAPORTE = 33,
                        ttOUTROS = 99);

type
  TBancoBrasilMulta = class
  private
    Ftipo: TTipoMulta;
    Fdata: TDate;
    Fporcentagem: Double;
    Fvalor: Double;
  public
    public property tipo: TTipoMulta read Ftipo write Ftipo;
    public property data: TDate read Fdata write Fdata;
    public property porcentagem: Double read Fporcentagem write Fporcentagem;
    public property valor: Double read Fvalor write Fvalor;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilJurosMora = class
  private
    Ftipo: TTipoJuros;
    Fporcentagem: Currency;
    Fvalor: Currency;
  public
    public property tipo: TTipoJuros read Ftipo write Ftipo;
    public property porcentagem: Currency read Fporcentagem write Fporcentagem;
    public property valor: Currency read Fvalor write Fvalor;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilTerceiroDesconto = class
  private
    FdataExpiracao: TDate;
    Fporcentagem: Double;
    Fvalor: Double;
    Ftipo: TTipoDesconto;
  public
    public property tipo: TTipoDesconto read Ftipo write Ftipo;
    public property dataExpiracao: TDate read FdataExpiracao write FdataExpiracao;
    public property porcentagem: Double read Fporcentagem write Fporcentagem;
    public property valor: Double read Fvalor write Fvalor;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilSegundoDesconto = class
  private
    FdataExpiracao: TDate;
    Fporcentagem: Double;
    Fvalor: Double;
    Ftipo: TTipoDesconto;
  public
    public property tipo: TTipoDesconto read Ftipo write Ftipo;
    public property dataExpiracao: TDate read FdataExpiracao write FdataExpiracao;
    public property porcentagem: Double read Fporcentagem write Fporcentagem;
    public property valor: Double read Fvalor write Fvalor;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilDesconto = class
  private
    Ftipo: TTipoDesconto;
    FdataExpiracao: Tdate;
    Fporcentagem: Double;
    Fvalor: Double;
  public
    public property tipo: TTipoDesconto read Ftipo write Ftipo;
    public property dataExpiracao: Tdate read FdataExpiracao write FdataExpiracao;
    public property porcentagem: Double read Fporcentagem write Fporcentagem;
    public property valor: Double read Fvalor write Fvalor;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilBeneficiarioFinal = class
  private
    FtipoInscricao: TTipoInscricao;
    FnumeroInscricao: Int64;
    Fnome: string;
  public
    public property tipoInscricao: TTipoInscricao read FtipoInscricao write FtipoInscricao;
    public property numeroInscricao: Int64 read FnumeroInscricao write FnumeroInscricao;
    public property nome: string read Fnome write Fnome;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilPagador = class
  private
    FtipoInscricao: TTipoInscricao;
    FnumeroInscricao: Int64;
    Fnome: string;
    Fendereco: string;
    Fcep: Integer;
    Fcidade: string;
    Fbairro: string;
    Fuf: string;
    Ftelefone: string;
  public
    public property tipoInscricao: TTipoInscricao read FtipoInscricao write FtipoInscricao;
    public property numeroInscricao: Int64 read FnumeroInscricao write FnumeroInscricao;
    public property nome: string read Fnome write Fnome;
    public property endereco: string read Fendereco write Fendereco;
    public property cep: Integer read Fcep write Fcep;
    public property cidade: string read Fcidade write Fcidade;
    public property bairro: string read Fbairro write Fbairro;
    public property uf: string read Fuf write Fuf;
    public property telefone: string read Ftelefone write Ftelefone;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilBeneficiario = class
  private
    Fagencia: Integer;
    FcontaCorrente: Integer;
    FtipoEndereco: Integer;
    Flogradouro: string;
    Fbairro: string;
    Fcidade: string;
    FcodigoCidade: Integer;
    Fuf: string;
    Fcep: Integer;
    FindicadorComprovacao: string;
  public
    public property agencia: Integer read Fagencia write Fagencia;
    public property contaCorrente: Integer read FcontaCorrente write FcontaCorrente;
    public property tipoEndereco: Integer read FtipoEndereco write FtipoEndereco;
    public property logradouro: string read Flogradouro write Flogradouro;
    public property bairro: string read Fbairro write Fbairro;
    public property cidade: string read Fcidade write Fcidade;
    public property codigoCidade: Integer read FcodigoCidade write FcodigoCidade;
    public property uf: string read Fuf write Fuf;
    public property cep: Integer read Fcep write Fcep;
    public property indicadorComprovacao: string read FindicadorComprovacao write FindicadorComprovacao;
    function toJson: TJSONObject;
  end;

type
  TBancoBrasilRetorno = class
    private
      Fnumero: string;
      FnumeroCarteira: Integer;
      FnumeroVariacaoCarteira: Integer;
      FcodigoCliente: Integer;
      FlinhaDigitavel: string;
      FcodigoBarraNumerico: string;
      FnumeroContratoCobranca: Integer;
      Fbeneficiario: TBancoBrasilBeneficiario;
      FqrCode_url: string;
      FqrCode_txId: string;
      FqrCode_emv: string;
    public
      public property numero: string read Fnumero write Fnumero;
      public property numeroCarteira: Integer read FnumeroCarteira write FnumeroCarteira;
      public property numeroVariacaoCarteira: Integer read FnumeroVariacaoCarteira write FnumeroVariacaoCarteira;
      public property codigoCliente: Integer read FcodigoCliente write FcodigoCliente;
      public property linhaDigitavel: string read FlinhaDigitavel write FlinhaDigitavel;
      public property codigoBarraNumerico: string read FcodigoBarraNumerico write FcodigoBarraNumerico;
      public property numeroContratoCobranca: Integer read FnumeroContratoCobranca write FnumeroContratoCobranca;
      public property beneficiario: TBancoBrasilBeneficiario read Fbeneficiario write Fbeneficiario;
      public property qrCode_url  : string read FqrCode_url write FqrCode_url;
      public property qrCode_txId : string read FqrCode_txId write FqrCode_txId;
      public property qrCode_emv  : string read FqrCode_emv write FqrCode_emv;
      function toJson: TJSONObject;
  end;

type
  TBoletoBancoBrasil = class

    const
        URL_HOMOLOCAO = 'https://api.hm.bb.com.br/cobrancas/v2';
        URL_PRODUCAO  = 'https://api.bb.com.br/cobrancas/v2/';

        URL_HOMOLOGACAO_AUTH  = 'https://oauth.hm.bb.com.br';
        URL_PRODUCAO_AUTH     = 'https://oauth.bb.com.br';


    private
      FnumeroConvenio             : Integer;
      FnumeroCarteira             : Integer;
      FindicadorPermissaoRecebimentoParcial: string;
      FvalorOriginal              : Double;
      FindicadorAceiteTituloVencido: string;
      FcodigoModalidade           : TTipoModalidade;
      FnumeroVariacaoCarteira     : Integer;
      ForgaoNegativador           : TOrgaoNegativador;
      FquantidadeDiasNegativacao  : Integer;
      FdescricaoTipoTitulo        : string;
      FcodigoTipoTitulo           : TTipoTitulo;
      FcampoUtilizacaoBeneficiario: string;
      FdataVencimento             : TDate;
      FdataEmissao                : TDate;
      FmensagemBloquetoOcorrencia : string;
      FnumeroTituloBeneficiario   : string;
      FnumeroDiasLimiteRecebimento: Integer;
      FvalorAbatimento            : Double;
      FcodigoAceite               : string;
      FnumeroTituloCliente        : string;
      FquantidadeDiasProtesto     : Integer;
      FindicadorPix               : string;
      FbeneficiarioFinal          : TBancoBrasilBeneficiarioFinal;
      Fpagador                    : TBancoBrasilPagador;
      Fdesconto                   : TBancoBrasilDesconto;
      FsegundoDesconto            : TBancoBrasilSegundoDesconto;
      FterceiroDesconto           : TBancoBrasilTerceiroDesconto;
      FjurosMora                  : TBancoBrasilJurosMora;
      Fmulta                      : TBancoBrasilMulta;
      FclientID                   : string;
      FsecretKey                  : string;
      FErros                      : string;
      FapplicationKey             : string;
      Fboleto                     : TBancoBrasilRetorno;
      Fcertificado: string;
      function GerarToken: string;

    public

      // Dados de Acesso
      public property clientID      : string read FclientID write FclientID;
      public property secretKey     : string read FsecretKey write FsecretKey;
      public property accessToken   : string read GerarToken;
      public property applicationKey: string read FapplicationKey write FapplicationKey;
      public property certificado   : string read Fcertificado write Fcertificado;

      // Dados Simples
      public property numeroConvenio: Integer read FnumeroConvenio write FnumeroConvenio;
      public property numeroCarteira: Integer read FnumeroCarteira write FnumeroCarteira;
      public property numeroVariacaoCarteira: Integer read FnumeroVariacaoCarteira write FnumeroVariacaoCarteira;
      public property codigoModalidade: TTipoModalidade read FcodigoModalidade write FcodigoModalidade;
      public property dataEmissao: TDate read FdataEmissao write FdataEmissao;
      public property dataVencimento: TDate read FdataVencimento write FdataVencimento;
      public property valorOriginal: Double read FvalorOriginal write FvalorOriginal;
      public property valorAbatimento: Double read FvalorAbatimento write FvalorAbatimento;
      public property quantidadeDiasProtesto: Integer read FquantidadeDiasProtesto write FquantidadeDiasProtesto;
      public property quantidadeDiasNegativacao: Integer read FquantidadeDiasNegativacao write FquantidadeDiasNegativacao;
      public property orgaoNegativador: TOrgaoNegativador read ForgaoNegativador write ForgaoNegativador;
      public property indicadorAceiteTituloVencido: string read FindicadorAceiteTituloVencido write FindicadorAceiteTituloVencido;
      public property numeroDiasLimiteRecebimento: Integer read FnumeroDiasLimiteRecebimento write FnumeroDiasLimiteRecebimento;
      public property codigoAceite: string read FcodigoAceite write FcodigoAceite;
      public property codigoTipoTitulo: TTipoTitulo read FcodigoTipoTitulo write FcodigoTipoTitulo;
      public property descricaoTipoTitulo: string read FdescricaoTipoTitulo write FdescricaoTipoTitulo;
      public property indicadorPermissaoRecebimentoParcial: string read FindicadorPermissaoRecebimentoParcial write FindicadorPermissaoRecebimentoParcial;
      public property numeroTituloBeneficiario: string read FnumeroTituloBeneficiario write FnumeroTituloBeneficiario;
      public property campoUtilizacaoBeneficiario: string read FcampoUtilizacaoBeneficiario write FcampoUtilizacaoBeneficiario;
      public property numeroTituloCliente: string read FnumeroTituloCliente write FnumeroTituloCliente;
      public property mensagemBloquetoOcorrencia: string read FmensagemBloquetoOcorrencia write FmensagemBloquetoOcorrencia;
      public property indicadorPix: string read FindicadorPix write FindicadorPix;

      // Objetos
      public property desconto: TBancoBrasilDesconto read Fdesconto write Fdesconto;
      public property segundoDesconto: TBancoBrasilSegundoDesconto read FsegundoDesconto write FsegundoDesconto;
      public property terceiroDesconto: TBancoBrasilTerceiroDesconto read FterceiroDesconto write FterceiroDesconto;
      public property jurosMora: TBancoBrasilJurosMora read FjurosMora write FjurosMora;
      public property multa: TBancoBrasilMulta read Fmulta write Fmulta;
      public property pagador: TBancoBrasilPagador read Fpagador write Fpagador;
      public property beneficiarioFinal: TBancoBrasilBeneficiarioFinal read FbeneficiarioFinal write FbeneficiarioFinal;

      // Boleto
      public property boleto: TBancoBrasilRetorno read Fboleto write Fboleto;

      // Mensagem Erro
      public property erros: string read FErros write FErros;

      // Funcoes
      function    toJson    : TJSONObject;
      function    fromJson( jsonObj: TJSONObject ) : Boolean;
      function    Registrar : Boolean;
      constructor Create;
      destructor  Destroy; Override;

      // Conversoes
      function    strToModalidade ( Value: string ) : TTipoModalidade;
      function    strToDesconto   ( Value: string ) : TTipoDesconto;
      function    strToJuros      ( Value: string ) : TTipoJuros;
      function    strToMulta      ( Value: string ) : TTipoMulta;
      function    strToInscricao  ( Value: string ) : TTipoInscricao;
      function    strToData       ( Value: string ) : TDate;

  end;


implementation



function TBancoBrasilJurosMora.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipo'        , TJSONNumber.Create( Integer( tipo ) ) );
    Result.AddPair( 'porcentagem' , porcentagem.ToString.Replace('.','').Replace(',','.') ) ;
    Result.AddPair( 'valor'       , valor.ToString.Replace('.','').Replace(',','.') ) ;

end;



function TBancoBrasilMulta.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;

    Result.AddPair( 'tipo'        , TJSONNumber.Create( Integer( tipo ) ) );
    Result.AddPair( 'porcentagem' , porcentagem.ToString.Replace('.','').Replace(',','.') ) ;
    Result.AddPair( 'valor'       , valor.ToString.Replace('.','').Replace(',','.') ) ;

    try
        Result.AddPair( 'data' , FormatDateTime( 'dd.MM.yyyy' , data )  );
    except
        Result.AddPair( 'data' , '' );
    end;

end;



function TBancoBrasilTerceiroDesconto.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipo'        , TJSONNumber.Create( Integer( tipo ) ) );

    try
        Result.AddPair( 'dataExpiracao' , FormatDateTime( 'dd.MM.yyyy' , dataExpiracao )  );
    except
        Result.AddPair( 'dataExpiracao' , '' );
    end;

    if tipo = tdFixo then
        Result.AddPair( 'valor'       , valor.ToString.Replace('.','').Replace(',','.') )
    else if tipo = tdPorcentagem then
        Result.AddPair( 'porcentagem' , porcentagem.ToString.Replace('.','').Replace(',','.') ) ;

end;




function TBancoBrasilSegundoDesconto.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipo'        , TJSONNumber.Create( Integer( tipo ) ) );

    try
        Result.AddPair( 'dataExpiracao' , FormatDateTime( 'dd.MM.yyyy' , dataExpiracao )  );
    except
        Result.AddPair( 'dataExpiracao' , '' );
    end;

    if tipo = tdFixo then
        Result.AddPair( 'valor'       , valor.ToString.Replace('.','').Replace(',','.') )
    else if tipo = tdPorcentagem then
        Result.AddPair( 'porcentagem' , porcentagem.ToString.Replace('.','').Replace(',','.') ) ;

end;



function TBancoBrasilDesconto.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipo'        , TJSONNumber.Create( Integer( tipo ) ) );

    try
        Result.AddPair( 'dataExpiracao' , FormatDateTime( 'dd.MM.yyyy' , dataExpiracao )  );
    except
        Result.AddPair( 'dataExpiracao' , '' );
    end;

    if tipo = tdFixo then
        Result.AddPair( 'valor'       , valor.ToString.Replace('.','').Replace(',','.') )
    else if tipo = tdPorcentagem then
        Result.AddPair( 'porcentagem' , porcentagem.ToString.Replace('.','').Replace(',','.') ) ;

end;


function TBancoBrasilBeneficiarioFinal.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipoInscricao'   , TJSONNumber.Create( Integer( tipoInscricao ) ) );
    Result.AddPair( 'numeroInscricao' , TJSONNumber.Create( numeroInscricao ) );
    Result.AddPair( 'nome' , nome );

end;


function TBancoBrasilPagador.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'tipoInscricao'   , TJSONNumber.Create( Integer( tipoInscricao ) ) );
    Result.AddPair( 'numeroInscricao' , TJSONNumber.Create( numeroInscricao ) );
    Result.AddPair( 'nome'      , nome );
    Result.AddPair( 'endereco'  , endereco );
    Result.AddPair( 'cep'       , TJSONNumber.Create(cep) );
    Result.AddPair( 'cidade'    , cidade );
    Result.AddPair( 'bairro'    , bairro );
    Result.AddPair( 'uf'        , uf );
    Result.AddPair( 'telefone'  , telefone );

end;


constructor TBoletoBancoBrasil.Create;
begin

    // Cria os Objetos
    desconto            := TBancoBrasilDesconto.Create;
    segundoDesconto     := TBancoBrasilSegundoDesconto.Create;
    terceiroDesconto    := TBancoBrasilTerceiroDesconto.Create;
    jurosMora           := TBancoBrasilJurosMora.Create;
    multa               := TBancoBrasilMulta.Create;
    pagador             := TBancoBrasilPagador.Create;
    beneficiarioFinal   := TBancoBrasilBeneficiarioFinal.Create;
    boleto              := TBancoBrasilRetorno.Create;
    boleto.beneficiario := TBancoBrasilBeneficiario.Create;

    // FConfiguraão Inicial
    codigoTipoTitulo  := ttDUPLICATAMERCANTIL;
    codigoAceite      := 'A';
    indicadorAceiteTituloVencido:= 'N';
    indicadorPix      := 'S';

end;


destructor TBoletoBancoBrasil.Destroy;
begin

    // Destroy os Objetos
    desconto.DisposeOf;
    segundoDesconto.DisposeOf;
    terceiroDesconto.DisposeOf;
    jurosMora.DisposeOf;
    multa.DisposeOf;
    pagador.DisposeOf;
    beneficiarioFinal.DisposeOf;

    if Assigned(boleto) then
        boleto.DisposeOf;

    inherited;
end;



function TBoletoBancoBrasil.GerarToken: string;
var
    Resp      : IResponse;
    jsonObj   : TJSONObject;
begin

    // Resultado
    Result  := '';
    erros   := '';

    if clientID.Trim = '' then
        Exit;

    if secretKey.Trim = '' then
        exit;

    // Gera o Token
    Resp    :=  TRequest.New.BaseURL(URL_HOMOLOGACAO_AUTH)
                .Resource('/oauth/token')
                .ContentType('application/x-www-form-urlencoded')
                .BasicAuthentication( FClientId , FSecretKey )
                .AddBody('grant_type=client_credentials')
                .AddBody('&')
                .AddBody('scope=cobrancas.boletos-requisicao cobrancas.boletos-info')
                .Timeout(10000)
                .Post;

    // Se pegou retorno
    if Resp.StatusCode < 210 then
        begin

            // Json
            jsonObj := TJSONObject.Create;
            jsonObj := TJSONObject.ParseJSONValue( Resp.Content ) as TJSONObject;

            // Retorna o Token
            Result  := jsonObj.GetValue<string>('access_token','');

        end
    else
        begin
            erros := 'Falha ao gerar access token';
        end;


end;



function TBoletoBancoBrasil.fromJson( jsonObj: TJSONObject ) : Boolean;
var
    jsonDesconto        : TJSONObject;
    jsonSegundoDesconto : TJSONObject;
    jsonTerceiroDesconto: TJSONObject;
    jsonJuros           : TJSONObject;
    jsonMulta           : TJSONObject;
    jsonPagador         : TJSONObject;
    jsonBeneficiario    : TJSONObject;
    jsonConfiguracao    : TJSONObject;
begin

    // False
    Result  := False;
    erros   := '';

    // Try
    try

        // Dados de Acesso
        jsonConfiguracao  :=  jsonObj.GetValue<TJSONObject>('configuracao',nil);
        if jsonConfiguracao <> nil then
            begin
                clientID      := jsonConfiguracao.GetValue<string>('clientid'   ,'');
                secretKey     := jsonConfiguracao.GetValue<string>('secretkey'  ,'');
                applicationKey:= jsonConfiguracao.GetValue<string>('application','');
                certificado   := jsonConfiguracao.GetValue<string>('certificado','');
            end;

        // Dados Principais
        numeroConvenio          := jsonObj.GetValue<integer>('numeroConvenio',0);
        numeroCarteira          := jsonObj.GetValue<integer>('numeroCarteira',0);
        numeroVariacaoCarteira  := jsonObj.GetValue<integer>('numeroVariacaoCarteira',0);
        codigoModalidade        := strToModalidade(jsonObj.GetValue<string>('modalidade','simples'));
        dataEmissao             := strToData( jsonObj.GetValue<string>('dataEmissao','01.01.1900') );
        dataVencimento          := strToData( jsonObj.GetValue<string>('dataVencimento','01.01.1900') );
        valorOriginal           := jsonObj.GetValue<Double>('valor',0 );
        codigoAceite            := jsonObj.GetValue<string>('aceite','A');
        codigoTipoTitulo        := TTipoTitulo( jsonObj.GetValue<integer>('tipoTitulo',2) );
        indicadorPermissaoRecebimentoParcial  := jsonObj.GetValue<string>('recebeParcial','N');
        numeroTituloCliente     :=  jsonObj.GetValue<string>('numeroTituloCliente','');
        valorAbatimento         :=  jsonObj.GetValue<Double>('valorAbatimento',0 );
        quantidadeDiasProtesto  := jsonObj.GetValue<integer>('quantidadeDiasProtesto',0);
        indicadorAceiteTituloVencido  := jsonObj.GetValue<string>('recebeVencido','N');
        numeroDiasLimiteRecebimento   := jsonObj.GetValue<integer>('diasLimiteVencido',0);
        descricaoTipoTitulo           := jsonObj.GetValue<string>('descricaoTipoTitulo','');
        numeroTituloBeneficiario      := jsonObj.GetValue<string>('numeroTitulo','');
        campoUtilizacaoBeneficiario   := jsonObj.GetValue<string>('utilizacaoBeneficiario','');
        mensagemBloquetoOcorrencia    := jsonObj.GetValue<string>('mensagemOcorrencia','');
        quantidadeDiasNegativacao     := jsonObj.GetValue<integer>('quantidadeDiasNegativacao',0);
        orgaoNegativador              := TOrgaoNegativador( jsonObj.GetValue<integer>('orgaoNegativador',0) );

        // Desconto
        jsonDesconto  :=  jsonObj.GetValue<TJSONObject>('desconto',nil);
        if jsonDesconto <> nil then
          begin
              desconto.tipo         := strToDesconto( jsonDesconto.GetValue<string>('tipo','') );
              desconto.porcentagem  := jsonDesconto.GetValue<Double>('porcentagem',0 );
              desconto.valor        := jsonDesconto.GetValue<Double>('valor',0 );
              desconto.dataExpiracao:= strToData( jsonDesconto.GetValue<string>('dataExpiracao','01.01.1900' ) );
          end;

        // Segundo Desconto
        jsonSegundoDesconto :=  jsonObj.GetValue<TJSONObject>('segundoDesconto',nil);
        if jsonSegundoDesconto <> nil then
            begin
                segundoDesconto.tipo         := desconto.tipo;
                segundoDesconto.porcentagem  := jsonSegundoDesconto.GetValue<Double>('porcentagem',0 );
                segundoDesconto.valor        := jsonSegundoDesconto.GetValue<Double>('valor',0 );
                segundoDesconto.dataExpiracao:= strToData( jsonDesconto.GetValue<string>('dataExpiracao','01.01.1900' ) );
            end;

        // Terceiro Desconto
        jsonTerceiroDesconto :=  jsonObj.GetValue<TJSONObject>('terceiroDesconto',nil);
        if jsonTerceiroDesconto <> nil then
            begin
                terceiroDesconto.tipo         := desconto.tipo;
                terceiroDesconto.porcentagem  := jsonTerceiroDesconto.GetValue<Double>('porcentagem',0 );
                terceiroDesconto.valor        := jsonTerceiroDesconto.GetValue<Double>('valor',0 );
                terceiroDesconto.dataExpiracao:= strToData( jsonDesconto.GetValue<string>('dataExpiracao','01.01.1900' ) );
            end;

        // Juros
        jsonJuros :=  jsonObj.GetValue<TJSONObject>('juros',nil);
        if jsonJuros <> nil then
            begin
                jurosMora.tipo         := strToJuros( jsonJuros.GetValue<string>('tipo','nenhum') );
                jurosMora.porcentagem  := jsonJuros.GetValue<Double>('porcentagem',0 );
                jurosMora.valor        := jsonJuros.GetValue<Double>('valor',0 );
            end;

        // Multa
        jsonMulta :=  jsonObj.GetValue<TJSONObject>('multa',nil);
        if jsonMulta <> nil then
            begin
                multa.tipo         := strToMulta( jsonMulta.GetValue<string>('tipo','nenhum') );
                multa.porcentagem  := jsonMulta.GetValue<Double>('porcentagem',0 );
                multa.valor        := jsonMulta.GetValue<Double>('valor',0 );
                multa.data         := strToData( jsonMulta.GetValue<string>('data','01.01.1900' ) );
            end;

        // Pagador
        jsonPagador := jsonObj.GetValue<TJSONObject>('pagador',nil);
        if jsonPagador <> nil then
            begin
                pagador.tipoInscricao   := strToInscricao( jsonPagador.GetValue<string>('tipoInscricao','cpf') );
                pagador.numeroInscricao := jsonPagador.GetValue<int64>('numeroInscricao',0);
                pagador.nome            := jsonPagador.GetValue<string>('nome','');
                pagador.endereco        := jsonPagador.GetValue<string>('endereco','');
                pagador.cep             := jsonPagador.GetValue<integer>('cep',0);
                pagador.cidade          := jsonPagador.GetValue<string>('cidade','');
                pagador.bairro          := jsonPagador.GetValue<string>('bairro','');
                pagador.uf              := jsonPagador.GetValue<string>('uf','');
                pagador.telefone        := jsonPagador.GetValue<string>('telefone','');
            end;

        // beneficiario Final
        jsonBeneficiario  := jsonObj.GetValue<TJSONObject>('beneficiario',nil);
        if jsonBeneficiario <> nil then
            begin
                beneficiarioFinal.tipoInscricao   := strToInscricao( jsonBeneficiario.GetValue<string>('tipoInscricao','cpf') );
                beneficiarioFinal.numeroInscricao := jsonBeneficiario.GetValue<int64>('numeroInscricao',0);
                beneficiarioFinal.nome            := jsonBeneficiario.GetValue<string>('nome','');
            end;

        // Resultad
        Result  := True;


    except on e:Exception do
        begin
            erros := 'Falha ao converter Json';
        end;
    end;

end;



function TBoletoBancoBrasil.Registrar: Boolean;
var
    Resp      : IResponse;
    jsonObj   : TJSONObject;
    token     : string;
begin

    // Resultado
    Result  := False;

    // Erro
    erros   := '';

    // Gerar o Token
    token   := accessToken;

    // Verifica se tem token
    if token = '' then
        Exit;

    ShowMessage(self.toJson.ToString );

    // Faz o Request
    Resp    :=   TRequest.New.BaseURL(URL_HOMOLOCAO)
                .Resource('/boletos')
                .AddParam('gw-dev-app-key', applicationKey)
                .ContentType('application/json')
                .TokenBearer(token)
                .AddBody( self.toJson.ToString )
                .Timeout(10000)
                .Post;

    // Se deu OK
    if Resp.StatusCode = 201 then
        begin

            // Json
            jsonObj := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;

            // Se tem o Boleo
            if not Assigned(boleto) then
                boleto  := TBancoBrasilRetorno.Create;

            // Coloca os dadosdo boleto
            boleto.numero                 := jsonObj.GetValue<string>('numero','');
            boleto.numeroCarteira         := jsonObj.GetValue<integer>('numeroCarteira',0);
            boleto.numeroVariacaoCarteira := jsonObj.GetValue<integer>('numeroVariacaoCarteira',0);
            boleto.codigoCliente          := jsonObj.GetValue<integer>('codigoCliente',0);
            boleto.linhaDigitavel         := jsonObj.GetValue<string>('linhaDigitavel','');
            boleto.codigoBarraNumerico    := jsonObj.GetValue<string>('codigoBarraNumerico','');
            boleto.numeroContratoCobranca := jsonObj.GetValue<Integer>('numeroContratoCobranca',0);

            // Coloca os dados do pix
            if indicadorPix = 'S' then
                begin
                    boleto.qrCode_url := jsonObj.GetValue<TJSONObject>('qrCode',nil).GetValue<string>('url' ,'');
                    boleto.qrCode_txId:= jsonObj.GetValue<TJSONObject>('qrCode',nil).GetValue<string>('txId','');
                    boleto.qrCode_emv := jsonObj.GetValue<TJSONObject>('qrCode',nil).GetValue<string>('emv' ,'');
                end;

            // Dados do beneficiario
            if not Assigned(boleto.beneficiario) then
                boleto.beneficiario := TBancoBrasilBeneficiario.Create;
            with boleto.beneficiario do
                begin
                    agencia       := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<integer>('agencia' ,0);
                    contaCorrente := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<integer>('contaCorrente' ,0);
                    tipoEndereco  := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<integer>('tipoEndereco' ,0);
                    logradouro    := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<string>('logradouro' ,'');
                    bairro        := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<string>('bairro' ,'');
                    cidade        := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<string>('cidade' ,'');
                    codigoCidade  := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<integer>('codigoCidade' ,0);
                    uf            := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<string>('uf' ,'');
                    cep           := jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<integer>('cep',0);
                    indicadorComprovacao:= jsonObj.GetValue<TJSONObject>('beneficiario',nil).GetValue<string>('indicadorComprovacao' ,'');
                end;

            // Resultado
            Result  := True;

        end
    else
        begin
            boleto  := nil;
            erros := Resp.Content;
        end;

end;



function TBoletoBancoBrasil.strToData(Value: string): TDate;
begin
    if value = '' then
        Result  := EncodeDate( 1900,01,01 )
    else
        Result  := EncodeDate(  StrToInt( Copy( Value, 7 , 4 ) ) ,
                                StrToInt( Copy( Value, 4 , 2 ) ) ,
                                StrToInt( Copy( Value, 1 , 2 ) ) );
end;



function TBoletoBancoBrasil.strToDesconto(Value: string): TTipoDesconto;
begin

    if Value = 'nenhum' then
        Result := TTipoDesconto.tdSemDesconto
    else if Value = 'fixo' then
        Result := TTipoDesconto.tdFixo
    else if Value = 'porcentagem' then
        Result := TTipoDesconto.tdPorcentagem
    else if Value = 'diario' then
        Result := TTipoDesconto.tdDiario
    else
        Result := TTipoDesconto.tdSemDesconto;

end;



function TBoletoBancoBrasil.strToInscricao(Value: string): TTipoInscricao;
begin

    if value = 'cpf' then
      result  := tiCPF
    else
      result  := tiCNPJ;

end;



function TBoletoBancoBrasil.strToJuros(Value: string): TTipoJuros;
begin

    if Value = 'nenhum' then
        Result  := tjDispensar
    else if Value = 'diario' then
        Result  := tjDiario
    else if value = 'mensal' then
        Result  := tjMensal
    else
        Result  := tjDispensar;

end;



function TBoletoBancoBrasil.strToModalidade(Value: string): TTipoModalidade;
begin

  if value <> 'simples' then
      result  := tpmVinculada
  else
      Result  := tpmSimples;

end;



function TBoletoBancoBrasil.strToMulta(Value: string): TTipoMulta;
begin

    if Value = 'nenhum' then
        Result  := tmDispensar
    else if Value = 'valor' then
        Result  := tmValor
    else if value = 'porcentagem' then
        Result  := tmPorcentagem
    else
        Result  := tmDispensar;

end;



function TBoletoBancoBrasil.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;

    Result.AddPair('numeroConvenio' , TJSONNumber.Create( numeroConvenio ) );
    Result.AddPair('numeroCarteira' , TJSONNumber.Create( numeroCarteira ) );
    Result.AddPair('numeroVariacaoCarteira' , TJSONNumber.Create( numeroVariacaoCarteira ) );
    Result.AddPair('codigoModalidade' , TJSONNumber.Create( Integer( codigoModalidade ) ) ) ;
    Result.AddPair('dataEmissao' , FormatDateTime('dd.MM.yyyy' , dataEmissao ) );
    Result.AddPair('dataVencimento', FormatDateTime('dd.MM.yyyy', dataVencimento ) );
    Result.AddPair('valorOriginal' , valorOriginal.ToString.Replace('.','').Replace(',','.') );
    Result.AddPair('codigoAceite' , codigoAceite );
    Result.AddPair('codigoTipoTitulo' , TJSONNumber.Create( Integer ( codigoTipoTitulo ) ) );
    Result.AddPair('indicadorPermissaoRecebimentoParcial' , indicadorPermissaoRecebimentoParcial );
    Result.AddPair('numeroTituloCliente' , numeroTituloCliente );

    // Valor Abatimento
    if valorAbatimento > 0 then
        Result.AddPair('valorAbatimento', valorAbatimento.ToString.Replace('.','').Replace(',','.') );

    // Protesto
    if quantidadeDiasProtesto > 0 then
        Result.AddPair('quantidadeDiasProtesto', TJSONNumber.Create( quantidadeDiasProtesto ) );

    // Titulo Vencido
    if indicadorAceiteTituloVencido <> '' then
      Result.AddPair('indicadorAceiteTituloVencido', indicadorAceiteTituloVencido );

    // Dia Limite
    if numeroDiasLimiteRecebimento > 0 then
        Result.AddPair('numeroDiasLimiteRecebimento', TJSONNumber.Create(numeroDiasLimiteRecebimento ) );

    // Descricao
    if descricaoTipoTitulo <> '' then
        Result.AddPair('descricaoTipoTitulo' , descricaoTipoTitulo );

    // Titulo Beneficiario
    if numeroTituloBeneficiario <> '' then
        Result.AddPair('numeroTituloBeneficiario' , numeroTituloBeneficiario );

    // Campo Beneficiario
    if campoUtilizacaoBeneficiario <> '' then
       Result.AddPair('campoUtilizacaoBeneficiario' , campoUtilizacaoBeneficiario );

    // Mensagem
    if mensagemBloquetoOcorrencia <> '' then
        Result.AddPair('mensagemBloquetoOcorrencia' , mensagemBloquetoOcorrencia );

    // Negativacao
    if quantidadeDiasNegativacao > 0  then
        begin
            Result.AddPair('quantidadeDiasNegativacao' , TJSONNumber.Create( quantidadeDiasNegativacao ) );
            Result.AddPair('orgaoNegativador', TJSONNumber.Create( Integer( orgaoNegativador ) ) );
        end;

    // Se tem desconto
    if desconto.tipo <> tdSemDesconto then
        Result.AddPair('desconto' , desconto.toJson );

    // Se tem desgundo desconto
    if ( segundoDesconto.porcentagem > 0 ) or (segundoDesconto.valor > 0 ) then
      Result.AddPair('segundoDesconto' , segundoDesconto.toJson );

    // Se tem terceiro desconto
    if ( terceiroDesconto.porcentagem > 0 ) or (terceiroDesconto.valor > 0 ) then
      Result.AddPair('terceiroDesconto' , terceiroDesconto.toJson );

    // Se Tem Juros
    if jurosMora.tipo <> tjDispensar then
      Result.AddPair('jurosMora' , jurosMora.toJson );

    // Se tem Multa
    if multa.tipo <> tmDispensar then
      Result.AddPair('multa' , multa.toJson );

    Result.AddPair('pagador', pagador.toJson );
    Result.AddPair('beneficiarioFinal' , beneficiarioFinal.toJson );
    Result.AddPair('indicadorPix' , indicadorPix );

end;



function TBancoBrasilRetorno.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair('numero',numero);
    Result.AddPair('numeroCarteira', TJSONNumber.Create(numeroCarteira));
    Result.AddPair('numeroVariacaoCarteira', TJSONNumber.Create(numeroVariacaoCarteira));
    Result.AddPair('codigoCliente', TJSONNumber.Create(codigoCliente));
    Result.AddPair('linhaDigitavel', linhaDigitavel);
    Result.AddPair('codigoBarraNumerico', codigoBarraNumerico);
    Result.AddPair('numeroContratoCobranca', TJSONNumber.Create(numeroContratoCobranca) );
    Result.AddPair('qrCode_url', qrCode_url);
    Result.AddPair('qrCode_txId', qrCode_txId);
    Result.AddPair('qrCode_emv', qrCode_emv);
    Result.AddPair('beneficiario', beneficiario.toJson);

end;


function TBancoBrasilBeneficiario.toJson: TJSONObject;
begin

    Result  := TJSONObject.Create;
    Result.AddPair( 'agencia' , TJSONNumber.Create( agencia ) );
    Result.AddPair( 'contaCorrente' , TJsonNumber.Create( contaCorrente ) );
    Result.AddPair( 'tipoEndereco'  , TJSONNumber.Create( tipoEndereco ) );
    Result.AddPair( 'logradouro'    , logradouro );
    Result.AddPair( 'bairro'        , bairro );
    Result.AddPair( 'cidade'        , cidade );
    Result.AddPair( 'codigoCidade'  , TJSONNumber.Create(codigoCidade) );
    Result.AddPair( 'cep'           , TJSONNumber.Create(cep) );
    Result.AddPair( 'uf'            , uf );
    Result.AddPair( 'indicadorComprovacao'  , indicadorCOmprovacao );

end;

end.
