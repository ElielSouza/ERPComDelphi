unit uPesquisarClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmPesquisarClientes = class(TForm)
    pnlContainer: TPanel;
    Panel2: TPanel;
    btnSelecionar: TSpeedButton;
    btnFechar: TSpeedButton;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    QClientes: TFDQuery;
    dsClientes: TDataSource;
    QClientesID: TIntegerField;
    QClientesNOME: TStringField;
    QClientesENDERECO: TStringField;
    QClientesBAIRRO: TStringField;
    QClientesCEP: TStringField;
    QClientesIDMUNICIPIO: TIntegerField;
    procedure btnPesquisarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPesquisarClientes: TfrmPesquisarClientes;

implementation
   uses
    uDmGlobal;
{$R *.dfm}

procedure TfrmPesquisarClientes.btnFecharClick(Sender: TObject);
begin
  Self.ModalResult := mrClose;
end;

procedure TfrmPesquisarClientes.btnPesquisarClick(Sender: TObject);
begin
  try
    // Monta a base da consulta
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Add('SELECT * FROM CLIENTE WHERE 1=1');

    if(Trim(edtPesquisa.Text) <> '')then
    begin
      QClientes.SQL.Add('AND NOME LIKE ' + QuotedStr('%'+edtPesquisa.Text + '%'));
    end;
    QClientes.Open;
  except
   on E: Exception do
    ShowMessage('Erro ao pesquisar CLIENTES: '+ #13+E.Message);
  end;
end;

procedure TfrmPesquisarClientes.btnSelecionarClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmPesquisarClientes.DBGrid1DblClick(Sender: TObject);
begin
  if not(QClientes.IsEmpty)then
    btnSelecionar.click;
end;

end.
