unit DK_StatPlotter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, Graphics,

  DK_Vector, DK_Matrix, DK_StrUtils, DK_TextUtils, DK_Math, DK_Graph,
  {DK_SVGWriter,} DK_PNGDrawer, DK_VMShow;

const
  FONT_NAME_DEFAULT = 'Arial';
  FONT_SIZE_DEFAULT = 9;

  MIN_TICKS_NUMBER = 5;

  CORE_MARGIN_DEFAULT = 1;
  GRAPH_MARGIN_MIN = 0;
  MARGIN_DEFAULT = 2;
  MARGIN_LEFT    = MARGIN_DEFAULT;
  MARGIN_RIGHT   = MARGIN_DEFAULT;
  MARGIN_TOP     = MARGIN_DEFAULT;
  MARGIN_BOTTOM  = MARGIN_DEFAULT;

  BG_COLOR_DEFAULT = clWhite;

  FRAME_COLOR_DEFAULT = BG_COLOR_DEFAULT;//clBlack;
  FRAME_WIDTH_DEFAULT = 1;

  LINE_COLOR_DEFAULT = clSilver;
  LINE_WIDTH_DEFAULT = 1;
  LINE_STYLE_DEFAULT = psDot;

  MARK_FRAME_COLOR_DEFAULT = clBlack; //FRAME_COLOR_DEFAULT;
  MARK_FRAME_WIDTH_DEFAULT = FRAME_WIDTH_DEFAULT;
  MARK_SHORT_MARGIN_DEFAULT = MARGIN_DEFAULT;       // left, top, botom
  MARK_WIDE_MARGIN_DEFAULT  = 2*MARK_SHORT_MARGIN_DEFAULT;  // right before text
  LEGEND_HORIZ_MARGIN_DEFAULT = 7*MARGIN_DEFAULT;   // between legend values if horizontal
  LEGEND_VERT_MARGIN_DEFAULT  = 2*MARGIN_DEFAULT;   // between legend values if vertical
  LEGEND_TOP_MARGIN_DEFAULT   = 5*MARGIN_DEFAULT;   // between legend and other

  GRAPH_COLORS_DEFAULT: array [0..9] of TColor = (
    $00BF6515,  //blue
    $00006AEE,  //orange
    $003E9939,  //green
    $009B009B,  //violet
    $002F2FD3,  //red
    $007A6E54,  //grey
    $00009EC0,  //olive
    $008E8200,  //teal
    $00505D86,  //brown
    $00834FEE   //pink
  );

  GRADIENT_LIGHTNESS_INCREMENT_DEFAULT = 30;
  GRADIENT_DEMARCATION_PERCENT_DEFAULT = 70;

  TICKS_MAX_COUNT_DEFAULT = 10;

  BAR_MAX_WIDTH_PERCENT_DEFAULT = 30;
  BAR_FRAME_WIDTH_DEFAULT = 1;
  BAR_MARGIN_DEFAULT = 2;

