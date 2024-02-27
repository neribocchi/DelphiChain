unit Utils;

interface
uses dateutils,windows,sysutils;

function DateTimeToUNIXTimestamp(DelphiTime : TDateTime): int64;
implementation
function DateTimeToUNIXTimestamp(DelphiTime : TDateTime): int64;
begin
Result := Round((DelphiTime - 25569) * 86400);
end;
end.
