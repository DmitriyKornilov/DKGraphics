unit DK_Graph;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, GraphUtil,
  DK_Math, DK_Vector, DK_Matrix, DK_StrUtils;

  function RectInc(const ARect: TRect; const dX1, dY1, dX2, dY2: Integer): TRect;
  function RectDeflate(const ARect: TRect; const ADelta: Integer): TRect;
  function RectDeflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;
  function RectInflate(const ARect: TRect; const ADelta: Integer): TRect;
  function RectInflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;

type
  TRectVector = array of TRect;
  procedure VDimRectVector(var V: TRectVector; const Size: Integer);
  procedure VAppendRectVector(var V: TRectVector; const ARect: TRect);

type
  TPointVector = array of TPoint;
  procedure VDimPointVector(var V: TPointVector; const Size: Integer);
  procedure VAppendPointVector(var V: TPointVector; const APoint: TPoint);

  {---COLORS-------------------------------------------------------------------}
  //Color lightness change
  function ColorIncLightness(const AColor: TColor; const LightnessIncrement: Integer): TColor;

  {---BARS RECTS --------------------------------------------------------------}
  function BarsVertRects(const ARect: TRect;
                       const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues,
                             AYDataValues: TIntVector): TRectVector;
  function BarsHorizRects(const ARect: TRect;
                        const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                        const AXTicksCoords, AXTicksValues,
                              AXDataValues: TIntVector): TRectVector;

  {---TEXT OUT RECTS----------------------------------------------------------}
  function StringHorizRect(const ARect: TRect;
                         const AString: String;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRect;
  function StringsHorizRects(const ARect: TRect;
                         const ARowHeight: Integer;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRectVector;
  function TextHorizRect(const ARect: TRect;
                         const AText: TStrVector;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout): TRect;
  function StringVertRect(const ARect: TRect;
                         const AString: String;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout): TRect;
  function StringsVertRects(const ARect: TRect;
                         const ARowWidth: Integer;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout): TRectVector;
  function TextVertRect(const ARect: TRect;
                         const AText: TStrVector;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRect;


implementation

function RectInc(const ARect: TRect; const dX1, dY1, dX2, dY2: Integer): TRect;
begin
  Result:= ARect;
  Inc(Result.Left, dX1);
  Inc(Result.Top, dY1);
  Inc(Result.Right, dX2);
  Inc(Result.Bottom, dY2);
end;

function RectDeflate(const ARect: TRect; const ADelta: Integer): TRect;
begin
  Result:= RectInc(ARect, ADelta, ADelta, -ADelta, -ADelta);
end;

function RectDeflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;
begin
  Result:= RectInc(ARect, ADeltaX, ADeltaY, -ADeltaX, -ADeltaY);
end;

function RectInflate(const ARect: TRect; const ADelta: Integer): TRect;
begin
  Result:= RectInc(ARect, -ADelta, -ADelta, ADelta, ADelta);
end;

function RectInflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;
begin
  Result:= RectInc(ARect, -ADeltaX, -ADeltaY, ADeltaX, ADeltaY);
end;

procedure VDimRectVector(var V: TRectVector; const Size: Integer);
var
  i: Integer;
begin
  V:= nil;
  SetLength(V,Size);
  for i:= 0 to Size-1 do
    V[i]:= Rect(0,0,0,0);
end;

procedure VAppendRectVector(var V: TRectVector; const ARect: TRect);
var
  i: Integer;
begin
  i:= Length(V);
  SetLength(V, i+1);
  V[i]:= ARect;
end;

procedure VDimPointVector(var V: TPointVector; const Size: Integer);
var
  i: Integer;
begin
  V:= nil;
  SetLength(V,Size);
  for i:= 0 to Size-1 do
    V[i]:= Point(0,0);
end;

procedure VAppendPointVector(var V: TPointVector; const APoint: TPoint);
var
  i: Integer;
begin
  i:= Length(V);
  SetLength(V, i+1);
  V[i]:= APoint;
end;

//Color utils

function ColorIncLightness(const AColor: TColor; const LightnessIncrement: Integer): TColor;
var
  H, L, S: Byte;
  Lightness: Integer;
begin
  ColorToHLS(AColor, H, L, S);
  Lightness:= L + LightnessIncrement;
  if Lightness<0 then
    L:= 0
  else if Lightness>255 then
    L:= 255
  else
    L:= Lightness;
  Result:= HLSToColor(H, L, S);
end;

// Bars rects

function BarsVertRects(const ARect: TRect;
                       const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues,
                             AYDataValues: TIntVector): TRectVector;
var
  i, BarsCount, BarWidth, BarHeight, BarMargin: Integer;
  N, Value, MaxValue, FirstBarLeftCoord: Integer;
begin
  Result:= nil;
  if VIsNil(AYDataValues) then Exit;

  BarsCount:= Length(AYDataValues);
  VDimRectVector(Result, BarsCount);
  //constraint max bar width
  BarWidth:= ARect.Width div BarsCount;
  Value:= Trunc(Percent(ARect.Width, AMaxBarWidthPercent));
  BarWidth:= Min(BarWidth, Value);
  //constraint min bar margin
  BarMargin:= Round(Percent(BarWidth, AMinBarMarginPercent));

  FirstBarLeftCoord:= ARect.Left + BarMargin +
                   ((ARect.Width - BarMargin - BarsCount*BarWidth) div 2);

  MaxValue:= VLast(AYTicksValues);

  for i:= 0 to High(AYDataValues) do
  begin
    Result[i].Bottom:= ARect.Bottom + 1;
    Result[i].Left:= FirstBarLeftCoord + i*BarWidth;
    Result[i].Right:= Result[i].Left + BarWidth - BarMargin;
    if not VSameIndexValue(AYDataValues[i], AYTicksValues,
                           AYTicksCoords, Result[i].Top) then
    begin
      BarHeight:= Round((AYDataValues[i]/MaxValue)*ARect.Height);
      Result[i].Top:= Result[i].Bottom - BarHeight - 1;
    end;
  end;
end;

function BarsHorizRects(const ARect: TRect;
                        const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                        const AXTicksCoords, AXTicksValues,
                             AXDataValues: TIntVector): TRectVector;
var
  i, BarsCount, BarWidth, BarHeight, BarMargin: Integer;
  N, Value, MaxValue, FirstBarTopCoord: Integer;
begin
  Result:= nil;
  if VIsNil(AXDataValues) then Exit;

  BarsCount:= Length(AXDataValues);
  VDimRectVector(Result, BarsCount);
  //constraint max bar height
  BarHeight:= ARect.Height div BarsCount;
  Value:= Trunc(Percent(ARect.Height, AMaxBarWidthPercent));
  BarHeight:= Min(BarHeight, Value);
  //constraint min bar margin
  BarMargin:= Round(Percent(BarHeight, AMinBarMarginPercent));

  FirstBarTopCoord:= ARect.Top + BarMargin +
                   ((ARect.Height - BarMargin - BarsCount*BarHeight) div 2);

  MaxValue:= VLast(AXTicksValues);
  for i:= 0 to High(AXDataValues) do
  begin
    Result[i].Left:= ARect.Left;
    Result[i].Top:= FirstBarTopCoord + i*BarHeight;
    Result[i].Bottom:= Result[i].Top + BarHeight - BarMargin;
    if not VSameIndexValue(AXDataValues[i], AXTicksValues,
                           AXTicksCoords, Result[i].Right) then
    begin
      BarWidth:= Round((AXDataValues[i]/MaxValue)*ARect.Width);
      Result[i].Right:= Result[i].Left + BarWidth;
    end;
    Result[i].Right:= Result[i].Right + 1;
  end;
end;

//Text rects

function StringHorizRect(const ARect: TRect;
                         const AString: String;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRect;
var
  W: Integer;
begin
  Result:= ARect;
  //Result.Left:= Result.Left + 1;
  W:= SWidth(AString, AFont);
  if AHorizPosition = taCenter then
    Result.Left:= ARect.Left + ((ARect.Width-W) div 2)
  else if AHorizPosition = taRightJustify then
    Result.Left:= ARect.Right - W - 1;
  Result.Right:= Result.Left + W - 1;
  Result.Bottom:= Result.Top + SHeight(AFont);
end;

function StringsHorizRects(const ARect: TRect;
                         const ARowHeight: Integer;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRectVector;
var
  i: Integer;
begin
  Result:= nil;
  if VIsNil(AStrings) or (ARowHeight=0) then Exit;
  VDimRectVector(Result, Length(AStrings));

  for i:=0 to High(AStrings) do
  begin
    Result[i]:= ARect;
    Result[i].Top:= ARect.Top + i*ARowHeight;
    Result[i].Bottom:= Result[i].Top + ARowHeight;
    Result[i]:= StringHorizRect(Result[i], AStrings[i], AFont, AHorizPosition);
  end;
end;

function TextHorizRect(const ARect: TRect;
                       const AText: TStrVector;
                       const AFont: TFont;
                       const AVertPosition: TTextLayout): TRect;
var
  RowHeight, TextHeight: Integer;
begin
  Result:= ARect;
  if VIsNil(AText) then Exit;

  RowHeight:= SHeight(AFont);
  if AVertPosition=tlTop then
    Result.Top:= ARect.Top + 1
  else begin
    TextHeight:= RowHeight*Length(AText);
    if AVertPosition=tlBottom then
      Result.Top:= ARect.Bottom - TextHeight - 1
    else  //tlCenter
      Result.Top:= ARect.Top + ((ARect.Height - TextHeight) div 2) +
                   Ord(Odd(ARect.Height - TextHeight));
  end;
end;

function StringVertRect(const ARect: TRect;
                         const AString: String;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout): TRect;
var
  H: Integer;
begin
  Result:= ARect;
  Result.Left:= Result.Left + 1;
  H:= SWidth(AString, AFont);
  if AVertPosition = tlCenter then
    Result.Top:= ARect.Top + ((ARect.Height-H) div 2)
  else if AVertPosition = tlBottom then
    Result.Top:= ARect.Bottom - H - 1;
  Result.Bottom:= Result.Top + H;
  Result.Right:= Result.Left + SHeight(AFont) - 1;
end;

function StringsVertRects(const ARect: TRect;
                         const ARowWidth: Integer;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout): TRectVector;
var
  i: Integer;
begin
  Result:= nil;
  if VIsNil(AStrings) or (ARowWidth=0) then Exit;
  VDimRectVector(Result, Length(AStrings));

  for i:=0 to High(AStrings) do
  begin
    Result[i]:= ARect;
    Result[i].Left:= ARect.Left + i*ARowWidth;
    Result[i].Right:= Result[i].Left + ARowWidth;
    Result[i]:= StringVertRect(Result[i], AStrings[i], AFont, AVertPosition);
  end;
end;

function TextVertRect(const ARect: TRect;
                         const AText: TStrVector;
                         const AFont: TFont;
                         const AHorizPosition: TAlignment): TRect;
var
  RowWidth, TextHeight: Integer;
begin
  Result:= ARect;
  if VIsNil(AText) then Exit;

  RowWidth:= SHeight(AFont);
  if AHorizPosition=taLeftJustify then
    Result.Left:= ARect.Left + 1
  else begin
    TextHeight:= RowWidth*Length(AText);
    if AHorizPosition=taRightJustify then
      Result.Left:= ARect.Right - TextHeight - 1
    else  //taCenter
      Result.Left:= ARect.Left + ((ARect.Width - TextHeight) div 2) -
                    Ord(Odd(ARect.Width - TextHeight));
  end;
end;

















end.

