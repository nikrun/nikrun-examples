uses '../nikrun-cli/stdlib/Console.pas', System;

begin
  Console.WriteLine('=================================');
  Console.WriteLine('     N U M B E R  G U E S S      ');
  Console.WriteLine('=================================');
  Console.WriteLine('I am thinking of a number between 1 and 100.');
  Console.WriteLine('Can you guess it?');
  Console.WriteLine('');

  // Random(100) returns 0 to 99, so + 1 for 1 to 100
  var secret := Random(100) + 1;
  var guess := 0;
  var attempts := 0;

  while guess <> secret do
  begin
    Console.WriteStr('Your guess: ');
    var input := Console.ReadLine();
    
    guess := StrToInt(input);
    attempts += 1;

    if guess < secret then
    begin
      Console.WriteLine('Too low! Try again.');
    end
    else if guess > secret then
    begin
      Console.WriteLine('Too high! Try again.');
    end;
  end;

  Console.WriteLine('');
  Console.WriteLine('CONGRATULATIONS!');
  Console.WriteLine('You guessed the number ' + IntToStr(secret) + ' in ' + IntToStr(attempts) + ' attempts!');
end;
