unit uRelatorios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrmRelatorios = class(TForm)
    pnlBottom: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    pnlContainer: TPanel;
    cbOpcao: TComboBox;
    btnPesquisarCliente: TSpeedButton;
    btnLimparCliente: TSpeedButton;
    pnlCliente: TPanel;
    pnlProduto: TPanel;
    btnLimparProduto: TSpeedButton;
    btnPesquisarProduto: TSpeedButton;
    edtProdutoDescricao: TEdit;
    lblProduto: TLabel;
    edtCliente: TEdit;
    lblOpcao: TLabel;
    lblCliente: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnPesquisarClienteClick(Sender: TObject);
    procedure btnLimparClienteClick(Sender: TObject);
    procedure btnLimparProdutoClick(Sender: TObject);
    procedure btnPesquisarProdutoClick(Sender: TObject);
    procedure cbOpcaoChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure RelatorioPorCliente;
    procedure RelatorioPorProduto;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelatorios: TFrmRelatorios;

implementation
  uses
    uRelatorioVendaPorCliente,
    uPesquisarProdutos,
    uPesquisarClientes;
{$R *.dfm}

procedure TFrmRelatorios.btnLimparClienteClick(Sender: TObject);
begin
  edtCliente.Tag := 0;
  edtCliente.Clear;
end;

procedure TFrmRelatorios.btnLimparProdutoClick(Sender: TObject);
begin
  edtProdutoDescricao.Clear;
  edtProdutoDescricao.Tag := 0;
end;

procedure TFrmRelatorios.btnPesquisarClienteClick(Sender: TObject);
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

procedure TFrmRelatorios.btnPesquisarProdutoClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesquisarProduto, frmPesquisarProduto);
  try
    frmPesquisarProduto.showModal;

    if(frmPesquisarProduto.ModalResult = mrOk)then
    begin
      edtProdutoDescricao.Tag   := frmPesquisarProduto.QProdutosID.asInteger;
      edtProdutoDescricao.Text  := frmPesquisarProduto.QProdutosDESCRICAO.AsString;
    end;
  finally
    FreeAndNil(frmPesquisarProduto);
  end;
end;

procedure TFrmRelatorios.cbOpcaoChange(Sender: TObject);
begin
  pnlCliente.Visible := cbOpcao.ItemIndex = 1;
  pnlProduto.Visible := cbOpcao.ItemIndex = 2;
end;

procedure TFrmRelatorios.SpeedButton1Click(Sender: TObject);
begin
  case cbOpcao.ItemIndex of
    1: RelatorioPorCliente;
    2: RelatorioPorProduto;
  end;
end;

procedure TFrmRelatorios.RelatorioPorCliente;
begin
  Application.CreateForm(TfrmRelatorioVendaPorCliente, frmRelatorioVendaPorCliente);
  try
    frmRelatorioVendaPorCliente.Cliente := edtCliente.Text;
    frmRelatorioVendaPorCliente.idCliente := edtCliente.Tag;
    frmRelatorioVendaPorCliente.ShowRel;
  finally
    FreeAndNil(frmRelatorioVendaPorCliente);
  end;
end;

procedure TFrmRelatorios.RelatorioPorProduto;
begin

end;


procedure TFrmRelatorios.SpeedButton2Click(Sender: TObject);
begin
  Close;
end;

end.
