program ErpComDelphi;

uses
  Vcl.Forms,
  uPrincipal in 'units\uPrincipal.pas' {FrmPrincipal},
  uClientesList in 'units\cadastros\uClientesList.pas' {frmClientesList},
  uClienteCadastro in 'units\cadastros\uClienteCadastro.pas' {frmClienteCadastro},
  uDmGlobal in 'units\uDmGlobal.pas' {DmGlobal: TDataModule},
  uPesquisarMunicipio in 'units\uPesquisarMunicipio.pas' {frmPesquisarMunicipios},
  uProdutosList in 'units\cadastros\uProdutosList.pas' {frmProdutosList},
  uProdutoCadastro in 'units\cadastros\uProdutoCadastro.pas' {frmProdutoCadastro},
  uVenda in 'units\uVenda.pas' {FrmVenda},
  uPesquisarClientes in 'units\uPesquisarClientes.pas' {frmPesquisarClientes},
  uPesquisarProdutos in 'units\uPesquisarProdutos.pas' {frmPesquisarProduto},
  uRelatorios in 'units\uRelatorios.pas' {FrmRelatorios},
  uRelatorioVendaPorCliente in 'units\uRelatorioVendaPorCliente.pas' {frmRelatorioVendaPorCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmVenda, FrmVenda);
  Application.CreateForm(TfrmPesquisarClientes, frmPesquisarClientes);
  Application.CreateForm(TfrmPesquisarProduto, frmPesquisarProduto);
  Application.CreateForm(TFrmRelatorios, FrmRelatorios);
  Application.CreateForm(TfrmRelatorioVendaPorCliente, frmRelatorioVendaPorCliente);
  Application.Run;
end.
