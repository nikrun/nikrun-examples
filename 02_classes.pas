uses System;

type
  TBase = class
  public
    var ID: Integer;
    
    function GetDescription: String;
    begin
      Result := 'Base class with ID: ' + IntToStr(Self.ID);
    end;
  end;

type
  TChild = class(TBase)
  public
    var Name: String;
    
    // Simple method
    procedure ShowInfo;
    begin
      PrintLn('Name: ' + Self.Name);
      PrintLn('Description: ' + Self.GetDescription()); // Access to inherited method
    end;
  end;

var
  obj: TChild;
begin
  // Instantiation
  obj := TChild.Create;
  
  // Assign inherited and own fields
  obj.ID := 42;
  obj.Name := 'Nikrun Object';
  
  // Call own method
  obj.ShowInfo();
  
  // Demonstrate built-ins of TObject (implicitly inherited)
  PrintLn('Class name: ' + obj.ClassName);
  PrintLn('Parent class name: ' + TChild.ClassParent.ClassName);
  
  // Free memory
  obj.Free;
  PrintLn('Object freed.');
end;
