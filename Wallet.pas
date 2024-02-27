unit Wallet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo,web3.utils, FMX.Edit,
  JSONRPCUtils,
  Transaction,
  Block,
  Chain,
  Node;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    genblocks: TSwitch;
    genblocks_label: TLabel;
    Timer1: TTimer;
    Label1: TLabel;
    genesis: TEdit;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure genblocksSwitch(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  blockchain:TChain;
implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
var
  g:Tblock;
begin
  memo1.Lines.Clear;
  blockchain:=TChain.create(genesis.Text,100,1,3);
  g:=blockchain.getGenesis;
  memo1.Lines.add('0-'+toHex(g.getHash)+'->null');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  var i:=blockchain.checkConsistancy;
  if i=0 then showmessage('consistent')
  else showmessage('not consistent at block:'+ blockchain.blocks[i].getIndex.ToString+' '+ toHex(blockchain.blocks[i].getPrevHash)+' not match with: '+toHex(blockchain.blocks[i].getPrevBlock.getHash));
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  var b:TBlock;
  b:=tblock.create(blockchain.lastBlock,random(9999999).tostring,3);
  b:=blockchain.addBlock(b);
  memo1.Lines.add(b.getIndex.toString+'-'+toHex(b.getHash)+'->'+toHex(b.getPrevHash));
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  var b:TNode;
  b:=TNode.create;
end;

procedure TForm3.Button5Click(Sender: TObject);
begin

 if not TJSONRPCRequest.parse('{"jsonrpc": "2.0", "method": "subtract", "params":"sdfdas", "id": 1}') then
   showmessage('invalid json')
 else
   showmessage(TJSONRPCRequest.method);

 if not TJSONRPCResponse.parse('{"jsonrpc": "2.0", "result": null, "params":null, "id": 1}') then
   showmessage('invalid json')
 else
 showmessage(TJSONRPCResponse.result);

 if not TJSONRPCError.parse('{"jsonrpc": "2.0", "error": null, "result": null, "id": 1}') then
   showmessage('invalid json')
 else
   showmessage(TJSONRPCError.error);

end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  memo1.Lines.Add(blockchain.addTransaction(TTransaction.create('neri','iren',222,1)));
end;

procedure TForm3.genblocksSwitch(Sender: TObject);
begin
 timer1.Enabled:=genblocks.IsChecked;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  var b:TBlock;
  b:=blockchain.addBlock(tblock.create(blockchain.lastBlock,random(9999999).tostring,3));
  memo1.Lines.add(b.getIndex.toString+'-'+toHex(b.getHash)+'->'+toHex(b.getPrevHash));
end;

end.
