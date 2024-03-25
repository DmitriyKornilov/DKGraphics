unit DK_SVGWriter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  DK_Graph, DK_Vector, DK_Matrix, DK_Math, DK_StrUtils, DK_Color;

const
  STR_SPACES = '  ';

type

  { TSVGWriter }

  TSVGWriter = class(TObject)
  private
    FSVG: TStrVector;
    FGradientCount: Integer;
    FWidth, FHeight: Integer;
    FZoomX, FZoomY: Double;

    function ScaleX(const ASize: Integer): Integer;
    function ScaleY(const ASize: Integer): Integer;
    function Scale(const ARect: TRect): TRect;

    function GetSVGText(const AFontStyles: TFontStyles): String;
    function GetSVGComplete: TStrVector;
    function GetGradient(const AStartBGColor, AEndBGColor:TColor;
                      const ADirection: TGradientDirection): TStrVector;
  public
    constructor Create(const AWidth, AHeight: Integer);
    destructor  Destroy; override;

    property SVGComplete: TStrVector read GetSVGComplete;
    property SVGLines: TStrVector read FSVG;

    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(AStream: TMemoryStream);

    {---LINES--------------------------------------------------------------------}
    //Line  (AStyle in [psSolid, psDash, psDot, psDashDot, psDashDotDot])
    procedure Line(const X1, Y1, X2, Y2: Integer;
                        const AColor: TColor;
                        const AWidth: Integer;
                        const AStyle: TPenStyle);


    {---RECTS--------------------------------------------------------------------}
    //Rectangle with background single color fill
    procedure Rect(const ARect: TRect; const ABGColor:TColor);
    //Rectangle with background single GetGradient fill
    procedure Rect(const ARect: TRect;
                   const AStartBGColor, AEndBGColor:TColor;
                   const ADirection: TGradientDirection);
    //Rectangle with background double GetGradient fill
    procedure Rect(const ARect: TRect;
                     const AStartBGColor1, AEndBGColor1,
                           AStartBGColor2, AEndBGColor2: TColor;
                     const ADirection1, ADirection2,
                           ADemarcationDirection: TGradientDirection;
                     const ADemarcationPercent: Byte);

    {---FRAMES--------------------------------------------------------------------}
    //Color frame with background single color fill
    procedure Frame(const ARect: TRect;
                        const ABGColor, AFrameColor: TColor;
                        const AFrameWidth: Integer);
    //Color frame with background single GetGradient fill
    procedure Frame(const ARect: TRect;
                      const AStartBGColor, AEndBGColor, AFrameColor: TColor;
                      const AFrameWidth: Integer;
                      const ADirection: TGradientDirection);
    //Color frame with background double GetGradient fill
    procedure Frame(const ARect: TRect;
                      const AStartBGColor1, AEndBGColor1,
                            AStartBGColor2, AEndBGColor2, AFrameColor: TColor;
                      const AFrameWidth: Integer;
                      const ADirection1, ADirection2,
                            ADemarcationDirection: TGradientDirection;
                      const ADemarcationPercent: Byte);

    {---BARS--------------------------------------------------------------------}
    procedure BarVert(const ARect: TRect;
                      const AMainBGColor, AFrameColor: TColor;
                      const AFrameWidth, AIncLightess: Integer;
                      const ADemarcationPercent: Byte);
    procedure BarsVert(const ARect: TRect;
                       const AMainBGColor, AFrameColor: TColor;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues, AYDataValues: TIntVector);
    procedure BarsVert(const ARect: TRect;
                       const AMainBGColors, AFrameColors: TColorVector;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues, AYDataValues: TIntVector);
    procedure BarsVert(const ARects: TRectVector;
                       const AMainBGColors, AFrameColors: TColorVector;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues: TIntVector;
                       const AYDataValues: TIntMatrix;
                       const AOneColorPerTick: Boolean = False);
    procedure BarHoriz(const ARect: TRect;
                        const AMainBGColor, AFrameColor: TColor;
                        const AFrameWidth, AIncLightess: Integer;
                        const ADemarcationPercent: Byte);
    procedure BarsHoriz(const ARect: TRect;
                         const AMainBGColor, AFrameColor: TColor;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues, AXDataValues: TIntVector);
    procedure BarsHoriz(const ARect: TRect;
                         const AMainBGColors, AFrameColors: TColorVector;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues, AXDataValues: TIntVector);
    procedure BarsHoriz(const ARects: TRectVector;
                         const AMainBGColors, AFrameColors: TColorVector;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues: TIntVector;
                         const AXDataValues: TIntMatrix;
                         const AOneColorPerTick: Boolean = False);

    {---HORIZONTAL (LEFT TO RIGHT) TEXT------------------------------------------}
    //Single left to right string
    procedure StringHoriz(const ARect: TRect;
                          const ABGColor: TColor;
                          const AString: String;
                          const AFont: TFont;
                          const AHorizPosition: TAlignment = taCenter);
    //Several left to right strings
    procedure StringsHoriz(const ARect: TRect;
                           const ABGColor: TColor;
                           const AStrings: TStrVector;
                           const AFont: TFont;
                           const ARowHeight: Integer;
                           const AHorizPosition: TAlignment = taCenter);
    //Multiline left to right text
    procedure TextHoriz(const ARect: TRect;
                        const ABGColor: TColor;
                        const AText: TStrVector;
                        const AFont: TFont;
                        const AHorizPosition: TAlignment = taCenter;
                        const AVertPosition: TTextLayout = tlCenter);

    {---VERTICAL (BOTTOM TO TOP) TEXT------------------------------------------}
    //Single bottom to top string
    procedure StringVert(const ARect: TRect;
                         const ABGColor: TColor;
                         const AString: String;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout = tlCenter);
    //Several bottom to top strings
    procedure StringsVert(const ARect: TRect;
                         const ABGColor: TColor;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const ARowWidth: Integer;
                         const AVertPosition: TTextLayout = tlCenter);
    //Multiline bottom to top text
    procedure TextVert(const ARect: TRect;
                       const ABGColor: TColor;
                       const AText: TStrVector;
                       const AFont: TFont;
                       const AHorizPosition: TAlignment = taCenter;
                       const AVertPosition: TTextLayout = tlCenter);
  end;

