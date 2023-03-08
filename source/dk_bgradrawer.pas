unit DK_BGRADrawer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, BGRABitmap, BGRABitmapTypes,
  DK_StrUtils, DK_Vector, DK_Matrix, DK_Graph, DK_Math;

const
  COLOR_BG_DEFAULT = clWhite;

type

  { TBGRADrawer }

  TBGRADrawer = class(TObject)
  private
    FBMP: TBGRABitmap;
  public
    constructor Create(const AWidth, AHeight: Integer;
                       const AColor: TColor = COLOR_BG_DEFAULT);
    destructor  Destroy; override;

    procedure Draw(const ACanvas: TCanvas;
                   const X: Integer = 0;
                   const Y: Integer = 0;
                   const AOpaque: Boolean = True);
    procedure SaveToStream(AStream: TMemoryStream);
    procedure SaveToFile(const AFileName: String);

    {---LINES------------------------------------------------------------------}
    procedure Line(const X1, Y1, X2, Y2: Integer;
                       const AColor: TColor;
                       const AWidth: Integer;
                       const AStyle: TPenStyle);
    procedure LinesYAtX(const AXCoords: TIntVector; const AYCoords: TIntMatrix;
                        const AColors: TColorVector;
                        const ALineWidth, APointRadius: Integer;
                        const AStyle: TPenStyle;
                        const AColorIndexes: TIntVector = nil);

    {---CIRCLES----------------------------------------------------------------}
    procedure Circle(const X, Y, R: Integer;
                     const AColor: TColor);

    {---RECTS------------------------------------------------------------------}
    //Rectangle with background single color fill
    procedure Rect(const ARect: TRect;
                   const ABGColor:TColor);
    //Rectangle with background single gradient fill
    procedure Rect(const ARect: TRect;
                   const AStartBGColor, AEndBGColor:TColor;
                   const ADirection: TGradientDirection);
    //Rectangle with background double gradient fill
    procedure Rect(const ARect: TRect;
                   const AStartBGColor1, AEndBGColor1, AStartBGColor2, AEndBGColor2: TColor;
                   const ADirection1, ADirection2, ADemarcationDirection: TGradientDirection;
                   const ADemarcationPercent: Byte);

    {---FRAMES--------------------------------------------------------------------}
    //Color frame with background single color fill
    procedure Frame(const ARect: TRect;
                        const ABGColor, AFrameColor: TColor;
                        const AFrameWidth: Integer);
    //Color frame with background single gradient fill
    procedure Frame(const ARect: TRect;
                        const AStartBGColor, AEndBGColor, AFrameColor: TColor;
                        const AFrameWidth: Integer;
                        const ADirection: TGradientDirection);
    //Color frame with background double gradient fill
    procedure Frame(const ARect: TRect;
                        const AStartBGColor1, AEndBGColor1, AStartBGColor2, AEndBGColor2, AFrameColor: TColor;
                        const AFrameWidth: Integer;
                        const ADirection1, ADirection2, ADemarcationDirection: TGradientDirection;
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
                       const AOneColorPerTick: Boolean = False;
                       const AColorIndexes: TIntVector = nil);
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
                         const AOneColorPerTick: Boolean = False;
                         const AColorIndexes: TIntVector = nil);

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

{ TBGRADrawer }

constructor TBGRADrawer.Create(const AWidth, AHeight: Integer;
                               const AColor: TColor = COLOR_BG_DEFAULT);
begin
  FBMP:= TBGRABitmap.Create(AWidth, AHeight, ColorToBGRA(AColor));
end;

destructor TBGRADrawer.Destroy;
begin
  FreeAndNil(FBMP);
  inherited Destroy;
end;

procedure TBGRADrawer.Draw(const ACanvas: TCanvas;
                           const X: Integer = 0;
                           const Y: Integer = 0;
                           const AOpaque: Boolean = True);
begin
  FBMP.Draw(ACanvas, X, Y, AOpaque);
end;

procedure TBGRADrawer.SaveToStream(AStream: TMemoryStream);
begin
  FBMP.SaveToStreamAsPng(AStream);
end;

procedure TBGRADrawer.SaveToFile(const AFileName: String);
begin
  FBMP.SaveToFileUTF8(SFileName(AFileName, 'png'));
end;

procedure TBGRADrawer.Line(const X1, Y1, X2, Y2: Integer;
                       const AColor: TColor;
                       const AWidth: Integer;
                       const AStyle: TPenStyle);
begin
  FBMP.PenStyle:= AStyle;
  FBMP.DrawLineAntialias(X1, Y1, X2, Y2, ColorToBGRA(AColor), AWidth);
end;

procedure TBGRADrawer.LinesYAtX(const AXCoords: TIntVector; const AYCoords: TIntMatrix;
                        const AColors: TColorVector;
                        const ALineWidth, APointRadius: Integer;
                        const AStyle: TPenStyle;
                        const AColorIndexes: TIntVector = nil);
var
  i, j, X1, Y1, X2, Y2: Integer;
  Color: TColor;
