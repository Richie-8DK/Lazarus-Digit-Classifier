unit linAlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  gridtype = array of array of double;

// wieso verdammt nochmal ist eine map function nicht möglich?!?!
// ich habe es wirkich versucht

// alle folgenden verändern A
procedure fill(A: gridtype; n: double);
procedure fillRandom(A: gridtype);
// alle folgenden geben das ergebnis zurück, A wird nicht verändert                          
function grid(rows, columns: integer): gridtype; // muss funktion sein :/
function rows(A: gridtype): integer;
function columns(A: gridtype): integer;
function transpose(A: gridtype): gridtype;
function copy(A: gridtype): gridtype; // ja überschirieben lazarus copy ist scheiße
function add(A, B: gridtype): gridtype;
function add(A: gridtype; n: double): gridtype;
function multiply(A, B: gridtype): gridtype;
function multiply(A: gridtype; n: double): gridtype;
function dot(A, B: gridtype): gridtype;


implementation

procedure fill(A: gridtype; n: double);
var i, j : Integer;
begin  
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      A[i,j] := n;
end;

procedure fillRandom(A: gridtype);
var i, j : Integer;
begin
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      A[i,j] := random*2-1;
end;

function grid(rows, columns: integer): gridtype;
begin
  setlength(result, rows, columns);
  fill(result, 0);
end;

function rows(A: gridtype): integer;
begin
  result := Length(A);
end;

function columns(A: gridtype): integer;
begin
  result := Length(A[0]);
end;

function transpose(A: gridtype): gridtype;  
var i, j : Integer;
begin
  setlength(result, columns(A), rows(A)); // check this shit
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[j,i] := A[i,j];
end;

function copy(A: gridtype): gridtype;  
var i, j : Integer;
begin    
  setlength(result, rows(A), columns(A));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[i,j] := A[i,j];
end;

function add(A, B: gridtype): gridtype;     
var i, j : Integer;
begin                                              
  if (rows(A) <> rows(B)) or (columns(A) <> columns(B)) then
    raise Exception.Create('Both Matrixies must have equal size');
  setlength(result, rows(A), columns(A));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[i,j] := A[i,j] + B[i,j];
end;

function add(A: gridtype; n: double): gridtype;
var i, j : Integer;
begin
  setlength(result, rows(A), columns(A));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[i,j] := A[i,j] + n;
end;

function multiply(A, B: gridtype): gridtype;
var i, j : Integer;
begin
  if (rows(A) <> rows(B)) or (columns(A) <> columns(B)) then
    raise Exception.Create('Both Matrixies must have equal size');
  setlength(result, rows(A), columns(A));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[i,j] := A[i,j] * B[i,j];
end;

function multiply(A: gridtype; n: double): gridtype;
var i, j : Integer;
begin
  setlength(result, rows(A), columns(A));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(A)-1 do
      result[i,j] := A[i,j] * n;
end;

function dot(A, B: gridtype): gridtype; // B musst be the one with less columns (a vector for example)
// keep track of what you pass yourself too!
var i, j, k: Integer;
begin
  if columns(A) <> rows(B) then
    raise Exception.Create('Both Matrixies must be compatible to dot');
  result := grid(rows(A), columns(B));
  for i:= 0 to rows(A)-1 do
    for j:= 0  to columns(B)-1 do
      for k := 0 to columns(A)-1 do
        result[i,j] := result[i,j] + A[i,k] * B[k,j];
end;

end.

