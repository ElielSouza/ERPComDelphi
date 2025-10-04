unit uPesquisarProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPesquisarProduto = class(TForm)
    pnlContainer: TPanel;
    Panel2: TPanel;
    btnSelecionar: TSpeedButton;
    btnFechar: TSpeedButton;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    QProdutos: TFDQuery;
    dsProdutos: TDataSource;
    QProdutosID: TIntegerField;
    QProdutosDESCRICAO: TStringField;
    QProdutosPRECO: TCurrencyField;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPesquisarProduto: TfrmPesquisarProduto;

implementation

{$R *.dfm}

procedure TfrmPesquisarProduto.btnFecharClick(Sender: TObject);
begin
  Self.ModalResult := mrClose;
end;

procedure TfrmPesquisarProduto.btnPesquisarClick(Sender: TObject);
begin
  try
    // Monta a base da consulta
    QProdutos.Close;
    QProdutos.SQL.Clear;
    QProdutos.SQL.Add('SELECT * FROM PRODUTO WHERE 1=1');

    if(Trim(edtPesquisa.Text) <> '')then
    begin
      QProdutos.SQL.Add('AND DESCRICAO LIKE ' + QuotedStr('%'+edtPesquisa.Text + '%'));
      QProdutos.SQL.Add(' OR PRECO LIKE ' + QuotedStr('%'+edtPesquisa.Text + '%'));
    end;
    QProdutos.Open;
  except
   on E: Exception do
    ShowMessage('Erro ao pesquisar CLIENTES: '+ #13+E.Message);
  end;
end;

procedure TfrmPesquisarProduto.btnSelecionarClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmPesquisarProduto.DBGrid1DblClick(Sender: TObject);
begin
  if not(QProdutos.IsEmpty)then
    btnSelecionar.click;
end;

end.
