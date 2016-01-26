unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.VCLUI.Wait;

type
  TDM = class(TDataModule)
    CpConnection: TFDConnection;
    FDQueryPickUp: TFDQuery;
    FDQueryNotReady: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure InitConnection;
    procedure InitQuery(AQuery: TFDQuery; ASQL: string);
    function GetIsDataFound: Boolean;
  public
    procedure InitData(APhone: string);
    property QueryPickUp: TFDQuery read FDQueryPickUp write FDQueryPickUp;
    property QueryNotReady: TFDQuery read FDQueryNotReady write FDQueryNotReady;
    property IsDataFound: Boolean read GetIsDataFound;
  end;

var
  DM: TDM;

implementation

uses
  FMX.Dialogs;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitConnection;
end;

function TDM.GetIsDataFound: Boolean;
begin
  Result := (QueryPickUp.RecordCount <> 0) or (QueryNotReady.RecordCount <> 0)
end;

procedure TDM.InitConnection;
begin
  if not CpConnection.Connected then
  begin
    CpConnection.Params.Values['Database'] :=
      ExtractFilePath(ParamStr(0)) + PathDelim + 'CP_DB.sqlite';
    try
      CpConnection.Connected := True;
    except on e: Exception do
      ShowMessage('Error connect to database: ' + e.Message);
    end;
  end;
end;

procedure TDM.InitData(APhone: string);
var
  SQLStr: string;
begin
  InitConnection;
  if DM.CpConnection.Connected then
  begin
    SQLStr :=
      'select c.TEL, i.* from customer c ' +
      'left join invitem i on c.tel = i.ACCSS ' +
      'where c.TEL = ' + QuotedStr(APhone) +
      ' and i.PICKUP = ' + QuotedStr('True') +
      ' and i.ALTERATION = ' + QuotedStr('False');
    InitQuery(FDQueryPickUp, SQLStr);

    SQLStr :=
      'select c.TEL, i.* from customer c ' +
      'left join invitem i on c.tel = i.ACCSS ' +
      'where c.TEL = ' + QuotedStr(APhone) +
      ' and i.PICKUP = ' + QuotedStr('False') +
      ' and i.ALTERATION = ' + QuotedStr('False');
    InitQuery(FDQueryNotReady, SQLStr);
  end;
end;

procedure TDM.InitQuery(AQuery: TFDQuery; ASQL: string);
begin
  if DM.CpConnection.Connected then
  begin
    if AQuery.Active then
      AQuery.Close;
    AQuery.SQL.Text := ASQL;
    AQuery.Active := True;
  end;

end;

end.
