unit uClientesList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids;

type
  TfrmClientesList = class(TForm)
    pnlTopList: TPanel;
    pnlBottomList: TPanel;
    pnlCenterList: TPanel;
    btnFechar: TSpeedButton;
    btnRemover: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnInserir: TSpeedButton;
    btnLimpar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    pnlPesquisa: TPanel;
    cbTipoPesquisa: TComboBox;
    edtPesquisa: TEdit;
    lblPesquisa: TLabel;
    lblTipoPesquisa: TLabel;
    dbClientes: TDBGrid;
    QClientes: TFDQuery;
    dsClientes: TDataSource;
    QClientesID: TIntegerField;
    QClientesNOME: TStringField;
    QClientesENDERECO: TStringField;
    QClientesBAIRRO: TStringField;
    QClientesCEP: TStringField;
    QClientesIDMUNICIPIO: TIntegerField;
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cbTipoPesquisaChange(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientesList: TfrmClientesList;

implementation
  uses
    uDmGlobal,
    uClienteCadastro;
{$R *.dfm}

procedure TfrmClientesList.btnAlterarClick(Sender: TObject);
begin
  if(QClientes.IsEmpty)then
    Exit;

  Application.CreateForm(TfrmClienteCadastro, frmClienteCadastro);
  try
   frmClienteCadastro.Id := QClientesID.AsInteger;
   frmClienteCadastro.ShowModal;
  finally
    FreeAndNil(frmClienteCadastro);
    btnPesquisar.Click;
  end;
end;

procedure TfrmClientesList.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClientesList.btnInserirClick(Sender: TObject);
begin
  Application.CreateForm(TfrmClienteCadastro, frmClienteCadastro);
  try
   frmClienteCadastro.Id := 0;
   frmClienteCadastro.ShowModal;
  finally
    FreeAndNil(frmClienteCadastro);
    btnPesquisar.Click;
  end;
end;

procedure TfrmClientesList.btnLimparClick(Sender: TObject);
begin
  cbTipoPesquisa.ItemIndex := 1;
  edtPesquisa.Clear;
  QClientes.Close;
end;

procedure TfrmClientesList.btnPesquisarClick(Sender: TObject);
var
  vFiltro: string;
begin
  try
    vFiltro := '';
    // Monta a base da consulta
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Add('SELECT * FROM CLIENTE WHERE 1=1');

    case cbTipoPesquisa.ItemIndex of
      0: // ID
        begin
          if Trim(edtPesquisa.Text) <> '' then
          begin
            QClientes.SQL.Add('AND ID = :ID');
            QClientes.ParamByName('ID').AsInteger := StrToIntDef(edtPesquisa.Text, 0);
          end;
        end;

      1: // Nome
        begin
          if Trim(edtPesquisa.Text) <> '' then
           QClientes.SQL.Add('AND NOME ' + QuotedStr('%'+edtPesquisa.Text + '%'));
        end;

      2: // CEP
        begin
          if Trim(edtPesquisa.Text) <> '' then
            QClientes.SQL.Add('AND CIDADE CEP ' + QuotedStr('%'+edtPesquisa.Text + '%'));
        end;
    end;

    QClientes.Open;
  except
   on E: Exception do
    ShowMessage('Erro ao pesquisar clientes: '+ #13+E.Message);
  end;
end;

procedure TfrmClientesList.btnRemoverClick(Sender: TObject);
begin
  if(QClientes.IsEmpty)then
    Exit;

  if(MessageDlg('Deseja realmente excluir este cliente?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)then
  begin
    QClientes.Delete;
    ShowMessage('Cliente removido com sucesso!');
    btnPesquisar.Click;
  end;
end;

procedure TfrmClientesList.cbTipoPesquisaChange(Sender: TObject);
begin
  lblPesquisa.Caption := Format('Pesquisar por %s', [cbTipoPesquisa.Items[cbTipoPesquisa.ItemIndex]]);
end;

end.