implementation

{ TSVGWriter }



constructor TSVGWriter.Create(const AWidth, AHeight: Integer);
begin
  FSVG:= nil;
  FGradientCount:= 0;

  FZoomX:= 1.0;
  FZoomY:= 1.0;
  if ScreenInfo.Initialized then
  begin
    FZoomX:= ScreenInfo.PixelsPerInchX/96;
    FZoomY:= ScreenInfo.PixelsPerInchY/96;
  end;

  FWidth:= ScaleX(AWidth);
  FHeight:= ScaleY(AHeight);
end;

destructor TSVGWriter.Destroy;
begin
  inherited Destroy;
end;

function TSVGWriter.GetSVGComplete: TStrVector;
begin
  Result:= VCreateStr([
    '<?xml version="1.0" encoding="UTF-8" standalone="no"?>',
    '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"',
    '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">',
    '<svg',
    STR_SPACES + Format('width="%dpx" height="%dpx"', [FWidth, FHeight]),
    STR_SPACES + 'xmlns="http://www.w3.org/2000/svg" version="1.1"',
    STR_SPACES + 'xmlns:xlink="http://www.w3.org/1999/xlink"',
    '>'
  ]);
  Result:= VAdd(Result, FSVG);
  VAppend(Result, '</svg>');
end;

procedure TSVGWriter.SaveToFile(const AFileName: String);
var
  SL: TStringList;
begin
  SL:= TStringList.Create;
  try
    VToStrings(SVGComplete, SL);
    SL.SaveToFile(SFileName(AFileName, 'svg'));
  finally
    FreeAndNil(SL);
  end;
