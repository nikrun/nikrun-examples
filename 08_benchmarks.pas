uses System;

const 
  CallCount = 500000;
  SieveSize = 10000;
  SortSize = 2000;

// --- 1. Function Call Overhead ---
function DummyAdd(a, b, c: Integer): Integer;
begin
  Result := a + b + c;
end;

procedure RunCallOverhead;
var 
  i, sum: Integer;
begin
  PrintLn('--- 1. Function Call Overhead ---');
  PrintLn('Calling a function ' + IntToStr(CallCount) + ' times...');
  sum := 0;
  for i := 1 to CallCount do
    sum := sum + DummyAdd(1, 2, 3);
  PrintLn('Result: ' + IntToStr(sum));
  PrintLn('');
end;

// --- 2. Sieve of Eratosthenes (Array & Loops) ---
type TSieveArray = array[1..10000] of Integer;

procedure RunSieve;
var
  primes: TSieveArray;
  p, p2: Integer;
  count: Integer;
begin
  PrintLn('--- 2. Sieve of Eratosthenes ---');
  PrintLn('Calculating primes up to ' + IntToStr(SieveSize) + '...');
  
  for p := 1 to SieveSize do
    primes[p] := 1; // 1 means prime
    
  p := 2;
  while p * p <= SieveSize do
  begin
    if primes[p] = 1 then
    begin
      p2 := p * p;
      while p2 <= SieveSize do
      begin
        primes[p2] := 0;
        p2 := p2 + p;
      end;
    end;
    p := p + 1;
  end;
  
  count := 0;
  for p := 2 to SieveSize do
    if primes[p] = 1 then
      count := count + 1;
      
  PrintLn('Found ' + IntToStr(count) + ' primes.');
  PrintLn('');
end;

// --- 3. BubbleSort (Array Swaps) ---
type TSortArray = array[1..2000] of Integer;

procedure RunSort;
var 
  Arr: TSortArray;
  i, j, temp: Integer;
begin
  PrintLn('--- 3. BubbleSort ---');
  PrintLn('Generating ' + IntToStr(SortSize) + ' random numbers...');
  for i := 1 to SortSize do
    Arr[i] := Random(10000);
    
  PrintLn('Sorting...');
  
  for i := 1 to SortSize do
    for j := 1 to SortSize - i do
      if Arr[j] > Arr[j + 1] then
      begin
        temp := Arr[j];
        Arr[j] := Arr[j + 1];
        Arr[j + 1] := temp;
      end;
  
  PrintLn('Sort complete. First element: ' + IntToStr(Arr[1]) + ', Last element: ' + IntToStr(Arr[SortSize]));
  PrintLn('');
end;

begin
  PrintLn('Starting Nikrun Benchmarks...');
  PrintLn('');
  
  RunCallOverhead();
  RunSieve();
  RunSort();
  
  PrintLn('All benchmarks completed!');
end;
