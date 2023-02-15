program ConsultaCEP;

uses
  System.StartUpCopy,
  FMX.Forms,
  ConsultaCEP.View.Principal in 'ConsultaCEP.View.Principal.pas' {FrmPrincipal},
  uFormat in 'units\uFormat.pas',
  uFancyDialog in 'units\uFancyDialog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
