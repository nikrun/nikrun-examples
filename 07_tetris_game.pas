uses '../nikrun-cli/stdlib/Console.pas';

type
  TBoardArray = array[1..200] of Integer;
  TPieceArray = array[1..7] of Integer;
  TPowArray = array[1..16] of Integer;

type
  TBoard = class
  public
    var Cells: TBoardArray;
    var Width: Integer;
    var Height: Integer;
    var i: Integer;
    var x: Integer;
    var y: Integer;

    procedure Init;
    begin
      Width := 10;
      Height := 20;
      for i := 1 to 200 do
        Cells[i] := 0;
    end;

    function GetCell(bx, by: Integer): Integer;
    begin
      if (bx < 1) or (bx > Width) or (by < 1) or (by > Height) then
        Result := -1 // Wall or Out of bounds
      else
        Result := Cells[(by - 1) * Width + bx];
    end;

    procedure SetCell(bx, by, color: Integer);
    begin
      if (bx >= 1) and (bx <= Width) and (by >= 1) and (by <= Height) then
        Cells[(by - 1) * Width + bx] := color;
    end;

    function ClearLines: Integer;
    var
      linesCleared: Integer;
      cy, cx, shiftY: Integer;
      isFull: Boolean;
    begin
      linesCleared := 0;
      cy := Height;
      while cy >= 1 do
      begin
        isFull := true;
        for cx := 1 to Width do
          if GetCell(cx, cy) = 0 then
            isFull := false;

        if isFull then
        begin
          linesCleared := linesCleared + 1;
          // Shift everything above down
          for shiftY := cy downto 2 do
            for cx := 1 to Width do
              SetCell(cx, shiftY, GetCell(cx, shiftY - 1));
          
          // Clear top line
          for cx := 1 to Width do
            SetCell(cx, 1, 0);

          // We must check this cy again since we shifted stuff down
          cy := cy + 1;
        end;
        cy := cy - 1;
      end;
      Result := linesCleared;
    end;

    procedure Draw(offsetX, offsetY: Integer);
    var color: Integer;
    begin
      for y := 1 to Height do
        for x := 1 to Width do
        begin
          color := GetCell(x, y);
          Console.SetCursorPosition(offsetX + (x - 1) * 2, offsetY + y - 1);
          if color = 0 then
          begin
            Console.SetForegroundColor(ccWhite);
            Console.WriteStr('· ');
          end
          else
          begin
            Console.SetForegroundColor(color);
            Console.WriteStr('[]');
          end;
        end;
    end;
  end;

