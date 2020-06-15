unit linAlg_Test;
// for testing purposes only

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, linAlg, NeuralNetwork;

type

  { TMatrixDisplay }

  TMatrixDisplay = class(TForm)
    actionButton: TButton;
    Button1: TButton;
    Button2: TButton;
    showButton: TButton;
    StringGrid1: TStringGrid;
    procedure actionButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure showButtonClick(Sender: TObject);
  private

  public

  end;

var
  MatrixDisplay: TMatrixDisplay; 
var
  A, B, C: gridtype;
  nn: TNeuralNetwork;

implementation


procedure display(M: gridtype);
// show grid
var i, j : integer;
begin
  MatrixDisplay.StringGrid1.RowCount:= rows(M);
  MatrixDisplay.StringGrid1.ColCount:= columns(M);
  for i:= 0 to rows(M)-1 do
    for j:= 0  to columns(M)-1 do
      MatrixDisplay.StringGrid1.Cells[j,i] := FloatToStr(M[i,j]);
end;

procedure trigger_action();
var i: Integer;
begin
  // some action to test capability

  // testing on xor
  nn.Create(2,4,1);
  for i:=0 to 10000 do
  begin
    A := grid(2, 1);
    A[0,0] := round(random());
    A[1,0] := round(random());
    C := grid(1,1);
    if (A[0,0]=1) xor (A[1,0]=1) then
      fill(C, 1);
    nn.train(A, C);
  end;                   
  B := nn.feedforward(A);
  C := nn.train(A, C);
end;

{ TMatrixDisplay }

procedure TMatrixDisplay.showButtonClick(Sender: TObject);
begin
  display(A);
end;

procedure TMatrixDisplay.Button1Click(Sender: TObject);
begin
  display(B);
end;

procedure TMatrixDisplay.Button2Click(Sender: TObject);
begin
  display(C);
end;


procedure TMatrixDisplay.actionButtonClick(Sender: TObject);
begin
  trigger_action();
end;


initialization
begin
  trigger_action();
end;

{$R *.lfm}

end.