end;

procedure TSVGWriter.SaveToStream(AStream: TMemoryStream);
var
  SL: TStringList;
begin
  SL:= TStringList.Create;
  try
    VToStrings(SVGComplete, SL);
    SL.SaveToStream(AStream);
  finally
    FreeAndNil(SL);
  end;
end;

procedure TSVGWriter.Line(const X1, Y1, X2, Y2: Integer;
                               const AColor: TColor;
                               const AWidth: Integer;
                               const AStyle: TPenStyle);
var
  R,G,B: Byte;
  S: String;
begin
  RedGreenBlue(AColor, R,G,B);

  S:= '<line x1="%d" y1="%d" x2="%d" y2="%d" fill="none" ' +
      'stroke="rgb(%d, %d, %d)" stroke-width="%d" ';
  if AStyle = psDot then
    S:= S + 'stroke-dasharray="3"'
  else if AStyle = psDash then
    S:= S + 'stroke-dasharray="15, 5"'
  else if AStyle = psDashDot then
    S:= S + 'stroke-dasharray="10, 5, 3, 5"'
  else if AStyle = psDashDotDot then
    S:= S + 'stroke-dasharray="10, 3, 3, 3, 3, 3"';
  S:= S + ' />';
  S:= Format(S, [ScaleX(X1), ScaleY(Y1), ScaleX(X2), ScaleY(Y2), R, G, B, ScaleX(AWidth)]);

  VAppend(FSVG, S);
end;

function TSVGWriter.GetGradient(const AStartBGColor, AEndBGColor: TColor;
                             const ADirection: TGradientDirection): TStrVector;
var
  R,G,B: Byte;
  X1, Y1, X2, Y2: Integer;
  S: String;
begin
  Result:= nil;

  VAppend(Result, '<defs>');

  X1:=0; Y1:=0; X2:= 0; Y2:=0;
  if ADirection=gdVertical then
    Y2:= 100
  else //gdHorizontal
    X2:= 100;
  Inc(FGradientCount);
  S:= '<linearGradient id="Gradient%d" x1="%d%%" y1="%d%%" x2="%d%%" y2="%d%%" >';
  S:= Format(S, [FGradientCount, X1, Y1, X2, Y2]);
  VAppend(Result, STR_SPACES + S);

  RedGreenBlue(AStartBGColor, R,G,B);
  S:= '<stop offset="0%%" stop-color="rgb(%d, %d, %d)" />';
  S:= Format(S, [R,G,B]);
  VAppend(Result, STR_SPACES + STR_SPACES + S);

  RedGreenBlue(AEndBGColor, R,G,B);
  S:= '<stop offset="100%%" stop-color="rgb(%d, %d, %d)" />';
  S:= Format(S, [R,G,B]);
  VAppend(Result, STR_SPACES + STR_SPACES + S);

  VAppend(Result, STR_SPACES + '</linearGradient>');
  VAppend(Result, '</defs>');
end;

procedure TSVGWriter.Rect(const ARect: TRect; const ABGColor: TColor);
var
  R,G,B: Byte;
  S: String;
  Rct: TRect;
begin
  Rct:= Scale(ARect);
  RedGreenBlue(ABGColor, R,G,B);
  S:= '<rect x="%d" y="%d" width="%d" height="%d" fill="rgb(%d, %d, %d)" />';
  S:= Format(S, [Rct.Left, Rct.Top, Rct.Width, Rct.Height, R, G, B]);
  VAppend(FSVG, S);
end;

procedure TSVGWriter.Rect(const ARect: TRect;
                          const AStartBGColor, AEndBGColor: TColor;
                          const ADirection: TGradientDirection);
var
  S: String;
  V: TStrVector;
  Rct: TRect;
