unit DK_Graph;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, GraphUtil,
  DK_Math, DK_Vector, DK_Matrix, DK_StrUtils;

const
  BAR_MAX_WIDTH_PX = 80;

  function RectInc(const ARect: TRect; const dX1, dY1, dX2, dY2: Integer): TRect;
  function RectDeflate(const ARect: TRect; const ADelta: Integer): TRect;
  function RectDeflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;
  function RectInflate(const ARect: TRect; const ADelta: Integer): TRect;
  function RectInflate(const ARect: TRect; const ADeltaX, ADeltaY: Integer): TRect;

type
  TDirectionType = (dtHorizontal, dtVertical);

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

  function ColorFromVector(const AColorVector: TColorVector; const AIndex: Integer;
                           const ASortIndexes: TIntVector = nil): TColor;


  {---DATA COORDS--------------------------------------------------------------}
  function DataCoordY(const ARect: TRect; const AYDataValue: Integer;
                      const AYTicksCoords, AYTicksValues: TIntVector): Integer;
  function DataCoordsY(const ARect: TRect;
                       const AYDataValues, AYTicksCoords, AYTicksValues: TIntVector): TIntVector;
  function DataCoordsY(const ARect: TRectVector;
                       const AYDataValues: TIntMatrix;
                       const AYTicksCoords, AYTicksValues: TIntVector): TIntMatrix;

  function DataCoordX(const ARect: TRect; const AXDataValue: Integer;
                      const AXTicksCoords, AXTicksValues: TIntVector): Integer;
  function DataCoordsX(const ARect: TRect;
                       const AXDataValues, AXTicksCoords, AXTicksValues: TIntVector): TIntVector;
  function DataCoordsX(const ARect: TRectVector;
                       const AXDataValues: TIntMatrix;
                       const AXTicksCoords, AXTicksValues: TIntVector): TIntMatrix;
  {---BARS RECTS---------------------------------------------------------------}
  function BarsVertRects(const ARect: TRect;
                       const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues,
                             AYDataValues: TIntVector;
                       const AMaxBarWidthInPixels: Integer = BAR_MAX_WIDTH_PX): TRectVector;
  function BarsHorizRects(const ARect: TRect;
                        const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                        const AXTicksCoords, AXTicksValues,
                              AXDataValues: TIntVector;
                        const AMaxBarWidthInPixels: Integer = BAR_MAX_WIDTH_PX): TRectVector;

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

function ColorFromVector(const AColorVector: TColorVector; const AIndex: Integer;
                         const ASortIndexes: TIntVector = nil): TColor;
var
  k, n: Integer;
begin
  n:= Length(ASortIndexes);
  if n>0 then
    k:= ASortIndexes[AIndex mod n]
  else
    k:= AIndex;
  Result:= AColorVector[k mod Length(AColorVector)];
end;

//Data coords

function DataCoordY(const ARect: TRect; const AYDataValue: Integer;
                    const AYTicksCoords, AYTicksValues: TIntVector): Integer;
var
  MaxValue, DeltaY: Integer;
begin
  MaxValue:= VLast(AYTicksValues);
  if not VSameIndexValue(AYDataValue, AYTicksValues, AYTicksCoords, Result) then
  begin
    DeltaY:= Round((AYDataValue/MaxValue)*ARect.Height);
    Result:= ARect.Bottom - DeltaY;
  end;
end;

function DataCoordsY(const ARect: TRect;
     const AYDataValues, AYTicksCoords, AYTicksValues: TIntVector): TIntVector;
var
  i: Integer;
begin
  Result:= nil;
  if VIsNil(AYDataValues) or VIsNil(AYTicksCoords) or VIsNil(AYTicksValues) then Exit;
  VDim(Result, Length(AYDataValues));
  for i:= 0 to High(AYDataValues) do
    Result[i]:= DataCoordY(ARect, AYDataValues[i], AYTicksCoords, AYTicksValues);
end;

function DataCoordsY(const ARect: TRectVector;
                     const AYDataValues: TIntMatrix;
                     const AYTicksCoords, AYTicksValues: TIntVector): TIntMatrix;
var
  i: Integer;
  V: TIntVector;
begin
  Result:= nil;
  if MIsNil(AYDataValues) then Exit;
  for i:= 0 to High(AYDataValues) do
  begin
    V:= DataCoordsY(ARect[i], AYDataValues[i], AYTicksCoords, AYTicksValues);
    MAppend(Result, V);
  end;
end;

function DataCoordX(const ARect: TRect; const AXDataValue: Integer;
                    const AXTicksCoords, AXTicksValues: TIntVector): Integer;