type
  TPiece = class
  public
    var Shapes: TPieceArray;
    var Colors: TPieceArray;
    var Pow2: TPowArray;
    var CurrentType: Integer;
    var CurrentRot: Integer;
    var X: Integer;
    var Y: Integer;
    var i: Integer;

    procedure InitShapes;
    begin
      // 1: I (Cyan)
      Shapes[1] := 3840;   Colors[1] := ccCyan;
      // 2: J (Blue)
      Shapes[2] := 36352;  Colors[2] := ccBlue;
      // 3: L (Orange->Yellow)
      Shapes[3] := 11776;  Colors[3] := ccYellow;
      // 4: O (Yellow)
      Shapes[4] := 26112;  Colors[4] := ccYellow;
      // 5: S (Green)
      Shapes[5] := 27648;  Colors[5] := ccGreen;
      // 6: T (Magenta)
      Shapes[6] := 19968;  Colors[6] := ccMagenta;
      // 7: Z (Red)
      Shapes[7] := 50688;  Colors[7] := ccRed;

      Pow2[1] := 32768; Pow2[2] := 16384; Pow2[3] := 8192; Pow2[4] := 4096;
      Pow2[5] := 2048;  Pow2[6] := 1024;  Pow2[7] := 512;  Pow2[8] := 256;
      Pow2[9] := 128;   Pow2[10] := 64;   Pow2[11] := 32;  Pow2[12] := 16;
      Pow2[13] := 8;    Pow2[14] := 4;    Pow2[15] := 2;   Pow2[16] := 1;
    end;

    function GetBlock(px, py, rot: Integer): Boolean;
    var pi: Integer;
    var mask: Integer;
    begin
      // Calculate index based on rotation
      if rot = 0 then pi := py * 4 + px;
      if rot = 1 then pi := 12 + py - (px * 4);
      if rot = 2 then pi := 15 - (py * 4) - px;
      if rot = 3 then pi := 3 - py + (px * 4);

      pi := pi + 1;
      mask := Shapes[CurrentType];
      
      if (mask div Pow2[pi]) mod 2 = 1 then
        Result := true
      else
        Result := false;
    end;

    procedure Spawn;
    begin
      CurrentType := Random(7) + 1;
      CurrentRot := 0;
      X := 4;
      Y := 1;
    end;

    function DoesFit(Board: TBoard; testX, testY, testRot: Integer): Boolean;
    var fx, fy: Integer;
    var cellState: Integer;
    begin
      Result := true;
      for fy := 0 to 3 do
        for fx := 0 to 3 do
          if GetBlock(fx, fy, testRot) then
          begin
            cellState := Board.GetCell(testX + fx, testY + fy);
            if cellState <> 0 then // Wall or occupied
              Result := false;
          end;
    end;

    procedure LockToBoard(Board: TBoard);
    var fx, fy: Integer;
    begin
      for fy := 0 to 3 do
        for fx := 0 to 3 do
          if GetBlock(fx, fy, CurrentRot) then
            Board.SetCell(X + fx, Y + fy, Colors[CurrentType]);
    end;

    procedure Erase(offsetX, offsetY: Integer);
    var fx, fy: Integer;
    begin
      Console.SetForegroundColor(ccWhite);
      for fy := 0 to 3 do
        for fx := 0 to 3 do
          if GetBlock(fx, fy, CurrentRot) then
          begin
            Console.SetCursorPosition(offsetX + (X + fx - 1) * 2, offsetY + (Y + fy - 1));
            Console.WriteStr('· ');
          end;
    end;

    procedure Draw(offsetX, offsetY: Integer);
    var fx, fy: Integer;
    begin
      Console.SetForegroundColor(Colors[CurrentType]);
      for fy := 0 to 3 do
        for fx := 0 to 3 do
          if GetBlock(fx, fy, CurrentRot) then
          begin
            Console.SetCursorPosition(offsetX + (X + fx - 1) * 2, offsetY + (Y + fy - 1));
            Console.WriteStr('[]');
          end;
    end;
  end;

