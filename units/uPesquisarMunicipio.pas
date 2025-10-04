unit uPesquisarMunicipio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TfrmPesquisarMunicipios = class(TForm)
    pnlContainer: TPanel;
    Panel2: TPanel;
    btnSelecionar: TSpeedButton;
    btnFechar: TSpeedButton;
    DBGrid1: TDBGrid;
    QMunicipios: TFDQuery;
    dsMunicipios: TDataSource;
    QMunicipiosID: TIntegerField;
    QMunicipiosIDUF: TSmallintField;
    QMunicipiosCIDADE: TWideStringField;
    Panel1: TPanel;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPesquisarMunicipios: TfrmPesquisarMunicipios;

implementation
   uses
    uDmGlobal;
{$R *.dfm}

procedure TfrmPesquisarMunicipios.btnPesquisarClick(Sender: TObject);
begin
  try
    // Monta a base da consulta
    QMunicipios.Close;
    QMunicipios.SQL.Clear;
    QMunicipios.SQL.Add('SELECT * FROM MUNICIPIO WHERE 1=1');

    if(Trim(edtPesquisa.Text) <> '')then
    begin
      QMunicipios.SQL.Add('AND CIDADE LIKE ' + QuotedStr('%'+edtPesquisa.Text + '%'));
    end;
    QMunicipios.Open;
  except
   on E: Exception do
    ShowMessage('Erro ao pesquisar municípios: '+ #13+E.Message);
  end;

end;

procedure TfrmPesquisarMunicipios.DBGrid1DblClick(Sender: TObject);
begin
  if not(QMunicipios.IsEmpty)then
    btnSelecionar.click;
end;

procedure TfrmPesquisarMunicipios.btnSelecionarClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmPesquisarMunicipios.btnFecharClick(Sender: TObject);
begin
  Self.ModalResult := mrClose;
end;

end.
