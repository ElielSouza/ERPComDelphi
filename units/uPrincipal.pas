unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Menus;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Venda1: TMenuItem;
    Relatrios1: TMenuItem;
    pnlTollBarPrincipal: TPanel;
    btnProdutos: TSpeedButton;
    btnClientes: TSpeedButton;
    btnNovaVenda: TSpeedButton;
    Clientes1: TMenuItem;
    Produtos1: TMenuItem;
    Vendas1: TMenuItem;
    VendasporClientes1: TMenuItem;
    procedure btnClientesClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnNovaVendaClick(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure Produtos1Click(Sender: TObject);
    procedure Nova1Click(Sender: TObject);
    procedure Vendas1Click(Sender: TObject);
    procedure VendasporClientes1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirManutencaoClientes;
    procedure AbrirManutencaoProdutos;
    procedure AbrirNovaVenda;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation
  uses
    uVenda,
    uRelatorios,
    uClientesList,
    uProdutosList;
{$R *.dfm}

procedure TFrmPrincipal.AbrirManutencaoClientes;
begin
  Application.CreateForm(TfrmClientesList, frmClientesList);
  try
    frmClientesList.ShowModal;
  finally
    FreeAndNil(frmClientesList);
  end;
end;

procedure TFrmPrincipal.btnClientesClick(Sender: TObject);
begin
  AbrirManutencaoClientes;
end;

procedure TFrmPrincipal.btnNovaVendaClick(Sender: TObject);
begin
  AbrirNovaVenda;
end;

procedure TFrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  AbrirManutencaoProdutos;
end;

procedure TFrmPrincipal.Clientes1Click(Sender: TObject);
begin
  AbrirManutencaoClientes;
end;

procedure TFrmPrincipal.Nova1Click(Sender: TObject);
begin
  AbrirNovaVenda;
end;

procedure TFrmPrincipal.Produtos1Click(Sender: TObject);
begin
  AbrirManutencaoProdutos;
end;

procedure TFrmPrincipal.Vendas1Click(Sender: TObject);
begin
  AbrirNovaVenda;
end;

procedure TFrmPrincipal.VendasporClientes1Click(Sender: TObject);
begin
  Application.CreateForm(TFrmRelatorios, FrmRelatorios);
  try
    FrmRelatorios.ShowModal;
  finally
    FreeAndNil(FrmRelatorios);
  end;
end;

procedure TFrmPrincipal.AbrirNovaVenda;
begin
  Application.CreateForm(TFrmVenda, FrmVenda);
  try
    FrmVenda.Id := 0;
    FrmVenda.ShowModal;
  finally
    FreeAndNil(FrmVenda);
  end;
end;

procedure TFrmPrincipal.AbrirManutencaoProdutos;
begin
  Application.CreateForm(TfrmProdutosList, frmProdutosList);
  try
    frmProdutosList.ShowModal;
  finally
    FreeAndNil(frmProdutosList);
  end;
end;
end.