type
  TGame = class
  public
    var Board: TBoard;
    var Piece: TPiece;
    var IsRunning: Boolean;
    var Score: Integer;
    var TickCount: Integer;
    var FallSpeed: Integer; // Ticks per fall
    var i: Integer;
    var key: String;
    var offsetX, offsetY: Integer;

    procedure DrawUI;
    begin
      Console.SetForegroundColor(ccWhite);
      Console.SetCursorPosition(1, 1);
      Console.WriteStr('--- NIKRUN TETRIS ---');
      Console.SetCursorPosition(1, 2);
      Console.WriteStr('Score: ' + IntToStr(Score) + '   ');
      Console.SetCursorPosition(1, 4);
      Console.WriteStr('Use Arrows to move');
      Console.SetCursorPosition(1, 5);
      Console.WriteStr('Up to rotate');
      Console.SetCursorPosition(1, 6);
      Console.WriteStr('X to exit');
    end;

    procedure DrawBorders;
    begin
      Console.SetForegroundColor(ccCyan);
      for i := 0 to Board.Height + 1 do
      begin
        Console.SetCursorPosition(offsetX - 2, offsetY + i - 1); Console.WriteStr('<!');
        Console.SetCursorPosition(offsetX + Board.Width * 2, offsetY + i - 1); Console.WriteStr('!>');
      end;
      for i := 0 to Board.Width + 1 do
      begin
        Console.SetCursorPosition(offsetX + (i - 1) * 2, offsetY + Board.Height); Console.WriteStr('==');
      end;
    end;

    procedure Init;
    begin
      Score := 0;
      IsRunning := true;
      TickCount := 0;
      FallSpeed := 5; // Fall every 5 ticks (500ms)
      offsetX := 25;
      offsetY := 2;

      Board := TBoard.Create;
      Board.Init();

      Piece := TPiece.Create;
      Piece.InitShapes();
      Piece.Spawn();

      Console.EnableRawMode();
      Console.HideCursor();
      Console.ClearScreen();

      DrawUI();
      DrawBorders();
      Board.Draw(offsetX, offsetY);
      Piece.Draw(offsetX, offsetY);
    end;

    procedure HandleInput;
    var testRot: Integer;
    begin
      if Console.KeyAvailable() then begin
        key := Console.ReadKey();
        if key = Chr(27) then begin // ESC sequence
          if (Console.ReadKey() = '[') then begin
            var k2 := Console.ReadKey(); // A/B/C/D

            if k2 = 'A' then begin // Up = Rotate
              testRot := Piece.CurrentRot + 1;
              if testRot > 3 then testRot := 0;
              if Piece.DoesFit(Board, Piece.X, Piece.Y, testRot) then
              begin
                Piece.Erase(offsetX, offsetY);
                Piece.CurrentRot := testRot;
                Piece.Draw(offsetX, offsetY);
              end;
            end;
            if k2 = 'B' then begin // Down = Fast Fall
              if Piece.DoesFit(Board, Piece.X, Piece.Y + 1, Piece.CurrentRot) then
              begin
                Piece.Erase(offsetX, offsetY);
                Piece.Y := Piece.Y + 1;
                Piece.Draw(offsetX, offsetY);
              end;
            end;
            if k2 = 'C' then begin // Right
              if Piece.DoesFit(Board, Piece.X + 1, Piece.Y, Piece.CurrentRot) then
              begin
                Piece.Erase(offsetX, offsetY);
                Piece.X := Piece.X + 1;
                Piece.Draw(offsetX, offsetY);
              end;
            end;
            if k2 = 'D' then begin // Left
              if Piece.DoesFit(Board, Piece.X - 1, Piece.Y, Piece.CurrentRot) then
              begin
                Piece.Erase(offsetX, offsetY);
                Piece.X := Piece.X - 1;
                Piece.Draw(offsetX, offsetY);
              end;
            end;
          end;
        end else if (key = 'x') or (key = 'X') then
          IsRunning := false;
      end;
    end;

    procedure UpdateLogic;
    var lines: Integer;
    begin
      TickCount := TickCount + 1;
      if TickCount >= FallSpeed then
      begin
        TickCount := 0;
        if Piece.DoesFit(Board, Piece.X, Piece.Y + 1, Piece.CurrentRot) then
        begin
          Piece.Erase(offsetX, offsetY);
          Piece.Y := Piece.Y + 1;
          Piece.Draw(offsetX, offsetY);
        end
        else
        begin
          // Piece hit something
          Piece.LockToBoard(Board);
          lines := Board.ClearLines();
          if lines > 0 then
          begin
            if lines = 1 then Score := Score + 100;
            if lines = 2 then Score := Score + 300;
            if lines = 3 then Score := Score + 500;
            if lines = 4 then Score := Score + 800;
            DrawUI();
            // Redraw whole board because lines shifted
            Board.Draw(offsetX, offsetY);
          end
          else
          begin
            // Redraw piece once more because LockToBoard might not draw if we just draw locked color
            // Wait, we can just redraw the board anyway when it locks so it updates the new blocks correctly
            Board.Draw(offsetX, offsetY);
          end;

          Piece.Spawn();
          
          // Clear keyboard buffer so new piece doesn't inherit fast-drops
          while Console.KeyAvailable() do
            key := Console.ReadKey();
            
          if not Piece.DoesFit(Board, Piece.X, Piece.Y, Piece.CurrentRot) then
            IsRunning := false // Game Over
          else
            Piece.Draw(offsetX, offsetY); // Draw new piece
        end;
      end;
    end;

    procedure Run;
    begin
      Init();

      while IsRunning do
      begin
        HandleInput();
        UpdateLogic();
        Sleep(100);
      end;

      Console.ResetFormat();
      Console.SetCursorPosition(1, offsetY + Board.Height + 2);
      Console.WriteStr('GAME OVER! Final Score: ' + IntToStr(Score));
      Console.WriteLine('');
      Console.ShowCursor();
      Console.DisableRawMode();
    end;

    procedure Cleanup;
    begin
      Board.Free;
      Piece.Free;
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