type
  TTicksCaptionPosition = (tcpBetween, tcpTicks);
  TTicksCaptionOrientation = (tcoHorizontal, tcoVertical);

  TVertAxisType  = (vatLeft, vatRight, vatBoth);
  THorizAxisType = (hatTop, hatBottom, hatBoth);

  TDrawDataProc = procedure of object;

  { TStatPlotterCore }

  TStatPlotterCore = class(TObject)
  private
    //FCanvas: TCanvas;
    FRect: TRect;
    FDrawData: TDrawDataProc;
    FPNG: TPNGDrawer;
    //FSVG: TSVGWriter;

    //Core
    FCoreFont: TFont;
    FCoreBGColor: TColor;
    FCoreFrameColor: TColor;
    FCoreFrameWidth: Integer;
    FCoreRect: TRect;
    //Title
    FTitle: String;
    FTitleRowValues: TStrVector;
    FTitleFont: TFont;
    FTitleBGColor: TColor;
    FTitleFrameColor: TColor;
    FTitleFrameWidth: Integer;
    FTitleRect: TRect;
    //Legend
    FLegend: TStrVector;
    FLegendFont: TFont;
    FLegendBGColor: TColor;
    FLegendFrameColor: TColor;
    FLegendFrameWidth: Integer;
    FLegendRect: TRect;
    FLegendMarkRects: TRectVector;
    FLegendTextRects: TRectVector;
    FLegendValues: TStrMatrix;
    FLegendTopMargin: Integer;
    //TopAxisTitle
    FTopAxisTitle: String;
    FTopAxisTitleRowValues: TStrVector;
    FTopAxisTitleFont: TFont;
    FTopAxisTitleBGColor: TColor;
    FTopAxisTitleFrameColor: TColor;
    FTopAxisTitleFrameWidth: Integer;
    FTopAxisTitleRect: TRect;
    //BottomAxisTitle
    FBottomAxisTitle: String;
    FBottomAxisTitleRowValues: TStrVector;
    FBottomAxisTitleFont: TFont;
    FBottomAxisTitleBGColor: TColor;
    FBottomAxisTitleFrameColor: TColor;
    FBottomAxisTitleFrameWidth: Integer;
    FBottomAxisTitleRect: TRect;
    //LeftAxisTitle
    FLeftAxisTitle: String;
    FLeftAxisTitleRowValues: TStrVector;
    FLeftAxisTitleFont: TFont;
    FLeftAxisTitleBGColor: TColor;
    FLeftAxisTitleFrameColor: TColor;
    FLeftAxisTitleFrameWidth: Integer;
    FLeftAxisTitleRect: TRect;
    //RightAxisTitle
    FRightAxisTitle: String;
    FRightAxisTitleRowValues: TStrVector;
    FRightAxisTitleFont: TFont;
    FRightAxisTitleBGColor: TColor;
    FRightAxisTitleFrameColor: TColor;
    FRightAxisTitleFrameWidth: Integer;
    FRightAxisTitleRect: TRect;

    //TopAxisTicks
    FTopAxisTicksValues: TIntVector;
    FTopAxisTicksCaptions: TStrVector;
    FTopAxisTicksRowValues: TStrMatrix;
    FTopAxisTicksPosition: TTicksCaptionPosition;
    FTopAxisTicksOrientation: TTicksCaptionOrientation;
    FTopAxisTicksFont: TFont;
    FTopAxisTicksBGColor: TColor;
    FTopAxisTicksFrameColor: TColor;
    FTopAxisTicksFrameWidth: Integer;
    FTopAxisTicksRect: TRect;
    FTopAxisTicksCaptionsRects: TRectVector;
    FTopAxisTicksVisible: Boolean;
    FTopAxisTicksWrapWords: Boolean; //перенос по слогам
    FTopAxisTicksMaxCount: Integer;
    //BottomAxisTicks
    FBottomAxisTicksValues: TIntVector;
    FBottomAxisTicksCaptions: TStrVector;
    FBottomAxisTicksRowValues: TStrMatrix;
    FBottomAxisTicksPosition: TTicksCaptionPosition;
    FBottomAxisTicksOrientation: TTicksCaptionOrientation;
    FBottomAxisTicksFont: TFont;
    FBottomAxisTicksBGColor: TColor;
    FBottomAxisTicksFrameColor: TColor;
    FBottomAxisTicksFrameWidth: Integer;
    FBottomAxisTicksRect: TRect;
    FBottomAxisTicksCaptionsRects: TRectVector;
    FBottomAxisTicksVisible: Boolean;
    FBottomAxisTicksWrapWords: Boolean;
    FBottomAxisTicksMaxCount: Integer;
    //LeftAxisTicks
    FLeftAxisTicksValues: TIntVector;
    FLeftAxisTicksCaptions: TStrVector;
    FLeftAxisTicksRowValues: TStrMatrix;
    FLeftAxisTicksPosition: TTicksCaptionPosition;
    FLeftAxisTicksOrientation: TTicksCaptionOrientation;
    FLeftAxisTicksFont: TFont;
    FLeftAxisTicksBGColor: TColor;
    FLeftAxisTicksFrameColor: TColor;
    FLeftAxisTicksFrameWidth: Integer;
    FLeftAxisTicksRect: TRect;
    FLeftAxisTicksCaptionsRects: TRectVector;
    FLeftAxisTicksVisible: Boolean;
    FLeftAxisTicksWrapWords: Boolean;
    FLeftAxisTicksMaxCount: Integer;
    //RightAxisTicks
    FRightAxisTicksValues: TIntVector;
    FRightAxisTicksCaptions: TStrVector;
    FRightAxisTicksRowValues: TStrMatrix;
    FRightAxisTicksPosition: TTicksCaptionPosition;
    FRightAxisTicksOrientation: TTicksCaptionOrientation;
    FRightAxisTicksFont: TFont;
    FRightAxisTicksBGColor: TColor;
    FRightAxisTicksFrameColor: TColor;
    FRightAxisTicksFrameWidth: Integer;
    FRightAxisTicksRect: TRect;
    FRightAxisTicksCaptionsRects: TRectVector;
    FRightAxisTicksVisible: Boolean;
    FRightAxisTicksWrapWords: Boolean;
    FRightAxisTicksMaxCount: Integer;

    //TopAxisGridLines
    FTopAxisGridLinesVisible: Boolean;
    FTopAxisGridLinesWidth: Integer;
    FTopAxisGridLinesColor: TColor;
    FTopAxisGridLinesStyle: TPenStyle;
    FTopAxisGridLinesCoords: TIntVector;
    //BottomAxisGridLines
    FBottomAxisGridLinesVisible: Boolean;
    FBottomAxisGridLinesWidth: Integer;
    FBottomAxisGridLinesColor: TColor;
    FBottomAxisGridLinesStyle: TPenStyle;
    FBottomAxisGridLinesCoords: TIntVector;
    //LeftAxisGridLines
    FLeftAxisGridLinesVisible: Boolean;
    FLeftAxisGridLinesWidth: Integer;
    FLeftAxisGridLinesColor: TColor;
    FLeftAxisGridLinesStyle: TPenStyle;
    FLeftAxisGridLinesCoords: TIntVector;
    //RightAxisGridLines
    FRightAxisGridLinesVisible: Boolean;
    FRightAxisGridLinesWidth: Integer;
    FRightAxisGridLinesColor: TColor;
    FRightAxisGridLinesStyle: TPenStyle;
    FRightAxisGridLinesCoords: TIntVector;

    //Graph
    FGraphColors: TColorVector;
    FGraphMinMargin: Integer;
    FGraphBGColor: TColor;
    FGraphFrameColor: TColor;
    FGraphFrameWidth: Integer;
    FGraphFrameVisible: Boolean;
    FGraphRect: TRect;

    //Series
    FTopAxisSeries: TIntMatrix;
    FBottomAxisSeries: TIntMatrix;
    FLeftAxisSeries: TIntMatrix;
    FRightAxisSeries: TIntMatrix;

    //Prepare
    procedure Prepare;
    procedure PrepareCore;
    procedure PrepareTitle;
    procedure PrepareLegend;
    procedure PrepareAxisTitles;
    procedure PrepareAxisTicks;
    procedure PrepareGridLines;
    procedure PrepareGraph;

    //Get
    function GetTitleVisible: Boolean;
    function GetLegendVisible: Boolean;
    function GetTopAxisTitleVisible: Boolean;
    function GetBottomAxisTitleVisible: Boolean;
    function GetLeftAxisTitleVisible: Boolean;
    function GetRightAxisTitleVisible: Boolean;
    function GetTopAxisTicksVisible: Boolean;
    function GetBottomAxisTicksVisible: Boolean;
    function GetLeftAxisTicksVisible: Boolean;
    function GetRightAxisTicksVisible: Boolean;
    function GetDataRectsVert(const AAxisGridLinesCoords: TIntVector;
                              const AAxisTicksCaptionsRects: TRectVector): TRectVector;
    function GetDataRectsLeftBottom: TRectVector;
    function GetDataRectsLeftTop: TRectVector;
    function GetDataRectsRightBottom: TRectVector;
    function GetDataRectsRightTop: TRectVector;
    function GetDataRectsHoriz(const AAxisGridLinesCoords: TIntVector;
                              const AAxisTicksCaptionsRects: TRectVector): TRectVector;
    function GetDataRectsBottomLeft: TRectVector;
    function GetDataRectsBottomRight: TRectVector;
    function GetDataRectsTopLeft: TRectVector;
    function GetDataRectsTopRight: TRectVector;

    //Set
    procedure SetFont(var AFont: TFont; const AValue: TFont);
    procedure SetGraphColors(AValue: TColorVector);
    procedure SetTitle(AValue: String);
    procedure SetTitleFont(AValue: TFont);
    procedure SetLegend(AValue: TStrVector);
    procedure SetLegendFont(AValue: TFont);
    procedure SetTopAxisTitle(AValue: String);
    procedure SetTopAxisTitleFont(AValue: TFont);
    procedure SetBottomAxisTitle(AValue: String);
    procedure SetBottomAxisTitleFont(AValue: TFont);
    procedure SetLeftAxisTitle(AValue: String);
    procedure SetLeftAxisTitleFont(AValue: TFont);
    procedure SetRightAxisTitle(AValue: String);
    procedure SetRightAxisTitleFont(AValue: TFont);
    procedure SetTopAxisTicksCaptions(AValue: TStrVector);
    procedure SetTopAxisTicksFont(AValue: TFont);
    procedure SetBottomAxisTicksCaptions(AValue: TStrVector);
    procedure SetBottomAxisTicksFont(AValue: TFont);
    procedure SetLeftAxisTicksCaptions(AValue: TStrVector);
    procedure SetLeftAxisTicksFont(AValue: TFont);
    procedure SetRightAxisTicksCaptions(AValue: TStrVector);
    procedure SetRightAxisTicksFont(AValue: TFont);
    procedure SetTopAxisSeries(AValues: TIntMatrix);
    procedure SetBottomAxisSeries(AValues: TIntMatrix);
    procedure SetLeftAxisSeries(AValues: TIntMatrix);
    procedure SetRightAxisSeries(AValues: TIntMatrix);

    //Drawing
    procedure Draw;
    procedure DrawCore;
    procedure DrawTitle;
    procedure DrawLegend;
    procedure DrawTopAxisTitle;
    procedure DrawBottomAxisTitle;
    procedure DrawLeftAxisTitle;
    procedure DrawRightAxisTitle;
    procedure DrawTopAxisTicks;
    procedure DrawBottomAxisTicks;
    procedure DrawLeftAxisTicks;
    procedure DrawRightAxisTicks;
    procedure DrawGridLines;
    procedure DrawDataFrame;


    procedure SetTicks(const ATicksMaxCount: Integer;
                       const ASeries: TIntMatrix;
                       var ATicksCaptions: TSTrVector;
                       var ATicksValues: TIntVector);
    procedure SetSeries(const AValues: TIntMatrix;
                        const ATicksMaxCount: Integer;
                        var ASeries: TIntMatrix;
                        var ATicksCaptions: TSTrVector;
                        var ATicksValues: TIntVector);
    procedure AddSeries(const AValues: TIntVector;
                        const ATicksMaxCount: Integer;
                        var ASeries: TIntMatrix;
                        var ATicksCaptions: TSTrVector;
                        var ATicksValues: TIntVector);

  public
    constructor Create(const AWidth, AHeight: Integer);
    destructor  Destroy; override;
    procedure Calc;
    //PNG
    property  PNG: TPNGDrawer read FPNG;
    //SVG
    //property  SVG: TSVGWriter read FSVG;

    //Series
    procedure TopAxisSeriesAdd(const AValues: TIntVector);
    procedure BottomAxisSeriesAdd(const AValues: TIntVector);
    procedure LeftAxisSeriesAdd(const AValues: TIntVector);
    procedure RightAxisSeriesAdd(const AValues: TIntVector);
    property TopAxisSeries: TIntMatrix read FTopAxisSeries write SetTopAxisSeries;
    property BottomAxisSeries: TIntMatrix read FBottomAxisSeries write SetBottomAxisSeries;
    property LeftAxisSeries: TIntMatrix read FLeftAxisSeries write SetLeftAxisSeries;
    property RightAxisSeries: TIntMatrix read FRightAxisSeries write SetRightAxisSeries;
    //Canvas
    //property Canvas: TCanvas read FCanvas;
    //Core
    property CoreBGColor: TColor read FCoreBGColor write FCoreBGColor;
    property CoreFrameColor: TColor read FCoreFrameColor write FCoreFrameColor;
    property CoreFrameWidth: Integer read FCoreFrameWidth write FCoreFrameWidth;
    //Title
    property Title: String read FTitle write SetTitle;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property TitleBGColor: TColor read FTitleBGColor write FTitleBGColor;
    property TitleFrameColor: TColor read FTitleFrameColor write FTitleFrameColor;
    property TitleFrameWidth: Integer read FTitleFrameWidth write FTitleFrameWidth;
    property TitleVisible: Boolean read GetTitleVisible;
    //Legend
    property Legend: TStrVector read FLegend write SetLegend;
    property LegendFont: TFont read FLegendFont write SetLegendFont;
    property LegendBGColor: TColor read FLegendBGColor write FLegendBGColor;
    property LegendFrameColor: TColor read FLegendFrameColor write FLegendFrameColor;
    property LegendFrameWidth: Integer read FLegendFrameWidth write FLegendFrameWidth;
    property LegendVisible: Boolean read GetLegendVisible;
    property LegendTopMargin: Integer read FLegendTopMargin write FLegendTopMargin;

    //TopAxisTitle
    property TopAxisTitle: String read FTopAxisTitle write SetTopAxisTitle;
    property TopAxisTitleFont: TFont read FTopAxisTitleFont write SetTopAxisTitleFont;
    property TopAxisTitleBGColor: TColor read FTopAxisTitleBGColor write FTopAxisTitleBGColor;
    property TopAxisTitleFrameColor: TColor read FTopAxisTitleFrameColor write FTopAxisTitleFrameColor;
    property TopAxisTitleFrameWidth: Integer read FTopAxisTitleFrameWidth write FTopAxisTitleFrameWidth;
    property TopAxisTitleVisible: Boolean read GetTopAxisTitleVisible;
    //BottomAxisTitle
    property BottomAxisTitle: String read FBottomAxisTitle write SetBottomAxisTitle;
    property BottomAxisTitleFont: TFont read FBottomAxisTitleFont write SetBottomAxisTitleFont;
    property BottomAxisTitleBGColor: TColor read FBottomAxisTitleBGColor write FBottomAxisTitleBGColor;
    property BottomAxisTitleFrameColor: TColor read FBottomAxisTitleFrameColor write FBottomAxisTitleFrameColor;
    property BottomAxisTitleFrameWidth: Integer read FBottomAxisTitleFrameWidth write FBottomAxisTitleFrameWidth;
    property BottomAxisTitleVisible: Boolean read GetBottomAxisTitleVisible;
    //LeftAxisTitle
    property LeftAxisTitle: String read FLeftAxisTitle write SetLeftAxisTitle;
    property LeftAxisTitleFont: TFont read FLeftAxisTitleFont write SetLeftAxisTitleFont;
    property LeftAxisTitleBGColor: TColor read FLeftAxisTitleBGColor write FLeftAxisTitleBGColor;
    property LeftAxisTitleFrameColor: TColor read FLeftAxisTitleFrameColor write FLeftAxisTitleFrameColor;
    property LeftAxisTitleFrameWidth: Integer read FLeftAxisTitleFrameWidth write FLeftAxisTitleFrameWidth;
    property LeftAxisTitleVisible: Boolean read GetLeftAxisTitleVisible;
    //RightAxisTitle
    property RightAxisTitle: String read FRightAxisTitle write SetRightAxisTitle;
    property RightAxisTitleFont: TFont read FRightAxisTitleFont write SetRightAxisTitleFont;
    property RightAxisTitleBGColor: TColor read FRightAxisTitleBGColor write FRightAxisTitleBGColor;
    property RightAxisTitleFrameColor: TColor read FRightAxisTitleFrameColor write FRightAxisTitleFrameColor;
    property RightAxisTitleFrameWidth: Integer read FRightAxisTitleFrameWidth write FRightAxisTitleFrameWidth;
    property RightAxisTitleVisible: Boolean read GetRightAxisTitleVisible;

    //TopAxisTicks
    property TopAxisTicksCaptions: TStrVector read FTopAxisTicksCaptions write SetTopAxisTicksCaptions;
    property TopAxisTicksPosition: TTicksCaptionPosition read FTopAxisTicksPosition write FTopAxisTicksPosition;
    property TopAxisTicksOrientation: TTicksCaptionOrientation read FTopAxisTicksOrientation write FTopAxisTicksOrientation;
    property TopAxisTicksFont: TFont read FTopAxisTicksFont write SetTopAxisTicksFont;
    property TopAxisTicksBGColor: TColor read FTopAxisTicksBGColor write FTopAxisTicksBGColor;
    property TopAxisTicksFrameColor: TColor read FTopAxisTicksFrameColor write FTopAxisTicksFrameColor;
    property TopAxisTicksFrameWidth: Integer read FTopAxisTicksFrameWidth write FTopAxisTicksFrameWidth;
    property TopAxisTicksVisible: Boolean read GetTopAxisTicksVisible write FTopAxisTicksVisible;
    property TopAxisTicksWrapWords: Boolean read FTopAxisTicksWrapWords write FTopAxisTicksWrapWords;
    property TopAxisTicksMaxCount: Integer read FTopAxisTicksMaxCount write FTopAxisTicksMaxCount;
    property TopAxisTicksCaptionsRects: TRectVector read FTopAxisTicksCaptionsRects;
    property TopAxisTicksValues: TIntVector read FTopAxisTicksValues;
    //BottomAxisTicks
    property BottomAxisTicksCaptions: TStrVector read FBottomAxisTicksCaptions write SetBottomAxisTicksCaptions;
    property BottomAxisTicksPosition: TTicksCaptionPosition read FBottomAxisTicksPosition write FBottomAxisTicksPosition;
    property BottomAxisTicksOrientation: TTicksCaptionOrientation read FBottomAxisTicksOrientation write FBottomAxisTicksOrientation;
    property BottomAxisTicksFont: TFont read FBottomAxisTicksFont write SetBottomAxisTicksFont;
    property BottomAxisTicksBGColor: TColor read FBottomAxisTicksBGColor write FBottomAxisTicksBGColor;
    property BottomAxisTicksFrameColor: TColor read FBottomAxisTicksFrameColor write FBottomAxisTicksFrameColor;
    property BottomAxisTicksFrameWidth: Integer read FBottomAxisTicksFrameWidth write FBottomAxisTicksFrameWidth;
    property BottomAxisTicksVisible: Boolean read GetBottomAxisTicksVisible write FBottomAxisTicksVisible;
    property BottomAxisTicksWrapWords: Boolean read FBottomAxisTicksWrapWords write FBottomAxisTicksWrapWords;
    property BottomAxisTicksMaxCount: Integer read FBottomAxisTicksMaxCount write FBottomAxisTicksMaxCount;
    property BottomAxisTicksCaptionsRects: TRectVector read FBottomAxisTicksCaptionsRects;
    property BottomAxisTicksValues: TIntVector read FBottomAxisTicksValues;
    //LeftAxisTicks
    property LeftAxisTicksCaptions: TStrVector read FLeftAxisTicksCaptions write SetLeftAxisTicksCaptions;
    property LeftAxisTicksPosition: TTicksCaptionPosition read FLeftAxisTicksPosition write FLeftAxisTicksPosition;
    property LeftAxisTicksOrientation: TTicksCaptionOrientation read FLeftAxisTicksOrientation write FLeftAxisTicksOrientation;
    property LeftAxisTicksFont: TFont read FLeftAxisTicksFont write SetLeftAxisTicksFont;
    property LeftAxisTicksBGColor: TColor read FLeftAxisTicksBGColor write FLeftAxisTicksBGColor;
    property LeftAxisTicksFrameColor: TColor read FLeftAxisTicksFrameColor write FLeftAxisTicksFrameColor;
    property LeftAxisTicksFrameWidth: Integer read FLeftAxisTicksFrameWidth write FLeftAxisTicksFrameWidth;
    property LeftAxisTicksVisible: Boolean read GetLeftAxisTicksVisible write FLeftAxisTicksVisible;
    property LeftAxisTicksWrapWords: Boolean read FLeftAxisTicksWrapWords write FLeftAxisTicksWrapWords;
    property LeftAxisTicksMaxCount: Integer read FLeftAxisTicksMaxCount write FLeftAxisTicksMaxCount;
    property LeftAxisTicksCaptionsRects: TRectVector read FLeftAxisTicksCaptionsRects;
    property LeftAxisTicksValues: TIntVector read FLeftAxisTicksValues;
    //RightAxisTicks
    property RightAxisTicksCaptions: TStrVector read FRightAxisTicksCaptions write SetRightAxisTicksCaptions;
    property RightAxisTicksPosition: TTicksCaptionPosition read FRightAxisTicksPosition write FRightAxisTicksPosition;
    property RightAxisTicksOrientation: TTicksCaptionOrientation read FRightAxisTicksOrientation write FRightAxisTicksOrientation;
    property RightAxisTicksFont: TFont read FRightAxisTicksFont write SetRightAxisTicksFont;
    property RightAxisTicksBGColor: TColor read FRightAxisTicksBGColor write FRightAxisTicksBGColor;
    property RightAxisTicksFrameColor: TColor read FRightAxisTicksFrameColor write FRightAxisTicksFrameColor;
    property RightAxisTicksFrameWidth: Integer read FRightAxisTicksFrameWidth write FRightAxisTicksFrameWidth;
    property RightAxisTicksVisible: Boolean read GetRightAxisTicksVisible write FRightAxisTicksVisible;
    property RightAxisTicksWrapWords: Boolean read FRightAxisTicksWrapWords write FRightAxisTicksWrapWords;
    property RightAxisTicksMaxCount: Integer read FRightAxisTicksMaxCount write FRightAxisTicksMaxCount;
    property RightAxisTicksCaptionsRects: TRectVector read FRightAxisTicksCaptionsRects;
    property RightAxisTicksValues: TIntVector read FRightAxisTicksValues;
    //TopAxisGridLines
    property TopAxisGridLinesVisible: Boolean read FTopAxisGridLinesVisible write FTopAxisGridLinesVisible;
    property TopAxisGridLinesWidth: Integer read FTopAxisGridLinesWidth write FTopAxisGridLinesWidth;
    property TopAxisGridLinesColor: TColor read FTopAxisGridLinesColor write FTopAxisGridLinesColor;
    property TopAxisGridLinesStyle: TPenStyle read FTopAxisGridLinesStyle write FTopAxisGridLinesStyle;
    property TopAxisGridLinesCoords: TIntVector read FTopAxisGridLinesCoords;
    //BottomAxisGridLines
    property BottomAxisGridLinesVisible: Boolean read FBottomAxisGridLinesVisible write FBottomAxisGridLinesVisible;
    property BottomAxisGridLinesWidth: Integer read FBottomAxisGridLinesWidth write FBottomAxisGridLinesWidth;
    property BottomAxisGridLinesColor: TColor read FBottomAxisGridLinesColor write FBottomAxisGridLinesColor;
    property BottomAxisGridLinesStyle: TPenStyle read FBottomAxisGridLinesStyle write FBottomAxisGridLinesStyle;
    property BottomAxisGridLinesCoords: TIntVector read FBottomAxisGridLinesCoords;
    //LeftAxisGridLines
    property LeftAxisGridLinesVisible: Boolean read FLeftAxisGridLinesVisible write FLeftAxisGridLinesVisible;
    property LeftAxisGridLinesWidth: Integer read FLeftAxisGridLinesWidth write FLeftAxisGridLinesWidth;
    property LeftAxisGridLinesColor: TColor read FLeftAxisGridLinesColor write FLeftAxisGridLinesColor;
    property LeftAxisGridLinesStyle: TPenStyle read FLeftAxisGridLinesStyle write FLeftAxisGridLinesStyle;
    property LeftAxisGridLinesCoords: TIntVector read FLeftAxisGridLinesCoords;
    //RightAxisGridLines
    property RightAxisGridLinesVisible: Boolean read FRightAxisGridLinesVisible write FRightAxisGridLinesVisible;
    property RightAxisGridLinesWidth: Integer read FRightAxisGridLinesWidth write FRightAxisGridLinesWidth;
    property RightAxisGridLinesColor: TColor read FRightAxisGridLinesColor write FRightAxisGridLinesColor;
    property RightAxisGridLinesStyle: TPenStyle read FRightAxisGridLinesStyle write FRightAxisGridLinesStyle;
    property RightAxisGridLinesCoords: TIntVector read FRightAxisGridLinesCoords;
    //Graph
    property GraphColors: TColorVector read  FGraphColors write SetGraphColors;
    property GraphMinMargin: Integer read FGraphMinMargin write FGraphMinMargin;
    property GraphBGColor: TColor read FGraphBGColor write FGraphBGColor;
    property GraphFrameColor: TColor read FGraphFrameColor write FGraphFrameColor;
    property GraphFrameWidth: Integer read FGraphFrameWidth write FGraphFrameWidth;
    property GraphFrameVisible: Boolean read FGraphFrameVisible write FGraphFrameVisible;
    //Data rects
    property DataRectsLeftBottom: TRectVector read GetDataRectsLeftBottom;
    property DataRectsLeftTop: TRectVector read GetDataRectsLeftTop;
    property DataRectsRightBottom: TRectVector read GetDataRectsRightBottom;
    property DataRectsRightTop: TRectVector read GetDataRectsRightTop;
    property DataRectsTopLeft: TRectVector read GetDataRectsTopLeft;
    property DataRectsTopRight: TRectVector read GetDataRectsTopRight;
    property DataRectsBottomLeft: TRectVector read GetDataRectsBottomLeft;
    property DataRectsBottomRight: TRectVector read GetDataRectsBottomRight;

    //Drowing data procedure
    property DrawData: TDrawDataProc read FDrawData write FDrawData;

  end;

  { TStatPlotterBar }

  TStatPlotterBar = class(TObject)
  private
    FPlotter: TStatPlotterCore;

    FBarFrameWidth: Integer;
    FBarMargin: Integer;
    FBarMaxWidthPercent: Byte;
    FBarGradientLightnessIncrement: Byte;
    FBarGradientDemarcationPercent: Byte;



    function GetLegendFont: TFont;
    function GetPNG: TPNGDrawer;
    //function GetSVG: TSVGWriter;
    function GetTitleFont: TFont;
    procedure SetDataFrameColor(AValue: TColor);
    procedure SetDataFrameWidth(AValue: Integer);

    procedure SetXAxisType(AValue: THorizAxisType);
    procedure SetYAxisType(AValue: TVertAxisType);

    procedure SetVertGridLinesVisible(AValue: Boolean);
    procedure SetHorizGridLinesVisible(AValue: Boolean);

    procedure SetFrameColor(AValue: TColor);
    procedure SetFrameWidth(AValue: Integer);

    procedure SetLegend(AValue: TStrVector);
    procedure SetLegendFont(AValue: TFont);

    procedure SetTitle(AValue: String);
    procedure SetTitleFont(AValue: TFont);


    procedure DrawDataProc; virtual; abstract;
  public
    constructor Create(const AWidth, AHeight: Integer);
    destructor  Destroy; override;

    property PNG: TPNGDrawer read GetPNG;
    //property SVG: TSVGWriter read GetSVG;

    procedure Calc;
    procedure Draw(const ACanvas: TCanvas; const X: Integer = 0; const Y: Integer = 0);

    property BarFrameWidth: Integer read FBarFrameWidth write FBarFrameWidth;
    property BarMargin: Integer read FBarMargin write FBarMargin;
    property BarMaxWidthPercent: Byte read FBarMaxWidthPercent write FBarMaxWidthPercent;
    property BarGradientLightnessIncrement: Byte read FBarGradientLightnessIncrement write FBarGradientLightnessIncrement;
    property BarGradientDemarcationPercent: Byte read FBarGradientDemarcationPercent write FBarGradientDemarcationPercent;

    property FrameColor: TColor write SetFrameColor;
    property FrameWidth: Integer write SetFrameWidth;

    property DataFrameColor: TColor write SetDataFrameColor;
    property DataFrameWidth: Integer write SetDataFrameWidth;

    property Title: String write SetTitle;
    property TitleFont: TFont read GetTitleFont write SetTitleFont;

    property Legend: TStrVector write SetLegend;
    property LegendFont: TFont read GetLegendFont write SetLegendFont;

    property HorizGridLinesVisible: Boolean write SetHorizGridLinesVisible;
    property VertGridLinesVisible: Boolean write SetVertGridLinesVisible;

    property YAxisType: TVertAxisType write SetYAxisType;
    property XAxisType: THorizAxisType write SetXAxisType;
  end;

  { TStatPlotterVertHist }

  TStatPlotterVertHist = class(TStatPlotterBar)
  private
    procedure DrawDataProc; override;
    procedure SetXTicks(AValues: TStrVector);
    procedure SetYSeries(AValues: TIntMatrix);
  public
    constructor Create(const AWidth, AHeight: Integer);
    procedure YSeriesAdd(const AValues: TIntVector);
    property YSeries: TIntMatrix write SetYSeries;
    property XTicks: TStrVector write SetXTicks;
  end;

  { TStatPlotterHorizHist }

  TStatPlotterHorizHist = class(TStatPlotterBar)
  private
    procedure DrawDataProc; override;
    procedure SetXSeries(AValues: TIntMatrix);
    procedure SetYTicks(AValues: TStrVector);
  public
    constructor Create(const AWidth, AHeight: Integer);
    procedure XSeriesAdd(const AValues: TIntVector);
    property XSeries: TIntMatrix write SetXSeries;
    property YTicks: TStrVector write SetYTicks;
  end;


  //AxisTicksScale - масштабирование меток оси
  //Input:
  //  AMinValue - наименьшее значение данных по оси
  //  AMaxValue - наибольшее значение данных по оси
  //  AMaxTicksCount - наибольшее количество меток оси
  //Output:
  //  AMinTick - наименьшее значение метки оси
  //  AMaxTick - наибольшее значение метки оси
  //  AStep - шаг изменения меток оси
  procedure AxisTicksScale(const AMinValue, AMaxValue: Double;
                           out AMinTick, AMaxTick, AStep: Double;
                           const AMaxTicksCount: Integer = 10);
  //AxisTicks - вектор меток оси
  //Input:
  //  AMinValue - наименьшее значение данных по оси
  //  AMaxValue - наибольшее значение данных по оси
  //  AMaxTicksCount - наибольшее количество меток оси
  function AxisTicks(const AMinValue, AMaxValue: Double;
                     const AMaxTicksCount: Integer = 10): TDblVector;
  function AxisTicksInt(const AMinValue, AMaxValue: Integer;
                        const AMaxTicksCount: Integer = 10): TIntVector;





  function ApproxTextHeight(const AText: String; const AFont: TFont;
                            const AMaxWidth: Integer): Integer;