begin
  if Length(AXCoords)<>Length(AYCoords) then Exit;
  for i:= 0 to High(AXCoords)-1 do
  begin
    X1:= AXCoords[i];
    X2:= AXCoords[i+1];
    for j:= 0 to High(AYCoords[i]) do
    begin
      Y1:= AYCoords[i, j];
      Y2:= AYCoords[i+1, j];
      Color:= ColorFromVector(AColors, j, AColorIndexes);
      Line(X1, Y1, X2, Y2, Color, ALineWidth, AStyle);
      Circle(X1, Y1, APointRadius, Color);
      Circle(X2, Y2, APointRadius, Color);
    end;
  end;

end;

procedure TBGRADrawer.Circle(const X, Y, R: Integer;
                             const AColor: TColor);
var
  Color: TBGRAPixel;
begin
  Color:= ColorToBGRA(AColor);
  FBMP.EllipseAntialias(X, Y, R, R, Color, 1, Color);
end;

procedure TBGRADrawer.Rect(const ARect: TRect; const ABGColor: TColor);
begin
  FBMP.FillRect(ARect, ColorToBGRA(ABGColor));
end;

procedure TBGRADrawer.Rect(const ARect: TRect;
                           const AStartBGColor, AEndBGColor:TColor;
                           const ADirection: TGradientDirection);
var
  P1, P2: TPointF;
  N: Single;
begin
  if ADirection=gdVertical then
  begin
    N:= ARect.Left + ARect.Width/2;
    P1:= PointF(N, ARect.Top);
    P2:= PointF(N, ARect.Bottom);
  end
  else begin //gdHorizontal
    N:= ARect.Top + ARect.Height/2;
    P1:= PointF(ARect.Left, N);
    P2:= PointF(ARect.Right, N);
  end;
  FBMP.GradientFill(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom,
                    ColorToBGRA(AStartBGColor), ColorToBGRA(AEndBGColor),
                    gtLinear, P1, P2, dmSet);
end;

procedure TBGRADrawer.Rect(const ARect: TRect;
                   const AStartBGColor1, AEndBGColor1, AStartBGColor2, AEndBGColor2: TColor;
                   const ADirection1, ADirection2, ADemarcationDirection: TGradientDirection;
                   const ADemarcationPercent: Byte);
var
  Rect1, Rect2: TRect;
  DemarcationValue: Integer;
begin
  if not IsValidPercent(ADemarcationPercent) then Exit;
  if ADemarcationPercent=0 then
    Rect(ARect, AStartBGColor2, AEndBGColor2, ADirection2)
  else if ADemarcationPercent=100 then
    Rect(ARect, AStartBGColor1, AEndBGColor1, ADirection1)
  else begin
    Rect1:= ARect;
    Rect2:= ARect;
    if ADemarcationDirection=gdVertical then
    begin
      DemarcationValue:= Round(Percent(Rect1.Width, ADemarcationPercent));
      Rect1.Right:= Rect1.Left + DemarcationValue;
      Rect2.Left:= Rect1.Right;
    end
    else begin //gdHorizontal
      DemarcationValue:= Round(Percent(Rect1.Height, ADemarcationPercent));
      Rect1.Bottom:= Rect1.Top + DemarcationValue;
      Rect2.Top:= Rect1.Bottom;
    end;
    Rect(Rect1, AStartBGColor1, AEndBGColor1, ADirection1);
    Rect(Rect2, AStartBGColor2, AEndBGColor2, ADirection2)
  end;
end;

procedure TBGRADrawer.Frame(const ARect: TRect;
                                  const ABGColor, AFrameColor: TColor;
                                  const AFrameWidth: Integer);
var
  R: TRect;
begin
  R:= RectInflate(ARect, AFrameWidth);
  Rect(R, AFrameColor);
  Rect(ARect, ABGColor);
end;

procedure TBGRADrawer.Frame(const ARect: TRect;
                       const AStartBGColor, AEndBGColor, AFrameColor: TColor;
                       const AFrameWidth: Integer;
                       const ADirection: TGradientDirection);
var
  R: TRect;
begin
  R:= RectInflate(ARect, AFrameWidth);
  Rect(R, AFrameColor);
  Rect(ARect, AStartBGColor, AEndBGColor, ADirection);
end;

procedure TBGRADrawer.Frame(const ARect: TRect;
                       const AStartBGColor1, AEndBGColor1,
                             AStartBGColor2, AEndBGColor2, AFrameColor: TColor;
                       const AFrameWidth: Integer;
                       const ADirection1, ADirection2,
                             ADemarcationDirection: TGradientDirection;
                       const ADemarcationPercent: Byte);
var
  R: TRect;
begin
  R:= RectInflate(ARect, AFrameWidth);
  Rect(R, AFrameColor);
  Rect(ARect, AStartBGColor1, AEndBGColor1, AStartBGColor2, AEndBGColor2,
           ADirection1, ADirection2, ADemarcationDirection, ADemarcationPercent);
end;

