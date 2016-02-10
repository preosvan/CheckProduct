program CheckProduct;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  DMUnit in 'DMUnit.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smile VCL');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
