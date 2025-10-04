unit uProdutosList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmProdutosList = class(TForm)
    pnlBottomList: TPanel;
    btnFechar: TSpeedButton;
    btnRemover: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnInserir: TSpeedButton;
    pnlCenterList: TPanel;
    dbClientes: TDBGrid;
    pnlTopList: TPanel;
    btnLimpar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    pnlPesquisa: TPanel;
    lblPesquisa: TLabel;
    lblTipoPesquisa: TLabel;
    cbTipoPesquisa: TComboBox;
    edtPesquisa: TEdit;
    dsProdutos: TDataSource;
    QProdutos: TFDQuery;
    QProdutosID: TIntegerField;
    QProdutosDESCRICAO: TStringField;
    QProdutosPRECO: TCurrencyField;
    procedure btnInserirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cbTipoPesquisaChange(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProdutosList: TfrmProdutosList;

implementation
  uses
    uProdutoCadastro,
    uDmGlobal;
{$R *.dfm}

procedure TfrmProdutosList.btnAlterarClick(Sender: TObject);
begin
  if(QProdutos.IsEmpty)then
    Exit;

  Application.CreateForm(TfrmProdutoCadastro, frmProdutoCadastro);
  try
   frmProdutoCadastro.Id := QProdutosID.AsInteger;
   frmProdutoCadastro.ShowModal;
  finally
    FreeAndNil(frmProdutoCadastro);
    btnPesquisar.Click;
  end;
end;

procedure TfrmProdutosList.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProdutosList.btnInserirClick(Sender: TObject);
begin
  Application.CreateForm(TfrmProdutoCadastro, frmProdutoCadastro);
  try
   frmProdutoCadastro.Id := 0;
   frmProdutoCadastro.ShowModal;
  finally
    FreeAndNil(frmProdutoCadastro);
    btnPesquisar.Click;
  end;
end;

procedure TfrmProdutosList.btnLimparClick(Sender: TObject);
begin
  cbTipoPesquisa.ItemIndex := 1;
  edtPesquisa.Clear;
  QProdutos.Close;
end;

procedure TfrmProdutosList.btnPesquisarClick(Sender: TObject);
var
  vFiltro: string;
begin
  try
    vFiltro := '';
    // Monta a base da consulta
    QProdutos.Close;
    QProdutos.SQL.Clear;
    QProdutos.SQL.Add('SELECT * FROM PRODUTO WHERE 1=1');

    case cbTipoPesquisa.ItemIndex of
      0: // ID
        begin
          if Trim(edtPesquisa.Text) <> '' then
          begin
            QProdutos.SQL.Add('AND ID = :ID');
            QProdutos.ParamByName('ID').AsInteger := StrToIntDef(edtPesquisa.Text, 0);
          end;
        end;

      2: // CEP
        begin
          if Trim(edtPesquisa.Text) <> '' then
            QProdutos.SQL.Add('AND DESCRICAO LIKE ' + QuotedStr('%'+edtPesquisa.Text + '%'));
        end;
    end;

    QProdutos.Open;
  except
   on E: Exception do
    ShowMessage('Erro ao pesquisar produtos: '+ #13+E.Message);
  end;
end;

procedure TfrmProdutosList.btnRemoverClick(Sender: TObject);
begin
  if(QProdutos.IsEmpty)then
    Exit;

  if(MessageDlg('Deseja realmente excluir este produto?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)then
  begin
    QProdutos.Delete;
    ShowMessage('Produto removido com sucesso!');
    btnPesquisar.Click;
  end;
end;

procedure TfrmProdutosList.cbTipoPesquisaChange(Sender: TObject);
begin
  lblPesquisa.Caption := Format('Pesquisar por %s', [cbTipoPesquisa.Items[cbTipoPesquisa.ItemIndex]]);
end;

end.
