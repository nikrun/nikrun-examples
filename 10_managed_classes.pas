uses System;

type
  TParent = managed class
  private
    var FParentName: String;
  public
    constructor;
    begin
      FParentName := 'Parent';
      PrintLn('  -> TParent.constructor (FParentName initialisiert auf: ', FParentName, ')');
    end;

    destructor;
    begin
      PrintLn('  -> TParent.destructor (FParentName war: ', FParentName, ')');
    end;

    property ParentName: String read FParentName write FParentName;
  end;

type
  TChild = managed class(TParent)
  private
    var FChildAge: Integer;
  public
    constructor;
    begin
      // Implizit wird hier zuerst TParent.constructor ausgeführt.
      FChildAge := 18;
      PrintLn('  -> TChild.constructor (FChildAge initialisiert auf: ', FChildAge, ')');
    end;

    destructor;
    begin
      PrintLn('  -> TChild.destructor (FChildAge war: ', FChildAge, ')');
      inherited; // Ruft den Destruktor der Elternklasse auf
    end;

    property ChildAge: Integer read FChildAge write FChildAge;
  end;

// 3. Demonstration von Return Value Protection
function CreateChildInstance(Age: Integer): TChild;
begin
  PrintLn('[CreateChildInstance] Starte...');
  Result.ChildAge := Age;
  Result.ParentName := 'Dynamic Parent';
  
  PrintLn('[CreateChildInstance] Instanz konfiguriert. Ende der Funktion.');
end;

procedure TestScopeLifetime;
var
  childObj: TChild;
begin
  PrintLn('--- Scope-Lifetime Test ---');
  PrintLn('Vor Erstzugriff (Lazy-Initialisierung)...');
  
  childObj.ChildAge := 42;
  
  PrintLn('Erstzugriff abgeschlossen. ChildAge: ', childObj.ChildAge);
  PrintLn('Ende der Prozedur TestScopeLifetime.');
end;

procedure TestReturnValueProtection;
var
  retObj: TChild;
begin
  PrintLn('--- Return-Value Protection Test ---');
  PrintLn('Rufe CreateChildInstance auf...');
  retObj := CreateChildInstance(25);
  
  PrintLn('Rückgabewert erhalten. retObj.ChildAge: ', retObj.ChildAge);
  PrintLn('Ende der Prozedur TestReturnValueProtection.');
end;

begin
  PrintLn('=== NIKRUN MANAGED CLASS DEMONSTRATION ===');
  PrintLn('');
  
  TestScopeLifetime();
  
  PrintLn('');
  TestReturnValueProtection();
  
  PrintLn('');
  PrintLn('=== DEMO BEENDET ===');
end;
