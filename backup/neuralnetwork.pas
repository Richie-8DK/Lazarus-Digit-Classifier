unit NeuralNetwork;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, linAlg;

type
  TNeuralNetwork = object
    private
    public                             
      input_n, hidden_n, output_n: integer;
      learningrate: double;
      weights_ih, weights_ho, bias_ih, bias_ho: gridtype;
      constructor Create(input_nodes, hidden_nodes, output_nodes: integer);
      function feedforward(input: gridtype): gridtype;           
      function train(input, targets: gridtype): gridtype;
  end;

implementation

function sigmoid(x: double): double;
begin
  result := 1/(1+exp(-x));
end;

function dsigmoid(y: double): double;
begin
  // input is already y = sigmoid(x)
  // so result := sigmoid(x) * (1 - sigmoid(x))
  // becomes:
  result := y * (1 - y);
end;


constructor TNeuralNetwork.Create(input_nodes, hidden_nodes, output_nodes: integer);
begin
  input_n := input_nodes;
  hidden_n := hidden_nodes;
  output_n := output_nodes;
  learningrate := 0.2;

  weights_ih := grid(hidden_n, input_n);
  weights_ho := grid(output_n, hidden_n);
  fillRandom(weights_ih);
  fillRandom(weights_ho);

  bias_ih := grid(hidden_n, 1);
  bias_ho := grid(output_n, 1);
  fillRandom(bias_ih);
  fillRandom(bias_ho);

end;

function TNeuralNetwork.feedforward(input: gridtype): gridtype;
var hidden, output: gridtype;
  i, j: integer;
begin


  // hidden layer
  hidden := add(dot(weights_ih, input), bias_ih);
  // activation function
  for i:= 0 to rows(hidden)-1 do
    for j:= 0  to columns(hidden)-1 do
      hidden[i,j] := sigmoid(hidden[i,j]);


  // output layer
  output := add(dot(weights_ho, hidden), bias_ho);
  // activation function
  for i:= 0 to rows(output)-1 do
    for j:= 0  to columns(output)-1 do
      output[i,j] := sigmoid(output[i,j]);

  result := output;
end;

function TNeuralNetwork.train(input, targets: gridtype): gridtype;
var hidden, output, error_output, error_hidden, gradient_ho, gradient_ih, d_weights_ho, d_weights_ih: gridtype;
  i, j: integer;
begin
   // hidden layer
  hidden := add(dot(weights_ih, input), bias_ih);
  // activation function
  for i:= 0 to rows(hidden)-1 do
    for j:= 0  to columns(hidden)-1 do
      hidden[i,j] := sigmoid(hidden[i,j]);

  // output layer
  output := add(dot(weights_ho, hidden), bias_ho);
  // activation function
  for i:= 0 to rows(output)-1 do
    for j:= 0  to columns(output)-1 do
      output[i,j] := sigmoid(output[i,j]);

  
  // backpropagate now! :)


  // output layer:

  // calculate output error
  error_output := add(targets, multiply(output, -1));


  // gradient of hidden - output
  gradient_ho := copy(output);
  // derivative of activation function
  for i:= 0 to rows(gradient_ho)-1 do
    for j:= 0  to columns(gradient_ho)-1 do
      gradient_ho[i,j] := dsigmoid(gradient_ho[i,j]);
  gradient_ho := multiply(multiply(gradient_ho, error_output), self.learningrate);

  // tune weights and bias between hidden and output
  d_weights_ho := dot(gradient_ho, transpose(hidden));
  self.weights_ho := add(self.weights_ho, d_weights_ho);
  self.bias_ho := add(self.bias_ho, gradient_ho);


  // hidden layer:


  // hidden layer error
  error_hidden := dot(transpose(self.weights_ho), error_output);

  // gradient of input - hidden
  gradient_ih := copy(hidden);
  // derivative of activation function
  for i:= 0 to rows(gradient_ih)-1 do
    for j:= 0  to columns(gradient_ih)-1 do
      gradient_ih[i,j] := dsigmoid(gradient_ih[i,j]);
  gradient_ih := multiply(multiply(gradient_ih, error_hidden), self.learningrate);

  // tune weights and bias between input and hidden
  d_weights_ih := dot(gradient_ih, transpose(input));
  self.weights_ih := add(self.weights_ih, d_weights_ih);
  self.bias_ih := add(self.bias_ih, gradient_ih);

  result := grid(1,1);
end;

end.

