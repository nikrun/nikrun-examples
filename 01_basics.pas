uses System;

type
  TWeekday = (Monday, Tuesday = 5, Wednesday);

var today: TWeekday;
var greeting: String;
var randomNumber: Integer;
begin
  // 1. Enums and Type-Casting
  today := Wednesday;
  PrintLn('The Enum value of Wednesday is: ' + IntToStr(Ord(today)));
  
  // 2. Compound Assignments
  greeting := 'Hello';
  greeting += ' Nikrun Developer!';
  PrintLn(greeting);
  
  // 3. String Manipulation (from Strings unit)
  PrintLn('All uppercase: ' + UpperCase(greeting));
  PrintLn('Length of the string: ' + IntToStr(Length(greeting)));
  
  // 4. Mathematics
  randomNumber := 10;
  randomNumber *= 5; // randomNumber is now 50
  PrintLn('A random number up to 50: ' + IntToStr(Random(randomNumber)));
end;