implementation


procedure AxisTicksScale(const AMinValue, AMaxValue: Double; out AMinTick,
  AMaxTick, AStep: Double; const AMaxTicksCount: Integer);
var
  Range: Double;

  function NiceNum(const ARange: Double; ARound: Boolean): Double;
  var
    Exponent: Integer;
    Fraction, NiceFraction: Double;
  begin
    Exponent:= Floor(Log10(ARange));
    Fraction:= ARange/IntPower(10, Exponent);
    NiceFraction:= 10;
    if ARound then
    begin
      if Fraction<1.5    then NiceFraction:= 1
      else if Fraction<3 then NiceFraction:= 2
      else if Fraction<7 then NiceFraction:= 5;
    end
    else begin
      if Fraction<=1      then NiceFraction:= 1
      else if Fraction<=2 then NiceFraction:= 2
      else if Fraction<=5 then NiceFraction:= 5;
    end;
    Result:= NiceFraction*IntPower(10, Exponent);
  end;

begin
  Range:= NiceNum(AMaxValue - AMinValue, False);
  AStep:= NiceNum(Range/(AMaxTicksCount - 1), True);
  AMinTick:= Floor(AMinValue/AStep)*AStep;
  AMaxTick:= Ceil(AMaxValue/AStep)*AStep;
end;

function AxisTicks(const AMinValue, AMaxValue: Double;
                   const AMaxTicksCount: Integer): TDblVector;
var
  MinTick, MaxTick, Step, TickValue: Double;
begin
  Result:= nil;
  AxisTicksScale(AMinValue, AMaxValue, MinTick, MaxTick, Step, AMaxTicksCount);
  TickValue:= MinTick;
  while TickValue<(MaxTick+Step) do
  begin
    VAppend(Result, TickValue);
    TickValue:= TickValue + Step;
  end;
end;

function AxisTicksInt(const AMinValue, AMaxValue: Integer;
  const AMaxTicksCount: Integer): TIntVector;
var
  V: TDblVector;
  i: Integer;
begin
  Result:= nil;
  V:= AxisTicks(AMinValue, AMaxValue, AMaxTicksCount);
  VDim(Result, Length(V));
  for i:= 0 to High(V) do
    Result[i]:= Round(V[i]);
  Result:= VUnique(Result);
end;

function ApproxTextHeight(const AText: String; const AFont: TFont;
  const AMaxWidth: Integer): Integer;
var
  N: Integer;
begin
  Result:= 0;
  if SEmpty(AText) then Exit;
  N:= Ceil(SWidth(AText, AFont)/AMaxWidth);
  Result:= N*SHeight(AFont);
end;

{ TStatPlotterHorizHist }

procedure TStatPlotterHorizHist.DrawDataProc;
var
  Rects: TRectVector;
  M: TIntMatrix;
begin
  M:= MTranspose(FPlotter.BottomAxisSeries);
  Rects:= FPlotter.DataRectsBottomLeft;
  FPlotter.PNG.BarsHoriz(Rects, FPlotter.GraphColors, FPlotter.GraphColors,
               BarFrameWidth, BarMargin, BarGradientLightnessIncrement,
               BarGradientDemarcationPercent, BarMaxWidthPercent,
               FPlotter.BottomAxisGridLinesCoords, FPlotter.BottomAxisTicksValues, M);
  //FPlotter.SVG.BarsHoriz(Rects, FPlotter.GraphColors, FPlotter.GraphColors,
  //             BarFrameWidth, BarMargin, BarGradientLightnessIncrement,
  //             BarGradientDemarcationPercent, BarMaxWidthPercent,
  //             FPlotter.BottomAxisGridLinesCoords, FPlotter.BottomAxisTicksValues, M);
end;

procedure TStatPlotterHorizHist.SetYTicks(AValues: TStrVector);
begin
  FPlotter.LeftAxisTicksCaptions:= AValues;
  FPlotter.RightAxisTicksCaptions:= AValues;
end;

constructor TStatPlotterHorizHist.Create(const AWidth, AHeight: Integer);
begin
  inherited Create(AWidth, AHeight);

  FPlotter.LeftAxisTicksPosition:= tcpBetween;
  FPlotter.RightAxisTicksPosition:= tcpBetween;

  FPlotter.TopAxisTicksPosition:= tcpTicks;
  FPlotter.BottomAxisTicksPosition:= tcpTicks;

  FPlotter.LeftAxisTicksOrientation:= tcoHorizontal;
  FPlotter.RightAxisTicksOrientation:= tcoHorizontal;
end;

procedure TStatPlotterHorizHist.XSeriesAdd(const AValues: TIntVector);
begin
  FPlotter.BottomAxisSeriesAdd(AValues);
  FPlotter.TopAxisSeriesAdd(AValues);
end;

procedure TStatPlotterHorizHist.SetXSeries(AValues: TIntMatrix);
begin
  FPlotter.BottomAxisSeries:= AValues;
  FPlotter.TopAxisSeries:= AValues;
end;

{ TStatPlotterBar }

procedure TStatPlotterBar.SetFrameColor(AValue: TColor);
begin
  FPlotter.CoreFrameColor:= AValue;
end;

function TStatPlotterBar.GetTitleFont: TFont;
begin
  Result:= FPlotter.TitleFont;
end;

procedure TStatPlotterBar.SetDataFrameColor(AValue: TColor);
begin
  FPlotter.GraphFrameColor:= AValue;
end;

procedure TStatPlotterBar.SetDataFrameWidth(AValue: Integer);
begin
  FPlotter.GraphFrameWidth:= AValue;
end;

procedure TStatPlotterBar.SetVertGridLinesVisible(AValue: Boolean);
begin
  FPlotter.LeftAxisGridLinesVisible:= AValue;
end;

procedure TStatPlotterBar.SetXAxisType(AValue: THorizAxisType);
begin
  FPlotter.TopAxisTicksVisible:= True;
  FPlotter.BottomAxisTicksVisible:= True;
  if AValue=hatTop then
    FPlotter.BottomAxisTicksVisible:= False
  else if AValue=hatBottom then
    FPlotter.TopAxisTicksVisible:= False;
end;

function TStatPlotterBar.GetLegendFont: TFont;
begin
  Result:= FPlotter.LegendFont;
end;

function TStatPlotterBar.GetPNG: TPNGDrawer;
begin
  Result:= FPlotter.PNG;
end;

//function TStatPlotterBar.GetSVG: TSVGWriter;
//begin
//  Result:= FPlotter.SVG;
//end;

procedure TStatPlotterBar.SetFrameWidth(AValue: Integer);
begin
  FPlotter.CoreFrameWidth:= AValue;
end;

procedure TStatPlotterBar.SetLegend(AValue: TStrVector);
begin
  FPlotter.Legend:= AValue;
end;

procedure TStatPlotterBar.SetLegendFont(AValue: TFont);
begin
  FPlotter.LegendFont.Assign(AValue);
end;

procedure TStatPlotterBar.SetTitle(AValue: String);
begin
  FPlotter.Title:= AValue;
end;

procedure TStatPlotterBar.SetTitleFont(AValue: TFont);
begin
  FPlotter.TitleFont.Assign(AValue);
end;

procedure TStatPlotterBar.SetYAxisType(AValue: TVertAxisType);
begin
  FPlotter.LeftAxisTicksVisible:= True;
  FPlotter.RightAxisTicksVisible:= True;
  if AValue=vatLeft then
    FPlotter.RightAxisTicksVisible:= False
  else if AValue=vatRight then
    FPlotter.LeftAxisTicksVisible:= False;
end;

procedure TStatPlotterBar.SetHorizGridLinesVisible(AValue: Boolean);
begin
  FPlotter.LeftAxisGridLinesVisible:= AValue;
end;



constructor TStatPlotterBar.Create(const AWidth, AHeight: Integer);
begin
  FPlotter:= TStatPlotterCore.Create(AWidth, AHeight);
  FPlotter.DrawData:= @DrawDataProc;

  YAxisType:= vatLeft;
  XAxisType:= hatBottom;

  FPlotter.GraphFrameColor:= clBlack;
  FPlotter.GraphFrameWidth:= 1;

  FBarFrameWidth:= BAR_FRAME_WIDTH_DEFAULT;
  FBarMargin:= BAR_MARGIN_DEFAULT;
  FBarMaxWidthPercent:= BAR_MAX_WIDTH_PERCENT_DEFAULT;
  FBarGradientLightnessIncrement:= GRADIENT_LIGHTNESS_INCREMENT_DEFAULT;
  FBarGradientDemarcationPercent:= GRADIENT_DEMARCATION_PERCENT_DEFAULT;
end;

destructor TStatPlotterBar.Destroy;
begin
  FreeAndNil(FPlotter);
  inherited Destroy;
end;

procedure TStatPlotterBar.Calc;
begin
  FPlotter.Calc;
end;

procedure TStatPlotterBar.Draw(const ACanvas: TCanvas; const X: Integer;
  const Y: Integer);
begin
  FPlotter.PNG.Draw(ACanvas, X, Y);
end;




{ TStatPlotterCore }

procedure TStatPlotterCore.Prepare;
begin
  PrepareCore;
  PrepareTitle;
  PrepareLegend;
  PrepareAxisTitles;
  PrepareAxisTicks;
  PrepareGridLines;
  PrepareGraph;
end;

function TStatPlotterCore.GetDataRectsHoriz(
                    const AAxisGridLinesCoords: TIntVector;
                    const AAxisTicksCaptionsRects: TRectVector): TRectVector;
var
  i, L, R: Integer;
