program Out;
Uses sysutils;

Var
    max : Integer = 4;
    x : Integer;
    input : Array [0..3] of string[20] = ('This', 'is', 'an', 'array');
begin
for x := 0 to max do
    begin
        Writeln('Index: ' + IntToStr(x) + ' // Value: ' + input[x]);
    end;
end.