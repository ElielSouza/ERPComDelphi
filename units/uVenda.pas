unit uVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Vcl.ComCtrls;

type
  TFrmVenda = class(TForm)
    pnlBottom: TPanel;
    btnConfirmar: TSpeedButton;
    btnCancelar: TSpeedButton;
    pnlVendaCabecalho: TPanel;
    edtCliente: TEdit;
    dsVenda: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    pnlItem: TPanel;
    edtProdutoDescricao: TEdit;
    btnAdicionarProduto: TSpeedButton;
    edtProdutoPreco: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    DBGrid1: TDBGrid;
    dsVendaItem: TDataSource;
    cdsVenda: TClientDataSet;
    cdsVendaID: TIntegerField;
    cdsVendaDATA: TDateField;
    cdsVendaIDCLIENTE: TIntegerField;
    cdsVendaSUBTOTAL: TCurrencyField;
    cdsVendaDESCONTO: TCurrencyField;
    cdsVendaTOTAL: TCurrencyField;
    cdsVendaItem: TClientDataSet;
    cdsVendaItemID: TIntegerField;
    cdsVendaItemIDVENDA: TIntegerField;
    cdsVendaItemITEM: TIntegerField;
    cdsVendaItemIDPRODUTO: TIntegerField;
    cdsVendaItemQUANTIDADE: TFloatField;
    cdsVendaItemUNITARIO: TCurrencyField;
    cdsVendaItemTOTAL: TCurrencyField;
    edtDataVenda: TDateTimePicker;
    btnPesquisarCliente: TSpeedButton;
    btnLimparCliente: TSpeedButton;
    btnPesquisarProduto: TSpeedButton;
    btnLimparProduto: TSpeedButton;
    edtProdutoQuantidade: TEdit;
    Label1: TLabel;
    edtDesconto: TEdit;
    edtSubTotal: TEdit;
    edtTotal: TEdit;
    cdsVendaItemDESCRICAO: TStringField;
    QVenda: TFDQuery;
    QVendaItem: TFDQuery;
    QVendaID: TIntegerField;
    QVendaDATA: TSQLTimeStampField;
    QVendaIDCLIENTE: TIntegerField;
    QVendaSUBTOTAL: TCurrencyField;
    QVendaDESCONTO: TCurrencyField;
    QVendaTOTAL: TCurrencyField;
    QVendaItemID: TIntegerField;
    QVendaItemIDVENDA: TIntegerField;
    QVendaItemITEM: TSmallintField;
    QVendaItemIDPRODUTO: TIntegerField;
    QVendaItemQUANTIDADE: TCurrencyField;
    QVendaItemUNITARIO: TCurrencyField;
    QVendaItemTOTAL: TCurrencyField;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLimparClienteClick(Sender: TObject);
    procedure btnPesquisarClienteClick(Sender: TObject);
    procedure btnLimparProdutoClick(Sender: TObject);
    procedure btnPesquisarProdutoClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure edtDescontoExit(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
  private
    FId: Integer;
    procedure CalculaTotais;
    { Private declarations }
  public
    { Public declarations }
    property Id: Integer read FId write FId;
  end;

var
  FrmVenda: TFrmVenda;

implementation
  uses
    uPesquisarProdutos,
    uPesquisarClientes,
    uDmGlobal;
{$R *.dfm}

procedure TFrmVenda.btnAdicionarProdutoClick(Sender: TObject);
begin
  if(edtProdutoDescricao.Tag = 0)then
  begin
    ShowMessage('Informe um produto');
    if(edtProdutoDescricao.CanFocus)then
      edtProdutoDescricao.SetFocus;
    Exit;
  end;

  if(StrToFloatDef(edtProdutoQuantidade.Text, 0) = 0)then
  begin
    ShowMessage('Informe uma quantidade para o produto');
    if(edtProdutoQuantidade.CanFocus)then
      edtProdutoQuantidade.SetFocus;
    Exit;
  end;

  cdsVendaItem.Append;
  cdsVendaItemIDPRODUTO.AsInteger := edtProdutoDescricao.Tag;
  cdsVendaItemDESCRICAO.AsString  := edtProdutoDescricao.Text;
  cdsVendaItemQUANTIDADE.AsFloat  := StrToFloatDef(edtProdutoQuantidade.Text, 0);
  cdsVendaItemUNITARIO.AsCurrency := StrToCurr(edtProdutoPreco.Text);
  cdsVendaItemTOTAL.AsCurrency    := cdsVendaItemQUANTIDADE.AsCurrency * cdsVendaItemUNITARIO.AsCurrency;
  cdsVendaItem.Post;

  CalculaTotais;
  btnLimparProduto.Click;
end;

procedure TFrmVenda.CalculaTotais;
var
  FSubtotal,
  FDesconto,
  FTotal: Currency;
begin
  FSubtotal := 0;
  FDesconto := StrToCurrDef(edtDesconto.Text, 0);

  cdsVendaItem.First;
  cdsVendaItem.DisableControls;
  while not cdsVendaItem.Eof do
  begin
    FSubtotal := FSubtotal + cdsVendaItemTOTAL.AsCurrency;
    cdsVendaItem.Next;
  end;
  cdsVendaItem.EnableControls;

  FTotal := FSubtotal - FDesconto;
  edtSubTotal.Text := CurrToStr(FSubtotal);
  edtTotal.Text    := CurrToStr(FTotal);

end;

procedure TFrmVenda.edtDescontoExit(Sender: TObject);
begin
  if(StrToCurrDef(edtDesconto.Text, 0) > 0)then
    CalculaTotais;
end;

procedure TFrmVenda.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmVenda.btnConfirmarClick(Sender: TObject);
var
  vIDVENDA: Integer;
begin
  try
    if(edtCliente.Tag = 0)then
    begin
      ShowMessage('Informe um Cliente');
      if(edtCliente.CanFocus)then
        edtCliente.SetFocus;
      Exit;
    end;

    if(cdsVendaItem.IsEmpty)then
    begin
      ShowMessage('Não há produtos adicionados');
      if(edtProdutoDescricao.CanFocus)then
        edtProdutoDescricao.SetFocus;
      Exit;
    end;

    DmGlobal.ConexaoGlobal.StartTransaction;
    QVenda.Open;
    // Salvando dados da tabela VENDA
    QVenda.Append;
    QVendaDATA.AsDateTime     := edtDataVenda.Date;
    QVendaIDCLIENTE.AsInteger := edtCliente.Tag;
    QVendaSUBTOTAL.AsCurrency := StrToCurr(edtSubTotal.Text);
    QVendaDESCONTO.AsCurrency := StrToCurr(edtDesconto.Text);
    QVendaTOTAL.AsCurrency    := StrToCurr(edtTotal.Text);
    QVenda.Post;

    // Recuperando o ID da venda salva
    DmGlobal.QAux1.Close;
    DmGlobal.QAux1.SQL.Clear;
    DmGlobal.QAux1.SQL.Add('SELECT MAX(ID) AS ID FROM VENDA');
    DmGlobal.QAux1.Open;

    vIDVENDA :=  DmGlobal.QAux1.FieldByName('ID').AsInteger;
    DmGlobal.QAux1.Close;

    // Salvando os itens da venda com o ID VENDA recuperado
    QVendaItem.Open;
    cdsVendaItem.First;
    cdsVendaItem.DisableControls;
    while not cdsVendaItem.Eof do
    begin

      QVendaItem.Append;
      QVendaItemIDVENDA.AsInteger      := vIDVENDA;
      QVendaItemITEM.AsInteger         := cdsVendaItemITEM.AsInteger;
      QVendaItemIDPRODUTO.AsInteger    := cdsVendaItemIDPRODUTO.AsInteger;
      QVendaItemQUANTIDADE.AsFloat     := cdsVendaItemQUANTIDADE.AsFloat;
      QVendaItemUNITARIO.AsCurrency    := cdsVendaItemUNITARIO.AsCurrency;
      QVendaItemTOTAL.AsCurrency       := cdsVendaItemTOTAL.AsCurrency;
      QVendaItem.Post;
      cdsVendaItem.Next;
    end;
    cdsVendaItem.EnableControls;
    DmGlobal.ConexaoGlobal.Commit;
    ShowMessage('Venda Salva com sucesso!');
    Close;
  except on
    E: Exception do
    begin
      DmGlobal.ConexaoGlobal.Rollback;
      ShowMessage('Erro ao gravar a venda:' +#13+ E.Message);
    end;
  end;
end;

procedure TFrmVenda.btnLimparClienteClick(Sender: TObject);
begin
  edtCliente.Tag := 0;
  edtCliente.Clear;
end;

procedure TFrmVenda.btnLimparProdutoClick(Sender: TObject);
begin
  edtProdutoDescricao.Clear;
  edtProdutoPreco.Clear;
  edtProdutoDescricao.Tag := 0;
end;

procedure TFrmVenda.btnPesquisarClienteClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesquisarClientes, frmPesquisarClientes);
  try
    frmPesquisarClientes.showModal;

    if(frmPesquisarClientes.ModalResult = mrOk)then
    begin
      edtCliente.Tag  := frmPesquisarClientes.QClientesID.asInteger;
      edtCliente.Text := frmPesquisarClientes.QClientesNOME.AsString;
    end;
  finally
    FreeAndNil(frmPesquisarClientes);
  end;
end;

procedure TFrmVenda.btnPesquisarProdutoClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesquisarProduto, frmPesquisarProduto);
  try
    frmPesquisarProduto.showModal;

    if(frmPesquisarProduto.ModalResult = mrOk)then
    begin
      edtProdutoDescricao.Tag   := frmPesquisarProduto.QProdutosID.asInteger;
      edtProdutoDescricao.Text  := frmPesquisarProduto.QProdutosDESCRICAO.AsString;
      edtProdutoPreco.Text      := CurrToStr(frmPesquisarProduto.QProdutosPRECO.AsCurrency);
      edtProdutoQuantidade.Text := '1';
    end;
  finally
    FreeAndNil(frmPesquisarProduto);
  end;
end;

procedure TFrmVenda.FormCreate(Sender: TObject);
begin
  cdsVenda.CreateDataSet;
  cdsVendaItem.CreateDataSet;
end;

procedure TFrmVenda.FormShow(Sender: TObject);
begin
  edtDataVenda.Date := Date;
end;

end.
