unit mnist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, linAlg, NeuralNetwork, Math;

type

  { TDigitClassifierForm }

  TDigitClassifierForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Shape1: TShape;
    Shape2: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  DigitClassifierForm: TDigitClassifierForm;
  type
    TData = record
      labels: array of integer;
      images: array of gridtype
    end;
var testing_data, training_data: TData;
  epoch: integer;
  nn: TNeuralNetwork;
  drawing: Boolean;
  drawn_image: gridtype;
  brush_rad: Double;

implementation

function load_data(filename: string): TData;
// loads data from a csv file
Var line, num : String;
    F : Textfile;
    i, j, k: integer;
    img: gridtype;
begin
  with result do
  begin
    AssignFile(F, filename);
    Reset(F);
    num:='A';
    i:=0;
    While not Eof(f) do
      Begin
      setLength(labels, i+1);
      setLength(images, i+1);
      // load label
      Readln(F,line);
      labels[i] := StrToInt(line);
      // load image
      Readln(F,line);
      img := grid(28*28, 1);
      num := '';
      k := 0;
      for j:=1 to Length(line) do
        begin
        if line[j] = ',' then
          begin
            img[k][0] := StrToInt(num)/255;
            num := '';
            inc(k);
          end
        else
          num := num+line[j];
        end;
      images[i] := img;
      inc(i);
      end;
    CloseFile(F);
  end;
end;

function get_max(guesses: gridtype):integer;
// return the spot with maximum value of n x 1 grid (Vector)
var j: integer;
  confidence: double;
begin
  result := 0;
  confidence := 0;
  for j:=0 to length(guesses)-1 do
    if guesses[j, 0] > confidence then
      begin
        confidence := guesses[j, 0];
        result := j;
      end;
end;

procedure show_img(img: gridtype);
// display an 28*28 image to canvas
var i, j: integer; 
  value: double;
begin
  for i:=0 to 27 do
    for j:=0 to 27 do
      begin
      value := img[i+j*28,0];
      DigitClassifierForm.PaintBox1.Canvas.Brush.Color:=RGBToColor(round(value*255), round(value*255), round(value*255));
      DigitClassifierForm.PaintBox1.Canvas.FillRect(i*10, j*10, i*10+10, j*10+10);
      end;
end;

procedure show_rand();
// show and predict random image from testing dataset
var rand, max: integer;
  img, guess: gridtype;
begin
  drawing := False;
  rand := trunc(random*length(testing_data.images));
  img := testing_data.images[rand];
  show_img(img);
  DigitClassifierForm.Label1.Caption := IntToStr(testing_data.labels[rand]);
  guess := nn.feedforward(img);
  max := get_max(guess);
  if max = testing_data.labels[rand] then
    DigitClassifierForm.Label4.Color:= clGreen
  else
    DigitClassifierForm.Label4.Color:= clRed;
  DigitClassifierForm.Label4.Caption := 'Prediction: ' + IntToStr(max);
end;

procedure train();
var i: integer;
  target: gridtype;
begin
  // train neural net on training data
  with training_data do
    for i:=0 to length(labels)-1 do
      begin
      target := grid(10, 1);
      target[labels[i], 0] := 1;
      nn.train(images[i], target);
      end;
  inc(epoch);
  DigitClassifierForm.Label2.Caption := 'Epoch: ' + IntToStr(epoch);
end;

function test(): double;
var i, score, max: integer;
  guess: gridtype;
begin
  // test how many digits get labeled right
  with testing_data do
  begin
    score := 0;
      for i:=0 to length(labels)-1 do
        begin
        guess := nn.feedforward(images[i]);
        max := get_max(guess);
        if max = labels[i] then
          inc(score);
        end;
    result := score/length(labels);
  end;
end;

{$R *.lfm}

{ TDigitClassifierForm }

procedure TDigitClassifierForm.Button1Click(Sender: TObject);
begin
  // load vital program structure
  training_data := load_data('storage/mnist_handwritten_train.csv');
  testing_data := load_data('storage/mnist_handwritten_test.csv');
  // decrease the number of hidden nodes for higher efficiency (good results, less execution time)
  // increase for accuracy (accurate results, after long execution time)
  nn.Create(28*28, 45, 10);
  drawn_image := grid(28*28, 1);
  brush_rad:=1.5;
  DigitClassifierForm.GroupBox1.Visible := True;
  DigitClassifierForm.PaintBox2.Visible := True;
  DigitClassifierForm.Button1.Visible := False;
  show_rand();
end;

procedure TDigitClassifierForm.Button2Click(Sender: TObject);
begin                                            
  show_rand();
end;

procedure TDigitClassifierForm.Button3Click(Sender: TObject);
begin
  train();
end;

procedure TDigitClassifierForm.Button4Click(Sender: TObject);
var succesrate: Double;
begin
  succesrate := test();
  DigitClassifierForm.Label3.Caption := 'Success: ' +FloatToStrF(100*succesrate, ffFixed, 3, 5)+' %';
end;

procedure TDigitClassifierForm.Button5Click(Sender: TObject);
begin
  // reset drawn image
  drawn_image := grid(28*28, 1);
end;

procedure TDigitClassifierForm.PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  drawing := true;
  DigitClassifierForm.PaintBox2.Canvas.Pen.Width:=15;
  DigitClassifierForm.PaintBox2.Canvas.MoveTo(X,Y);
end;

procedure TDigitClassifierForm.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i,j: integer;
  d, n, a, value: double;
begin
  if drawing then
    begin
    // draw in canvas
    DigitClassifierForm.PaintBox2.Canvas.LineTo(X,Y);
    // save to 28*28 image
    for i:=0 to 27 do
      for j:=0 to 27 do
        begin
        // value(d) = 1-a*d^n
        d := sqrt(sqr(x/10 - i)+sqr(y / 10 - j));
        n := 3.5;
        a := power(brush_rad, -n);
        value := 1-a*power(d,n);
        if d < brush_rad then
          if drawn_image[i+j*28, 0] < value then
            drawn_image[i+j*28, 0] := value;
        end;
    end;
end;

procedure TDigitClassifierForm.PaintBox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var max: integer;
begin
  // predict drawn digit
  drawing := false;
  show_img(drawn_image);
  max := get_max(nn.feedforward(drawn_image));
  DigitClassifierForm.Label4.Caption := 'Prediction: ' + IntToStr(max);
  DigitClassifierForm.Label4.Color := clNone;
  DigitClassifierForm.Label1.Caption := '';
end;

end.

