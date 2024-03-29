{******************************************************************************}
{                                                                              }
{                                  NeriChain                                   }
{                                                                              }
{             Copyright(c) 2024 Luis Bocchi <lbocchi@gmail.com>                }
{                                                                              }
{             Distributed under GNU AGPL v3.0 with Commons Clause              }
{                                                                              }
{   This program is free software: you can redistribute it and/or modify       }
{   it under the terms of the GNU Affero General Public License as published   }
{   by the Free Software Foundation, either version 3 of the License, or       }
{   (at your option) any later version.                                        }
{                                                                              }
{   This program is distributed in the hope that it will be useful,            }
{   but WITHOUT ANY WARRANTY; without even the implied warranty of             }
{   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              }
{   GNU Affero General Public License for more details.                        }
{                                                                              }
{   You should have received a copy of the GNU Affero General Public License   }
{   along with this program.  If not, see <https://www.gnu.org/licenses/>      }
{                                                                              }
{******************************************************************************}
unit Block;


interface

uses System.Types,
     System.DateUtils,
     System.SysUtils,
     web3.utils,
     fmx.Types,
     Velthuis.BigIntegers;

Type

TBlock = Class(TObject)
  private
    dificulty:integer;
    timestamp:TTime;
    index:biginteger;
    prevBlock:TBlock;
    prevhash:TBytes;
    nonce:biginteger;
    data:string;
    hash:TBytes;
  public
    constructor create(aPrevBlock:TBlock;aData:string;aDificulty:integer);
    function calculateBlockHash:TBytes;
    function getHash:TBytes;
    function getPrevHash:TBytes;
    function getIndex:BigInteger;
    function getPrevBlock:TBlock;
    function getData:string;
    function getNonce:biginteger;
    function asJson:String;
    procedure mineBlock;
End;

implementation



{ TBlock }

constructor TBlock.create(aPrevBlock: TBlock; aData:string;aDificulty:integer);
begin
  if assigned(aPrevBlock) then
  begin
    prevBlock:=aPrevBlock;
    prevHash:=prevBlock.getHash;
    index:=prevBlock.index+1;
  end
  else
  begin
    //this is a genesis block
    index:=0;
  end;
  nonce:=0;
  dificulty:=aDificulty;
  data:=aData;
  mineblock;
  timestamp:=now;
end;

function TBlock.asJson: string;
begin
  result:='{"nonce":"'+nonce.ToString+'","index":"'+index.ToString+'","timestamp":"'+datetimetounix(timestamp).tostring+'","hash":"'+toHex(hash)+'","prevHash":"'+toHex(prevHash)+'","data":"'+data+'"}';
end;

function TBlock.getData: string;
begin
  result:=data;
end;

function TBlock.getHash: TBytes;
begin
  result:=hash;
end;

function TBlock.getIndex: Biginteger;
begin
  result:=index;
end;

function TBlock.getNonce: biginteger;
begin
  result:=nonce;
end;

function TBlock.getPrevBlock: TBlock;
begin
  result:=prevBlock;
end;

function TBlock.getPrevHash: TBytes;
begin
  result:=prevHash;
end;


procedure TBlock.mineBlock;
begin
  var newhash:TBytes;

  while copy(tohex(newhash),3,dificulty)<>StringOfChar('0',dificulty) do
  begin
    nonce:=nonce+1;
    newhash:=calculateBlockHash;
  end;

  hash:=newhash;

end;

function TBlock.calculateBlockHash: TBytes;
var hashing:TBytes;
begin
  hashing:=TEncoding.Unicode.GetBytes(index.ToString)+
           TEncoding.Unicode.GetBytes(nonce.ToString)+
           prevHash+
           TEncoding.Unicode.GetBytes(data);
  result:=sha3(hashing);
end;



end.
