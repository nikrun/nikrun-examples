program SetExample;

var
  Vowels, WordChars, ResultChars: set of Integer;
  IsSubset: Boolean;

begin
  // Set Creation
  Vowels := [97, 101, 105, 111, 117]; // ASCII for 'a', 'e', 'i', 'o', 'u'
  WordChars := [97, 100, 101];        // ASCII for 'a', 'd', 'e'

  // IN Operator
  if 97 in Vowels then
    Writeln('a is a vowel')
  else
    Writeln('a is not a vowel');

  // Set Union
  ResultChars := Vowels + WordChars;
  if 100 in ResultChars then
    Writeln('d is in the union');

  // Set Difference
  ResultChars := Vowels - WordChars;
  if 97 in ResultChars then
    Writeln('a is in the difference')
  else
    Writeln('a is NOT in the difference (expected)');

  // Set Intersection
  ResultChars := Vowels * WordChars;
  if 101 in ResultChars then
    Writeln('e is in the intersection');

  // Subset Comparison
  IsSubset := WordChars <= Vowels;
  if IsSubset then
    Writeln('WordChars is a subset of Vowels')
  else
    Writeln('WordChars is NOT a subset of Vowels');

  // Include and Exclude
  Include(Vowels, 121); // 'y'
  if 121 in Vowels then
    Writeln('y is now included in Vowels');
    
  Exclude(Vowels, 97); // 'a'
  if 97 in Vowels then
    Writeln('a is in Vowels')
  else
    Writeln('a is excluded from Vowels');
end.