begin
  Result:= nil;
  if Length(AAxisTicksCaptionsRects)=0 then Exit;

  VDimRectVector(Result, Length(AAxisTicksCaptionsRects));
  L:= VFirst(AAxisGridLinesCoords);
  R:= VLast(AAxisGridLinesCoords);
  for i:= 0 to High(AAxisTicksCaptionsRects) do
  begin
    Result[i].Top:= AAxisTicksCaptionsRects[i].Top;
    Result[i].Bottom:= AAxisTicksCaptionsRects[i].Bottom;
    Result[i].Left:= L;
    Result[i].Right:= R;
  end;
end;

function TStatPlotterCore.GetDataRectsBottomLeft: TRectVector;
begin
  Result:= GetDataRectsHoriz(BottomAxisGridLinesCoords, LeftAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsBottomRight: TRectVector;
begin
  Result:= GetDataRectsHoriz(BottomAxisGridLinesCoords, RightAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsTopLeft: TRectVector;
begin
  Result:= GetDataRectsHoriz(TopAxisGridLinesCoords, LeftAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsTopRight: TRectVector;
begin
  Result:= GetDataRectsHoriz(TopAxisGridLinesCoords, RightAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsVert(
                      const AAxisGridLinesCoords: TIntVector;
                      const AAxisTicksCaptionsRects: TRectVector): TRectVector;
var
  i, B, T: Integer;
begin
  Result:= nil;
  if Length(AAxisTicksCaptionsRects)=0 then Exit;

  VDimRectVector(Result, Length(AAxisTicksCaptionsRects));
  B:= VFirst(AAxisGridLinesCoords);
  T:= VLast(AAxisGridLinesCoords);
  for i:= 0 to High(AAxisTicksCaptionsRects) do
  begin
    Result[i].Top:= T;
    Result[i].Bottom:= B;
    Result[i].Left:= AAxisTicksCaptionsRects[i].Left;
    Result[i].Right:= AAxisTicksCaptionsRects[i].Right;
  end;
end;

function TStatPlotterCore.GetDataRectsLeftBottom: TRectVector;
begin
  Result:= GetDataRectsVert(LeftAxisGridLinesCoords, BottomAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsLeftTop: TRectVector;
begin
  Result:= GetDataRectsVert(LeftAxisGridLinesCoords, TopAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsRightBottom: TRectVector;
begin
  Result:= GetDataRectsVert(RightAxisGridLinesCoords, BottomAxisTicksCaptionsRects);
end;

function TStatPlotterCore.GetDataRectsRightTop: TRectVector;
begin
  Result:= GetDataRectsVert(RightAxisGridLinesCoords, TopAxisTicksCaptionsRects);
end;

procedure TStatPlotterCore.PrepareCore;
begin
  //FCoreRect:= Rect(0, 0, FCanvas.Width, FCanvas.Height);
  FCoreRect:= RectDeflate(FRect, CORE_MARGIN_DEFAULT + CoreFrameWidth);
end;

procedure TStatPlotterCore.PrepareTitle;
var
  ClientHeight: Integer;
begin
  FTitleRect:= FCoreRect;
  FTitleRect.Bottom:= FTitleRect.Top;
  if not TitleVisible then Exit;

  FTitleRect:= RectDeflate(FTitleRect, MARGIN_DEFAULT + TitleFrameWidth);
  TextToWidth(FTitle, FTitleFont, FTitleRect.Width, ClientHeight, FTitleRowValues, True{DELETE!!!});
  FTitleRect.Bottom:= FTitleRect.Top + ClientHeight;
end;

procedure TStatPlotterCore.PrepareLegend;
var
  ClientHeight, RowHeight: Integer;
  MarkWidth, MarkHeight: Integer;
  MaxLegendWidth, LegendCountInRow: Integer;
  RowValues: TStrVector;

  function IsOneRow: Boolean;
  var
    i, X: Integer;
  begin
    X:= MARK_SHORT_MARGIN_DEFAULT;
    for i:= 0 to High(FLegend) do
      X:= X + MarkWidth + MARK_WIDE_MARGIN_DEFAULT +
          SWidth(FLegend[i], FLegendFont) + LEGEND_HORIZ_MARGIN_DEFAULT;
    Result:= X < FLegendRect.Width;
  end;

  function CalcMaxLegendWidth: Integer;
  var
    i, X: Integer;
  begin
    Result:= 0;
    for i:= 0 to High(FLegend) do
    begin
      X:= MARK_SHORT_MARGIN_DEFAULT + MarkWidth + MARK_WIDE_MARGIN_DEFAULT +
          SWidth(FLegend[i], FLegendFont) + LEGEND_HORIZ_MARGIN_DEFAULT;
      if X>Result then
        Result:= X;
    end;
  end;

  procedure PrepareLegendHorizontal;
  var
    i: Integer;
  begin
    for i:= 0 to High(FLegend) do
    begin
      RowValues:= nil;
      VAppend(RowValues, FLegend[i]);
      FLegendValues[i]:= VCut(RowValues);
    end;
    ClientHeight:= RowHeight + MARK_SHORT_MARGIN_DEFAULT;
    FLegendRect.Top:= FLegendRect.Bottom - ClientHeight;

    FLegendMarkRects[0]:= RectDeflate(FLegendRect, MARK_SHORT_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT);
    FLegendMarkRects[0].Right:= FLegendMarkRects[0].Left + MarkWidth;
    FLegendMarkRects[0].Bottom:= FLegendMarkRects[0].Top + MarkHeight;

    FLegendTextRects[0]:= FLegendRect;
    FLegendTextRects[0].Left:= FLegendMarkRects[0].Right + MARK_WIDE_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT;
    FLegendTextRects[0].Right:= FLegendTextRects[0].Left + SWidth(FLegend[i], FLegendFont);
    for i:= 1 to High(FLegend) do
    begin
      FLegendMarkRects[i]:= FLegendMarkRects[i-1];
      FLegendMarkRects[i].Left:= FLegendTextRects[i-1].Right + LEGEND_HORIZ_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT;
      FLegendMarkRects[i].Right:= FLegendMarkRects[i].Left + MarkWidth;

      FLegendTextRects[i]:= FLegendTextRects[i-1];
      FLegendTextRects[i].Left:= FLegendMarkRects[i].Right + MARK_WIDE_MARGIN_DEFAULT + + MARK_FRAME_WIDTH_DEFAULT;
      FLegendTextRects[i].Right:= FLegendTextRects[i].Left + SWidth(FLegend[i], FLegendFont);
    end;
  end;

  procedure PrepareLegendVertical;
  var
    i, W, H: Integer;
    ItemHeights: TIntVector;
  begin
    ItemHeights:= nil;
    VDim(ItemHeights, Length(FLegend));
    W:= FLegendRect.Width - (MARK_SHORT_MARGIN_DEFAULT + MarkWidth + MARK_WIDE_MARGIN_DEFAULT);
    for i:=0 to High(FLegend) do
    begin
      RowValues:= nil;
      TextToWidth(FLegend[i], FLegendFont, W, H, RowValues);
      FLegendValues[i]:= VCut(RowValues);
      if i<High(FLegend) then
        ItemHeights[i]:= H + LEGEND_VERT_MARGIN_DEFAULT
      else
        ItemHeights[i]:= H + MARK_SHORT_MARGIN_DEFAULT;
    end;
    ClientHeight:= VSum(ItemHeights);
    FLegendRect.Top:= FLegendRect.Bottom - ClientHeight;

    FLegendMarkRects[0]:= RectDeflate(FLegendRect, MARK_SHORT_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT);
    FLegendMarkRects[0].Right:= FLegendMarkRects[0].Left + MarkWidth;
    FLegendMarkRects[0].Bottom:= FLegendMarkRects[0].Top + MarkHeight;

    FLegendTextRects[0]:= FLegendRect;
    FLegendTextRects[0].Left:= FLegendMarkRects[0].Right + MARK_WIDE_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT;
    FLegendTextRects[0].Bottom:= FLegendTextRects[0].Top + ItemHeights[0] - LEGEND_VERT_MARGIN_DEFAULT;
    for i:= 1 to High(Legend) do
    begin
      FLegendMarkRects[i]:= FLegendMarkRects[i-1];
      FLegendMarkRects[i].Top:= FLegendTextRects[i-1].Top + ItemHeights[i-1] + MARK_SHORT_MARGIN_DEFAULT;
      FLegendMarkRects[i].Bottom:= FLegendMarkRects[i].Top + MarkHeight;

      FLegendTextRects[i]:= FLegendTextRects[i-1];
      FLegendTextRects[i].Top:= FLegendTextRects[i].Top + ItemHeights[i-1];
      FLegendTextRects[i].Bottom:= FLegendTextRects[i-1].Bottom + ItemHeights[i];
    end;
  end;

  procedure PrepareLegendColumns;
  var
    i, j, k, RowsCount: Integer;
  begin
    for i:= 0 to High(FLegend) do
    begin
      RowValues:= nil;
      VAppend(RowValues, FLegend[i]);
      FLegendValues[i]:= VCut(RowValues);
    end;

    RowsCount:= Ceil(Length(FLegend)/LegendCountInRow);
    ClientHeight:= RowsCount*RowHeight + MARK_SHORT_MARGIN_DEFAULT +
                   (RowsCount-1)*LEGEND_VERT_MARGIN_DEFAULT;
    FLegendRect.Top:= FLegendRect.Bottom - ClientHeight;

    k:= 0;
    for j:= 0 to LegendCountInRow-1 do
    begin
      for i:= 0 to RowsCount-1 do
      begin
        if k>High(FLegend) then break;

        FLegendMarkRects[k].Left:=
          FLegendRect.Left + MARK_SHORT_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT +
          j*MaxLegendWidth;
        FLegendMarkRects[k].Top:=
          FLegendRect.Top + MARK_SHORT_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT +
          i*(RowHeight + LEGEND_VERT_MARGIN_DEFAULT);
        FLegendMarkRects[k].Right:= FLegendMarkRects[k].Left + MarkWidth;
        FLegendMarkRects[k].Bottom:= FLegendMarkRects[k].Top + MarkHeight;

        FLegendTextRects[k].Left:=
          FLegendMarkRects[k].Right + MARK_WIDE_MARGIN_DEFAULT + MARK_FRAME_WIDTH_DEFAULT;
        FLegendTextRects[k].Right:= FLegendTextRects[k].Left + MaxLegendWidth -
          (MARK_SHORT_MARGIN_DEFAULT + MarkWidth + MARK_WIDE_MARGIN_DEFAULT + LEGEND_HORIZ_MARGIN_DEFAULT) ;
        FLegendTextRects[k].Top:=
          FLegendRect.Top + i*(RowHeight + LEGEND_VERT_MARGIN_DEFAULT);
        FLegendTextRects[k].Bottom:=
          FLegendTextRects[k].Top + RowHeight;
        k:= k + 1;
      end;
      if k>High(FLegend) then break;
    end;
  end;

begin
  FLegendValues:= nil;
  FLegendMarkRects:= nil;
  FLegendTextRects:= nil;

  FLegendRect:= FCoreRect;
  FLegendRect.Top:= FLegendRect.Bottom;
  if not LegendVisible then Exit;

  MDim(FLegendValues, Length(FLegend));
  VDimRectVector(FLegendMarkRects, Length(FLegend));
  VDimRectVector(FLegendTextRects, Length(FLegend));

  FLegendRect:= RectDeflate(FLegendRect, MARGIN_DEFAULT + LegendFrameWidth);

  RowHeight:= SHeight(FLegendFont);
  MarkHeight:= RowHeight - 2*MARK_SHORT_MARGIN_DEFAULT;
  MarkWidth:= 2*MarkHeight;

  if IsOneRow then
    PrepareLegendHorizontal
  else begin
    MaxLegendWidth:= CalcMaxLegendWidth;
    LegendCountInRow:= FLegendRect.Width div MaxLegendWidth;
    if LegendCountInRow>1 then
      PrepareLegendColumns
    else
      PrepareLegendVertical;
  end;
end;

procedure TStatPlotterCore.PrepareAxisTitles;
var
  R: TRect;
  LeftWidth, RightWidth, LeftWidthNew, RightWidthNew: Integer;
  TopHeight, BottomHeight, TopHeightNew, BottomHeightNew: Integer;
  H1, H2, H, DeltaH: Integer;
  W1, W2, W, DeltaW: Integer;
begin
  R:= FCoreRect;
  R.Top:= FTitleRect.Bottom + TitleFrameWidth*Ord(TitleVisible);
  R.Bottom:= FLegendRect.Top - (LegendFrameWidth+LegendTopMargin)*Ord(LegendVisible);

  TopHeight:= 0;
  BottomHeight:= 0;
  LeftWidth:= 0;
  RightWidth:= 0;
  TopHeightNew:= ApproxTextHeight(FTopAxisTitle, FTopAxisTitleFont, R.Width);
  BottomHeightNew:= ApproxTextHeight(FBottomAxisTitle, FBottomAxisTitleFont, R.Width);
  LeftWidthNew:= ApproxTextHeight(FLeftAxisTitle, FLeftAxisTitleFont, R.Height);
  RightWidthNew:= ApproxTextHeight(FRightAxisTitle, FRightAxisTitleFont, R.Height);

  DeltaW:= 0;
  if TopAxisTitleVisible then
    DeltaW:= DeltaW + Round(1.5*SWidth('X', TopAxisTitleFont));
  if BottomAxisTitleVisible then
    DeltaW:= DeltaW + Round(1.5*SWidth('X', BottomAxisTitleFont));

  DeltaH:= 0;
  if LeftAxisTitleVisible then
    DeltaH:= DeltaH + Round(1.5*SWidth('X', LeftAxisTitleFont));
  if RightAxisTitleVisible then
    DeltaH:= DeltaH + Round(1.5*SWidth('X', RightAxisTitleFont));

  while (TopHeightNew>TopHeight) or (BottomHeightNew>BottomHeight) or
        (LeftWidthNew>LeftWidth) or (RightWidthNew>RightWidth) do
  begin
    TopHeight:= TopHeightNew;
    BottomHeight:= BottomHeightNew;
    LeftWidth:= LeftWidthNew;
    RightWidth:= RightWidthNew;

    H1:= Ord(TopAxisTitleVisible)*(TopHeight + 2*FTopAxisTitleFrameWidth + MARGIN_DEFAULT);
    H2:= Ord(BottomAxisTitleVisible)*(BottomHeight + 2*FBottomAxisTitleFrameWidth + MARGIN_DEFAULT);
    W1:= Ord(LeftAxisTitleVisible)*(LeftWidth + 2*FLeftAxisTitleFrameWidth + MARGIN_DEFAULT);
    W2:= Ord(RightAxisTitleVisible)*(RightWidth + 2*FRightAxisTitleFrameWidth + MARGIN_DEFAULT);

    W:= R.Width - W1 - W2 - DeltaW;
    H:= R.Height - H1 - H2 - DeltaH;

    if (W<0) or (H<0) then
      raise Exception.Create('Too big text!');

    TextToWidth(FTopAxisTitle, FTopAxisTitleFont, W, TopHeightNew, FTopAxisTitleRowValues);
    TextToWidth(FBottomAxisTitle, FBottomAxisTitleFont, W, BottomHeightNew, FBottomAxisTitleRowValues);
    TextToWidth(FLeftAxisTitle, FLeftAxisTitleFont, H, LeftWidthNew, FLeftAxisTitleRowValues);
    TextToWidth(FRightAxisTitle, FRightAxisTitleFont, H, RightWidthNew, FRightAxisTitleRowValues);
  end;

  FTopAxisTitleRect.Top:= R.Top + (MARGIN_DEFAULT+FTopAxisTitleFrameWidth)*Ord(TopAxisTitleVisible);
  FTopAxisTitleRect.Bottom:= FTopAxisTitleRect.Top + TopHeightNew;
  FBottomAxisTitleRect.Bottom:= R.Bottom - (MARGIN_DEFAULT+FBottomAxisTitleFrameWidth)*Ord(BottomAxisTitleVisible);
  FBottomAxisTitleRect.Top:= FBottomAxisTitleRect.Bottom - BottomHeightNew;
  FLeftAxisTitleRect.Left:= R.Left + (MARGIN_DEFAULT+FLeftAxisTitleFrameWidth)*Ord(LeftAxisTitleVisible);
  FLeftAxisTitleRect.Right:= FLeftAxisTitleRect.Left + LeftWidthNew;
  FRightAxisTitleRect.Right:= R.Right - (MARGIN_DEFAULT+FRightAxisTitleFrameWidth)*Ord(RightAxisTitleVisible);
  FRightAxisTitleRect.Left:= FRightAxisTitleRect.Right - RightWidthNew;

  W:= FLeftAxisTitleRect.Right + FLeftAxisTitleFrameWidth*Ord(LeftAxisTitleVisible);
  FTopAxisTitleRect.Left:= W + (MARGIN_DEFAULT+FTopAxisTitleFrameWidth)*Ord(TopAxisTitleVisible);
  FBottomAxisTitleRect.Left:= W + (MARGIN_DEFAULT+FBottomAxisTitleFrameWidth)*Ord(BottomAxisTitleVisible);

  W:= FRightAxisTitleRect.Left - FRightAxisTitleFrameWidth*Ord(RightAxisTitleVisible);
  FTopAxisTitleRect.Right:= W - (MARGIN_DEFAULT+FTopAxisTitleFrameWidth)*Ord(TopAxisTitleVisible);
  FBottomAxisTitleRect.Right:= W - (MARGIN_DEFAULT+FBottomAxisTitleFrameWidth)*Ord(BottomAxisTitleVisible);

  W:= FTopAxisTitleRect.Bottom + FTopAxisTitleFrameWidth*Ord(TopAxisTitleVisible);
  FLeftAxisTitleRect.Top:= W + (MARGIN_DEFAULT+FLeftAxisTitleFrameWidth)*Ord(LeftAxisTitleVisible);
  FRightAxisTitleRect.Top:= W + (MARGIN_DEFAULT+FRightAxisTitleFrameWidth)*Ord(RightAxisTitleVisible);

  W:= FBottomAxisTitleRect.Top - FBottomAxisTitleFrameWidth*Ord(BottomAxisTitleVisible);
  FLeftAxisTitleRect.Bottom:= W - (MARGIN_DEFAULT+FLeftAxisTitleFrameWidth)*Ord(LeftAxisTitleVisible);
  FRightAxisTitleRect.Bottom:= W - (MARGIN_DEFAULT+FRightAxisTitleFrameWidth)*Ord(RightAxisTitleVisible);
end;

procedure TStatPlotterCore.PrepareAxisTicks;
var
  R: TRect;
  LeftWidth, RightWidth, LeftWidthNew, RightWidthNew: Integer;
  TopHeight, BottomHeight, TopHeightNew, BottomHeightNew: Integer;

  function CalcDefaultHeight(const AValues: TStrVector; const AFont: TFont;
                             const AOrientation: TTicksCaptionOrientation): Integer;
  var
    H, W, i: Integer;
  begin
    Result:= 0;
    W:= R.Width div Length(AValues);
    W:= W - 2*MARGIN_DEFAULT;
    for i:= 0 to High(AValues) do
    begin
      if AOrientation=tcoHorizontal then
        H:= ApproxTextHeight(AValues[i], AFont, W)
      else
        H:= SWidth(AValues[i], AFont)+ 2*MARGIN_DEFAULT;
      if H>Result then
        Result:= H;
    end;
  end;

  function CalcDefaultWidth(const AValues: TStrVector; const AFont: TFont;
                            const AOrientation: TTicksCaptionOrientation): Integer;
  var
    H, W, i: Integer;
  begin
    Result:= 0;
    H:= R.Height div Length(AValues);
    H:= H - 2*MARGIN_DEFAULT;
    for i:= 0 to High(AValues) do
    begin
      if AOrientation=tcoVertical then
        W:= ApproxTextHeight(AValues[i], AFont, H)
      else
        W:= SWidth(AValues[i], AFont) + 2*MARGIN_DEFAULT;
      if W>Result then
        Result:= W;
    end;
  end;

  procedure CalcDefaultHeightWidth;
  begin
    TopHeight:= 0;
    BottomHeight:= 0;
    LeftWidth:= 0;
    RightWidth:= 0;
    TopHeightNew:= 0;
    BottomHeightNew:= 0;
    LeftWidthNew:= 0;
    RightWidthNew:= 0;
    if TopAxisTicksVisible then
      TopHeightNew:= CalcDefaultHeight(FTopAxisTicksCaptions, FTopAxisTicksFont, FTopAxisTicksOrientation);
    if BottomAxisTicksVisible then
      BottomHeightNew:= CalcDefaultHeight(FBottomAxisTicksCaptions, FBottomAxisTicksFont, FBottomAxisTicksOrientation);
    if LeftAxisTicksVisible then
      LeftWidthNew:= CalcDefaultWidth(FLeftAxisTicksCaptions, FLeftAxisTicksFont, FLeftAxisTicksOrientation);
    if RightAxisTicksVisible then
      RightWidthNew:= CalcDefaultWidth(FRightAxisTicksCaptions, FRightAxisTicksFont, FRightAxisTicksOrientation);
  end;

  function CalcHeight(const AValues: TStrVector; const AFont: TFont;
                      const AOrientation: TTicksCaptionOrientation;
                      const ADefaultHeight, AMaxWidth: Integer;
                      const AWrapWords: Boolean;
                      var ARowValues: TStrMatrix): Integer;
  var
    H, W, i: Integer;
    V: TStrVector;
  begin
    Result:= 0;
    W:= AMaxWidth div Length(AValues);
    W:= W - 2*MARGIN_DEFAULT;
    for i:= 0 to High(AValues) do
    begin
      if AOrientation=tcoHorizontal then
      begin
        TextToWidth(AValues[i], AFont, W, H, V, AWrapWords);
      end
      else begin
        H:= ADefaultHeight;
        V:= VCreateStr([AValues[i]]);
      end;
      MAppend(ARowValues, V);
      if H>Result then Result:= H;
    end;
  end;

  function CalcWidth(const AValues: TStrVector; const AFont: TFont;
                      const AOrientation: TTicksCaptionOrientation;
                      const ADefaultWidth, AMaxHeight: Integer;
                      const AWrapWords: Boolean;
                      var ARowValues: TStrMatrix): Integer;
  var
    H, W, i: Integer;
    V: TStrVector;
  begin
    Result:= 0;
    H:= AMaxHeight div Length(AValues);
    H:= H - 2*MARGIN_DEFAULT;
    for i:= 0 to High(AValues) do
    begin
      if AOrientation=tcoVertical then
      begin
        TextToWidth(AValues[i], AFont, H, W, V, AWrapWords);
      end
      else begin
        W:= ADefaultWidth;
        V:= VCreateStr([AValues[i]]);
      end;
      MAppend(ARowValues, V);
      if W>Result then Result:= W;
    end;
  end;

  procedure CalcHeightWidthAndLoadRowValues;
  var
    H1, H2, H: Integer;
    W1, W2, W: Integer;
  begin
    while (TopHeightNew>TopHeight) or (BottomHeightNew>BottomHeight) or
          (LeftWidthNew>LeftWidth) or (RightWidthNew>RightWidth) do
    begin
      FTopAxisTicksRowValues:= nil;
      FBottomAxisTicksRowValues:= nil;
      FLeftAxisTicksRowValues:= nil;
      FRightAxisTicksRowValues:= nil;

      TopHeight:= TopHeightNew;
      BottomHeight:= BottomHeightNew;
      LeftWidth:= LeftWidthNew;
      RightWidth:= RightWidthNew;

      H1:= Ord(TopAxisTicksVisible)*(TopHeight + 2*FTopAxisTicksFrameWidth + MARGIN_DEFAULT);
      H2:= Ord(BottomAxisTicksVisible)*(BottomHeight + 2*FBottomAxisTicksFrameWidth + MARGIN_DEFAULT);
      W1:= Ord(LeftAxisTicksVisible)*(LeftWidth + 2*FLeftAxisTicksFrameWidth + MARGIN_DEFAULT);
      W2:= Ord(RightAxisTicksVisible)*(RightWidth + 2*FRightAxisTicksFrameWidth + MARGIN_DEFAULT);

      W:= R.Width - W1 - W2;
      H:= R.Height - H1 - H2;

      if (W<0) or (H<0) then
        raise Exception.Create('Too big text!');

      if TopAxisTicksVisible then
       TopHeightNew:= CalcHeight(FTopAxisTicksCaptions, FTopAxisTicksFont,
                                 FTopAxisTicksOrientation, TopHeight, W,
                                 FTopAxisTicksWrapWords, FTopAxisTicksRowValues);
      if BottomAxisTicksVisible then
        BottomHeightNew:= CalcHeight(FBottomAxisTicksCaptions, FBottomAxisTicksFont,
                                 FBottomAxisTicksOrientation, BottomHeight, W,
                                 FBottomAxisTicksWrapWords, FBottomAxisTicksRowValues);
      if LeftAxisTicksVisible then
        LeftWidthNew:= CalcWidth(FLeftAxisTicksCaptions, FLeftAxisTicksFont,
                                 FLeftAxisTicksOrientation, LeftWidth, H,
                                 FLeftAxisTicksWrapWords, FLeftAxisTicksRowValues);
      if RightAxisTicksVisible then
        RightWidthNew:= CalcWidth(FRightAxisTicksCaptions, FRightAxisTicksFont,
                                 FRightAxisTicksOrientation, RightWidth, H,
                                 FRightAxisTicksWrapWords, FRightAxisTicksRowValues);
    end;
  end;

  procedure CalcTicksRects;
  var
    N: Integer;
  begin
    FTopAxisTicksRect.Top:= R.Top;
    N:= FTopAxisTicksRect.Top - FCoreRect.Top;
    if N<GraphMinMargin then
      FTopAxisTicksRect.Top:= FTopAxisTicksRect.Top + GraphMinMargin - N;
    N:= (MARGIN_DEFAULT+FTopAxisTicksFrameWidth)*Ord(TopAxisTicksVisible);
    FTopAxisTicksRect.Top:= FTopAxisTicksRect.Top + N;

    FBottomAxisTicksRect.Bottom:= R.Bottom;
    N:= FCoreRect.Bottom - FBottomAxisTicksRect.Bottom;
    if N<GraphMinMargin then
      FBottomAxisTicksRect.Bottom:= FBottomAxisTicksRect.Bottom - (GraphMinMargin - N);
    N:= (MARGIN_DEFAULT+FBottomAxisTicksFrameWidth)*Ord(BottomAxisTicksVisible);
    FBottomAxisTicksRect.Bottom:= FBottomAxisTicksRect.Bottom - N;

    FLeftAxisTicksRect.Left:= R.Left;
    N:= FLeftAxisTicksRect.Left - FCoreRect.Left;
    if N<GraphMinMargin then
      FLeftAxisTicksRect.Left:= FLeftAxisTicksRect.Left + GraphMinMargin - N;
    N:= (MARGIN_DEFAULT+FLeftAxisTicksFrameWidth)*Ord(LeftAxisTicksVisible);
    FLeftAxisTicksRect.Left:= FLeftAxisTicksRect.Left + N;

    FRightAxisTicksRect.Right:= R.Right;
    N:= FCoreRect.Right - FRightAxisTicksRect.Right;
    if N<GraphMinMargin then
      FRightAxisTicksRect.Right:= FRightAxisTicksRect.Right - (GraphMinMargin - N);
    N:= (MARGIN_DEFAULT+FRightAxisTicksFrameWidth)*Ord(RightAxisTicksVisible);
    FRightAxisTicksRect.Right:= FRightAxisTicksRect.Right - N;

    FTopAxisTicksRect.Bottom:= FTopAxisTicksRect.Top + TopHeightNew;
    FBottomAxisTicksRect.Top:= FBottomAxisTicksRect.Bottom - BottomHeightNew;
    FLeftAxisTicksRect.Right:= FLeftAxisTicksRect.Left + LeftWidthNew;
    FRightAxisTicksRect.Left:= FRightAxisTicksRect.Right - RightWidthNew;

    N:= FLeftAxisTicksRect.Right + FLeftAxisTicksFrameWidth*Ord(LeftAxisTicksVisible);
    FTopAxisTicksRect.Left:= N + (MARGIN_DEFAULT+FTopAxisTicksFrameWidth)*Ord(TopAxisTicksVisible);
    FBottomAxisTicksRect.Left:= N + (MARGIN_DEFAULT+FBottomAxisTicksFrameWidth)*Ord(BottomAxisTicksVisible);

    N:= FRightAxisTicksRect.Left - FRightAxisTicksFrameWidth*Ord(RightAxisTicksVisible);
    FTopAxisTicksRect.Right:= N - (MARGIN_DEFAULT+FTopAxisTicksFrameWidth)*Ord(TopAxisTicksVisible);
    FBottomAxisTicksRect.Right:= N - (MARGIN_DEFAULT+FBottomAxisTicksFrameWidth)*Ord(BottomAxisTicksVisible);

    N:= FTopAxisTicksRect.Bottom + FTopAxisTicksFrameWidth*Ord(TopAxisTicksVisible);
    FLeftAxisTicksRect.Top:= N + (MARGIN_DEFAULT+FLeftAxisTicksFrameWidth)*Ord(LeftAxisTicksVisible);
    FRightAxisTicksRect.Top:= N + (MARGIN_DEFAULT+FRightAxisTicksFrameWidth)*Ord(RightAxisTicksVisible);

    N:= FBottomAxisTicksRect.Top - FBottomAxisTicksFrameWidth*Ord(BottomAxisTicksVisible);
    FLeftAxisTicksRect.Bottom:= N - (MARGIN_DEFAULT+FLeftAxisTicksFrameWidth)*Ord(LeftAxisTicksVisible);
    FRightAxisTicksRect.Bottom:= N - (MARGIN_DEFAULT+FRightAxisTicksFrameWidth)*Ord(RightAxisTicksVisible);
  end;

  procedure CalcHorizontalAxisTicksCaptionsRects(const AValues: TStrVector;
                      const ARect: TRect; var ARects: TRectVector);
  var
    i, N: Integer;
  begin
    N:= ARect.Width div Length(AValues);
    VDimRectVector(ARects, Length(AValues));
    ARects[0]:= ARect;
    ARects[0].Right:= ARects[0].Left + N;
    for i:= 1 to High(AValues) do
    begin
      ARects[i]:= ARects[i-1];
      ARects[i].Left:= ARects[i-1].Left + N;
      ARects[i].Right:= ARects[i-1].Right + N;
    end;
  end;

  procedure CalcVerticalAxisTicksCaptionsRects(const AValues: TStrVector;
                      const ARect: TRect; var ARects: TRectVector);
  var
    i, N: Integer;
  begin
    N:= ARect.Height div Length(AValues);
    VDimRectVector(ARects, Length(AValues));
    ARects[0]:= ARect;
    ARects[0].Top:= ARects[0].Bottom - N;
    for i:= 1 to High(AValues) do
    begin
      ARects[i]:= ARects[i-1];
      ARects[i].Top:= ARects[i-1].Top - N;
      ARects[i].Bottom:= ARects[i-1].Bottom - N;
    end;
  end;

  procedure CalcTicksCaptionsRects;
  begin
    if TopAxisTicksVisible then
      CalcHorizontalAxisTicksCaptionsRects(FTopAxisTicksCaptions, FTopAxisTicksRect, FTopAxisTicksCaptionsRects);
    if BottomAxisTicksVisible then
      CalcHorizontalAxisTicksCaptionsRects(FBottomAxisTicksCaptions, FBottomAxisTicksRect, FBottomAxisTicksCaptionsRects);
    if LeftAxisTicksVisible then
      CalcVerticalAxisTicksCaptionsRects(FLeftAxisTicksCaptions, FLeftAxisTicksRect, FLeftAxisTicksCaptionsRects);
    if RightAxisTicksVisible then
      CalcVerticalAxisTicksCaptionsRects(FRightAxisTicksCaptions, FRightAxisTicksRect, FRightAxisTicksCaptionsRects);
  end;

begin
  R.Top:= FTopAxisTitleRect.Bottom + TopAxisTitleFrameWidth*Ord(TopAxisTitleVisible);
  R.Bottom:= FBottomAxisTitleRect.Top - BottomAxisTitleFrameWidth*Ord(BottomAxisTitleVisible);
  R.Left:= FLeftAxisTitleRect.Right + LeftAxisTitleFrameWidth*Ord(LeftAxisTitleVisible);
  R.Right:= FRightAxisTitleRect.Left - RightAxisTitleFrameWidth*Ord(RightAxisTitleVisible);

  CalcDefaultHeightWidth;
  CalcHeightWidthAndLoadRowValues;
  CalcTicksRects;
  CalcTicksCaptionsRects;
end;

procedure TStatPlotterCore.PrepareGridLines;

  procedure CalcVerticalLinesCoords(var ACoords: TIntVector; const ARects: TRectVector;
                                    const APosition: TTicksCaptionPosition);
  var
    i: Integer;
  begin
    VDim(ACoords, Length(ARects));
    for i:=0 to High(ARects) do
    begin
      ACoords[i]:= ARects[i].Left;
      if APosition=tcpTicks then
        ACoords[i]:= ACoords[i] + (ARects[i].Width div 2);
    end;
  end;

  procedure CalcHorizontalLinesCoords(var ACoords: TIntVector; const ARects: TRectVector;
                                      const APosition: TTicksCaptionPosition);
  var
    i: Integer;
  begin
    VDim(ACoords, Length(ARects));
    for i:=0 to High(ARects) do
    begin
      ACoords[i]:= ARects[i].Bottom;
      if APosition=tcpTicks then
        ACoords[i]:= ACoords[i] - (ARects[i].Height div 2);
    end;
  end;

begin
  CalcVerticalLinesCoords(FTopAxisGridLinesCoords, FTopAxisTicksCaptionsRects,
                          FTopAxisTicksPosition);
  CalcVerticalLinesCoords(FBottomAxisGridLinesCoords, FBottomAxisTicksCaptionsRects,
                          FBottomAxisTicksPosition);
  CalcHorizontalLinesCoords(FLeftAxisGridLinesCoords, FLeftAxisTicksCaptionsRects,
                            FLeftAxisTicksPosition);
  CalcHorizontalLinesCoords(FRightAxisGridLinesCoords, FRightAxisTicksCaptionsRects,
                            FRightAxisTicksPosition);
end;

procedure TStatPlotterCore.PrepareGraph;
begin
  FGraphRect.Left:= FLeftAxisTicksRect.Right + FLeftAxisTicksFrameWidth*Ord(LeftAxisTicksVisible);
  FGraphRect.Right:= FRightAxisTicksRect.Left - FRightAxisTicksFrameWidth*Ord(RightAxisTicksVisible);
  FGraphRect.Top:= FTopAxisTicksRect.Bottom + FTopAxisTicksFrameWidth*Ord(TopAxisTicksVisible);
  FGraphRect.Bottom:= FBottomAxisTicksRect.Top - FBottomAxisTicksFrameWidth*Ord(BottomAxisTicksVisible);

  FGraphRect:= RectDeflate(FGraphRect, (MARGIN_DEFAULT+FGraphFrameWidth)*Ord(GraphFrameVisible));
end;

function TStatPlotterCore.GetTitleVisible: Boolean;
begin
  Result:= not SEmpty(FTitle);
end;

function TStatPlotterCore.GetLegendVisible: Boolean;
begin
  Result:= not VIsNil(FLegend);
end;

function TStatPlotterCore.GetTopAxisTitleVisible: Boolean;
begin
  Result:= not SEmpty(FTopAxisTitle);
end;

function TStatPlotterCore.GetBottomAxisTitleVisible: Boolean;
begin
  Result:= not SEmpty(FBottomAxisTitle);
end;

function TStatPlotterCore.GetLeftAxisTitleVisible: Boolean;
begin
  Result:= not SEmpty(FLeftAxisTitle);
end;

function TStatPlotterCore.GetRightAxisTitleVisible: Boolean;
begin
  Result:= not SEmpty(FRightAxisTitle);
end;

function TStatPlotterCore.GetBottomAxisTicksVisible: Boolean;
begin
  Result:= FBottomAxisTicksVisible and (not VIsNil(FBottomAxisTicksCaptions));
end;

function TStatPlotterCore.GetTopAxisTicksVisible: Boolean;
begin
  Result:= FTopAxisTicksVisible and (not VIsNil(FTopAxisTicksCaptions));
end;

function TStatPlotterCore.GetLeftAxisTicksVisible: Boolean;
begin
  Result:= FLeftAxisTicksVisible and (not VIsNil(FLeftAxisTicksCaptions));
end;

function TStatPlotterCore.GetRightAxisTicksVisible: Boolean;
begin
  Result:= FRightAxisTicksVisible and (not VIsNil(FRightAxisTicksCaptions));
end;



procedure TStatPlotterCore.SetFont(var AFont: TFont; const AValue: TFont);
begin
  if not Assigned(AFont) then
    AFont:= TFont.Create;
  AFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetGraphColors(AValue: TColorVector);
begin
  FGraphColors:= VCut(AValue);
end;



procedure TStatPlotterCore.SetLegend(AValue: TStrVector);
begin
  FLegend:= VCut(AValue);
end;

procedure TStatPlotterCore.SetLegendFont(AValue: TFont);
begin
  FLegendFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetTitle(AValue: String);
begin
  if FTitle=AValue then Exit;
  FTitle:= AValue;
end;

procedure TStatPlotterCore.SetTitleFont(AValue: TFont);
begin
  FTitleFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetTopAxisTitle(AValue: String);
begin
  if FTopAxisTitle=AValue then Exit;
  FTopAxisTitle:= AValue;
end;

procedure TStatPlotterCore.SetTopAxisTitleFont(AValue: TFont);
begin
  FTopAxisTitleFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetBottomAxisTitle(AValue: String);
begin
  if FBottomAxisTitle=AValue then Exit;
  FBottomAxisTitle:= AValue;
end;

procedure TStatPlotterCore.SetBottomAxisTitleFont(AValue: TFont);
begin
  FBottomAxisTitleFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetLeftAxisTitle(AValue: String);
begin
  if FLeftAxisTitle=AValue then Exit;
  FLeftAxisTitle:= AValue;
end;

procedure TStatPlotterCore.SetLeftAxisTitleFont(AValue: TFont);
begin
  FLeftAxisTitleFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetRightAxisTitle(AValue: String);
begin
  if FRightAxisTitle=AValue then Exit;
  FRightAxisTitle:= AValue;
end;

procedure TStatPlotterCore.SetRightAxisTitleFont(AValue: TFont);
begin
  FRightAxisTitleFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetTopAxisTicksCaptions(AValue: TStrVector);
begin
  FTopAxisTicksCaptions:= VCut(AValue);
  FTopAxisTicksValues:= VOrder(Length(FTopAxisTicksCaptions));
  FTopAxisSeries:= nil;
  MAppend(FTopAxisSeries, FTopAxisTicksValues);
end;

procedure TStatPlotterCore.SetTopAxisTicksFont(AValue: TFont);
begin
  FTopAxisTicksFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetBottomAxisTicksCaptions(AValue: TStrVector);
begin
  FBottomAxisTicksCaptions:= VCut(AValue);
  FBottomAxisTicksValues:= VOrder(Length(FBottomAxisTicksCaptions));
  FBottomAxisSeries:= nil;
  MAppend(FBottomAxisSeries, FBottomAxisTicksValues);
end;

procedure TStatPlotterCore.SetBottomAxisTicksFont(AValue: TFont);
begin
  FBottomAxisTicksFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetLeftAxisTicksCaptions(AValue: TStrVector);
begin
  FLeftAxisTicksCaptions:= VCut(AValue);
  FLeftAxisTicksValues:= VOrder(Length(FLeftAxisTicksCaptions));
  FLeftAxisSeries:= nil;
  MAppend(FLeftAxisSeries, FLeftAxisTicksValues);
end;

procedure TStatPlotterCore.SetLeftAxisTicksFont(AValue: TFont);
begin
  FLeftAxisTicksFont.Assign(AValue);
end;

procedure TStatPlotterCore.SetRightAxisTicksCaptions(AValue: TStrVector);
begin
  FRightAxisTicksCaptions:= VCut(AValue);
  FRightAxisTicksValues:= VOrder(Length(FRightAxisTicksCaptions));
  FRightAxisSeries:= nil;
  MAppend(FRightAxisSeries, FRightAxisTicksValues);
end;

procedure TStatPlotterCore.SetRightAxisTicksFont(AValue: TFont);
begin
  FRightAxisTicksFont.Assign(AValue);
end;

procedure TStatPlotterCore.Draw;
begin
  DrawCore;
  DrawTitle;
  DrawLegend;
  DrawTopAxisTitle;
  DrawBottomAxisTitle;
  DrawLeftAxisTitle;
  DrawRightAxisTitle;
  DrawTopAxisTicks;
  DrawBottomAxisTicks;
  DrawLeftAxisTicks;
  DrawRightAxisTicks;
  DrawDataFrame;
  DrawGridLines;
  if Assigned(FDrawData) then FDrawData;
end;

procedure TStatPlotterCore.DrawCore;
begin
  PNG.Rect(FRect, CoreBGColor);
  PNG.Frame(FCoreRect, CoreBGColor, CoreFrameColor, CoreFrameWidth);

  //SVG.Rect(FRect, CoreBGColor);
  //SVG.Frame(FCoreRect, CoreBGColor, CoreFrameColor, CoreFrameWidth);
end;

procedure TStatPlotterCore.DrawTitle;
var
  H: Integer;
begin
  if not TitleVisible then Exit;
  H:= SHeight(TitleFont);

  PNG.Frame(FTitleRect, TitleBGColor, TitleFrameColor, TitleFrameWidth);
  PNG.StringsHoriz(FTitleRect, TitleBGColor, FTitleRowValues, TitleFont, H, taCenter);

  //SVG.Frame(FTitleRect, TitleBGColor, TitleFrameColor, TitleFrameWidth);
  //SVG.StringsHoriz(FTitleRect, TitleBGColor, FTitleRowValues, TitleFont, H, taCenter);
end;

procedure TStatPlotterCore.DrawLegend;
var
  i, N, H: Integer;
  Color: TColor;
begin
  if not LegendVisible then Exit;
  Color:= BG_COLOR_DEFAULT;
  PNG.Frame(FLegendRect, LegendBGColor, LegendFrameColor, LegendFrameWidth);
  //SVG.Frame(FLegendRect, LegendBGColor, LegendFrameColor, LegendFrameWidth);

  H:= SHeight(LegendFont);
  N:= Length(GraphColors);
  for i:= 0 to High(FLegend) do
  begin
    Color:= GraphColors[i mod N];
    PNG.BarHoriz(FLegendMarkRects[i], Color,
                 Color, MARK_FRAME_WIDTH_DEFAULT,
                 GRADIENT_LIGHTNESS_INCREMENT_DEFAULT,
                 GRADIENT_DEMARCATION_PERCENT_DEFAULT);
    PNG.StringsHoriz(FLegendTextRects[i], LegendBGColor,
                     FLegendValues[i], LegendFont, H, taLeftJustify);

    //SVG.BarHoriz(FLegendMarkRects[i], Color,
    //             Color, MARK_FRAME_WIDTH_DEFAULT,
    //             GRADIENT_LIGHTNESS_INCREMENT_DEFAULT,
    //             GRADIENT_DEMARCATION_PERCENT_DEFAULT);
    //SVG.StringsHoriz(FLegendTextRects[i], LegendBGColor,
    //                 FLegendValues[i], LegendFont, H, taLeftJustify);
  end;
end;

procedure TStatPlotterCore.DrawTopAxisTitle;
var
  H: Integer;
begin
  if not TopAxisTitleVisible then Exit;
  H:= SHeight(TopAxisTitleFont);
  PNG.Frame(FTopAxisTitleRect, TopAxisTitleBGColor,
            TopAxisTitleFrameColor, TopAxisTitleFrameWidth);
  PNG.StringsHoriz(FTopAxisTitleRect, TopAxisTitleBGColor,
                   FTopAxisTitleRowValues, TopAxisTitleFont, H, taCenter);

  //SVG.Frame(FTopAxisTitleRect, TopAxisTitleBGColor,
  //          TopAxisTitleFrameColor, TopAxisTitleFrameWidth);
  //SVG.StringsHoriz(FTopAxisTitleRect, TopAxisTitleBGColor,
  //                 FTopAxisTitleRowValues, TopAxisTitleFont, H, taCenter);
end;

procedure TStatPlotterCore.DrawBottomAxisTitle;
var
  H: Integer;
begin
  if not BottomAxisTitleVisible then Exit;
  H:= SHeight(BottomAxisTitleFont);
  PNG.Frame(FBottomAxisTitleRect, BottomAxisTitleBGColor,
            BottomAxisTitleFrameColor, BottomAxisTitleFrameWidth);
  PNG.StringsHoriz(FBottomAxisTitleRect, BottomAxisTitleBGColor,
                   FBottomAxisTitleRowValues, BottomAxisTitleFont, H, taCenter);

  //SVG.Frame(FBottomAxisTitleRect, BottomAxisTitleBGColor,
  //          BottomAxisTitleFrameColor, BottomAxisTitleFrameWidth);
  //SVG.StringsHoriz(FBottomAxisTitleRect, BottomAxisTitleBGColor,
  //                 FBottomAxisTitleRowValues, BottomAxisTitleFont, H, taCenter);
end;

procedure TStatPlotterCore.DrawLeftAxisTitle;
var
  W: Integer;
begin
  if not LeftAxisTitleVisible then Exit;
  W:= SHeight(LeftAxisTitleFont);
  PNG.Frame(FLeftAxisTitleRect, LeftAxisTitleBGColor,
            LeftAxisTitleFrameColor, LeftAxisTitleFrameWidth);
  PNG.StringsVert(FLeftAxisTitleRect, LeftAxisTitleBGColor, FLeftAxisTitleRowValues,
                  LeftAxisTitleFont, W, tlCenter);

  //SVG.Frame(FLeftAxisTitleRect, LeftAxisTitleBGColor,
  //          LeftAxisTitleFrameColor, LeftAxisTitleFrameWidth);
  //SVG.StringsVert(FLeftAxisTitleRect, LeftAxisTitleBGColor, FLeftAxisTitleRowValues,
  //                LeftAxisTitleFont, W, tlCenter);
end;

procedure TStatPlotterCore.DrawRightAxisTitle;
var
  W: Integer;
begin
  if not RightAxisTitleVisible then Exit;
  W:= SHeight(RightAxisTitleFont);
  PNG.Frame(FRightAxisTitleRect, RightAxisTitleBGColor,
            RightAxisTitleFrameColor, RightAxisTitleFrameWidth);
  PNG.StringsVert(FRightAxisTitleRect, RightAxisTitleBGColor, FRightAxisTitleRowValues,
                  RightAxisTitleFont, W, tlCenter);

  //SVG.Frame(FRightAxisTitleRect, RightAxisTitleBGColor,
  //          RightAxisTitleFrameColor, RightAxisTitleFrameWidth);
  //SVG.StringsVert(FRightAxisTitleRect, RightAxisTitleBGColor, FRightAxisTitleRowValues,
  //                RightAxisTitleFont, W, tlCenter);
end;

procedure TStatPlotterCore.DrawTopAxisTicks;
var
  i: Integer;
begin
  if not TopAxisTicksVisible then Exit;

  PNG.Frame(FTopAxisTicksRect, TopAxisTicksBGColor,
            TopAxisTicksFrameColor, TopAxisTicksFrameWidth);
  for i:= 0 to High(FTopAxisTicksCaptions) do
  begin
    if FTopAxisTicksOrientation = tcoVertical then
      PNG.TextVert(FTopAxisTicksCaptionsRects[i], TopAxisTicksBGColor,
                   FTopAxisTicksRowValues[i], TopAxisTicksFont, taCenter, tlCenter)
    else
      PNG.TextHoriz(FTopAxisTicksCaptionsRects[i], TopAxisTicksBGColor,
                    FTopAxisTicksRowValues[i], TopAxisTicksFont, taCenter, tlCenter);
  end;

  //SVG.Frame(FTopAxisTicksRect, TopAxisTicksBGColor,
  //          TopAxisTicksFrameColor, TopAxisTicksFrameWidth);
  //for i:= 0 to High(FTopAxisTicksCaptions) do
  //begin
  //  if FTopAxisTicksOrientation = tcoVertical then
  //    SVG.TextVert(FTopAxisTicksCaptionsRects[i], TopAxisTicksBGColor,
  //                 FTopAxisTicksRowValues[i], TopAxisTicksFont, taCenter, tlCenter)
  //  else
  //    SVG.TextHoriz(FTopAxisTicksCaptionsRects[i], TopAxisTicksBGColor,
  //                  FTopAxisTicksRowValues[i], TopAxisTicksFont, taCenter, tlCenter);
  //end;
end;

procedure TStatPlotterCore.DrawBottomAxisTicks;
var
  i: Integer;
begin
  if not BottomAxisTicksVisible then Exit;

  PNG.Frame(FBottomAxisTicksRect, BottomAxisTicksBGColor,
            BottomAxisTicksFrameColor, BottomAxisTicksFrameWidth);
  for i:= 0 to High(FBottomAxisTicksCaptions) do
  begin
    if FBottomAxisTicksOrientation = tcoVertical then
      PNG.TextVert(FBottomAxisTicksCaptionsRects[i], BottomAxisTicksBGColor,
                   FBottomAxisTicksRowValues[i], BottomAxisTicksFont, taCenter, tlCenter)
    else
      PNG.TextHoriz(FBottomAxisTicksCaptionsRects[i], BottomAxisTicksBGColor,
                    FBottomAxisTicksRowValues[i], BottomAxisTicksFont, taCenter, tlCenter);
  end;

  //SVG.Frame(FBottomAxisTicksRect, BottomAxisTicksBGColor,
  //          BottomAxisTicksFrameColor, BottomAxisTicksFrameWidth);
  //for i:= 0 to High(FBottomAxisTicksCaptions) do
  //begin
  //  if FBottomAxisTicksOrientation = tcoVertical then
  //    SVG.TextVert(FBottomAxisTicksCaptionsRects[i], BottomAxisTicksBGColor,
  //                 FBottomAxisTicksRowValues[i], BottomAxisTicksFont, taCenter, tlCenter)
  //  else
  //    SVG.TextHoriz(FBottomAxisTicksCaptionsRects[i], BottomAxisTicksBGColor,
  //                  FBottomAxisTicksRowValues[i], BottomAxisTicksFont, taCenter, tlCenter);
  //end;
end;

procedure TStatPlotterCore.DrawLeftAxisTicks;
var
  i: Integer;
begin
  if not LeftAxisTicksVisible then Exit;

  PNG.Frame(FLeftAxisTicksRect, LeftAxisTicksBGColor,
            LeftAxisTicksFrameColor, LeftAxisTicksFrameWidth);
  for i:= 0 to High(FLeftAxisTicksCaptions) do
  begin
    if FLeftAxisTicksOrientation = tcoVertical then
      PNG.TextVert(FLeftAxisTicksCaptionsRects[i], LeftAxisTicksBGColor,
                   FLeftAxisTicksRowValues[i], LeftAxisTicksFont, taCenter, tlCenter)
    else
      PNG.TextHoriz(FLeftAxisTicksCaptionsRects[i], LeftAxisTicksBGColor,
                    FLeftAxisTicksRowValues[i], LeftAxisTicksFont, taCenter, tlCenter);
  end;

  //SVG.Frame(FLeftAxisTicksRect, LeftAxisTicksBGColor,
  //          LeftAxisTicksFrameColor, LeftAxisTicksFrameWidth);
  //for i:= 0 to High(FLeftAxisTicksCaptions) do
  //begin
  //  if FLeftAxisTicksOrientation = tcoVertical then
  //    SVG.TextVert(FLeftAxisTicksCaptionsRects[i], LeftAxisTicksBGColor,
  //                 FLeftAxisTicksRowValues[i], LeftAxisTicksFont, taCenter, tlCenter)
  //  else
  //    SVG.TextHoriz(FLeftAxisTicksCaptionsRects[i], LeftAxisTicksBGColor,
  //                  FLeftAxisTicksRowValues[i], LeftAxisTicksFont, taCenter, tlCenter);
  //end;
end;

procedure TStatPlotterCore.DrawRightAxisTicks;
var
  i: Integer;
begin
  if not RightAxisTicksVisible then Exit;

  PNG.Frame(FRightAxisTicksRect, RightAxisTicksBGColor,
            RightAxisTicksFrameColor, RightAxisTicksFrameWidth);
  for i:= 0 to High(FRightAxisTicksCaptions) do
  begin
    if FRightAxisTicksOrientation = tcoVertical then
      PNG.TextVert(FRightAxisTicksCaptionsRects[i], RightAxisTicksBGColor,
                   FRightAxisTicksRowValues[i], RightAxisTicksFont, taCenter, tlCenter)
    else
      PNG.TextHoriz(FRightAxisTicksCaptionsRects[i], RightAxisTicksBGColor,
                    FRightAxisTicksRowValues[i], RightAxisTicksFont, taCenter, tlCenter);
  end;

  //SVG.Frame(FRightAxisTicksRect, RightAxisTicksBGColor,
  //          RightAxisTicksFrameColor, RightAxisTicksFrameWidth);
  //for i:= 0 to High(FRightAxisTicksCaptions) do
  //begin
  //  if FRightAxisTicksOrientation = tcoVertical then
  //    SVG.TextVert(FRightAxisTicksCaptionsRects[i], RightAxisTicksBGColor,
  //                 FRightAxisTicksRowValues[i], RightAxisTicksFont, taCenter, tlCenter)
  //  else
  //    SVG.TextHoriz(FRightAxisTicksCaptionsRects[i], RightAxisTicksBGColor,
  //                  FRightAxisTicksRowValues[i], RightAxisTicksFont, taCenter, tlCenter);
  //end;
end;

procedure TStatPlotterCore.DrawGridLines;

  procedure DrawVerticalLines(const ACoords: TIntVector; const AColor: TColor;
                      const AWidth: Integer; const AStyle: TPenStyle;
                      const APosition: TTicksCaptionPosition);
  var
    i, X, Y1, Y2: Integer;
  begin
    Y1:= FGraphRect.Top;
    Y2:= FGraphRect.Bottom;
    for i:= Ord(APosition=tcpBetween) to High(ACoords) do
    begin
      X:= ACoords[i];
      PNG.Line(X, Y1, X, Y2, AColor, AWidth, AStyle);
      //SVG.Line(X, Y1, X, Y2, AColor, AWidth, AStyle);
    end;
  end;

  procedure DrawHorizontalLines(const ACoords: TIntVector; const AColor: TColor;
                      const AWidth: Integer; const AStyle: TPenStyle;
                      const APosition: TTicksCaptionPosition);
  var
    i, X1, X2, Y: Integer;
  begin
    X1:= FGraphRect.Left;
    X2:= FGraphRect.Right;
    for i:= Ord(APosition=tcpBetween) to High(ACoords) do
    begin
      Y:= ACoords[i];
      PNG.Line(X1, Y, X2, Y, AColor, AWidth, AStyle);
      //SVG.Line(X1, Y, X2, Y, AColor, AWidth, AStyle);
    end;
  end;

begin
  if TopAxisGridLinesVisible then
    DrawVerticalLines(FTopAxisGridLinesCoords, FTopAxisGridLinesColor,
                      FTopAxisGridLinesWidth, FTopAxisGridLinesStyle,
                      FTopAxisTicksPosition);
  if BottomAxisGridLinesVisible then
    DrawVerticalLines(FBottomAxisGridLinesCoords, FBottomAxisGridLinesColor,
                      FBottomAxisGridLinesWidth, FBottomAxisGridLinesStyle,
                      FBottomAxisTicksPosition);
  if LeftAxisGridLinesVisible then
    DrawHorizontalLines(FLeftAxisGridLinesCoords, FLeftAxisGridLinesColor,
                      FLeftAxisGridLinesWidth, FLeftAxisGridLinesStyle,
                      FLeftAxisTicksPosition);
  if RightAxisGridLinesVisible then
    DrawHorizontalLines(FRightAxisGridLinesCoords, FRightAxisGridLinesColor,
                      FRightAxisGridLinesWidth, FRightAxisGridLinesStyle,
                      FRightAxisTicksPosition);
end;

procedure TStatPlotterCore.DrawDataFrame;
begin
  if not GraphFrameVisible then Exit;

  PNG.Frame(FGraphRect, GraphBGColor, GraphFrameColor, GraphFrameWidth);
  //SVG.Frame(FGraphRect, GraphBGColor, GraphFrameColor, GraphFrameWidth);
end;

constructor TStatPlotterCore.Create(const AWidth, AHeight: Integer);
begin
  inherited Create;

  FRect:= Rect(0, 0, AWidth, AHeight);
  FPNG:= TPNGDrawer.Create(AWidth, AHeight);
  //FSVG:= TSVGWriter.Create(AWidth, AHeight);

  FDrawData:= nil;

  //Graph
  FGraphColors:= VCreateColor(GRAPH_COLORS_DEFAULT);
  FGraphMinMargin:= GRAPH_MARGIN_MIN;

  //Core
  FCoreFont:= TFont.Create;
  FCoreFont.Name:= FONT_NAME_DEFAULT;
  FCoreFont.Size:= FONT_SIZE_DEFAULT;
  FCoreBGColor:= BG_COLOR_DEFAULT;
  FCoreFrameColor:= FRAME_COLOR_DEFAULT;
  FCoreFrameWidth:= FRAME_WIDTH_DEFAULT;
  FCoreRect:= Rect(0,0,0,0);
  //Title
  FTitle:= EmptyStr;
  FTitleRowValues:= nil;
  SetFont(FTitleFont, FCoreFont);
  FTitleBGColor:= BG_COLOR_DEFAULT;
  FTitleFrameColor:= FRAME_COLOR_DEFAULT;
  FTitleFrameWidth:= FRAME_WIDTH_DEFAULT;
  FTitleRect:= Rect(0,0,0,0);
  //Legend
  FLegend:= nil;
  SetFont(FLegendFont, FCoreFont);
  FLegendBGColor:= BG_COLOR_DEFAULT;
  FLegendFrameColor:= FRAME_COLOR_DEFAULT;
  FLegendFrameWidth:= FRAME_WIDTH_DEFAULT;
  FLegendRect:= Rect(0,0,0,0);
  FLegendMarkRects:= nil;
  FLegendTextRects:= nil;
  FLegendValues:= nil;
  FLegendTopMargin:= LEGEND_TOP_MARGIN_DEFAULT;
  //TopAxisTitle
  FTopAxisTitle:= EmptyStr;
  FTopAxisTitleRowValues:= nil;
  SetFont(FTopAxisTitleFont, FCoreFont);
  FTopAxisTitleBGColor:= BG_COLOR_DEFAULT;
  FTopAxisTitleFrameColor:= FRAME_COLOR_DEFAULT;
  FTopAxisTitleFrameWidth:= FRAME_WIDTH_DEFAULT;
  FTopAxisTitleRect:= Rect(0,0,0,0);
  //BottomAxisTitle
  FBottomAxisTitle:= EmptyStr;
  FBottomAxisTitleRowValues:= nil;
  SetFont(FBottomAxisTitleFont, FCoreFont);
  FBottomAxisTitleBGColor:= BG_COLOR_DEFAULT;
  FBottomAxisTitleFrameColor:= FRAME_COLOR_DEFAULT;
  FBottomAxisTitleFrameWidth:= FRAME_WIDTH_DEFAULT;
  FBottomAxisTitleRect:= Rect(0,0,0,0);
  //LeftAxisTitle
  FLeftAxisTitle:= EmptyStr;
  FLeftAxisTitleRowValues:= nil;
  SetFont(FLeftAxisTitleFont, FCoreFont);
  FLeftAxisTitleBGColor:= BG_COLOR_DEFAULT;
  FLeftAxisTitleFrameColor:= FRAME_COLOR_DEFAULT;
  FLeftAxisTitleFrameWidth:= FRAME_WIDTH_DEFAULT;
  FLeftAxisTitleRect:= Rect(0,0,0,0);
  //RightAxisTitle
  FRightAxisTitle:= EmptyStr;
  FRightAxisTitleRowValues:= nil;
  SetFont(FRightAxisTitleFont, FCoreFont);
  FRightAxisTitleBGColor:= BG_COLOR_DEFAULT;
  FRightAxisTitleFrameColor:= FRAME_COLOR_DEFAULT;
  FRightAxisTitleFrameWidth:= FRAME_WIDTH_DEFAULT;
  FRightAxisTitleRect:= Rect(0,0,0,0);

  //TopAxisTicks
  FTopAxisTicksValues:= nil;
  FTopAxisTicksCaptions:= nil;
  FTopAxisTicksRowValues:= nil;
  FTopAxisTicksPosition:= tcpBetween;
  FTopAxisTicksOrientation:= tcoHorizontal;
  SetFont(FTopAxisTicksFont, FCoreFont);
  FTopAxisTicksBGColor:= BG_COLOR_DEFAULT;
  FTopAxisTicksFrameColor:= FRAME_COLOR_DEFAULT;
  FTopAxisTicksFrameWidth:= FRAME_WIDTH_DEFAULT;
  FTopAxisTicksRect:= Rect(0,0,0,0);
  FTopAxisTicksCaptionsRects:= nil;
  FTopAxisTicksVisible:= True;
  FTopAxisTicksWrapWords:= False;
  FTopAxisTicksMaxCount:= TICKS_MAX_COUNT_DEFAULT;
  //BottomAxisTicks
  FBottomAxisTicksValues:= nil;
  FBottomAxisTicksCaptions:= nil;
  FBottomAxisTicksRowValues:= nil;
  FBottomAxisTicksPosition:= tcpBetween;
  FBottomAxisTicksOrientation:= tcoHorizontal;
  SetFont(FBottomAxisTicksFont, FCoreFont);
  FBottomAxisTicksBGColor:= BG_COLOR_DEFAULT;
  FBottomAxisTicksFrameColor:= FRAME_COLOR_DEFAULT;
  FBottomAxisTicksFrameWidth:= FRAME_WIDTH_DEFAULT;
  FBottomAxisTicksRect:= Rect(0,0,0,0);
  FBottomAxisTicksCaptionsRects:= nil;
  FBottomAxisTicksVisible:= True;
  FBottomAxisTicksWrapWords:= False;
  FBottomAxisTicksMaxCount:= TICKS_MAX_COUNT_DEFAULT;
  //LeftAxisTicks
  FLeftAxisTicksValues:= nil;
  FLeftAxisTicksCaptions:= nil;
  FLeftAxisTicksRowValues:= nil;
  FLeftAxisTicksPosition:= tcpBetween;
  FLeftAxisTicksOrientation:= tcoHorizontal;
  SetFont(FLeftAxisTicksFont, FCoreFont);
  FLeftAxisTicksBGColor:= BG_COLOR_DEFAULT;
  FLeftAxisTicksFrameColor:= FRAME_COLOR_DEFAULT;
  FLeftAxisTicksFrameWidth:= FRAME_WIDTH_DEFAULT;
  FLeftAxisTicksRect:= Rect(0,0,0,0);
  FLeftAxisTicksCaptionsRects:= nil;
  FLeftAxisTicksVisible:= True;
  FLeftAxisTicksWrapWords:= False;
  FLeftAxisTicksMaxCount:= TICKS_MAX_COUNT_DEFAULT;
  //RightAxisTicks
  FRightAxisTicksValues:= nil;
  FRightAxisTicksCaptions:= nil;
  FRightAxisTicksRowValues:= nil;
  FRightAxisTicksPosition:= tcpBetween;
  FRightAxisTicksOrientation:= tcoHorizontal;
  SetFont(FRightAxisTicksFont, FCoreFont);
  FRightAxisTicksBGColor:= BG_COLOR_DEFAULT;
  FRightAxisTicksFrameColor:= FRAME_COLOR_DEFAULT;
  FRightAxisTicksFrameWidth:= FRAME_WIDTH_DEFAULT;
  FRightAxisTicksRect:= Rect(0,0,0,0);
  FRightAxisTicksCaptionsRects:= nil;
  FRightAxisTicksVisible:= True;
  FRightAxisTicksWrapWords:= False;
  FRightAxisTicksMaxCount:= TICKS_MAX_COUNT_DEFAULT;

  //TopAxisGridLines
  FTopAxisGridLinesVisible:= True;
  FTopAxisGridLinesWidth:= LINE_WIDTH_DEFAULT;
  FTopAxisGridLinesColor:= LINE_COLOR_DEFAULT;
  FTopAxisGridLinesStyle:= LINE_STYLE_DEFAULT;
  FTopAxisGridLinesCoords:= nil;
  //BottomAxisGridLines
  FBottomAxisGridLinesVisible:= True;
  FBottomAxisGridLinesWidth:= LINE_WIDTH_DEFAULT;
  FBottomAxisGridLinesColor:= LINE_COLOR_DEFAULT;
  FBottomAxisGridLinesStyle:= LINE_STYLE_DEFAULT;
  FBottomAxisGridLinesCoords:= nil;
  //LeftAxisGridLines
  FLeftAxisGridLinesVisible:= True;
  FLeftAxisGridLinesWidth:= LINE_WIDTH_DEFAULT;
  FLeftAxisGridLinesColor:= LINE_COLOR_DEFAULT;
  FLeftAxisGridLinesStyle:= LINE_STYLE_DEFAULT;
  FLeftAxisGridLinesCoords:= nil;
  //RightAxisGridLines
  FRightAxisGridLinesVisible:= True;
  FRightAxisGridLinesWidth:= LINE_WIDTH_DEFAULT;
  FRightAxisGridLinesColor:= LINE_COLOR_DEFAULT;
  FRightAxisGridLinesStyle:= LINE_STYLE_DEFAULT;
  FRightAxisGridLinesCoords:= nil;

  //Graph
  FGraphBGColor:= BG_COLOR_DEFAULT;
  FGraphFrameColor:= FRAME_COLOR_DEFAULT;
  FGraphFrameWidth:= FRAME_WIDTH_DEFAULT;
  FGraphFrameVisible:= True;
  FGraphRect:= Rect(0,0,0,0);

  //Series
  FTopAxisSeries:= nil;
  FBottomAxisSeries:= nil;
  FLeftAxisSeries:= nil;
  FRightAxisSeries:= nil;


end;

destructor TStatPlotterCore.Destroy;
begin
  FreeAndNil(FPNG);
  //FreeAndNil(FSVG);

  FreeAndNil(FTitleFont);
  FreeAndNil(FLegendFont);
  FreeAndNil(FTopAxisTitleFont);
  FreeAndNil(FBottomAxisTitleFont);
  FreeAndNil(FLeftAxisTitleFont);
  FreeAndNil(FRightAxisTitleFont);

  FreeAndNil(FTopAxisTicksFont);
  FreeAndNil(FBottomAxisTicksFont);
  FreeAndNil(FLeftAxisTicksFont);
  FreeAndNil(FRightAxisTicksFont);
  inherited Destroy;
end;

procedure TStatPlotterCore.Calc;
begin
  Prepare;
  Draw;
end;



//procedure TStatPlotterCore.PNGDraw(const ACanvas: TCanvas; const X: Integer;
//  const Y: Integer);
//begin
//  FPNG.Draw(ACanvas, X, Y);
//end;
//
//procedure TStatPlotterCore.PNGSaveToFile(const AFileName: String);
//begin
//  FPNG.SaveToFile(AFileName);
//end;
//
//procedure TStatPlotterCore.PNGSaveToStream(AStream: TStream);
//begin
//  FPNG.SaveToStream(AStream);
//end;
//
//function TStatPlotterCore.SVGLines: TStrVector;
//begin
//  Result:= VCut(FSVG.SVGComplete);
//end;
//
//procedure TStatPlotterCore.SVGSaveToFile(const AFileName: String);
//begin
//  FSVG.SaveToFile(AFileName);
//end;
//
//procedure TStatPlotterCore.SVGSaveToStream(AStream: TStream);
//begin
//  FSVG.SaveToStream(AStream);
//end;

procedure TStatPlotterCore.SetTicks(const ATicksMaxCount: Integer;
  const ASeries: TIntMatrix; var ATicksCaptions: TSTrVector;
  var ATicksValues: TIntVector);
begin
  ATicksValues:= AxisTicksInt(0, MMax(ASeries), ATicksMaxCount);
  ATicksCaptions:= VIntToStr(ATicksValues);
end;

procedure TStatPlotterCore.SetSeries(const AValues: TIntMatrix;
  const ATicksMaxCount: Integer; var ASeries: TIntMatrix;
  var ATicksCaptions: TSTrVector; var ATicksValues: TIntVector);
begin
  ASeries:= MCut(AValues);
  SetTicks(ATicksMaxCount, ASeries, ATicksCaptions, ATicksValues);
end;

procedure TStatPlotterCore.AddSeries(const AValues: TIntVector;
                    const ATicksMaxCount: Integer;
                    var ASeries: TIntMatrix;
                    var ATicksCaptions: TSTrVector;
                    var ATicksValues: TIntVector);
begin
  if (not MIsNil(ASeries)) and (Length(AValues)<>Length(ASeries[0])) then
      raise Exception.Create('Incorrect vector size!');
  MAppend(ASeries, AValues);
  SetTicks(ATicksMaxCount, ASeries, ATicksCaptions, ATicksValues);
  //ATicksValues:= AxisTicksInt(0, MMax(ASeries), ATicksMaxCount);
  //ATicksCaptions:= VIntToStr(ATicksValues);
end;

procedure TStatPlotterCore.SetTopAxisSeries(AValues: TIntMatrix);
begin
  SetSeries(AValues, TopAxisTicksMaxCount, FTopAxisSeries,
            FTopAxisTicksCaptions, FTopAxisTicksValues);
end;

procedure TStatPlotterCore.SetBottomAxisSeries(AValues: TIntMatrix);
begin
  SetSeries(AValues, BottomAxisTicksMaxCount, FBottomAxisSeries,
            FBottomAxisTicksCaptions, FBottomAxisTicksValues);
end;

procedure TStatPlotterCore.SetLeftAxisSeries(AValues: TIntMatrix);
begin
  SetSeries(AValues, LeftAxisTicksMaxCount, FLeftAxisSeries,
            FLeftAxisTicksCaptions, FLeftAxisTicksValues);
end;

procedure TStatPlotterCore.SetRightAxisSeries(AValues: TIntMatrix);
begin
  SetSeries(AValues, RightAxisTicksMaxCount, FRightAxisSeries,
            FRightAxisTicksCaptions, FRightAxisTicksValues);
end;

procedure TStatPlotterCore.TopAxisSeriesAdd(const AValues: TIntVector);
begin
  AddSeries(AValues, TopAxisTicksMaxCount,
            FTopAxisSeries, FTopAxisTicksCaptions, FTopAxisTicksValues);
end;

procedure TStatPlotterCore.BottomAxisSeriesAdd(const AValues: TIntVector);
begin
  AddSeries(AValues, BottomAxisTicksMaxCount,
            FBottomAxisSeries, FBottomAxisTicksCaptions, FBottomAxisTicksValues);
end;

procedure TStatPlotterCore.LeftAxisSeriesAdd(const AValues: TIntVector);
begin
  AddSeries(AValues, LeftAxisTicksMaxCount,
            FLeftAxisSeries, FLeftAxisTicksCaptions, FLeftAxisTicksValues);
end;

procedure TStatPlotterCore.RightAxisSeriesAdd(const AValues: TIntVector);
begin
  AddSeries(AValues, RightAxisTicksMaxCount,
            FRightAxisSeries, FRightAxisTicksCaptions, FRightAxisTicksValues);
end;

{ TStatPlotterVertHist }

procedure TStatPlotterVertHist.DrawDataProc;
var
  Rects: TRectVector;
  M: TIntMatrix;
begin
  M:= MTranspose(FPlotter.LeftAxisSeries);
  Rects:= FPlotter.DataRectsLeftBottom;
  FPlotter.PNG.BarsVert(Rects, FPlotter.GraphColors, FPlotter.GraphColors,
               BarFrameWidth, BarMargin, BarGradientLightnessIncrement,
               BarGradientDemarcationPercent, BarMaxWidthPercent,
               FPlotter.LeftAxisGridLinesCoords, FPlotter.LeftAxisTicksValues, M);
  //FPlotter.SVG.BarsVert(Rects, FPlotter.GraphColors, FPlotter.GraphColors,
  //             BarFrameWidth, BarMargin, BarGradientLightnessIncrement,
  //             BarGradientDemarcationPercent, BarMaxWidthPercent,
  //             FPlotter.LeftAxisGridLinesCoords, FPlotter.LeftAxisTicksValues, M);
end;

procedure TStatPlotterVertHist.SetXTicks(AValues: TStrVector);
begin
  FPlotter.TopAxisTicksCaptions:= AValues;
  FPlotter.BottomAxisTicksCaptions:= AValues;
end;

constructor TStatPlotterVertHist.Create(const AWidth, AHeight: Integer);
begin
  inherited Create(AWidth, AHeight);

  FPlotter.TopAxisTicksPosition:= tcpBetween;
  FPlotter.BottomAxisTicksPosition:= tcpBetween;

  FPlotter.LeftAxisTicksPosition:= tcpTicks;
  FPlotter.RightAxisTicksPosition:= tcpTicks;

  FPlotter.TopAxisTicksOrientation:= tcoHorizontal;
  FPlotter.BottomAxisTicksOrientation:= tcoHorizontal;
end;

procedure TStatPlotterVertHist.YSeriesAdd(const AValues: TIntVector);
begin
  FPlotter.LeftAxisSeriesAdd(AValues);
  FPlotter.RightAxisSeriesAdd(AValues);
end;

procedure TStatPlotterVertHist.SetYSeries(AValues: TIntMatrix);
begin
  FPlotter.LeftAxisSeries:= AValues;
  FPlotter.RightAxisSeries:= AValues;
end;

end.