begin
  Rct:= Scale(ARect);
  V:= GetGradient(AStartBGColor, AEndBGColor, ADirection);
  FSVG:= VAdd(FSVG, V);
  S:= '<rect x="%d" y="%d" width="%d" height="%d" fill="url(#Gradient%d)" />';
  S:= Format(S, [Rct.Left, Rct.Top, Rct.Width, Rct.Height, FGradientCount]);
  VAppend(FSVG, S);
end;

procedure TSVGWriter.Rect(const ARect: TRect;
                          const AStartBGColor1, AEndBGColor1,
                                AStartBGColor2, AEndBGColor2: TColor;
                          const ADirection1, ADirection2,
                                ADemarcationDirection: TGradientDirection;
                          const ADemarcationPercent: Byte);
var
  Rct1, Rct2: TRect;
  DemarcationValue: Integer;
begin
  if not IsValidPercent(ADemarcationPercent) then Exit;

  if ADemarcationPercent=0 then
    Rect(ARect, AStartBGColor2, AEndBGColor2, ADirection2)
  else if ADemarcationPercent=100 then
    Rect(ARect, AStartBGColor1, AEndBGColor1, ADirection1)
  else begin
    Rct1:= ARect;
    Rct2:= ARect;
    if ADemarcationDirection=gdVertical then
    begin
      DemarcationValue:= Round(Percent(Rct1.Width, ADemarcationPercent));
      Rct1.Right:= Rct1.Left + DemarcationValue;
      Rct2.Left:= Rct1.Right;
    end
    else begin //gdHorizontal
      DemarcationValue:= Round(Percent(Rct1.Height, ADemarcationPercent));
      Rct1.Bottom:= Rct1.Top + DemarcationValue;
      Rct2.Top:= Rct1.Bottom;
    end;
    Rect(Rct1, AStartBGColor1, AEndBGColor1, ADirection1);
    Rect(Rct2, AStartBGColor2, AEndBGColor2, ADirection2)
  end;
end;

procedure TSVGWriter.Frame(const ARect: TRect;
                           const ABGColor, AFrameColor: TColor;
                           const AFrameWidth: Integer);
var
  R: TRect;
begin
  R:= RectInflate(ARect, ScaleX(AFrameWidth), ScaleY(AFrameWidth));
  Rect(R, AFrameColor);
  Rect(ARect, ABGColor);
end;

procedure TSVGWriter.Frame(const ARect: TRect;
                      const AStartBGColor, AEndBGColor, AFrameColor: TColor;
                      const AFrameWidth: Integer;
                      const ADirection: TGradientDirection);
var
  R: TRect;
begin
  R:= RectInflate(ARect, ScaleX(AFrameWidth), ScaleY(AFrameWidth));
  Rect(R, AFrameColor);
  Rect(ARect, AStartBGColor, AEndBGColor, ADirection);
end;

procedure TSVGWriter.Frame(const ARect: TRect;
                      const AStartBGColor1, AEndBGColor1,
                            AStartBGColor2, AEndBGColor2, AFrameColor: TColor;
                      const AFrameWidth: Integer;
                      const ADirection1, ADirection2,
                            ADemarcationDirection: TGradientDirection;
                      const ADemarcationPercent: Byte);
var
  R: TRect;
begin
  R:= RectInflate(ARect, ScaleX(AFrameWidth), ScaleY(AFrameWidth));
  Rect(R, AFrameColor);
  Rect(ARect, AStartBGColor1, AEndBGColor1, AStartBGColor2, AEndBGColor2,
           ADirection1, ADirection2, ADemarcationDirection, ADemarcationPercent);
end;

procedure TSVGWriter.BarVert(const ARect: TRect;
                      const AMainBGColor, AFrameColor: TColor;
                      const AFrameWidth, AIncLightess: Integer;
                      const ADemarcationPercent: Byte);
var
  MiddleBGColor: TColor;
  R: TRect;
