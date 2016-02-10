unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, adscnnct, Data.DB, adsdata, adsfunc, adstable;

type
  TDM = class(TDataModule)
    AdsConnection: TAdsConnection;
    AdsQueryPickUp: TAdsQuery;
    AdsQueryNotReady: TAdsQuery;
    AdsQuery: TAdsQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure InitConnection;
    procedure InitQuery(AQuery: TAdsQuery; ASQL: string);
    function GetIsDataFound: Boolean;
  public
    function GetCustomerInfo(APhone: string): string;
    procedure InitData(APhone: string);
    property QueryPickUp: TAdsQuery read AdsQueryPickUp write AdsQueryPickUp;
    property QueryNotReady: TAdsQuery read AdsQueryNotReady write AdsQueryNotReady;
    property IsDataFound: Boolean read GetIsDataFound;
  end;

var
  DM: TDM;

implementation

uses
  Vcl.Dialogs;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitConnection;
end;

function TDM.GetCustomerInfo(APhone: string): string;
var
  SQLStr: string;
begin
  Result := EmptyStr;
  InitConnection;
  if DM.AdsConnection.IsConnected then
  begin
    //7274294140
    //7274275526
    SQLStr := 'select * from customer ' +
      'where tel = ' + QuotedStr(APhone);
    if AdsQuery.Active then
      AdsQuery.Close;
    AdsQuery.SQL.Text := SQLStr;
    AdsQuery.Active := True;
    Result := 'Name: ' + AdsQuery.FieldByName('LASTNAME').AsString;
    Result := Result + ' ' + AdsQuery.FieldByName('NAME').AsString + '. ';
    if AdsQuery.FieldByName('ADDRESS2').AsString <> EmptyStr then
      Result := Result + 'Address: ' + AdsQuery.FieldByName('ADDRESS2').AsString + '. ';
    Result := Result + 'Tel: ' + AdsQuery.FieldByName('TEL').AsString + '. ';
    Result := Result + 'Balance: ' + AdsQuery.FieldByName('BALANCE').AsString + '$';
  end;
end;

function TDM.GetIsDataFound: Boolean;
begin
  Result := (QueryPickUp.RecordCount <> 0) or (QueryNotReady.RecordCount <> 0)
end;

procedure TDM.InitConnection;
begin
  if not AdsConnection.IsConnected then
  begin
    AdsConnection.ConnectPath :=
      ExtractFilePath(ParamStr(0)) + PathDelim + 'ADS';
    try
      AdsConnection.IsConnected := True;
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
  if DM.AdsConnection.IsConnected then
  begin
    SQLStr :=
      'select c.TEL, i.* from customer c ' +
      'join invitem i on c.tel = i.ACCSS ' +
      'where c.TEL = ' + QuotedStr(APhone) +
      ' and i.PICKUP = True' +
      ' and i.ALTERATION = False';
    InitQuery(AdsQueryPickUp, SQLStr);

    SQLStr :=
      'select c.TEL, i.* from customer c ' +
      'join invitem i on c.tel = i.ACCSS ' +
      'where c.TEL = ' + QuotedStr(APhone) +
      ' and i.PICKUP = False' +
      ' and i.ALTERATION = False';
    InitQuery(AdsQueryNotReady, SQLStr);
  end;
end;

procedure TDM.InitQuery(AQuery: TAdsQuery; ASQL: string);
begin
  if DM.AdsConnection.IsConnected then
  begin
    if AQuery.Active then
      AQuery.Close;
    AQuery.SQL.Text := ASQL;
    AQuery.Active := True;
  end;
end;

end.
