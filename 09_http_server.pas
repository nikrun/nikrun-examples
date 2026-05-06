uses Http, System;

function OnRequest(Req: THttpRequest): THttpResponse;
var
  res: THttpResponse;
  i: Integer;
  headersJson: String;
begin
  case Req.Path of
    '/hello':
      begin
        res.StatusCode := HTTP_OK;
        res.Body := '{"status": "ok", "method": "' + Req.Method + '", "query": "' + Req.Query + '", "ip": "' + Req.RemoteAddr + '"}';
        res.ContentType := 'application/json';
      end;

    '/echo':
      begin
        res.StatusCode := HTTP_OK;
        res.Body := Req.Body;
        res.ContentType := 'text/plain';
      end;

    '/headers':
      begin
        res.StatusCode := HTTP_OK;
        
        // Collect all incoming headers into a JSON object manually
        headersJson := '{';
        for i := 0 to Length(Req.Headers) - 1 do
        begin
          if i > 0 then headersJson := headersJson + ', ';
          headersJson := headersJson + '"' + Req.Headers[i].Name + '": "' + Req.Headers[i].Value + '"';
        end;
        headersJson := headersJson + '}';
        
        res.Body := headersJson;
        res.ContentType := 'application/json';
        
        // Add a custom response header
        SetLength(res.Headers, 1);
        res.Headers[0].Name := 'X-Powered-By';
        res.Headers[0].Value := 'Nikrun-Pascal-Engine';
      end;

    '/redirect':
      begin
        res.StatusCode := HTTP_FOUND;
        res.Body := 'Redirecting...';
        res.Location := '/hello';
      end 

      else begin
        res.StatusCode := HTTP_NOT_FOUND;
        res.Body := 'Not Found';
        res.ContentType := 'text/plain';
      end;
  end;

  Result := res;
end;

begin
end;