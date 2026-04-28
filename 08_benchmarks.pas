uses System;

const 
  FibN = 30;
  SieveSize = 10000;
  SortSize = 2000;

// --- 1. Fibonacci (Call Overhead & Recursion) ---
function Fib(n: Integer): Integer;
begin
  if n <= 1 then
    Result := n
  else
    Result := Fib(n - 1) + Fib(n - 2);
end;

procedure RunFibonacci;
var res: Integer;
begin
  PrintLn('--- 1. Recursive Fibonacci ---');
  PrintLn('Calculating Fib(' + IntToStr(FibN) + ')...');
  res := Fib(FibN);
  PrintLn('Result: ' + IntToStr(res));
  PrintLn('');
end;

// --- 2. Sieve of Eratosthenes (Array & Loops) ---
type TSieveArray = array[1..SieveSize] of Integer;

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

// --- 3. QuickSort (Recursion & Array Swaps) ---
type TSortArray = array[1..2000] of Integer;

var Arr: TSortArray;

procedure QuickSort(low, high: Integer);
var
  i, j, pivot, temp: Integer;
begin
  if low < high then
  begin
    pivot := Arr[high];
    i := low - 1;
    for j := low to high - 1 do
    begin
      if Arr[j] < pivot then
      begin
        i := i + 1;
        temp := Arr[i];
        Arr[i] := Arr[j];
        Arr[j] := temp;
      end;
    end;
    temp := Arr[i + 1];
    Arr[i + 1] := Arr[high];
    Arr[high] := temp;
    
    QuickSort(low, i);
    QuickSort(i + 2, high);
  end;
end;

procedure RunSort;
var i: Integer;
begin
  PrintLn('--- 3. QuickSort ---');
  PrintLn('Generating ' + IntToStr(SortSize) + ' random numbers...');
  for i := 1 to SortSize do
    Arr[i] := Random(10000);
    
  PrintLn('Sorting...');
  QuickSort(1, SortSize);
  
  PrintLn('Sort complete. First element: ' + IntToStr(Arr[1]) + ', Last element: ' + IntToStr(Arr[SortSize]));
  PrintLn('');
end;

begin
  PrintLn('Starting Nikrun Benchmarks...');
  PrintLn('');
  
  RunFibonacci();
  RunSieve();
  RunSort();
  
  PrintLn('All benchmarks completed!');
end;
