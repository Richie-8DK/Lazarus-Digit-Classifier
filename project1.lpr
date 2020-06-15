program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, runtimetypeinfocontrols, linAlg_Test, linAlg,
  neuralnetwork, mnist
  { you can add units after this };

{$R *.res}

begin
  Randomize;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  // comment in to use for testing
  // Application.CreateForm(TMatrixDisplay, MatrixDisplay);
  Application.CreateForm(TDigitClassifierForm, DigitClassifierForm);
  Application.Run;
end.

