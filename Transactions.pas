unit Transactions;

interface

 uses
  Block,
  ChainVault,
  System.SysUtils,
  Velthuis.BigIntegers,
  web3.utils,
  dateutils,
  utils,
  Generics.collections;

  type

  TTransaction = Class(TObject)
    timestamp:int64;
    from_address:string;
    to_address:string;
    amount:int64;
    nonce:int64;
  public
    constructor create(aFrom_address,aTo_address:string;aAmount:int64;aNonce:int64);
    function toJson:string;
  End;


implementation

{ TTransaction }

constructor TTransaction.create(aFrom_address, aTo_address: string;
  aAmount: int64;aNonce:int64);
begin
  from_address:=aFrom_address;
  to_address:=aTo_address;
  timestamp:=DateTimeToUNIXTimestamp(now);
  nonce:=aNonce;
end;
function TTransaction.toJson: string;
begin
  result:='{"from_address":"'+from_address+'","toAddress":"'+to_address+'","amount":"'+inttostr(amount)+'","timestamp":"'+inttostr(timestamp)+'","nonce":"'+nonce.toString+'"}';
end;

end.
