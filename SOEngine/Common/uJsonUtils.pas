unit uJsonUtils;

interface

uses
  System.JSON, System.SysUtils,
  uSoTypes, uEngine2DClasses;

  function JsonToFont(AJson: TJsonObject): TFont;
  function JsonToFillTextFlags(AJson: TJsonObject): TFillTextFlags;
  function JsonToTextAlign(AJson: TJsonObject): TTextAlign;
  function JsonToBool(AJson: TJsonValue): Bool;
  function JsonToPointF(AJson: TJsonValue): TPointF;
  function JsonToRectF(AJson: TJsonValue): TRectF;
  function JsonToJustify(AJson: TJsonValue): TObjectJustify;
  function JsonToRenditionType(AJson: TJsonValue): TRenditionType;
implementation

function JsonToRenditionType(AJson: TJsonValue): TRenditionType;
begin
  if AJson.Value.ToLower = 'sprite' then
    Exit(TRenditionType.rtSprite);
  if AJson.Value.ToLower = 'text' then
    Exit(TRenditionType.rtText);
  if AJson.Value.ToLower = 'shape' then
    Exit(TRenditionType.rtShape);

   raise Exception.Create('Unsupported SeJson Rendition Type');
end;

function JsonToFont(AJson: TJsonObject): TFont;
var
  vVal: TJSONValue;
  vArr: TJSONArray;
  i: Int;
begin
  Result := TFont.Create;
  if AJson.TryGetValue('Family', vVal) then
    Result.Family := vVal.Value;

  if AJson.TryGetValue('Size', vVal) then
    Result.Size := StrToFloat(vVal.Value);

  if AJson.TryGetValue('Style', vVal) then
  begin
    vArr := TJSONArray(vVal);

    for i := 0 to vArr.Count - 1 do
    begin
      if LowerCase(vArr.Items[i].Value) = 'bold' then
        Result.Style :=  Result.Style + [TFontStyle.fsBold];
      if LowerCase(vArr.Items[i].Value) = 'italic' then
        Result.Style :=  Result.Style + [TFontStyle.fsItalic];
      if LowerCase(vArr.Items[i].Value) = 'underline' then
        Result.Style :=  Result.Style + [TFontStyle.fsUnderline];
      if LowerCase(vArr.Items[i].Value) = 'strikeout' then
        Result.Style :=  Result.Style + [TFontStyle.fsStrikeOut];
    end;
  end;
end;

function JsonToPointF(AJson: TJsonValue): TPointF;
var
  vArr: TArray<string>;
begin
  vArr := (AJson.Value).Split([',']);
  Result := TPointF.Create(StrToFloat(vArr[0]), StrToFloat(vArr[1]));
end;

function JsonToFillTextFlags(AJson: TJsonObject): TFillTextFlags;
var
  i: Integer;
begin
  Result := [];

  for i := 0 to TJSONArray(AJson).Count - 1 do
    if LowerCase(TJSONArray(AJson).Items[i].Value) = 'RightToLeft'  then
      Result :=  Result + [TFillTextFlag.RightToLeft];
end;

function JsonToTextAlign(AJson: TJsonObject): TTextAlign;
begin
  if LowerCase(AJson.Value) = 'center' then
    Exit(TTextAlign.Center);
  if LowerCase(AJson.Value) = 'leading' then
    Exit(TTextAlign.Leading);
  if LowerCase(AJson.Value) = 'trailing' then
    Exit(TTextAlign.Trailing);
end;

function JsonToBool(AJson: TJsonValue): Bool;
begin
  if (LowerCase(AJson.Value) = 'true') or (LowerCase(AJson.Value) = '1') then
    Result := True
  else
    Result := False;
end;

function JsonToRectF(AJson: TJSONValue): TRectF;
var
  vArr, vArr1, vArr2: TArray<string>;
begin
  vArr := (AJson.Value).Split([';']);
  vArr1 := vArr[0].Split([',']);
  vArr2 := vArr[1].Split([',']);
  Result := TRectF.Create(vArr1[0].ToSingle, vArr1[1].ToSingle, vArr2[0].ToSingle, vArr2[1].ToSingle);
end;

function JsonToJustify(AJson: TJsonValue): TObjectJustify;
var
  vS: string;
begin
  vS := LowerCase(AJson.Value);
  if vS = 'center'  then
    Exit(TObjectJustify.Center);
  if vS = 'topcenter'  then
    Exit(TObjectJustify.TopCenter);
  if vS = 'bottomcenter'  then
    Exit(TObjectJustify.BottomCenter);

  if vS = 'topleft'  then
    Exit(TObjectJustify.TopLeft);
  if vS = 'topright'  then
    Exit(TObjectJustify.TopRight);

  if vS = 'centerleft'  then
    Exit(TObjectJustify.CenterLeft);
  if vS = 'centerright'  then
    Exit(TObjectJustify.CenterRight);

  if vS = 'bottomleft'  then
    Exit(TObjectJustify.BottomLeft);
  if vS = 'bottomright'  then
    Exit(TObjectJustify.BottomRight);

end;

end.