begin
  Rect(ARect, AFrameColor);
  MiddleBGColor:= ColorIncLightness(AMainBGColor, AIncLightess);
  R:= RectDeflate(ARect, AFrameWidth);
  Rect(R, AMainBGColor, MiddleBGColor, MiddleBGColor, AMainBGColor,
           gdHorizontal, gdHorizontal, gdVertical, ADemarcationPercent);
end;

procedure TSVGWriter.BarsVert(const ARect: TRect;
                       const AMainBGColor, AFrameColor: TColor;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues, AYDataValues: TIntVector);
var
  i: Integer;
  Rects: TRectVector;
begin
  Rects:= BarsVertRects(ARect, AMaxBarWidthPercent, AMinBarMarginPercent,
                        AYTicksCoords, AYTicksValues, AYDataValues);
  for i:= 0 to High(Rects) do
    BarVert(Rects[i], AMainBGColor, AFrameColor, AFrameWidth,
                AIncLightess, ADemarcationPercent);
end;

procedure TSVGWriter.BarsVert(const ARect: TRect;
                       const AMainBGColors, AFrameColors: TColorVector;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues, AYDataValues: TIntVector);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
  Rects: TRectVector;
begin
  Rects:= BarsVertRects(ARect, AMaxBarWidthPercent, AMinBarMarginPercent,
                        AYTicksCoords, AYTicksValues, AYDataValues);

  for i:= 0 to High(Rects) do
  begin
    MainBGColor:= ColorFromVector(AMainBGColors, i);
    FrameColor:= ColorFromVector(AFrameColors, i);
    BarVert(Rects[i], MainBGColor, FrameColor, AFrameWidth,
                AIncLightess, ADemarcationPercent);
  end;
end;

procedure TSVGWriter.BarsVert(const ARects: TRectVector;
                       const AMainBGColors, AFrameColors: TColorVector;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues: TIntVector;
                       const AYDataValues: TIntMatrix;
                       const AOneColorPerTick: Boolean = False);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
begin
  if AOneColorPerTick then
  begin
    for i:= 0 to High(ARects) do
    begin
      MainBGColor:= ColorFromVector(AMainBGColors, i);
      FrameColor:= ColorFromVector(AFrameColors, i);
      BarsVert(ARects[i], MainBGColor, FrameColor, AFrameWidth, AIncLightess,
               ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent,
               AYTicksCoords, AYTicksValues, AYDataValues[i]);
    end;
  end
  else begin
    for i:= 0 to High(ARects) do
      BarsVert(ARects[i], AMainBGColors, AFrameColors, AFrameWidth, AIncLightess,
               ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent,
               AYTicksCoords, AYTicksValues, AYDataValues[i]);
  end;
end;

procedure TSVGWriter.BarHoriz(const ARect: TRect;
                        const AMainBGColor, AFrameColor: TColor;
                        const AFrameWidth, AIncLightess: Integer;
                        const ADemarcationPercent: Byte);
var
  MiddleBGColor: TColor;
  R: TRect;
begin
  Rect(ARect, AFrameColor);
  MiddleBGColor:= ColorIncLightness(AMainBGColor, AIncLightess);
  R:= RectDeflate(ARect, AFrameWidth);
  Rect(R, AMainBGColor, MiddleBGColor, MiddleBGColor, AMainBGColor,
           gdVertical, gdVertical, gdHorizontal, ADemarcationPercent);
end;

procedure TSVGWriter.BarsHoriz(const ARect: TRect;
                         const AMainBGColor, AFrameColor: TColor;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues, AXDataValues: TIntVector);
var
  i: Integer;
  Rects: TRectVector;
begin
  Rects:= BarsHorizRects(ARect, AMaxBarWidthPercent, AMinBarMarginPercent,
                        AXTicksCoords, AXTicksValues, AXDataValues);
  for i:= 0 to High(Rects) do
    BarHoriz(Rects[i], AMainBGColor, AFrameColor, AFrameWidth,
                AIncLightess, ADemarcationPercent);
end;

