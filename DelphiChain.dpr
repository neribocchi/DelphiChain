program DelphiChain;

uses
  System.StartUpCopy,
  FMX.Forms,
  Accounts in 'Accounts.pas',
  Block in 'Block.pas',
  Chain in 'Chain.pas',
  ChainVault in 'ChainVault.pas',
  SealedVault in 'SealedVault.pas',
  Wallet in 'Wallet.pas' {Form3},
  web3.utils in 'web3.utils.pas',
  Node in 'Node.pas',
  JsonRPCutils in 'JsonRPCutils.pas',
  Transaction in 'Transaction.pas',
  Utils in 'Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
