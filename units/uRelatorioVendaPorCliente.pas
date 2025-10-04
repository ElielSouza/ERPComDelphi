unit uRelatorioVendaPorCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmRelatorioVendaPorCliente = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLLabel1: TRLLabel;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLDBText1: TRLDBText;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLSubDetail1: TRLSubDetail;
    RLBand4: TRLBand;
    RLPanel3: TRLPanel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    dsVenda: TDataSource;
    dsVendaItem: TDataSource;
    QVendaItem: TFDQuery;
    QVendaItemID: TIntegerField;
    QVendaItemIDVENDA: TIntegerField;
    QVendaItemITEM: TSmallintField;
    QVendaItemIDPRODUTO: TIntegerField;
    QVendaItemQUANTIDADE: TCurrencyField;
    QVendaItemUNITARIO: TCurrencyField;
    QVendaItemTOTAL: TCurrencyField;
    QVenda: TFDQuery;
    QVendaID: TIntegerField;
    QVendaDATA: TSQLTimeStampField;
    QVendaIDCLIENTE: TIntegerField;
    QVendaSUBTOTAL: TCurrencyField;
    QVendaDESCONTO: TCurrencyField;
    QVendaTOTAL: TCurrencyField;
    QVendaItemDESCRICAO: TStringField;
    RLPanel2: TRLPanel;
    RLLabel6: TRLLabel;
    RLDraw1: TRLDraw;
    RLBand3: TRLBand;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLPanel4: TRLPanel;
    RLDraw2: TRLDraw;
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBand4BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FidCliente: Integer;
    FCliente: string;
    { Private declarations }
  public
    { Public declarations }
    procedure ShowRel;

    property idCliente: Integer read FidCliente write FidCliente;
    property Cliente: string read FCliente write FCliente;
  end;

var
  frmRelatorioVendaPorCliente: TfrmRelatorioVendaPorCliente;

implementation
  uses
    uDmGlobal;
{$R *.dfm}

procedure TfrmRelatorioVendaPorCliente.RLBand4BeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  vQtdRegistro: Integer;
begin
  Inc(vQtdRegistro);
  RLLabel12.Caption := Format('Qtd: %d', [vQtdRegistro]);
end;

procedure TfrmRelatorioVendaPorCliente.RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  RLLabel11.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now);
end;

procedure TfrmRelatorioVendaPorCliente.ShowRel;
begin
  RLLabel1.Caption := Format('Relatório de Vendas por Cliente %s', [FCliente]);

  QVenda.Close;
  QVenda.SQL.Clear;
  QVenda.SQL.Add('SELECT * FROM VENDA');
  QVenda.SQL.Add('WHERE IDCLIENTE = :IDCLIENTE');

  {
  SELECT * FROM VENDA
    WHERE EXISTS(SELECT VI.IDPRODUTO FROM vendaitem VI WHERE VI.IDPRODUTO = :IDPRODUTO)
    QVenda.ParamByName('idproduto').AsInteger := FidProduto;
  }
  QVenda.ParamByName('IDCLIENTE').AsInteger := FidCliente;
  QVenda.Open;

  QVendaItem.Close;
  QVendaItem.SQL.Clear;
  QVendaItem.SQL.Add('SELECT VI.*, P.DESCRICAO');
  QVendaItem.SQL.Add('  FROM VENDAITEM VI');
  QVendaItem.SQL.Add('  JOIN PRODUTO P ON(VI.IDPRODUTO = P.ID)');
  QVendaItem.SQL.Add('WHERE IDVENDA = :IDVENDA');
  QVendaItem.ParamByName('IDVENDA').AsInteger := QVenda.FieldByName('ID').AsInteger;
  QVendaItem.Open;

  RLReport1.Prepare;
  RLReport1.Preview;

end;

end.
