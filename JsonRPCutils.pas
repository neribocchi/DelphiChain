unit JsonRPCutils;

interface

uses JSON,System.SysUtils,superObject,supertypes;

type
 TJSONRPCRequest = class
  public
   class var JSON:ISuperObject;
   class function parse(aJSON:string):boolean;
   class function create(id,method,params:string):boolean;
   class function id:string;
   class function method:string;
   class function params:ISuperObject;
 end;

 TJSONRPCResponse = class
  public
   class var JSON:ISuperObject;
   class function parse(aJSON:string):boolean;
   class function create(id,res:string):boolean;
   class function id:string;
   class function result:string;
 end;

 TJSONRPCError= class
  public
   class var JSON:ISuperObject;
   class function parse(aJSON:string):boolean;
   class function create(id,error:string):boolean;
   class function id:string;
   class function error:string;
 end;


implementation

{ TJSONRPC }

class function TJSONRPCRequest.create(id, method, params: string): boolean;
begin
  parse('{"jsonrpc": "2.0", "method": "'+method+'", "params": '+params+', "id": '+id+'}');
end;

class function TJSONRPCRequest.id: string;
begin
  result:=JSON['id'].AsString;
end;


class function TJSONRPCRequest.method: string;
begin
    result:=JSON['method'].AsString;
end;

class function TJSONRPCRequest.params: ISuperObject;
var js:TJsonValue;
begin
  result:=JSON['params'];
end;

class function TJSONRPCRequest.parse(aJSON: string): boolean;

begin
  result:=true;
  try
    JSON := SO(aJson);
    if not JSON.AsObject.Exists('jsonrpc') then result:=false;
    if not JSON.AsObject.Exists('method') then result:=false;
    if not JSON.AsObject.Exists('params') then result:=false;
    if JSON['jsonrpc'].AsString<>'2.0' then result:=false;
  except
    result:=false;
  end;

end;

{ TJSONRPCResponse }

class function TJSONRPCResponse.parse(aJSON: string): boolean;
begin
  result:=true;
  try
    JSON := SO(aJson);
    if JSON['jsonrpc'].AsString<>'2.0' then result:=false;
    if JSON['result'].AsString='' then result:=false;
  except
    result:=false;
  end;
end;

class function TJSONRPCResponse.create(id, res:string): boolean;
begin
  result:=parse('{"jsonrpc": "2.0", "result": '+res+', "id": '+id+'}');
end;

class function TJSONRPCResponse.id: string;
begin
  result:=JSON['id'].AsString;
end;

class function TJSONRPCResponse.result: string;
begin
  result:=JSON['result'].AsString;
end;

{ TJSONRPCError }



class function TJSONRPCError.parse(aJSON: string): boolean;
begin
  result:=true;
  try
    JSON := SO(aJson);
    if JSON['jsonrpc'].AsString<>'2.0' then result:=false;
    if JSON['error'].AsString='' then result:=false;
  except
    result:=false;
  end;
end;

class function TJSONRPCError.create(id,  error: string): boolean;
begin
   result:=self.parse('{"jsonrpc": "2.0", "error": '+error+',"id": '+id+'}');
end;

class function TJSONRPCError.error: string;
begin
  result:=JSON['error'].AsString;
end;

class function TJSONRPCError.id: string;
begin
  result:=JSON['id'].AsString;
end;



end.
