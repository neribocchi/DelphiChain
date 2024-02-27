unit Node;

interface
uses horse,
FMX.Types,
sysutils,
block,
chain,
superObject,supertypes,
JSONRPCUtils,
web3.utils;

type

TNode = Class (TObject)

blockchain:TChain;
constructor create;

End;

implementation

{ TNode }

constructor TNode.create;
begin

  if THorse.IsRunning then
  begin
    log.d('already running');
    exit;
  end;

  var chainID:integer;
  var genesis:string;

  THorse.Post('/',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin

      if not TJSONRPCRequest.parse(Req.Body) then
      begin
        TJSONRPCError.create('1','"invalid json"');
        Res.Send(TJSONRPCError.JSON.AsString);
        exit;
      end;

      if TJSONRPCRequest.method='initChain'  then
      begin
        var params:iSuperObject;
        params:=SO(TJSONRPCRequest.params.AsString);

        if not params.AsObject.Exists('chainID')  then
        begin
          //chainID not specified
          TJSONRPCError.create('1','"chainID not specified"');
          Res.Send(TJSONRPCError.JSON.AsString);
          exit;
        end;

        if not params.AsObject.Exists('genesis')  then
        begin
          //genesis not specified
          TJSONRPCError.create('1','"genesis not specified"');
          Res.Send(TJSONRPCError.JSON.AsString);
          exit;
        end;

        chainID:=strtoint(params['chainID'].AsString);
        genesis:=params['genesis'].AsString;


        if assigned(blockchain) then
        begin
          TJSONRPCError.create('1','"a blockchain already initializaed on this node with the chainID:'+blockchain.chainID.ToString+'"');
          Res.Send(TJSONRPCError.JSON.AsString);
          exit;
        end;

        blockchain:=TChain.create(genesis,100,chainID,3);
        TJSONRPCResponse.create('1','blockchain id:'+chainID.ToString+' created with genesis:'+genesis);
        Res.Send(TJSONRPCResponse.JSON.AsString);
      end else
      if TJSONRPCRequest.method='addBlock' then
      begin
        if not(assigned(blockchain)) then
        begin
          TJSONRPCError.create('1','"Cant add block to blockchain not initialized"');
          Res.Send(TJSONRPCError.JSON.AsString);
          exit;
        end;
        var b:TBlock;
        b:=TBlock.create(blockchain.lastBlock,TJSONRPCRequest.params['data'].AsString,3);
        blockchain.addBlock(b);
        TJSONRPCResponse.create('1',b.asJson);
        Res.Send(TJSONRPCResponse.JSON.AsString);
      end
      else
      if TJSONRPCRequest.method='getBlockchain' then
      begin
        var arr:iSuperArray;
        arr:=TSuperArray.Create;
        for var i := 0 to blockchain.blocks.Count-1 do
        begin
          var o:iSuperObject;
          o:=SO('{}');
          o.s['index']:=blockchain.blocks[i].getIndex.ToString;
          o.s['timestamp']:='';
          o.s['nonce']:=blockchain.blocks[i].getNonce.ToString;
          o.s['data']:=blockchain.blocks[i].getData;
          o.s['hash']:=tohex(blockchain.blocks[i].getHash);
          o.s['prevHash']:=tohex(blockchain.blocks[i].getPrevHash);
          arr.Add(o);
        end;
        Res.Send(arr.AsJson);
      end
      else
      begin
        TJSONRPCError.create('1','"method not allowed"');
        Res.Send(TJSONRPCError.JSON.AsString);
        exit;
      end;

    end);



  THorse.Listen(9000);
end;

end.
