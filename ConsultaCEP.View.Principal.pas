unit ConsultaCEP.View.Principal;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  Firedac.DApt,

  RESTRequest4D,
  uFormat,
  uFancyDialog,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrmPrincipal = class(TForm)
    TopHeader: TRectangle;
    CirclePesquisa: TCircle;
    Image1: TImage;
    Rectangle1: TRectangle;
    edtCEP: TEdit;
    StyleBook1: TStyleBook;
    RectEnd: TRectangle;
    lblEndereco: TLabel;
    RectBairro: TRectangle;
    lblBairoo: TLabel;
    RectCidade: TRectangle;
    lblCidade: TLabel;
    RectComplemento: TRectangle;
    lblComplemento: TLabel;
    RectUF: TRectangle;
    lblUF: TLabel;
    lblTitulo: TLabel;
    procedure CirclePesquisaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure edtCEPTyping(Sender: TObject);
  private
    procedure BuscaCEP(CEP : string);
    procedure PopulaLabels;
    procedure TamanhoMinimodoFrmPrincipal;
    { Private declarations }
  public
    { Public declarations }
    var
    Fancy : TFancyDialog;
    TabCEP : TFDMemTable;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.BuscaCEP(CEP : string);
var
 LResponse : IResponse;
 begin
  TabCEP := TFDMemTable.Create(nil);

  LResponse := TRequest.New.BaseURL('https://viacep.com.br/ws')
              .Resource(cep + '/json' )
              .Accept('Application/json')
              .DataSetAdapter(TabCEP)
              .Get;

     if LResponse.StatusCode <> 200 then
     raise Exception.Create(LResponse.Content);

     PopulaLabels;
 end;

procedure TFrmPrincipal.CirclePesquisaClick(Sender: TObject);
begin
  if SomenteNumero(edtCEP.Text).Length <> 8 then
  begin
     Fancy.Show(TIconDialog.Warning, 'Erro', 'O CEP informado está invárido', 'Ok');
     Exit
  end
  else
  BuscaCEP(somentenumero(edtCEP.Text));
end;

procedure TFrmPrincipal.edtCEPTyping(Sender: TObject);
begin
   Formatar(edtCEP,CEP);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    Fancy := TFancyDialog.Create(FrmPrincipal);
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
   Fancy.DisposeOf;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
   TamanhoMinimodoFrmPrincipal;
end;

procedure TFrmPrincipal.PopulaLabels;
begin
  with TabCEP do
  begin
      if FieldByName('logradouro').AsString = '' then
         lblEndereco.Text := 'Indisponível'
      else
      lblEndereco.Text := FieldByName('logradouro').AsString;

      if FieldByName('bairro').AsString = '' then
        lblBairoo.Text := 'Bairo - Indisponível'
      else
      lblBairoo.Text := FieldByName('bairro').AsString;

      if FieldByName('complemento').AsString =  '' then
         lblComplemento.Text :=  'Complemento - Indisponivel'
      else
      lblComplemento.Text := FieldByName('complemento').AsString;

      if FieldByName('localidade').Asstring = '' then
         lblCidade.Text := 'Cidade - Indisponível'
      else
      lblCidade.Text := FieldByName('localidade').Asstring;

      if FieldByName('uf').Asstring = '' then
         lblUF.Text := 'Uf - Indisponível'
      else
      lblUF.Text := FieldByName('uf').AsString;

  end;

    FreeAndNil(TabCEP);
end;


procedure TFrmPrincipal.TamanhoMinimodoFrmPrincipal;
begin
    if FrmPrincipal.Width < 377 then
       FrmPrincipal.Width := 377;
end;

end.
