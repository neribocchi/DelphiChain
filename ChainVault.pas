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
unit ChainVault;

interface
uses
  System.SysUtils,
  Velthuis.BigIntegers,
  web3.utils;

Type

TChainVault = Class(TObject)
  fromBlockIndex:BigInteger;
  toBlockIndex:BigInteger;
  vaultHash:TBytes;
  public
  constructor Create(fromIndex,toIndex:BigInteger);
End;

implementation


{ TVault }

constructor TChainVault.Create(fromIndex, toIndex: BigInteger);
begin
  //
end;

end.
