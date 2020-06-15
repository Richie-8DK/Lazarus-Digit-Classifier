unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, linAlg, NeuralNetwork, linAlg_Test;

implementation
Var
  A, B, C: gridtype;
  nn: TNeuralNetwork;
  i: integer;

{ TForm1 }


initialization
begin
  randomize;
  nn.Create(2,2,1);
  for i:=0 to 100000 do
  begin               
    A := grid(2, 1);
    A[0,0] := round(random());
    A[1,0] := round(random());
    B := grid(1,1);
    if (A[0,0]=1) xor (A[1,0]=1) then
      fill(B, 1);
    nn.train(A, B);
  end;
  C := nn.feedforward(A);
  linAlg_Test.A := copy(A);
  linAlg_Test.B := copy(B);
  linAlg_Test.C := copy(C);
end;

{$R *.lfm}

end.

