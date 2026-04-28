uses '../nikrun-cli/stdlib/Console.pas';

Console.ClearScreen;
Console.SetForegroundColor(ccBlue);
Console.WriteLine('=== Nikrun Interactive Console ===');

Console.WriteStr('Please enter your name: ');
var name := Console.ReadLine();

Console.WriteStr('Hello ' + name + '! How old are you? ');
var ageStr := Console.ReadLine();

Console.WriteLine('Perfect. So you are ' + ageStr + ' years old.');
Console.WriteLine('Thanks for testing Nikrun!');
