unit MainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, System.Rtti, FMX.Grid, FMX.ExtCtrls, FMX.Objects,
  FireDAC.Comp.Client;

type
  TMainForm = class(TForm)
    StyleBook: TStyleBook;
    tcMain: TTabControl;
    TabLogin: TTabItem;
    edPhone: TEdit;
    btnGo: TButton;
    TabProduct: TTabItem;
    ActionList: TActionList;
    actGo: TAction;
    LayoutLogin: TLayout;
    lbLogin: TLabel;
    GridForPickUp: TGrid;
    CheckColumnPickUp: TCheckColumn;
    StringColumnItemPickUp: TStringColumn;
    StringColumnSlotPickUp: TStringColumn;
    ColumnOrderPickUp: TColumn;
    ColumnOrderBalancePickUp: TColumn;
    LayoutPickUp: TLayout;
    lbPickUp: TLabel;
    ImagePickUp: TImage;
    btnPrintPickUp: TButton;
    actBack: TAction;
    btnBack: TButton;
    actPrintPickUp: TAction;
    lbNotReady: TLabel;
    ImageNotReady: TImage;
    btnPrintNotReady: TButton;
    GridForNotReady: TGrid;
    CheckColumnNotReady: TCheckColumn;
    StringColumnItemNotReady: TStringColumn;
    StringColumnSlotNotReady: TStringColumn;
    ColumnOrderNotReady: TColumn;
    ColumnOrderBalanceNotReady: TColumn;
    actPrintNotReady: TAction;
    TabNothing: TTabItem;
    Layout1: TLayout;
    lbNothing: TLabel;
    ImageSmile: TImage;
    btnBack2: TButton;
    Image1: TImage;
    lbOops: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layouttop: TLayout;
    LayoutCentr1: TLayout;
    LayoutCentr2: TLayout;
    Layout8: TLayout;
    LayoutBottom: TLayout;
    Layout10: TLayout;
    LayoutReady: TLayout;
    LayoutNotReady: TLayout;
    ScaledLayout1: TScaledLayout;
    procedure actGoExecute(Sender: TObject);
    procedure GridForPickUpDrawColumnCell(Sender: TObject;
      const Canvas: TCanvas; const Column: TColumn; const [Ref] Bounds: TRectF;
      const Row: Integer; const [Ref] Value: TValue;
      const State: TGridDrawStates);
    procedure GridForPickUpGetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
    procedure actBackExecute(Sender: TObject);
    procedure actPrintPickUpExecute(Sender: TObject);
    procedure actPrintNotReadyExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridForNothingGetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
    procedure GridForNotReadyGetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
    procedure FormResize(Sender: TObject);
  private
    procedure InitGridRows(AGrid: TGrid; AQuery: TFDQuery);
    procedure InitGridData(Sender: TObject;
      const Col, Row: Integer; var Value: TValue; AQuery: TFDQuery);
    procedure InitGridTotal(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
    procedure InitGridHeader(Sender: TObject; const Col,
      Row: Integer; var Value: TValue);
    procedure ResizeGridColumns(Grid: TGrid);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  DMUnit;

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone.fmx IOS}

procedure TMainForm.actGoExecute(Sender: TObject);
var
  Phone: string;
begin
  Phone := Trim(edPhone.Text);
  if Phone <> EmptyStr then
    DM.InitData(Phone);

  if (Phone = EmptyStr) or not DM.IsDataFound then
    tcMain.ActiveTab := TabNothing
  else
  begin
    InitGridRows(GridForPickUp, DM.FDQueryPickUp);
    InitGridRows(GridForNotReady, DM.FDQueryNotReady);
    tcMain.ActiveTab := TabProduct;
  end;
end;

procedure TMainForm.actPrintNotReadyExecute(Sender: TObject);
begin
  ShowMessage('Printing...');
end;

procedure TMainForm.actPrintPickUpExecute(Sender: TObject);
begin
  ShowMessage('Printing...');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  actBack.Execute;
end;

procedure TMainForm.FormResize(Sender: TObject);
const
  MinWidth  = 532;
  MinHeight = 468;
begin
  if (Width < MinWidth) or (Height < MinHeight) then
  begin
    SetBounds(Self.Left, Self.Top, MinWidth, MinHeight);
    Self.ReleaseCapture;
  end;
  ResizeGridColumns(GridForPickUp);
  ResizeGridColumns(GridForNotReady);
  LayoutNotReady.Size.Height := (LayoutPickUp.Size.Height / 2);
end;

procedure TMainForm.actBackExecute(Sender: TObject);
begin
  edPhone.Text := EmptyStr;
  tcMain.ActiveTab := TabLogin;
end;

procedure TMainForm.GridForNothingGetValue(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
begin
  InitGridHeader(Sender, Col, Row, Value);
end;

procedure TMainForm.GridForNotReadyGetValue(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
begin
  InitGridHeader(Sender, Col, Row, Value);
  if Col > 0 then
    InitGridData(Sender, Col, Row, Value, DM.FDQueryNotReady);
  InitGridTotal(Sender, Col, Row, Value);
end;

procedure TMainForm.GridForPickUpDrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const [Ref] Bounds: TRectF;
  const Row: Integer; const [Ref] Value: TValue; const State: TGridDrawStates);
begin
//  Canvas.Font.Size := 25;
//  Canvas.Font.Family := 'Comic Sans MS';
end;

procedure TMainForm.GridForPickUpGetValue(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
begin
  InitGridHeader(Sender, Col, Row, Value);
  if Col > 0 then
    InitGridData(Sender, Col, Row, Value, DM.FDQueryPickUp);
  InitGridTotal(Sender, Col, Row, Value);
end;

procedure TMainForm.InitGridData(Sender: TObject;
  const Col, Row: Integer; var Value: TValue; AQuery: TFDQuery);
begin
  if (Row > 0) and (Row <= TGrid(Sender).RowCount - 2)  then
  begin
    AQuery.First;
    while not AQuery.Eof {or (AQuery.RecNo > Row)} do
    begin
      if (AQuery.RecNo = Row) then
      begin
        case Col of
          1: Value := AQuery.FieldByName('ITEM').AsString;
          2: Value := '';
          3: Value := '';
          4: Value := '';
        end;
        exit;
      end;
      AQuery.Next;
    end;
  end;
end;

procedure TMainForm.InitGridHeader(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
begin
  if (Row = 0) then
  case Col of
    1: Value := 'Item';
    2: Value := 'Slot#';
    3: Value := 'Order#';
    4: Value := 'Order Balance';
  end;
end;

procedure TMainForm.InitGridRows(AGrid: TGrid; AQuery: TFDQuery);
begin
  AGrid.RowCount := AQuery.RecordCount + 2;
end;

procedure TMainForm.InitGridTotal(Sender: TObject; const Col,
  Row: Integer; var Value: TValue);
begin
  if (Row = TGrid(Sender).RowCount - 1) then
  case Col of
    3: Value := 'Total';
    4: Value := '0$';
  end;
end;

procedure TMainForm.ResizeGridColumns(Grid: TGrid);
var
  I: Integer;
  W: Single;
begin
  W := 0;
  for I := 0 to Grid.ColumnCount - 1 do
    W := W + Grid.Columns[I].Size.Width;
  for I := 0 to Grid.ColumnCount - 1 do
    Grid.Columns[I].Size.Width := Grid.Columns[I].Size.Width * ((Grid.Size.Width - 24{TODO Change to ScrollWidth}) / W);
end;

end.
