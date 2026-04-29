uses '../nikrun-cli/stdlib/Console.pas';

type
  TFood = class
  public
    var X: Integer;
    var Y: Integer;
    var MaxWidth: Integer;
    var MaxHeight: Integer;

    procedure Spawn;
    begin
      X := Random(MaxWidth - 3) + 2;
      Y := Random(MaxHeight - 5) + 4;
    end;

    procedure Draw;
    begin
      Console.SetForegroundColor(ccRed);
      Console.SetCursorPosition(X, Y);
      Console.WriteStr('@');
    end;
  end;

type
  TDirection = enum (
    dirNone,
    dirUp,
    dirDown,
    dirLeft,
    dirRight
  );

  TIntArray = array[1..400] of Integer;

  TSnake = class
  public
    var bodyX: TIntArray;
    var bodyY: TIntArray;
    var len: Integer;
    var dir: TDirection;
    var oldTailX: Integer;
    var oldTailY: Integer;
    var i: Integer;

    procedure Init(startX, startY: Integer);
    begin
      len := 3;
      bodyX[1] := startX;
	  bodyY[1] := startY;
      bodyX[2] := startX - 1;
	  bodyY[2] := startY;
      bodyX[3] := startX - 2;
	  bodyY[3] := startY;
      dir := dirRight;
    end;

    procedure SetDirection(newDir: TDirection);
    begin
      if (dir = dirRight) and (newDir = dirLeft) then Exit;
      if (dir = dirLeft) and (newDir = dirRight) then Exit;
      if (dir = dirDown) and (newDir = dirUp) then Exit;
      if (dir = dirUp) and (newDir = dirDown) then Exit;

      dir := newDir;
    end;

    procedure Move;
    begin
      oldTailX := bodyX[len];
      oldTailY := bodyY[len];

      for i := len downto 2 do
      begin
        bodyX[i] := bodyX[i-1];
        bodyY[i] := bodyY[i-1];
      end;

      if dir = dirRight then bodyX[1] := bodyX[1] + 1;
      if dir = dirLeft then bodyX[1] := bodyX[1] - 1;
      if dir = dirUp then bodyY[1] := bodyY[1] - 1;
      if dir = dirDown then bodyY[1] := bodyY[1] + 1;
    end;

    procedure Grow;
    begin
      len := len + 1;
      // Inherit old tail position so it isn't erased
      bodyX[len] := oldTailX;
      bodyY[len] := oldTailY;
    end;

    function HeadX: Integer;
    begin
      Result := bodyX[1];
    end;

    function HeadY: Integer;
    begin
      Result := bodyY[1];
    end;

    function CheckSelfCollision: Boolean;
    begin
      Result := false;
      for i := 2 to len do
        if (HeadX() = bodyX[i]) and (HeadY() = bodyY[i]) then
          Result := true;
    end;

    procedure Draw;
    begin
      Console.SetCursorPosition(oldTailX, oldTailY);
      Console.WriteStr(' ');

      Console.SetForegroundColor(ccGreen);
      Console.SetCursorPosition(HeadX(), HeadY());
      Console.WriteStr('O');
    end;

    procedure DrawFull;
    begin
      Console.SetForegroundColor(ccGreen);
      for i := 1 to len do
      begin
        Console.SetCursorPosition(bodyX[i], bodyY[i]);
        Console.WriteStr('O');
      end;
    end;
  end;

type
  TGame = class
  public
    var Snake: TSnake;
    var Food: TFood;
    var Score: Integer;
    var IsRunning: Boolean;
    var Width: Integer;
    var Height: Integer;
    var i: Integer;
    var key: String;

    procedure DrawBorders;
    begin
      Console.SetForegroundColor(ccCyan);
      for i := 1 to Width do
      begin
        Console.SetCursorPosition(i, 3); Console.WriteStr('-');
        Console.SetCursorPosition(i, Height); Console.WriteStr('-');
      end;
      for i := 3 to Height do
      begin
        Console.SetCursorPosition(1, i); Console.WriteStr('|');
        Console.SetCursorPosition(Width, i); Console.WriteStr('|');
      end;
    end;

    procedure DrawUI;
    begin
      Console.SetForegroundColor(ccWhite);
      Console.SetCursorPosition(1, 1);
      Console.WriteStr('--- NIKRUN SNAKE OOP ---');
      Console.SetCursorPosition(1, 2);
      Console.WriteStr('Score: ' + IntToStr(Score) + '   Use arrow keys to move, X to exit');
    end;

    procedure Init;
    begin
      Width := 40;
      Height := 20;
      Score := 0;
      IsRunning := true;

      Snake := TSnake.Create;
      Snake.Init(10, 10);

      Food := TFood.Create;
      Food.MaxWidth := Width;
      Food.MaxHeight := Height;
      Food.Spawn();

      Console.EnableRawMode();
      Console.HideCursor();
      Console.ClearScreen();

      DrawBorders();
      DrawUI();
      
      Snake.DrawFull();
      Food.Draw();
    end;

    procedure HandleInput;
    begin
      if Console.KeyAvailable() then begin
        key := Console.ReadKey();
        if key = #27 then begin // ESC für Sondertasten
          if (Console.ReadKey() = '[') then begin
            var k2 := Console.ReadKey(); // A/B/C/D

            if k2 = 'A' then Snake.SetDirection(dirUp); // Pfeil hoch
            if k2 = 'B' then Snake.SetDirection(dirDown);  // Pfeil runter
            if k2 = 'C' then Snake.SetDirection(dirRight);  // Pfeil rechts
            if k2 = 'D' then Snake.SetDirection(dirLeft); // Pfeil links
          end;
        end else if key = 'x' then
          IsRunning := false;
      end;
    end;

    procedure UpdateLogic;
    begin
      Snake.Move();

      // Check Walls
      if (Snake.HeadX() <= 1) or (Snake.HeadX() >= Width) or 
         (Snake.HeadY() <= 3) or (Snake.HeadY() >= Height)
      then
        IsRunning := false;

      // Check Self
      if Snake.CheckSelfCollision() then
        IsRunning := false;

      // Check Food
      if (Snake.HeadX() = Food.X) and (Snake.HeadY() = Food.Y) then
      begin
        Snake.Grow();
        Score := Score + 10;
        
        // Update Score UI
        Console.SetCursorPosition(8, 2);
        Console.SetForegroundColor(ccWhite);
        Console.WriteStr(IntToStr(Score) + ' ');

        Food.Spawn();
        Food.Draw();
      end;
    end;

    procedure Render;
    begin
      if IsRunning then
        Snake.Draw();

      // Show score at the bottom
      Console.SetCursorPosition(1, Height + 1);
      Console.SetForegroundColor(ccWhite);
      Console.WriteStr('Score: ' + IntToStr(Score) + '      ');
    end;

    procedure Run;
    begin
      Init();

      while IsRunning do
      begin
        HandleInput();
        UpdateLogic();
        Render();
        Sleep(100);
      end;

      Console.ResetFormat();
      Console.SetCursorPosition(1, Height + 2);
      Console.WriteStr('GAME OVER! Final Score: ' + IntToStr(Score));
      Console.WriteLine('');
      Console.ShowCursor();
      Console.DisableRawMode();
    end;

    procedure Cleanup;
    begin
      Snake.Free;
      Food.Free;
    end;
  end;

var
  Game: TGame;

begin
  Game := TGame.Create;
  Game.Run();
  Game.Cleanup();
  Game.Free;
end;