var
  MaxValue, DeltaX: Integer;
begin
  MaxValue:= VLast(AXTicksValues);
  if not VSameIndexValue(AXDataValue, AXTicksValues, AXTicksCoords, Result) then
  begin
    DeltaX:= Round((AXDataValue/MaxValue)*ARect.Width);
    Result:= ARect.Left + DeltaX;
  end;
  Result:= Result + 1;
end;

function DataCoordsX(const ARect: TRect;
   const AXDataValues, AXTicksCoords, AXTicksValues: TIntVector): TIntVector;
var
  i: Integer;
begin
  Result:= nil;
  if VIsNil(AXDataValues) or VIsNil(AXTicksCoords) or VIsNil(AXTicksValues) then Exit;
  VDim(Result, Length(AXDataValues));
  for i:= 0 to High(AXDataValues) do
    Result[i]:= DataCoordX(ARect, AXDataValues[i], AXTicksCoords, AXTicksValues);
end;

function DataCoordsX(const ARect: TRectVector;
                       const AXDataValues: TIntMatrix;
                       const AXTicksCoords, AXTicksValues: TIntVector): TIntMatrix;
var
  i: Integer;
  V: TIntVector;
begin
  Result:= nil;
  if MIsNil(AXDataValues) then Exit;
  for i:= 0 to High(AXDataValues) do
  begin
    V:= DataCoordsX(ARect[i], AXDataValues[i], AXTicksCoords, AXTicksValues);
    MAppend(Result, V);
  end;
end;

// Bars rects

function BarsVertRects(const ARect: TRect;
                       const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues,
                             AYDataValues: TIntVector;
                       const AMaxBarWidthInPixels: Integer = BAR_MAX_WIDTH_PX): TRectVector;
var
  i, BarsCount, BarWidth, BarMargin: Integer;
  Value, FirstBarLeftCoord: Integer;
begin
  Result:= nil;
  if VIsNil(AYDataValues) then Exit;

  BarsCount:= Length(AYDataValues);
  VDimRectVector(Result, BarsCount);
  //constraint max bar width
  BarWidth:= ARect.Width div BarsCount;
  Value:= Trunc(Percent(ARect.Width, AMaxBarWidthPercent));
  BarWidth:= Min(BarWidth, Value);
  BarWidth:= Min(BarWidth, AMaxBarWidthInPixels);
  //constraint min bar margin
  BarMargin:= Round(Percent(BarWidth, AMinBarMarginPercent));

  FirstBarLeftCoord:= ARect.Left + BarMargin +
                   ((ARect.Width - BarMargin - BarsCount*BarWidth) div 2);

  for i:= 0 to High(AYDataValues) do
  begin
    Result[i].Bottom:= ARect.Bottom + 1;
    Result[i].Left:= FirstBarLeftCoord + i*BarWidth;
    Result[i].Right:= Result[i].Left + BarWidth - BarMargin;
    Result[i].Top:= DataCoordY(ARect, AYDataValues[i], AYTicksCoords, AYTicksValues);
  end;
end;

function BarsHorizRects(const ARect: TRect;
                        const AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                        const AXTicksCoords, AXTicksValues,
                             AXDataValues: TIntVector;
                        const AMaxBarWidthInPixels: Integer = BAR_MAX_WIDTH_PX): TRectVector;
var
  i, BarsCount, BarHeight, BarMargin: Integer;
  Value, FirstBarTopCoord: Integer;
begin
  Result:= nil;
  if VIsNil(AXDataValues) then Exit;

  BarsCount:= Length(AXDataValues);
  VDimRectVector(Result, BarsCount);
  //constraint max bar height
  BarHeight:= ARect.Height div BarsCount;
  Value:= Trunc(Percent(ARect.Height, AMaxBarWidthPercent));
  BarHeight:= Min(BarHeight, Value);
  BarHeight:= Min(BarHeight, AMaxBarWidthInPixels);
  //constraint min bar margin
  BarMargin:= Round(Percent(BarHeight, AMinBarMarginPercent));

  FirstBarTopCoord:= ARect.Top + BarMargin +
                   ((ARect.Height - BarMargin - BarsCount*BarHeight) div 2);

  for i:= 0 to High(AXDataValues) do
  begin
    Result[i].Left:= ARect.Left;
    Result[i].Top:= FirstBarTopCoord + i*BarHeight;
    Result[i].Bottom:= Result[i].Top + BarHeight - BarMargin;
    Result[i].Right:= DataCoordX(ARect, AXDataValues[i], AXTicksCoords, AXTicksValues);
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