procedure TSVGWriter.BarsHoriz(const ARect: TRect;
                         const AMainBGColors, AFrameColors: TColorVector;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues, AXDataValues: TIntVector);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
  Rects: TRectVector;
begin
  Rects:= BarsHorizRects(ARect, AMaxBarWidthPercent, AMinBarMarginPercent,
                        AXTicksCoords, AXTicksValues, AXDataValues);

  for i:= 0 to High(Rects) do
  begin
    MainBGColor:= ColorFromVector(AMainBGColors, i);
    FrameColor:= ColorFromVector(AFrameColors, i);
    BarHoriz(Rects[i], MainBGColor, FrameColor, AFrameWidth,
                AIncLightess, ADemarcationPercent);
  end;
end;

procedure TSVGWriter.BarsHoriz(const ARects: TRectVector;
                         const AMainBGColors, AFrameColors: TColorVector;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues: TIntVector;
                         const AXDataValues: TIntMatrix;
                         const AOneColorPerTick: Boolean = False);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
begin
  if AOneColorPerTick then
  begin
    for i:= 0 to High(ARects) do
    begin
      MainBGColor:= ColorFromVector(AMainBGColors, i);
      FrameColor:= ColorFromVector(AFrameColors, i);
      BarsHoriz(ARects[i], MainBGColor, FrameColor, AFrameWidth, AIncLightess,
               ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent,
               AXTicksCoords, AXTicksValues, AXDataValues[i]);
    end;
  end
  else begin
    for i:= 0 to High(ARects) do
      BarsHoriz(ARects[i], AMainBGColors, AFrameColors, AFrameWidth, AIncLightess,
               ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent,
               AXTicksCoords, AXTicksValues, AXDataValues[i]);
  end;
end;

function TSVGWriter.ScaleX(const ASize: Integer): Integer;
begin
  Result:= Round(ASize/FZoomX);
end;

function TSVGWriter.ScaleY(const ASize: Integer): Integer;
begin
  Result:= Round(ASize/FZoomY);
end;

function TSVGWriter.Scale(const ARect: TRect): TRect;
begin
  Result.Left:= ScaleX(ARect.Left);
  Result.Right:= ScaleX(ARect.Right);
  Result.Top:= ScaleY(ARect.Top);
  Result.Bottom:= ScaleY(ARect.Bottom);
end;

function TSVGWriter.GetSVGText(const AFontStyles: TFontStyles): String;
begin
  Result:= '<text x="%d" y="%d" ' +
                 'font-family="%s" font-size="%dpx" ' +
                 'fill="rgb(%d, %d, %d)" ';
  if fsBold in AFontStyles then
    Result:= Result + 'font-weight="bold" '
  else
    Result:= Result + 'font-weight="normal" ';
  if fsItalic in AFontStyles then
    Result:= Result + 'font-style="italic" '
  else
    Result:= Result + 'font-style="normal" ';
  if fsUnderline in AFontStyles then
    Result:= Result + 'text-decoration="underline" '
  else if fsStrikeOut in AFontStyles then
    Result:= Result + 'text-decoration="line-through" '
  else
    Result:= Result + 'text-decoration="none" ';
  //Result:= Result + 'rotate="%d" >';
  Result:= Result + 'transform="rotate(%d %d,%d)" >';
end;

procedure TSVGWriter.StringHoriz(const ARect: TRect;
                          const ABGColor: TColor;
                          const AString: String;
                          const AFont: TFont;
                          const AHorizPosition: TAlignment = taCenter);
var
  Rct: TRect;
  S: String;
  R,G,B: Byte;
  TM: TLCLTextMetric;
  X,Y,H: Integer;
