unit uDmGlobal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDmGlobal = class(TDataModule)
    ConexaoGlobal: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    QAux1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  DmGlobal: TDmGlobal;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  try
    ConexaoGlobal.Params.Clear;
    ConexaoGlobal.Params.DriverID := 'FB';
    ConexaoGlobal.Params.Database := 'D:\Consultorias\FelipeEsteves\ERPComDelphi\database\ERPCOMDELPHI.FDB';
    ConexaoGlobal.Params.UserName := 'SYSDBA';
    ConexaoGlobal.Params.Password := 'masterkey';
    ConexaoGlobal.Params.Add('Server=127.0.0.1');
    ConexaoGlobal.Params.Add('Port=3050');
    ConexaoGlobal.LoginPrompt := False;
    ConexaoGlobal.Connected := True;
  except
    on E: Exception do
      ShowMessage('Erro ao conectar ao banco de dados: ' +#13+ E.Message);
  end;
end;

procedure TDmGlobal.DataModuleDestroy(Sender: TObject);
begin
  ConexaoGlobal.Connected := False;
end;

end.
