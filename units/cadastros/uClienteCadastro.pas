unit uClienteCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmClienteCadastro = class(TForm)
    pnlBottom: TPanel;
    btnSalvar: TSpeedButton;
    btnFechar: TSpeedButton;
    pnlDados: TPanel;
    QCliente: TFDQuery;
    dsCliente: TDataSource;
    QClienteID: TIntegerField;
    QClienteNOME: TStringField;
    QClienteENDERECO: TStringField;
    QClienteBAIRRO: TStringField;
    QClienteCEP: TStringField;
    QClienteIDMUNICIPIO: TIntegerField;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    Edit1: TEdit;
    Label7: TLabel;
    QClienteCIDADE: TStringField;
    btnPesquisarMunicipio: TSpeedButton;
    btnLimparMunicipio: TSpeedButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBEdit6Exit(Sender: TObject);
    procedure btnLimparMunicipioClick(Sender: TObject);
    procedure btnPesquisarMunicipioClick(Sender: TObject);
  private
    FId: Integer;
    procedure SalvarDados;
    procedure ValidarCamposObrigatorio;
    procedure CarregarDados;
    procedure CarregarCidade(AIDMunicipio: Integer);
    { Private declarations }
  public
    { Public declarations }
    property Id: Integer read FId write FId;
  end;

var
  frmClienteCadastro: TfrmClienteCadastro;

implementation

  uses
    uPesquisarMunicipio,
    uDmGlobal;

{$R *.dfm}

procedure TfrmClienteCadastro.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClienteCadastro.btnLimparMunicipioClick(Sender: TObject);
begin
  QClienteIDMUNICIPIO.Clear;
  Edit1.Clear;
end;

procedure TfrmClienteCadastro.btnPesquisarMunicipioClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesquisarMunicipios, frmPesquisarMunicipios);
  try
    frmPesquisarMunicipios.showModal;

    if(frmPesquisarMunicipios.ModalResult = mrOk)then
    begin
      QClienteIDMUNICIPIO.AsInteger := frmPesquisarMunicipios.QMunicipiosID.asInteger;
      Edit1.Text := frmPesquisarMunicipios.QMunicipiosCIDADE.AsString;
    end;
  finally
    FreeAndNil(frmPesquisarMunicipios);
  end;
end;

procedure TfrmClienteCadastro.btnSalvarClick(Sender: TObject);
begin
  ValidarCamposObrigatorio;
  SalvarDados;
end;

procedure TfrmClienteCadastro.FormShow(Sender: TObject);
begin
  CarregarDados;
  if(FId > 0)then
    QCliente.Edit
  else
    QCliente.Append;

  QClienteNOME.FocusControl;
end;

procedure TfrmClienteCadastro.CarregarDados;
begin
  QCliente.Close;
  QCliente.SQL.Clear;
  QCliente.SQL.Add('SELECT * FROM CLIENTE');
  QCliente.SQL.Add(' WHERE ID = :ID');
  QCliente.ParamByName('ID').AsInteger := FId;
  QCliente.Open;

  CarregarCidade(QClienteIDMUNICIPIO.AsInteger);
end;

procedure TfrmClienteCadastro.DBEdit6Exit(Sender: TObject);
begin
  if(TDBEdit(Sender).Text <> '')then
    CarregarCidade(StrToInt(TDBEdit(Sender).Text));
end;

procedure TfrmClienteCadastro.CarregarCidade(AIDMunicipio: Integer);
begin
  DmGlobal.QAux1.Close;
  DmGlobal.QAux1.SQL.Clear;
  DmGlobal.QAux1.SQL.Add('SELECT CIDADE FROM MUNICIPIO');
  DmGlobal.QAux1.SQL.Add(' WHERE ID = :ID');
  DmGlobal.QAux1.ParamByName('ID').AsInteger := AIDMunicipio;
  DmGlobal.QAux1.Open;
  Edit1.Text := DmGlobal.QAux1.FieldByName('CIDADE').AsString;
end;

procedure TfrmClienteCadastro.ValidarCamposObrigatorio;
begin
  if(QClienteIDMUNICIPIO.IsNull)then
  begin
    ShowMessage('Preencha o município');
    Abort;
  end;
end;

procedure TfrmClienteCadastro.SalvarDados;
begin
  QCliente.Post;
  Close;
end;

end.
