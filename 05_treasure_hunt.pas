uses '../nikrun-cli/stdlib/Console.pas', System;

var
  playerX, playerY: Integer;
  treasureX, treasureY: Integer;
  moveInput: String;
  x, y: Integer;
  won: Boolean;
  moves: Integer;
  isPlayer, isTreasure: Boolean;

begin
  // Starting positions
  playerX := 1;
  playerY := 1;
  
  // Random treasure position (2..9)
  treasureX := Random(8) + 2; 
  treasureY := Random(8) + 2;
  
  won := False;
  moves := 0;

  while not won do
  begin
    Console.ClearScreen;
    
    Console.SetForegroundColor(ccCyan);
    Console.WriteLine('=== N I K R U N   T R E A S U R E   H U N T ===');
    Console.ResetFormat;
    Console.WriteLine('Find the treasure (X)! Controls: w, a, s, d and [Enter]');
    Console.WriteLine('Moves: ' + IntToStr(moves));
    Console.WriteLine('');
    
    // Draw board (10x10)
    y := 1;
    while y <= 10 do
    begin
      x := 1;
      while x <= 10 do
      begin
        isPlayer := False;
        isTreasure := False;
        
        if x = playerX then
        begin
          if y = playerY then
          begin
            isPlayer := True;
          end;
        end;
        
        if x = treasureX then
        begin
          if y = treasureY then
          begin
            isTreasure := True;
          end;
        end;

        if isPlayer then
        begin
          Console.SetForegroundColor(ccBlue);
          Console.WriteStr('P ');
        end
        else if isTreasure then
        begin
          Console.SetForegroundColor(ccYellow);
          Console.WriteStr('X ');
        end
        else
        begin
          Console.SetForegroundColor(ccDefault);
          Console.WriteStr('. ');
        end;
        x += 1;
      end;
      Console.ResetFormat;
      Console.WriteLine('');
      y += 1;
    end;
    
    Console.WriteLine('');
    
    // Check Win Condition
    won := False;
    if playerX = treasureX then
    begin
      if playerY = treasureY then
      begin
        won := True;
      end;
    end;

    if won then
    begin
      Console.SetForegroundColor(ccGreen);
      Console.WriteLine('CONGRATULATIONS! You found the treasure!');
      Console.ResetFormat;
    end
    else
    begin
      Console.WriteStr('Where to? (w/a/s/d): ');
      moveInput := LowerCase(Console.ReadLine());
      
      if moveInput = 'w' then
        playerY -= 1
      else if moveInput = 's' then
        playerY += 1
      else if moveInput = 'a' then
        playerX -= 1
      else if moveInput = 'd' then
        playerX += 1;
        
      // Collision check / Boundaries
      if playerX < 1 then playerX := 1;
      if playerX > 10 then playerX := 10;
      if playerY < 1 then playerY := 1;
      if playerY > 10 then playerY := 10;
      
      moves += 1;
    end;
  end;
end;