procedure TBGRADrawer.BarVert(const ARect: TRect;
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

procedure TBGRADrawer.BarsVert(const ARect: TRect;
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

procedure TBGRADrawer.BarsVert(const ARect: TRect;
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

procedure TBGRADrawer.BarsVert(const ARects: TRectVector;
                       const AMainBGColors, AFrameColors: TColorVector;
                       const AFrameWidth, AIncLightess: Integer;
                       const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                       const AYTicksCoords, AYTicksValues: TIntVector;
                       const AYDataValues: TIntMatrix;
                       const AOneColorPerTick: Boolean = False;
                       const AColorIndexes: TIntVector = nil);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
begin
  if AOneColorPerTick then
  begin
    for i:= 0 to High(ARects) do
    begin
      MainBGColor:= ColorFromVector(AMainBGColors, i, AColorIndexes);
      FrameColor:= ColorFromVector(AFrameColors, i, AColorIndexes);
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

procedure TBGRADrawer.BarHoriz(const ARect: TRect;
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

procedure TBGRADrawer.BarsHoriz(const ARect: TRect;
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

procedure TBGRADrawer.BarsHoriz(const ARect: TRect;
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

procedure TBGRADrawer.BarsHoriz(const ARects: TRectVector;
                         const AMainBGColors, AFrameColors: TColorVector;
                         const AFrameWidth, AIncLightess: Integer;
                         const ADemarcationPercent, AMaxBarWidthPercent, AMinBarMarginPercent: Byte;
                         const AXTicksCoords, AXTicksValues: TIntVector;
                         const AXDataValues: TIntMatrix;
                         const AOneColorPerTick: Boolean = False;
                         const AColorIndexes: TIntVector = nil);
var
  i: Integer;
  MainBGColor, FrameColor: TColor;
begin
  if AOneColorPerTick then
  begin
    for i:= 0 to High(ARects) do
    begin
      MainBGColor:= ColorFromVector(AMainBGColors, i, AColorIndexes);
      FrameColor:= ColorFromVector(AFrameColors, i, AColorIndexes);
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

procedure TBGRADrawer.StringHoriz(const ARect: TRect;
                          const ABGColor: TColor;
                          const AString: String;
                          const AFont: TFont;
                          const AHorizPosition: TAlignment = taCenter);
var
  R: TRect;
begin
  R:= StringHorizRect(ARect, AString, AFont, AHorizPosition);
  FBMP.FontAntialias:= True;
  FBMP.FontName:= AFont.Name;
  FBMP.FontQuality:= fqSystemClearType;
  FBMP.FontHeight:= -AFont.Height;
  FBMP.FontStyle:= AFont.Style;
  FBMP.FontOrientation:= 0;
  Rect(R, ABGColor);
  FBMP.TextOut(R.Left+1, R.Top, AString, ColorToBGRA(AFont.Color));
end;

procedure TBGRADrawer.StringsHoriz(const ARect: TRect;
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

procedure TBGRADrawer.TextHoriz(const ARect: TRect;
                        const ABGColor: TColor;
                        const AText: TStrVector;
                        const AFont: TFont;
                        const AHorizPosition: TAlignment = taCenter;
                        const AVertPosition: TTextLayout = tlCenter);
var
  R: TRect;
  RowHeight: Integer;
begin
  if VIsNil(AText) then Exit;
  R:= TextHorizRect(ARect, AText, AFont, AVertPosition);
  RowHeight:= SHeight(AFont);
  StringsHoriz(R, ABGColor, AText, AFont, RowHeight, AHorizPosition);
end;

procedure TBGRADrawer.StringVert(const ARect: TRect;
                         const ABGColor: TColor;
                         const AString: String;
                         const AFont: TFont;
                         const AVertPosition: TTextLayout = tlCenter);
var
  R: TRect;
begin
  R:= StringVertRect(ARect, AString, AFont, AVertPosition);
  FBMP.FontAntialias:= True;
  FBMP.FontName:= AFont.Name;
  FBMP.FontQuality:= fqSystemClearType;
  FBMP.FontHeight:= -AFont.Height;
  FBMP.FontStyle:= AFont.Style;
  FBMP.FontOrientation:= 900;
  Rect(R, ABGColor);
  FBMP.TextOut(R.Left+1, R.Top, AString, ColorToBGRA(AFont.Color));
end;

procedure TBGRADrawer.StringsVert(const ARect: TRect;
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

procedure TBGRADrawer.TextVert(const ARect: TRect;
                       const ABGColor: TColor;
                       const AText: TStrVector;
                       const AFont: TFont;
                       const AHorizPosition: TAlignment = taCenter;
                       const AVertPosition: TTextLayout = tlCenter);
var
  R: TRect;
  RowWidth: Integer;
begin
  if VIsNil(AText) then Exit;
  R:= TextVertRect(ARect, AText, AFont, AHorizPosition);
  RowWidth:= SHeight(AFont);
  StringsVert(R, ABGColor, AText, AFont, RowWidth, AVertPosition);
end;

end.