begin
  Rct:= StringHorizRect(ARect, AString, AFont, AHorizPosition);
  Rect(Rct, ABGColor);

  RedGreenBlue(AFont.Color, R,G,B);
  TM:= SMetric(AFont);
  X:= ScaleX(Rct.Left);
  Y:= ScaleY(Rct.Top+TM.Ascender);
  H:= Abs(AFont.Height);//ScaleY(AFont.Height);

  S:= GetSVGText(AFont.Style);
  S:= Format(S, [X, Y, AFont.Name, H, R, G, B, 0, 0, 0]);

  VAppend(FSVG, S);
  VAppend(FSVG, STR_SPACES + AString);
  VAppend(FSVG, '</text>');
end;

procedure TSVGWriter.StringsHoriz(const ARect: TRect;
                           const ABGColor: TColor;
                           const AStrings: TStrVector;
                           const AFont: TFont;
                           const ARowHeight: Integer;
                           const AHorizPosition: TAlignment = taCenter);
var
  i: Integer;
  Rects: TRectVector;
begin
  Rects:= StringsHorizRects(ARect, ARowHeight, AStrings, AFont, AHorizPosition);
  if Length(Rects)=0 then Exit;
  for i:=0 to High(Rects) do
    StringHoriz(Rects[i], ABGColor, AStrings[i], AFont, AHorizPosition);
end;

procedure TSVGWriter.TextHoriz(const ARect: TRect;
                        const ABGColor: TColor;
                        const AText: TStrVector;
                        const AFont: TFont;
                        const AHorizPosition: TAlignment = taCenter;
                        const AVertPosition: TTextLayout = tlCenter);
var
  Rct: TRect;
  RowHeight: Integer;
begin
  if VIsNil(AText) then Exit;
  Rct:= TextHorizRect(ARect, AText, AFont, AVertPosition);
  RowHeight:= SHeight(AFont);
  StringsHoriz(Rct, ABGColor, AText, AFont, RowHeight, AHorizPosition);
end;

procedure TSVGWriter.StringVert(const ARect: TRect;
                         const ABGColor: TColor;
                         const AString: String;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout = tlCenter);
var
  Rct: TRect;
  S: String;
  R,G,B: Byte;
  TM: TLCLTextMetric;
  X,Y,H: Integer;
begin
  Rct:= StringVertRect(ARect, AString, AFont, AVertPosition);
  Rect(Rct, ABGColor);

  RedGreenBlue(AFont.Color, R,G,B);
  TM:= SMetric(AFont);
  X:= ScaleX(Rct.Left+TM.Ascender);
  Y:= ScaleY(Rct.Bottom);
  H:= Abs(AFont.Height); //ScaleX(AFont.Height);

  S:= GetSVGText(AFont.Style);
  S:= Format(S, [X, Y, AFont.Name, H, R, G, B, -90, X, Y]);

  VAppend(FSVG, S);
  VAppend(FSVG, STR_SPACES + AString);
  VAppend(FSVG, '</text>');
end;

procedure TSVGWriter.StringsVert(const ARect: TRect;
                         const ABGColor: TColor;
                         const AStrings: TStrVector;
                         const AFont: TFont;
                         const ARowWidth: Integer;
                         const AVertPosition: TTextLayout = tlCenter);
var
  i: Integer;
  Rects: TRectVector;
begin
  Rects:= StringsVertRects(ARect, ARowWidth, AStrings, AFont, AVertPosition);
  if Length(Rects)=0 then Exit;
  for i:=0 to High(Rects) do
    StringVert(Rects[i], ABGColor, AStrings[i], AFont, AVertPosition);
end;

procedure TSVGWriter.TextVert(const ARect: TRect;
                       const ABGColor: TColor;
                       const AText: TStrVector;
                       const AFont: TFont;
                       const AHorizPosition: TAlignment = taCenter;
                       const AVertPosition: TTextLayout = tlCenter);
var
  Rct: TRect;
  RowWidth: Integer;
begin
  if VIsNil(AText) then Exit;
  Rct:= TextVertRect(ARect, AText, AFont, AHorizPosition);
  RowWidth:= SHeight(AFont);
  StringsVert(Rct, ABGColor, AText, AFont, RowWidth, AVertPosition);
end;



end.

