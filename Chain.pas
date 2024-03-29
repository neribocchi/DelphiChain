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

unit Chain;

interface
uses
  Block,
  Transaction,
  ChainVault,
  System.SysUtils,
  Velthuis.BigIntegers,
  web3.utils,
  Generics.collections;

type

TChain = Class(TObject)
  dificulty:integer;
  chainID:integer;
  blocks:TList<TBlock>;
  vaultLimit:Integer;
  chainVaults:TList<TChainVault>;
  pendigTransactions:TDictionary<String, TTransaction>;
  public
  constructor create(genesis:string;vl:integer;aChainID:integer;aDificulty:integer);
  function addBlock(block:TBlock):TBlock;
  function getGenesis:TBlock;
  function lastBlock:TBlock;
  function checkConsistancy:integer;
  function addTransaction(aTransaction:TTransaction):string;
End;


implementation

{ TChain }

function TChain.addBlock(block: TBlock):TBlock;
begin
  result:=nil;
  if assigned(blocks) then
  begin
    var i:=Blocks.Add(block);
    result:=blocks[i];
  end;
end;

function TChain.addTransaction(aTransaction: TTransaction): string;
begin
  pendigTransactions.Add(tohex(sha3(TEncoding.Unicode.GetBytes(aTransaction.AsJson))),aTransaction);
  result:=aTransaction.AsJson;
end;

function TChain.checkConsistancy: integer;
begin
  result:=0;
  var prevBlock:Tblock;
  prevBlock:=blocks[0];
  for var i:=1 to blocks.Count-1 do
  begin
    If not(blocks[i].getPrevHash=prevBlock.getHash) then
    begin
      result:=i;
      break;
    end;
    prevBlock:=blocks[i];
  end;
end;

constructor TChain.create(genesis: string;vl:integer;aChainID,aDificulty:integer);
begin

  chainID:=aChainID;
  dificulty:=aDificulty;
  vaultLimit:=vl;
  blocks:=TList<TBlock>.create;
  chainVaults:=TList<TChainVault>.create;
  //add genesis block
  blocks.Add(TBlock.create(nil,genesis,3));
  pendigTransactions:=TDictionary<String, TTransaction>.create;
end;

function TChain.getGenesis: TBlock;
begin
  result:=blocks[0];
end;

function TChain.lastBlock: TBlock;
begin
  result:=blocks.Last;
end;

end.
