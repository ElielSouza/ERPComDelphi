unit uProdutoCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmProdutoCadastro = class(TForm)
    pnlBottom: TPanel;
    btnSalvar: TSpeedButton;
    btnFechar: TSpeedButton;
    Panel1: TPanel;
    dsProduto: TDataSource;
    QProduto: TFDQuery;
    QProdutoID: TIntegerField;
    QProdutoDESCRICAO: TStringField;
    QProdutoPRECO: TCurrencyField;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FId: Integer;
    procedure SalvarDados;
    procedure ValidarCamposObrigatorio;
    procedure CarregarDados;
    { Private declarations }
  public
    { Public declarations }
    property Id: Integer read FId write FId;
  end;

var
  frmProdutoCadastro: TfrmProdutoCadastro;

implementation
  uses
    uDmGlobal;
{$R *.dfm}

procedure TfrmProdutoCadastro.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutoCadastro.btnSalvarClick(Sender: TObject);
begin
  ValidarCamposObrigatorio;
  SalvarDados;
end;

procedure TfrmProdutoCadastro.CarregarDados;
begin
  QProduto.Close;
  QProduto.SQL.Clear;
  QProduto.SQL.Add('SELECT * FROM PRODUTO');
  QProduto.SQL.Add(' WHERE ID = :ID');
  QProduto.ParamByName('ID').AsInteger := FId;
  QProduto.Open;
end;

procedure TfrmProdutoCadastro.FormShow(Sender: TObject);
begin
  CarregarDados;
  if(FId > 0)then
    QProduto.Edit
  else
    QProduto.Append;

  QProdutoDESCRICAO.FocusControl;
end;

procedure TfrmProdutoCadastro.SalvarDados;
begin
  QProduto.Post;
  Close;
end;

procedure TfrmProdutoCadastro.ValidarCamposObrigatorio;
begin
  if(QProdutoDESCRICAO.IsNull)then
  begin
    ShowMessage('Preencha a descrição do produto');
    Abort;
  end;
end;

end.
