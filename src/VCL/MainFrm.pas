unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.Imaging.pngimage, Vcl.Grids, adstable, AdvObj, BaseGrid, AdvGrid,
  System.UITypes;

type
  TMainForm = class(TForm)
    btnGo: TButton;
    lbLogin: TLabel;
    pnLoginNavi: TPanel;
    pnLogin: TPanel;
    pnGo: TPanel;
    gpnKeypad: TGridPanel;
    btnKey1: TButton;
    btnKey2: TButton;
    btnKey3: TButton;
    btnKey4: TButton;
    btnKey5: TButton;
    btnKey6: TButton;
    btnKey7: TButton;
    btnKey8: TButton;
    btnKey9: TButton;
    btnKeyStar: TButton;
    btnKey0: TButton;
    btnKeySharp: TButton;
    pnLoginCentre: TPanel;
    edPhone: TButtonedEdit;
    ImageList: TImageList;
    pnNothingTop: TPanel;
    lbNothingTop: TLabel;
    pnNothingNavi: TPanel;
    ActionList: TActionList;
    actGo: TAction;
    actBack: TAction;
    actPrintPickUp: TAction;
    actPrintNotReady: TAction;
    btnNothingBack: TButton;
    ImageSmileTop: TImage;
    ImageSmileCentre: TImage;
    lbNothingBottom: TLabel;
    pnProductNavi: TPanel;
    pnProdReadyTop: TPanel;
    lbPickUp: TLabel;
    ImagePickUp: TImage;
    pnReady: TPanel;
    pnProdReadyBottom: TPanel;
    btnPrintPickUp: TButton;
    GridForPickUp: TAdvStringGrid;
    Splitter: TSplitter;
    pnNotReady: TPanel;
    pnNotReadyTop: TPanel;
    lbNotReady: TLabel;
    ImageNotReady: TImage;
    pnNotReadyBottom: TPanel;
    btnPrintNotReady: TButton;
    GridNotReady: TAdvStringGrid;
    pnCustomerInfo: TPanel;
    lbCustomerInfo: TLabel;
    btnProductBack: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnKeyClick(Sender: TObject);
    procedure edPhoneRightButtonClick(Sender: TObject);
    procedure actGoExecute(Sender: TObject);
    procedure actBackExecute(Sender: TObject);
    procedure actPrintPickUpExecute(Sender: TObject);
    procedure actPrintNotReadyExecute(Sender: TObject);
  private
    FFullScreen: Boolean;
    procedure InitGridHeader(AGrid: TAdvStringGrid);
    procedure InitGridRows(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
    procedure InitCheckBox(AGrid: TAdvStringGrid);
    procedure InitGridData(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
    procedure InitGridTotal(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
    procedure InitGridSize(AGrid: TAdvStringGrid);
    procedure InitGrid(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
    procedure InitVisibleControls;
    procedure PrintGrid(AGrid: TAdvStringGrid);
    procedure SetFullScreen(const Value: Boolean);
    procedure SwitchPanel(APanel: TPanel);
   public
    property FullScreen: Boolean read FFullScreen write SetFullScreen;
  end;

var
  MainForm: TMainForm;

implementation

uses
  DMUnit;

{$R *.dfm}

procedure TMainForm.actBackExecute(Sender: TObject);
begin
  SwitchPanel(pnLoginNavi);
end;

procedure TMainForm.actGoExecute(Sender: TObject);
var
  Phone: string;
begin
  Phone := Trim(edPhone.Text);
  if Phone <> EmptyStr then
    DM.InitData(Phone);

  if (Phone = EmptyStr) or not DM.IsDataFound then
    SwitchPanel(pnNothingNavi)
  else
  begin   
    InitVisibleControls; 
    SwitchPanel(pnProductNavi); 
    InitGrid(GridForPickUp, DM.QueryPickUp);
    InitGrid(GridNotReady, DM.QueryNotReady); 
    GridNotReady.UnCheckAll(0);
    lbCustomerInfo.Caption := DM.GetCustomerInfo(Phone);   
  end;
end;

procedure TMainForm.actPrintNotReadyExecute(Sender: TObject);
begin
  PrintGrid(GridNotReady);
end;

procedure TMainForm.actPrintPickUpExecute(Sender: TObject);
begin
  PrintGrid(GridForPickUp);
end;

procedure TMainForm.btnKeyClick(Sender: TObject);
begin
  edPhone.Text := edPhone.Text + TButton(Sender).Caption;
end;

procedure TMainForm.edPhoneRightButtonClick(Sender: TObject);
var
  OldPhone: string;
begin
  if Length(edPhone.Text) > 0 then
  begin
    OldPhone := Trim(edPhone.Text);
    edPhone.Text := OldPhone.Substring(0, OldPhone.Length - 1);
    edPhone.SelStart := Length(edPhone.Text)
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//  FullScreen := True;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  btnGo.SetFocus;
  SwitchPanel(pnLoginNavi);
end;

procedure TMainForm.InitCheckBox(AGrid: TAdvStringGrid);
var
  I: Integer;
begin
  AGrid.AddCheckBoxColumn(0, True, True);
  for I := 1 to AGrid.RowCount - 2 do
    AGrid.AddCheckBox(0, I, True, True);
end;

procedure TMainForm.InitGrid(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
begin
  AGrid.BeginUpdate;
  try
    InitGridHeader(AGrid);
    InitGridRows(AGrid, AQuery);
    InitGridData(AGrid, AQuery);
    InitGridTotal(AGrid, AQuery);
    InitGridSize(AGrid);
  finally
    AGrid.EndUpdate;
  end;
end;

procedure TMainForm.InitGridData(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
var
  Row: Integer;
begin
  Row := 1;
  AQuery.First;
  while not AQuery.Eof do
  begin
    AGrid.Cells[1, Row] := AQuery.FieldByName('ITEM').AsString;
    AGrid.Cells[2, Row] := '';
    AGrid.Cells[3, Row] := '';
    AGrid.Cells[4, Row] := '';
    Row := Row + 1;
    AQuery.Next;
  end;
end;

procedure TMainForm.InitGridHeader(AGrid: TAdvStringGrid);
var
  I, J: Integer;
  NewCheckBox: TCheckBox;
begin
  AGrid.ColCount := 5;
  //Header
  for I := 0 to AGrid.ColCount - 1 do
  case I of
    1: AGrid.Cells[I, 0] := 'Item';
    2: AGrid.Cells[I, 0] := 'Slot#';
    3: AGrid.Cells[I, 0] := 'Order#';
    4: AGrid.Cells[I, 0] := 'Order Balance';
  end;
end;

procedure TMainForm.InitGridRows(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
begin
  AGrid.RowCount := AQuery.RecordCount + 2;
  InitCheckBox(AGrid);
end;

procedure TMainForm.InitGridSize(AGrid: TAdvStringGrid);
begin
  AGrid.ColWidths[0] := 20;
  AGrid.ColWidths[1] := 200;
end;

procedure TMainForm.InitGridTotal(AGrid: TAdvStringGrid; AQuery: TAdsQuery);
begin
  AGrid.Cells[3, AGrid.RowCount - 1] := 'Total';
  AGrid.Cells[4, AGrid.RowCount - 1] := '0$';
end;

procedure TMainForm.InitVisibleControls;
var
  I: Integer;
  VisibleReady, VisibleNotReady: Boolean;
begin
  VisibleReady := DM.QueryPickUp.RecordCount > 0;
  VisibleNotReady := DM.QueryNotReady.RecordCount > 0;  
  pnReady.Visible := VisibleReady;
  Splitter.Visible := VisibleReady and VisibleNotReady;
  pnNotReady.Visible := VisibleNotReady;

  //Hide balance
  GridForPickUp.HideColumn(4);
  
  //Relocation button btnProductBack
  if pnReady.Visible then
    btnProductBack.Parent := pnProdReadyTop
  else
    btnProductBack.Parent := pnNotReadyTop;

//  //UnCheck GridNotReady
//  for I := 1 to GridNotReady.RowCount - 1 do
//    GridNotReady.SetCheckBoxState(0, I, False);
end;

procedure TMainForm.PrintGrid(AGrid: TAdvStringGrid);
var
  I: Integer;
  CheckState: Boolean;
begin
  //Hiden rows by check state
  for I := 1 to AGrid.RowCount - 1 do
  begin
    AGrid.GetCheckBoxState(0, I, CheckState);
    if not CheckState then
      AGrid.HideRow(I);
  end;

  //Print
  try
    AGrid.PrintSettings.Date := ppBottomLeft;
    AGrid.PrintSettings.Time := ppBottomLeft;    
    AGrid.PrintSettings.HeaderFont.Name := 'Comic Sans MS';
    AGrid.PrintSettings.HeaderFont.Style := [fsBold];    
    AGrid.PrintSettings.HeaderFont.Size := 10;    
    AGrid.PrintSettings.Title := ppTopCenter;    
    AGrid.PrintSettings.TitleLines.Clear;
    AGrid.PrintSettings.TitleLines.Add('Report');
    AGrid.PrintSettings.TitleLines.Add(DM.GetCustomerInfo(Trim(edPhone.Text)));    
    AGrid.Print;
  finally
    AGrid.UnHideRowsAll;
  end;
end;

procedure TMainForm.SetFullScreen(const Value: Boolean);
begin
  FFullScreen := Value;
  if Value then
  begin
    BorderStyle := bsNone;
    WindowState := wsMaximized;
    Left := 0;
    Top := 0;

//    Left := Screen.PrimaryMonitor.Left;
//    Top := Screen.PrimaryMonitor.Top;

    Height := Screen.Height;
    Width := Screen.Width;

//    Height := Screen.PrimaryMonitor.Height;
//    Width := Screen.PrimaryMonitor.Width;

//    Height := Screen.DesktopHeight;
//    Width := Screen.DesktopWidth;
    FormStyle := fsStayOnTop;
    Refresh;
  end
  else
  begin
    BorderStyle := bsSingle;
    WindowState := wsNormal;
    Height := Screen.Height - 200;
    Width := Screen.Width - 200;
    FormStyle := fsNormal;
  end;
end;

procedure TMainForm.SwitchPanel(APanel: TPanel);
begin
  APanel.Align := alClient;
  pnLoginNavi.Visible := pnLoginNavi = APanel;
  pnProductNavi.Visible := pnProductNavi = APanel;
  pnNothingNavi.Visible := pnNothingNavi = APanel;
end;

end.
