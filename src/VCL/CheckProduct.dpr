program CheckProduct;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  DMUnit in 'DMUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
