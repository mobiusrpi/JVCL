{-------------------------------------------------------------------------------
 QWindows.pas

 Copyright (c) 2003, Andre Snepvangers (asn@xs4all.nl)
 All rights reserved.

 Version 0.5
  Description: Qt based wrappers for common MS Windows API's
  Purpose: Reduce coding effort for porting VCL based components to VisualCLX
           compatible components

 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files(the "Software"), to deal in
 the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
--------------------------------------------------------------------------------

Last Modified: 2004-01-02

Known Issues:
  - Covers only a small part of the Windows APIs
  - Not all functionality is supported
{-----------------------------------------------------------------------------}

unit QWindows;

interface

uses
  Types, StrUtils, SysUtils, Classes, Math, SyncObjs,
  QTypes, Qt, QConsts, QGraphics, QControls, QForms, QExtCtrls, QButtons;

const
  { Windows VK_ keycodes to Qt key }
  VK_BACK     = Key_Backspace;
  VK_TAB      = Key_Tab;
  VK_RETURN   = 4100;  // Enter key from keypad
  VK_SHIFT    = Key_Shift;
  VK_CONTROL  = Key_Control;
  VK_MENU     = Key_Alt;
  VK_PAUSE    = Key_Pause;
  VK_CAPITAL  =  Key_CapsLock;
  VK_ESCAPE   = 4096;
  VK_SPACE    = Key_Space;
  VK_PRIOR    = Key_Prior;
  VK_NEXT     = Key_Next;
  VK_END      = Key_End;
  VK_HOME     = Key_Home;
  VK_LEFT     = Key_Left;
  VK_UP       = Key_Up;
  VK_RIGHT    = Key_Right;
  VK_DOWN     = Key_Down;
  { VK_SELECT   = 41; }
  VK_PRINT    = Key_Print;
  { VK_EXECUTE  = 43; }
  VK_SNAPSHOT = Key_Print;
  VK_INSERT   = Key_Insert;
  VK_DELETE   = Key_Delete;
  VK_HELP     = Key_Help;
  { VK_LWIN     = 91; }
  { VK_RWIN     = 92; }
  VK_APPS     = Key_Menu;
  VK_NUMPAD0  = Key_0;
  VK_NUMPAD1  = Key_1;
  VK_NUMPAD2  = Key_2;
  VK_NUMPAD3  = Key_3;
  VK_NUMPAD4  = Key_4;
  VK_NUMPAD5  = Key_5;
  VK_NUMPAD6  = Key_6;
  VK_NUMPAD7  = Key_7;
  VK_NUMPAD8  = Key_8;
  VK_NUMPAD9  = Key_9;
  VK_MULTIPLY = Key_Asterisk;
  VK_ADD      = Key_Plus;
  VK_SUBTRACT = Key_Minus;
  VK_DECIMAL  = Key_Period;
  VK_DIVIDE   = Key_Slash;
  VK_F1       = Key_F1;
  VK_F2       = Key_F2;
  VK_F3       = Key_F3;
  VK_F4       = Key_F4;
  VK_F5       = Key_F5;
  VK_F6       = Key_F6;
  VK_F7       = Key_F7;
  VK_F8       = Key_F8;
  VK_F9       = Key_F1;
  VK_F10      = Key_F10;
  VK_F11      = Key_F11;
  VK_F12      = Key_F12;
  VK_F13      = Key_F13;
  VK_F14      = Key_F14;
  VK_F15      = Key_F15;
  VK_F16      = Key_F16;
  VK_F17      = Key_F17;
  VK_F18      = Key_F18;
  VK_F19      = Key_F19;
  VK_F20      = Key_F20;
  VK_F21      = Key_F21;
  VK_F22      = Key_F22;
  VK_F23      = Key_F23;
  VK_F24      = Key_F24;
  VK_NUMLOCK  = Key_NumLock;
  VK_SCROLL   = Key_ScrollLock;
  { VK_L.. & VK_R.. mapping:                      }
  { Alt, Ctrl and Shift keys produce same keycode }
  VK_LSHIFT   = Key_Shift;
  VK_RSHIFT   = Key_Shift;
  VK_LCONTROL = Key_Control;
  VK_RCONTROL = Key_Control;
  VK_LMENU    = Key_Alt;
  VK_RMENU    = Key_Alt;

  { Qt alignment flags, (as used by Canvas.TextRect) }
  AlignLeft     = $1;
  AlignRight    = $2;
  AlignHCenter  = $4;
  AlignTop      = $8;
  AlignBottom   = $10;
  AlignVCenter  = $20;
  AlignCenter   = $24;
  SingleLine    = $40;
  DontClip      = $80;
  ExpandTabs    = $100;
  ShowPrefix    = $200;
  WordBreak     = $400;
  BreakAnywhere = $800;
  {
  DontPrint = $1000; not used

  Additional constanst for Qt text alignments
  used by DrawText
  }
  QtAlignMask   = $FFFF;
  CalcRect      = $10000;
  ClipPath      = $20000;
  ClipName      = $40000;
  ClipToWord    = $100000;
  ModifyString  = $200000;

  TA_LEFT = Integer(AlignmentFlags_AlignLeft);
  TA_RIGHT = Integer(AlignmentFlags_AlignRight);
  TA_CENTER = Integer(AlignmentFlags_AlignHCenter);
  TA_TOP = Integer(AlignmentFlags_AlignTop);
  TA_BOTTOM = Integer(AlignmentFlags_AlignBottom);
  VTA_CENTER = Integer(AlignmentFlags_AlignVCenter);
  TA_NOUPDATECP = 0;
  TA_UPDATECP = $8000;
  TA_BASELINE = $4000;
  VTA_BASELINE = TA_BASELINE;

  pf24bit = pf32bit;
  clMoneyGreen = TColor($C0DCC0);
  clSkyBlue = TColor($F0CAA6);
  clCream = TColor($F0FBFF);
  clMedGray = TColor($A4A0A0);

  INFINITE = LongWord($FFFFFFFF); // Infinite timeout
  
type
  HWND = QWidgetH;
  HCURSOR = QCursorH;
  HRGN = QRegionH;
  HBRUSH = QBrushH;
  HBITMAP = QPixmapH;
  HDC = QPainterH;
  HFONT = QFontH;
  UINT = Cardinal;
  BOOL = LongBool;

  TWinControl = TWidgetControl;
  TControlClass = class of TControl;
  TColorRef = Integer;    // real colors
  TPointL = record
    X: Longint;
    Y: Longint;
  end;
  TTime = TDateTime;
  TDate = TDateTime;

  PMessage = ^TMessage;
  TMessage = packed record
    Msg: Integer;
    WParam: Integer;
    LParam: Integer;
    Result: Integer;
  end;

{
  2 dummies for ... VCL
 asn: AFAIK use of RightToLeft or LeftToRight is automatic
}
function DrawTextBiDiModeFlagsReadingOnly: Longint;
function DrawTextBiDiModeFlags(Flags: Longint): Longint;
function UseRightToLeftAlignment: Boolean;
{ colors }
function GetSysColor(SysColor: Integer): TColorRef;
function SetSysColor(RefColor: TColor; TrueColor: TColorRef): boolean;
function SetSysColors(Elements: Integer; const lpaElements;
  const lpaRgbValues): LongBool;


function RGB(Red, Green, Blue: Integer): TColorRef;
function GetBValue(Col: TColorRef): Byte;
function GetGValue(Col: TColorRef): Byte;
function GetRValue(Col: TColorRef): Byte;

const
  { windows symbolic colors }         { mapping VisualCLX Symbolic colors}
  COLOR_SCROLLBAR = 0;                // clNormalButton
  COLOR_BACKGROUND = 1;               // clNormalBackground
  COLOR_ACTIVECAPTION = 2;            // clActiveHighlightedText
  COLOR_INACTIVECAPTION = 3;          // clDisabledHighlightedText
  COLOR_MENU = 4;                     // clNormalMid
  COLOR_WINDOW = 5;                   // clNormalBase
  COLOR_WINDOWFRAME = 6;              // clNormalHighlight
  COLOR_MENUTEXT = 7;                 // clNormalButtonText
  COLOR_WINDOWTEXT = 8;               // clNormalText
  COLOR_CAPTIONTEXT = 9;              // clNormalHighlightedText
  COLOR_ACTIVEBORDER = 10;            // clActiveHighlight
  COLOR_INACTIVEBORDER = 11;          // clDisabledHighlight
  COLOR_APPWORKSPACE = 12;            // clNormalMid
  COLOR_HIGHLIGHT = 13;               // clNormalHighlight
  COLOR_HIGHLIGHTTEXT = 14;           // clNormalHighlightedText
  COLOR_BTNFACE = 15;                 // clNormalButton
  COLOR_BTNSHADOW = $10;              // clNormalDark
  COLOR_GRAYTEXT = 17;                // clNormalDisabledText
  COLOR_BTNTEXT = 18;                 // clNormalButtonText
  COLOR_INACTIVECAPTIONTEXT = 19;     // clDisabledHighlightedText
  COLOR_BTNHIGHLIGHT = 20;            // clActiveLight
  COLOR_3DDKSHADOW = 21;              // clNormalMid
  COLOR_3DLIGHT = 22;                 // clNormalMidLight
  COLOR_INFOTEXT = 23;                // clNormalText
  COLOR_INFOBK = 24;                  // TColor($E1FFFF)
//             = 25;                  // ?? (asn: defined as clBlack for now)
  COLOR_HOTLIGHT = 26;                // clNormalHighlight (asn: ??)
  COLOR_GRADIENTACTIVECAPTION = 27;   // clActiveHighLight (asn: ??)
  COLOR_GRADIENTINACTIVECAPTION = 28; // clDisabledHighlight (asn: ??)

  COLOR_ENDCOLORS = COLOR_GRADIENTINACTIVECAPTION;
(*)
  COLOR_MENUHILIGHT = 29;
  COLOR_MENUBAR = 30;
  COLOR_ENDCOLORS = COLOR_MENUBAR;
(*)

  COLOR_DESKTOP = COLOR_BACKGROUND;
  COLOR_3DFACE = COLOR_BTNFACE;
  COLOR_3DSHADOW = COLOR_BTNSHADOW;
  COLOR_3DHIGHLIGHT = COLOR_BTNHIGHLIGHT;
  COLOR_3DHILIGHT = COLOR_BTNHIGHLIGHT;
  COLOR_BTNHILIGHT = COLOR_BTNHIGHLIGHT;

  clHintColor = TColor($20210500);
  clDesktop = TColor($20210501);
  clNoRole = TColor(-15);
  clNormalNoRole = TColor(clNoRole - cloNormal);
  clDisabledNoRole = TColor(clNoRole - cloDisabled);
  clActiveNoRole = TColor(clNoRole - cloActive);


  // Windows symbolic colors to mapping VisualCLX symbolic colors
  Win2TColor: array [0..COLOR_ENDCOLORS] of TColor = (
  clNormalButton, clNormalBackground, clActiveHighlightedText,     // 0
  clDisabledHighlightedText, clNormalMid, clNormalBase,            // 3
  clNormalHighlight, clNormalButtonText, clNormalText,             // 6
  clNormalHighlightedText, clActiveHighlight, clDisabledHighlight, // 9
  clNormalMid, clNormalHighlight,  clNormalHighlightedText,        // 12
  clNormalButton, clNormalDark, clDisabledText,                    // 15
  clNormalButtonText, clDisabledHighlightedText, clActiveLight,    // 18
  clNormalMid, clNormalMidLight, clNormalText,                     // 21
  clHintColor, clBlack ,clNormalHighlight,                         // 24
  clActiveHighLight, clDisabledHighlight);                         // 27

function SetRect(var R: TRect; Left, Top, Right, Bottom: Integer): LongBool;
function IsRectEmpty(R: TRect): LongBool;
function EqualRect(R1, R2: TRect): LongBool;
function UnionRect(var Dst: TRect; R1, R2: TRect): LongBool;
function CopyRect(var Dst: TRect; const Src: TRect): LongBool;

type
  TRGBQuad = packed record
    rgbReserved: Byte;
    rgbBlue: Byte;
    rgbGreen: Byte;
    rgbRed: Byte;
  end;

  TRGBTriple = packed record
    rgbtReserved: Byte;
    rgbtBlue: Byte;
    rgbtGreen: Byte;
    rgbtRed: Byte;
  end;

  tagTEXTMETRICA = record
    { supported by QFontMetrics }
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    (* unsupported:
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
    tmWeight: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: AnsiChar;
    tmLastChar: AnsiChar;
    tmDefaultChar: AnsiChar;
    tmBreakChar: AnsiChar;
    *)
  end;
  TTextMetric = tagTEXTMETRICA;

  PtagBITMAP = ^tagBITMAP;
  tagBITMAP = packed record
    //bmType: Longint;
    bmWidth: Longint;
    bmHeight: Longint;
    //bmWidthBytes: Longint;
    //bmPlanes: Word;
    bmBitsPixel: Word;
    //bmBits: Pointer;
  end;

  PBitmapInfoHeader = ^TBitmapInfoHeader;
  tagBITMAPINFOHEADER = packed record
    biSize: DWORD;
    biWidth: Longint;
    biHeight: Longint;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: DWORD;
    biSizeImage: DWORD;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;
  TBitmapInfoHeader = tagBITMAPINFOHEADER;
  BITMAPINFOHEADER = tagBITMAPINFOHEADER;


{ brushes }
function CreateSolidBrush(crColor: TColorRef): QBrushH;
function CreateHatchBrush(bStyle: BrushStyle; crColor: TColorRef): QBrushH;
function DeleteObject(Handle: QBrushH): LongBool; overload;

const
  { BrushStyle mappings}
  HS_BDIAGONAL  = BrushStyle_BDiagPattern;    // 45-degree downward left-to-right hatch
  HS_CROSS      = BrushStyle_CrossPattern;    // Hor. and vertical crosshatch
  HS_DIAGCROSS  = BrushStyle_DiagCrossPattern;// 45-degree crosshatch
  HS_FDIAGONAL  = BrushStyle_FDiagPattern;    // 45-degree upward left-to-right hatch
  HS_HORIZONTAL = BrushStyle_HorPattern;      // Horizontal hatch
  HS_VERTICAL   = BrushStyle_VerPattern;      // Vertical hatch

function CreatePen(Style, Width: Integer; Color: TColorRef): QPenH;
function DeleteObject(Handle: QPenH): LongBool; overload;

const
  { Pen Styles }
  PS_NULL          = 0;   // PenStyle_NoPen
  PS_SOLID         = 1;   // PenStyle_SolidLine
  PS_DASH          = 2;   // PenStyle_DashLine
  PS_DOT           = 3;   // PenStyle_DotLine
  PS_DASHDOT       = 4;   // PenStyle_DashDotLine
  PS_DASHDOTDOT    = 5;   // PenStyle_DashDotDotLine
  PS_STYLE_MASK    = 15;  // PenStyle_MPenStyle
  {caps}
  PS_ENDCAP_FLAT   = 0;   // PenCapStyle_FlatCap
  PS_ENDCAP_SQUARE = 16;  // PenCapStyle_SquareCap
  PS_ENDCAP_ROUND  = 32;  // PenCapStyle_RoundCap
  PS_ENDCAP_MASK   = 48;  // PenCapStyle_MPenCapStyle
  {join}
  PS_JOIN_MITER    = 0;   // PenJoinStyle_MiterJoin
  PS_JOIN_BEVEL    = 64;  // PenJoinStyle_BevelJoin
  PS_JOIN_ROUND    = 128; // PenJoinStyle_RoundJoin
  PS_JOIN_MASK     = $C0; // PenCapStyle_MPenCapStyle

function DPtoLP(Handle: QPainterH; var Points; Count: Integer): LongBool;
function LPtoDP(Handle: QPainterH; var Points; Count: Integer): LongBool;
function SetWindowOrgEx(Handle: QPainterH; X, Y: Integer; OldOrg: PPoint): LongBool;
function GetWindowOrgEx(Handle: QPainterH; Org: PPoint): LongBool;
{ limited implementations of }
function BitBlt(DestDC: QPainterH; X, Y, Width, Height: Integer; SrcDC: QPainterH;
  XSrc, YSrc: Integer; Rop: RasterOp): LongBool; overload;
function BitBlt(DestDC: QPainterH; X, Y, Width, Height: Integer; SrcDC: QPainterH;
  XSrc, YSrc: Integer; WinRop: Cardinal): LongBool; overload;
function PatBlt(Handle: QPainterH; X, Y, Width, Height: Integer;
  WinRop: Cardinal): LongBool; //overload;

function StretchBlt(dst: QPainterH; dx, dy, dw, dh: Integer;
  src: QPainterH; sx, sy, sw, sh: Integer; winrop: Cardinal): LongBool; overload;
function StretchBlt(dst: QPainterH; dx, dy, dw, dh: Integer; src: QPainterH;
  sx, sy, sw, sh: Integer; Rop: RasterOp): LongBool; overload;

function GetStretchBltMode(DC: QPainterH): Integer;
function SetStretchBltMode(DC: QPainterH; StretchMode: Integer): Integer;

const
  { StretchBlt() Modes }
  BLACKONWHITE = 1;
  WHITEONBLACK = 2;
  COLORONCOLOR = 3;
  HALFTONE = 4;
  MAXSTRETCHBLTMODE = 4;
  STRETCH_ANDSCANS = BLACKONWHITE;
  STRETCH_ORSCANS = WHITEONBLACK;
  STRETCH_DELETESCANS = COLORONCOLOR;
  STRETCH_HALFTONE = HALFTONE;

const
  { BitBlt:  windows dwRop values
    asn: limited implementation, possible to extend }
  BLACKNESS   = $00000042;   // RasterOp_ClearROP
  DSTINVERT   = $00550009;   // RasterOp_NotROP
  MERGECOPY   = $00C000CA;   // RasterOp_OrROP
  MERGEPAINT  = $00BB0226;   // RasterOp_NotOrRop
  NOTSRCCOPY  = $00330008;   // RasterOp_NotCopyROP
  NOTSRCERASE = $001100A6;   // RasterOp_NorROP
  SRCAND      = $008800C6;   // RasterOp_AndROP
  SRCCOPY     = $00CC0020;   // RasterOp_CopyROP
  SRCERASE    = $00440328;   // RasterOp_AndNotROP
  SRCINVERT   = $00660046;   // RasterOp_XorROP
  SRCPAINT    = $00EE0086;   // RasterOp_OrROP;
  WHITENESS   = $00FF0062;   // RasterOp_SetROP
  PATCOPY     = $00F00021;   // dest = pattern
  PATPAINT    = $00FB0A09;   // dest = DPSnoo = PDSnoo
  PATINVERT   = $005A0049;   // dest = pattern XOR dest
  ROP_DSPDxax = $00E20746;   // dest = ((pattern XOR dest) AND source) XOR Dest
  ROP_DSna    = $00220326;   // RasterOp_NotAndROP
  ROP_DSno    = MERGEPAINT;
  ROP_DPSnoo  = PATPAINT;
  ROP_D       = $00AA0029;   // RasterOp_NopROP
  ROP_Dn      = DSTINVERT;   // DSTINVERT
  ROP_SDna    = SRCERASE;    // SRCERASE
  ROP_SDno    = $00DD0228;   // RasterOp_OrNotROP
  ROP_DSan    = $007700E6;   // RasterOp_NandROP
  ROP_DSon    = $001100A6;   // NOTSRCERASE
  //ROP_Pn      = $000F0001;   //

const
 { SetROP2:  windows ROP2 values }
  R2_BLACK       = 9;  // RasterOp_ClearROP:  Pixel is always 0.
  R2_WHITE       = 10; // RasterOp_SetROP:Pixel is always 1.
  R2_NOP         = 11; // RasterOp_NopROP: Pixel remains unchanged.
  R2_NOT         = 8;  // RasterOp_NotROP:      inverse of the screen color.
  R2_COPYPEN     = 0;  // RasterOp_CopyROP: Pixel is the pen color.
  R2_NOTCOPYPEN  = 4;  // RasterOp_NotCopyROP; inverse of the pen color.
  R2_MERGEPENNOT = 13; // RasterOp_OrNotROP: combination of the pen color and the inverse of the screen color.
  R2_MASKPENNOT  = 12; // RasterOp_AndNotROP: combination of the colors common to both the pen and the inverse of the screen.
  R2_MERGEPEN    = 1;  // RasterOp_OrROP: combination of the pen color and the screen color.
  R2_NOTMERGEPEN = 15; // RasterOp_NorROP:  inverse of the R2_MERGEPEN color.
  R2_MASKPEN     = 7;  // RasterOp_AndROP: combination of the colors common to both the pen and the screen.
  R2_NOTMASKPEN  = 14; // RasterOp_NandROP: inverse of the R2_MASKPEN color.
  R2_XORPEN      = 2;  // RasterOp_XorROP: combination of the colors in the pen and in the screen, but not in both.
  R2_NOTXORPEN   = 6;  // RasterOp_NotXorROP: inverse of the R2_XORPEN color.
  R2_MASKNOTPEN  = 3;  // RasterOp_NotAndROP: combination of the colors common to both the screen and the inverse of the pen.
  R2_MERGENOTPEN = 5;  // RasterOp_NotOrROP: combination of the screen color and the inverse of the pen color.

function SetROP2(Handle: QPainterH; Rop: Integer): Integer; overload;
function GetROP2(Handle: QPainterH): Integer; overload;

const
  { SetBkMode: background mode }
  TRANSPARENT = 1; // BGMode_TransparentMode
  OPAQUE      = 2; // BGMode_OpaqueMode

function GetPixel(Handle: QPainterH; X, Y: Integer): TColorRef;
function SetPixel(Handle: QPainterH; X, Y: Integer; Color: TColorRef): TColorRef;
function SetTextColor(Handle: QPainterH; color: TColor): TColor;
function SetBkColor(Handle: QPainterH; color: TColor): TColor;
function GetBkMode(Handle: QPainterH): Integer;
function SetBkMode(Handle: QPainterH; BkMode: Integer): Integer;
function SetDCBrushColor(Handle: QPainterH; Color: TColorRef): TColorRef;
function SetDCPenColor(Handle: QPainterH; Color: TColorRef): TColorRef;
function SetPenColor(Handle: QPainterH; Color: TColor): TColor;

function CreateCompatibleDC(Handle: QPainterH; Width: Integer = 1; Height: Integer = 1): QPainterH;
function CreateCompatibleBitmap(Handle: QPainterH; Width, Height: Integer): QPixmapH;
function CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer): QPixmapH;
function GetObject(Handle: QPixmapH; Size: Cardinal; Data: PtagBITMAP): Boolean;

// DeleteObject is intended to destroy the Handle returned by CreateCompatibleBitmap
// (it destroys the Painter AND PaintDevice) 
function DeleteObject(Handle: QPainterH): LongBool; overload;
function DeleteObject(Handle: QPixmapH): LongBool; overload;
function GetDC(Handle: QWidgetH): QPainterH; overload;
function GetDC(Handle: Integer): QPainterH; overload;
function GetWindowDC(Handle: QWidgetH): QPainterH;

function ReleaseDC(wdgtH: QWidgetH; Handle: QPainterH): Integer; overload;
function ReleaseDC(wdgtH: Integer; Handle: QPainterH): Integer; overload;
function DeleteDC(Handle: QPainterH): LongBool;

function SaveDC(Handle: QPainterH): Integer;
{ only negative and zero values of nSaveDC are supported }
function RestoreDC(Handle: QPainterH; nSavedDC: Integer): LongBool;

function ExtTextOut(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; const Text: WideString; Len: Integer; lpDx: Pointer): LongBool; overload;
function ExtTextOut(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; pText: PChar; Len: Integer; lpDx: Pointer): LongBool; overload;
function ExtTextOutW(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; pText: PWideChar; Len: Integer; lpDx: Pointer): LongBool;
function SetTextAlign(Handle: QPainterH; Mode: Cardinal): Cardinal; 
function GetTextAlign(Handle: QPainterH): Cardinal;

const
  { ExtTextOut format flags }
  ETO_OPAQUE     = 2;
  ETO_CLIPPED    = 4;
  ETO_RTLREADING = $80; // ignored

function FillRect(Handle: QPainterH; const R: TRect; Brush: QBrushH): LongBool;
function GetCurrentPositionEx(Handle: QPainterH; pos: PPoint): LongBool;
function GetTextExtentPoint32(Handle: QPainterH; const Text: WideString; Len: Integer;
  var Size: TSize): LongBool; overload;
function GetTextExtentPoint32(Handle: QPainterH; pText: PChar; Len: Integer;
  var Size: TSize): LongBool; overload;
function GetTextExtentPoint32W(Handle: QPainterH; pText: PWideChar; Len: Integer;
  var Size: TSize): LongBool;

function FrameRect(Handle: QPainterH; const R: TRect; Brush: QBrushH): LongBool; overload;
procedure FrameRect(Canvas: TCanvas; const R: TRect); overload;
function DrawFocusRect(Handle: QPainterH; const R: TRect): LongBool;
function DrawFrameControl(Handle: QPainterH; const Rect: TRect; uType, uState: LongWord): LongBool;
function InvertRect(Handle: QPainterH; const R: TRect): LongBool;
function RoundRect(Handle: QPainterH; Left, Top, Right, Bottom, X3, Y3: Integer): LongBool;
function Ellipse(Handle: QPainterH; Left, Top, Right, Bottom: Integer): LongBool;
function LineTo(Handle: QPainterH; X, Y:Integer): LongBool;
function MoveToEx(Handle: QPainterH; X, Y:Integer; oldpos: PPoint): LongBool;
function DrawIcon(Handle: QPainterH; X, Y: Integer; hIcon: QPixMapH): LongBool;
function DrawIconEx(Handle: QPainterH; X, Y: Integer; hIcon: QPixmapH;
  W, H: Integer; istepIfAniCur: Integer; hbrFlickerFreeDraw: QBrushH;
  diFlags: Cardinal): LongBool;

const
{ DrawIconEx diFlags }
  DI_MASK        = 1;
  DI_IMAGE       = 2;
  DI_NORMAL      = 3;
//  DI_COMPAT    = 4;   not supported
  DI_DEFAULTSIZE = 8;


const
  { flags for DrawFrameControl }
  DFC_CAPTION = 1;
  DFC_MENU = 2;
  DFC_SCROLL = 3;
  DFC_BUTTON = 4;
  DFC_POPUPMENU = 5;

  DFCS_CAPTIONCLOSE = 0;
  DFCS_CAPTIONMIN = 1;
  DFCS_CAPTIONMAX = 2;
  DFCS_CAPTIONRESTORE = 3;
  DFCS_CAPTIONHELP = 4;

  DFCS_MENUARROW = 0;
  DFCS_MENUCHECK = 1;
  DFCS_MENUBULLET = 2;
  DFCS_MENUARROWRIGHT = 4;

  DFCS_SCROLLUP = 0;
  DFCS_SCROLLDOWN = 1;
  DFCS_SCROLLLEFT = 2;
  DFCS_SCROLLRIGHT = 3;
  DFCS_SCROLLCOMBOBOX = 5;
  DFCS_SCROLLSIZEGRIP = 8;
  DFCS_SCROLLSIZEGRIPRIGHT = $10;

  DFCS_BUTTONCHECK = 0;
  DFCS_BUTTONRADIOIMAGE = 1;
  DFCS_BUTTONRADIOMASK = 2;
  DFCS_BUTTONRADIO = 4;
  DFCS_BUTTON3STATE = 8;
  DFCS_BUTTONPUSH = $10;

  DFCS_INACTIVE = $100;
  DFCS_PUSHED = $200;
  DFCS_CHECKED = $400;
  DFCS_TRANSPARENT = $800;
  DFCS_HOT = $1000;
  DFCS_ADJUSTRECT = $2000;
  DFCS_FLAT = $4000;
  DFCS_MONO = $8000;


function DrawText(Handle: QPainterH; var Text: WideString; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer; overload;
{ limited implementation of }
function DrawText(Handle: QPainterH; Text: PAnsiChar; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer; overload;
function DrawTextW(Handle: QPainterH; Text: PWideChar; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer; overload;

const
  { DrawText format (windows) flags }
  DT_TOP           = 0;
  DT_LEFT          = 0;
  DT_CENTER        = 1;
  DT_RIGHT         = 2;
  DT_VCENTER       = 4;
  DT_BOTTOM        = 8;
  DT_WORDBREAK     = $10;
  DT_SINGLELINE    = $20;
  DT_EXPANDTABS    = $40;
  DT_TABSTOP       = $80;
  DT_NOCLIP        = $100;
(* DT_EXTERNALLEADING = $200;  // not supported *)
  DT_CALCRECT      = $400;
  DT_NOPREFIX      = $800;
  DT_INTERNAL      = $1000;  // Uses the system font to calculate text metrics.
  DT_EDITCONTROL   = $2000;  // ignored
  DT_PATH_ELLIPSIS = $4000;
  DT_ELLIPSIS      = $8000;
  DT_END_ELLIPSIS  = DT_ELLIPSIS;
  DT_MODIFYSTRING  = $10000;
  DT_RTLREADING    = $20000; // ignored
  DT_WORD_ELLIPSIS = $40000;
  DT_HIDEPREFIX    = $100000;
  DT_PREFIXONLY    = $200000;

type
  TSysMetrics = (
    SM_CXSCREEN,  SM_CYSCREEN,
    SM_CXVSCROLL, SM_CYVSCROLL,
    SM_CXHSCROLL, SM_CYHSCROLL,
    SM_CXSMICON,  SM_CYSMICON,
    SM_CXICON,    SM_CYICON,
    SM_CXBORDER,  SM_CYBORDER,
    SM_CXFRAME,   SM_CYFRAME,
    SM_CYCAPTION
  );

{ limited implementation of }
function GetSystemMetrics(PropItem: TSysMetrics): Integer;

type
  TDeviceCap = (
    HORZSIZE,        {Horizontal size in millimeters}
    VERTSIZE,        {Vertical size in millimeters}
    HORZRES,         {Horizontal width in pixels}
    VERTRES,         {Vertical height in pixels}
    BITSPIXEL,       {Number of bits per pixel}
    NUMCOLORS,
    LOGPIXELSX,      {Logical pixelsinch in X}
    LOGPIXELSY,      {Logical pixelsinch in Y}
    PHYSICALWIDTH,   {Physical Width in device units}
    PHYSICALHEIGHT,  {Physical Height in device units}
    PHYSICALOFFSETX, {Physical Printable Area X margin}
    PHYSICALOFFSETY  {Physical Printable Area Y margin}
  );

{ (very) limited implementations of }
function GetDeviceCaps(Handle: QPainterH; devcap: TDeviceCap): Integer;
function GetTextMetrics(Handle: QPainterH; tt: TTextMetric): Integer;

type
  TMinMaxInfo = packed record
    ptReserved: TPoint;
    ptMaxSize: TPoint;
    ptMaxPosition: TPoint;
    ptMinTrackSize: TPoint;
    ptMaxTrackSize: TPoint;
  end;

(*)
  PPaintStruct = ^TPaintStruct;
  tagPAINTSTRUCT = packed record
    hdc: HDC;
    fErase: BOOL;
    rcPaint: TRect;
    fRestore: BOOL;
    fIncUpdate: BOOL;
    rgbReserved: array[0..31] of Byte;
  end;
  TPaintStruct = tagPAINTSTRUCT;
  PAINTSTRUCT = tagPAINTSTRUCT;
(*)
  TWindowPlacement = packed record
    length: Cardinal;
    flags: Integer;
    showCmd: UInt;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;
  PWindowPlacement = ^TWindowPlacement;


// widget related  function
function BringWindowToTop(Handle: QWidgetH): LongBool;
function CloseWindow(Handle: QWidgetH): LongBool;
function DestroyWindow(Handle: QWidgetH): LongBool;
function EnableWindow(Handle: QWidgetH; Value: Boolean): LongBool;
function GetClientRect(Handle: QWidgetH; var R: TRect): LongBool;
function GetFocus: QWidgetH;
function GetParent(Handle: QWidgetH): QWidgetH;
function SetParent(hWndChild, hWndNewParent: QWidgetH): QWidgetH;
function GetWindowPlacement(Handle: QWidgetH; W: PWindowPlacement): LongBool;
function GetWindowRect(Handle: QWidgetH; var  R: TRect): LongBool;
function WindowFromDC(Handle: QPainterH): QWidgetH;
function ChildWindowFromPoint(hWndParent: QWidgetH; Point: TPoint): QWidgetH; // hWndParent is ignored under Linux
function WindowFromPoint(Point: TPoint): QWidgetH;
function GetClassName(Handle: QWidgetH; Buffer: PChar; MaxCount: Integer): Integer;

function HWND_DESKTOP: QWidgetH;
function InvalidateRect(Handle: QWidgetH; R: PRect; EraseBackground: Boolean): LongBool;
function UpdateWindow(Handle: QWidgetH): LongBool;
function IsChild(ParentHandle, ChildHandle: QWidgetH): LongBool;
function IsWindowEnabled(Handle: QWidgetH): LongBool;
function IsWindowVisible(Handle: QWidgetH): LongBool;
function MapWindowPoints(WidgetTo, WidgetFrom: QWidgetH; var Points; nr: Cardinal): Integer;
function SetFocus(Handle: QWidgetH): QWidgetH;
function SetForegroundWindow(Handle: QWidgetH): LongBool;
function SetWindowPlacement(Handle: QWidgetH; W: PWindowPlacement): LongBool;
function SwitchToThisWindow(Handle: QWidgetH; Restore: Boolean): LongBool;

function ClientToScreen(Handle: QWidgetH; var Point: TPoint): LongBool;
function ScreenToClient(Handle: QWidgetH; var Point: TPoint): LongBool;
function SmallPointToPoint(const P: TSmallPoint): TPoint;
function PointToSmallPoint(const P: TPoint): TSmallPoint;

function SetWindowPos(Wnd, WndInsertAfter: QWidgetH; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool; overload;
function SetWindowPos(Wnd, WndInsertAfter: Cardinal; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool; overload;
function SetWindowPos(Wnd: QWidgetH; WndInsertAfter: Cardinal; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool; overload;

const
  { SetWindowPos Flags }
  SWP_NOSIZE = 1;
  SWP_NOMOVE = 2;
  SWP_NOZORDER = 4;
  SWP_NOREDRAW = 8;
  SWP_NOACTIVATE = $10;
  SWP_FRAMECHANGED = $20;    { The frame changed: send WM_NCCALCSIZE }
  SWP_SHOWWINDOW = $40;
  SWP_HIDEWINDOW = $80;
  SWP_NOCOPYBITS = $100; // ignored
  SWP_NOOWNERZORDER = $200;  { Don't do owner Z ordering }
  SWP_NOSENDCHANGING = $400;  // ignores
  SWP_DRAWFRAME = SWP_FRAMECHANGED;
  SWP_NOREPOSITION = SWP_NOOWNERZORDER;
  SWP_DEFERERASE = $2000;
  SWP_ASYNCWINDOWPOS = $4000; // ignored

  HWND_TOP = Cardinal(0);
  HWND_BOTTOM = Cardinal(1);
  HWND_TOPMOST = Cardinal(-1);
  HWND_NOTOPMOST = Cardinal(-2);

function ShowWindow(Handle: QWidgetH; showCmd: UInt): LongBool;

const
  { ShowWindow() Commands }
  SW_HIDE = 0;
  SW_SHOWNORMAL = 1;
  SW_NORMAL = 1;
  SW_SHOWMINIMIZED = 2;
  SW_SHOWMAXIMIZED = 3;
  SW_MAXIMIZE = 3;
  SW_SHOWNOACTIVATE = 4;
  SW_SHOW = 5;
  SW_MINIMIZE = 6;
  SW_SHOWMINNOACTIVE = 7;
  SW_SHOWNA = 8;
  SW_RESTORE = 9;
  SW_SHOWDEFAULT = 10;
  SW_MAX = 10;

function MessageBox(parent: QWidgetH; Text, Caption: string; WinFlags: Cardinal): Integer; overload;
function MessageBox(parent: QWidgetH; Text, Caption: WideString; WinFlags: Cardinal): Integer; overload;
function MessageBox(parent: QWidgetH; pText, pCaption: PChar; WinFlags: Cardinal): Integer; overload;
//function MessageBoxW(parent: QWidgetH; pText, pCaption: PWideChar; WinFlags: Cardinal): Integer;

const
  { MessageBox() WinFlags }
  MB_OK              = $0000;
  MB_OKCANCEL        = $0001;
  MB_ABORTRETRYIGNORE= $0002;
  MB_YESNOCANCEL     = $0003;
  MB_YESNO           = $0004;
  MB_RETRYCANCEL     = $0005;
  MB_HELP            = $4000; { Help Button not supported}
  MB_ICONHAND        = $0010;
  MB_ICONQUESTION    = $0020;
  MB_ICONEXCLAMATION = $0030;
  MB_ICONASTERISK    = $0040;
  MB_USERICON        = $0080;
  MB_DEFBUTTON1      = $0000;
  MB_DEFBUTTON2      = $0100;
  MB_DEFBUTTON3      = $0200;
  MB_DEFBUTTON4      = $0300;
  MB_ICONWARNING     = MB_ICONEXCLAMATION;
  MB_ICONERROR       = MB_ICONHAND;
  MB_ICONINFORMATION = MB_ICONASTERISK;
  MB_ICONSTOP        = MB_ICONHAND;

  { MessageBox() return values }
  IDCLOSE  = 0;
  IDOK     = 1;
  IDCANCEL = 2;
  IDYES    = 3;
  IDNO     = 4;
  IDABORT  = 5;
  IDRETRY  = 6;
  IDIGNORE = 7;
  { aliases }
  ID_OK      = IDOK;
  ID_CANCEL  = IDCANCEL;
  ID_ABORT   = IDABORT;
  ID_RETRY   = IDRETRY;
  ID_IGNORE  = IDIGNORE;
  ID_YES     = IDYES;
  ID_NO      = IDNO;
  ID_CLOSE   = IDCLOSE;
  IDHELP     = 9;        //  not supported
  ID_HELP    = IDHELP;  //  not supported
  IDTRYAGAIN = IDRETRY;
  IDCONTINUE = IDIGNORE;

function SelectObject(Handle: QPainterH; Font: QFontH): QFontH; overload;
function SelectObject(Handle: QPainterH; Brush: QBrushH): QBrushH; overload;
function SelectObject(Handle: QPainterH; Pen: QPenH): QPenH; overload;

// limited to CreateCompatibleDC Handles.
function SelectObject(Handle: QPainterH; Bitmap: QPixmapH): QPixmapH; overload;

// region related API's
type
  TCombineMode = (
    RGN_AND,  // Creates the intersection of the two combined regions.
    RGN_COPY,  // Creates a copy of the region identified by hrgnSrc1.
    RGN_DIFF,  // Combines the parts of hrgnSrc1 that are not part of hrgnSrc2.
    RGN_OR,    // Creates the union of two combined regions.
    RGN_XOR    // Creates the union of two combined regions except for any overlapping areas.
    );

function CombineRgn(DestRgn, Source1, Source2: QRegionH; Operation: TCombineMode): Integer;
function CreateEllipticRgn(Left, Top, Right, Bottom: Integer): QRegionH;
function CreateEllipticRgnIndirect(Rect: TRect): QRegionH;
//function CreatePolygonRgn(p1: TPointArray; FillMode: Integer): QRegionH;
function CreatePolygonRgn(const Points; Count, FillMode: Integer): QRegionH;
function CreateRectRgn(Left, Top, Right, Bottom: Integer): QRegionH;
function CreateRectRgnIndirect(Rect: TRect): QRegionH;
function CreateRoundRectRgn(x1, y1, x2, y2, WidthEllipse, HeightEllipse: Integer): QRegionH;
function DeleteObject(Region: QRegionH): LongBool; overload;
function EqualRgn(Rgn1, Rgn2: QRegionH): LongBool;
function FillRgn(Handle: QPainterH; Region: QRegionH; Brush: QBrushH): LongBool;
function GetClipRgn(Handle: QPainterH; rgn: QRegionH): Integer;
function ExcludeClipRect(Handle: QPainterH; X1, Y1, X2, Y2: Integer): Integer; overload;
function ExcludeClipRect(Handle: QPainterH; const R: TRect): Integer; overload;
function IntersectClipRect(Handle: QPainterH; X1, Y1, X2, Y2: Integer): Integer; overload;
function IntersectClipRect(Handle: QPainterH; const R: TRect): Integer; overload;
function InvertRgn(Handle: QPainterH; Region: QRegionH): LongBool;
function OffsetClipRgn(Handle: QPainterH; X, Y: Integer): Integer;
function OffsetRgn(Region: QRegionH; X, Y: Integer): Integer;
function PtInRegion(Rgn: QRegionH; X, Y: Integer): Boolean;
function RectInRegion(RGN: QRegionH; const Rect: TRect): LongBool;
function SelectClipRgn(Handle: QPainterH; Region: QRegionH): Integer;
function SetRectRgn(Rgn: QRegionH; X1, Y1, X2, Y2: Integer): LongBool;

const
  // constants for CreatePolygon
  ALTERNATE     = 1;
  WINDING       = 2;
  // CombineRgn return values
  NULLREGION    = 1;     // Region is empty
  SIMPLEREGION  = 2;     // Region is a rectangle
  COMPLEXREGION = 3;     // Region is not a rectangle
  ERROR          = 0;     // Region error
  RGN_ERROR     = ERROR;

// viewports
function SetViewportExtEx(Handle: QPainterH; XExt, YExt: Integer; Size: PSize): LongBool;
function SetViewPortOrgEx(Handle: QPainterH; X, Y: Integer; OldOrg: PPoint): LongBool;
function GetViewportExtEx(Handle: QPainterH; Size: PSize): LongBool;

// Text clipping
function TruncatePath(const FilePath: string; Canvas: TCanvas; MaxLen: Integer): string;
function TruncateName(const Name: WideString; Canvas: TCanvas; MaxLen: Integer): WideString;

procedure TextOutAngle(Handle: QPainterH; Angle, Left, Top: Integer; Text: WideString); overload;
procedure TextOutAngle(ACanvas: TCanvas; Angle, Left, Top: Integer; Text: WideString); overload;

procedure CopyMemory(Dest: Pointer; Src: Pointer; Len: Cardinal);
procedure FillMemory(Dest: Pointer; Len: Cardinal; Fill: Byte);
procedure MoveMemory(Dest: Pointer; Src: Pointer; Len: Cardinal);
procedure ZeroMemory(Dest: Pointer; Len: Cardinal);

{ ------------ Caret -------------- }
function CreateCaret(Widget: QWidgetH; Pixmap: QPixmapH; Width, Height: Integer): Boolean; overload;
function CreateCaret(Widget: QWidgetH; ColorCaret: Cardinal; Width, Height: Integer): Boolean; overload;
function GetCaretBlinkTime: Cardinal;
function SetCaretBlinkTime(uMSeconds: Cardinal): LongBool;
function HideCaret(Widget: QWidgetH): Boolean;
function ShowCaret(Widget: QWidgetH): Boolean;
function SetCaretPos(X, Y: Integer): Boolean;
function GetCaretPos(var Pt: TPoint): Boolean;
function DestroyCaret: Boolean;

function GetDoubleClickTime: Cardinal;
function SetDoubleClickTime(Interval: Cardinal): LongBool;

function Win2QtAlign(Flags: Integer): Integer;
function QtStdAlign(Flags: Integer): Word;

{ Message }
//  (ahuser) Do not rename PostMsg/SendMsg to PostMessage/SendMessage because
//  it is easier to find non-working PostMessage/SendMessage calls when the
//  compiler give you an error at these positions.
function Perform(Control: TControl; Msg: Cardinal; WParam, LParam: Longint): Longint;
{ Limitation: Handle must be a TWidgetControl derived class handle }
function PostMsg(Handle: QWidgetH; Msg: Integer; WParam, LParam: Longint): LongBool;
 { SendMsg synchronizes with the main thread }
function SendMsg(Handle: QWidgetH; Msg: Integer; WParam, LParam: Longint): Integer;


{$IFDEF LINUX}

resourcestring
  SFCreateError = 'Unable to create file %s';
  SFOpenError = 'Unable to open file %s';
  SReadError = 'Error reading file';
  SWriteError = 'Error writing file';

function CopyFile(lpExistingFileName, lpNewFileName: PChar;
  bFailIfExists: LongBool): LongBool; overload;
function CopyFileA(lpExistingFileName, lpNewFileName: PAnsiChar;
  bFailIfExists: LongBool): LongBool;
function CopyFileW(lpExistingFileName, lpNewFileName: PWideChar;
  bFailIfExists: LongBool): LongBool;
function CopyFile(const source: string; const destination: string;
  FailIfExists: Boolean): LongBool; overload;

function FileGetSize(const FileName: string): Cardinal;
function FileGetAttr(const FileName: string): Integer;
//function GetUserName(lpBuffer: PChar; var nSize: DWORD): LongBool;
//function GetComputerName(lpBuffer: PChar; var nSize: DWORD): LongBool;
function MakeIntResource(Value: Integer): PChar;
function GetTickCount: Cardinal;
procedure MessageBeep(Value: Integer);   // value ignored

{$ENDIF LINUX}

// easier QColor handling that prevents memory leaks
type
  IQColorGuard = interface
    function Handle: QColorH;
  end;

function QColorEx(Color: TColor): IQColorGuard;


implementation

{$IFDEF LINUX}
uses
  Libc, Xlib, Windows;
{$ENDIF LINUX}
{$IFDEF MSWINDOWS}
uses
  Windows;
{$ENDIF MSWINDOWS}

{---------------------------------------}
// easier QColor handling that prevents memory leaks
type
  TQColorGuard = class(TInterfacedObject, IQColorGuard)
  private
    FHandle: QColorH;
  public
    constructor Create(AColor: TColor);
    destructor Destroy; override;
    function Handle: QColorH;
  end;

{ TQColorGuard }
constructor TQColorGuard.Create(AColor: TColor);
begin
  inherited Create;
  FHandle := QColor(AColor);
end;

destructor TQColorGuard.Destroy;
begin
  QColor_destroy(FHandle);
  inherited Destroy;
end;

function TQColorGuard.Handle: QColorH;
begin
  Result := FHandle;
end;

function QColorEx(Color: TColor): IQColorGuard;
begin
  Result := TQColorGuard.Create(Color);
end;
{---------------------------------------}


// used internally
procedure MapPainterLPwh(Handle: QPainterH; var Width, Height: Integer); overload;
var
  Matrix: QWMatrixH;
begin
  if QPainter_hasWorldXForm(Handle) then
  begin
    Matrix := QPainter_worldMatrix(Handle);

    Matrix := QWMatrix_create(QWMatrix_m11(Matrix), QWMatrix_m12(Matrix),
      QWMatrix_m21(Matrix), QWMatrix_m22(Matrix), 0, 0);
    try
      QWMatrix_map(Matrix, Width, Height, @Width, @Height);
    finally
      QWMatrix_destroy(Matrix);
    end;
  end;
end;

procedure MapPainterLP(Handle: QPainterH; var x, y: Integer); overload;
var
  Matrix: QWMatrixH;
begin
  if QPainter_hasWorldXForm(Handle) then
  begin
    Matrix := QPainter_worldMatrix(Handle);
    QWMatrix_map(Matrix, x, y, @x, @y);
  end;
end;

procedure MapPainterLP(Handle: QPainterH; var x0, y0, x1, y1: Integer); overload;
var
  Matrix: QWMatrixH;
begin
  if QPainter_hasWorldXForm(Handle) then
  begin
    Matrix := QPainter_worldMatrix(Handle);
    QWMatrix_map(Matrix, x0, y0, @x0, @y0);
    QWMatrix_map(Matrix, x1, y1, @x1, @y1);
  end;
end;

procedure MapPainterLP(Handle: QPainterH; var R: TRect); overload;
var
  Matrix: QWMatrixH;
begin
  if QPainter_hasWorldXForm(Handle) then
  begin
    Matrix := QPainter_worldMatrix(Handle);
    QWMatrix_map(Matrix, PRect(@R), PRect(@R));
  end;
end;

procedure MapPainterLP(Handle: QPainterH; var Pt: TPoint); overload;
var
  Matrix: QWMatrixH;
begin
  if QPainter_hasWorldXForm(Handle) then
  begin
    Matrix := QPainter_worldMatrix(Handle);
    QWMatrix_map(Matrix, PPoint(@Pt), PPoint(@Pt));
  end;
end;

{---------------------------------------}
type
  PPainterInfo = ^TPainterInfo;
  TPainterInfo = record
    Painter: QPainterH;
    IsCompatibleDC: Boolean;
    TextAlignment: Cardinal;
    StetchBltMode: Integer;
  end;

var
  PainterInfos: TList = nil;

function GetPainterInfo(Handle: QPainterH; var Info: PPainterInfo): Boolean;
var
  i: Integer;
begin
  Result := False;
  Info := nil;
  if PainterInfos <> nil then
  begin
    for i := 0 to PainterInfos.Count - 1 do
      if PPainterInfo(PainterInfos[i])^.Painter = Handle then
      begin
        Result := True;
        Info := PPainterInfo(PainterInfos[i]);
        Exit;
      end;
  end;
end;

function NewPainterInfo(Handle: QPainterH): PPainterInfo;
begin
  New(Result);
  Result^.Painter := Handle;
  Result^.IsCompatibleDC := False;
  Result^.TextAlignment := TA_LEFT or TA_TOP;
  if PainterInfos = nil then
    PainterInfos := TList.Create;
  PainterInfos.Add(Result);
end;

function SetPainterInfo(Handle: QPainterH): PPainterInfo;
var
  i: Integer;
begin
  Result := nil;
  if PainterInfos <> nil then
  begin
    for i := 0 to PainterInfos.Count - 1 do
      if PPainterInfo(PainterInfos[i])^.Painter = Handle then
      begin
        Result := PPainterInfo(PainterInfos[i]);
        Exit;
      end;
  end;
  if Result = nil then
    Result := NewPainterInfo(Handle);
end;

procedure DeletePainterInfo(Handle: QPainterH);
var
  P: PPainterInfo;
begin
  if PainterInfos <> nil then
  begin
    if GetPainterInfo(Handle, P) then
    begin
      PainterInfos.Delete(PainterInfos.IndexOf(P));
      Dispose(P);
    end;
  end;
end;

procedure FreePainterInfos;
var
  i: Integer;
begin
  if PainterInfos <> nil then
  begin
    for i := 0 to PainterInfos.Count - 1 do
      Dispose(PPainterInfo(PainterInfos[i]));
    PainterInfos.Free;
  end;
end;
{----------------------------------------}

function DrawTextBiDiModeFlagsReadingOnly: Longint;
begin
  Result := 0;
end;

function DrawTextBiDiModeFlags(Flags: Longint): Longint;
begin
  Result := Flags;
end;

function UseRightToLeftAlignment: Boolean;
begin
  Result := False;
end;

function GetSysColor(SysColor: integer): TColorRef;
begin
  if (SysColor >= 0) and (SysColor <= COLOR_ENDCOLORS) then
    SysColor := GetSysColor( Win2TColor[SysColor] );
  case SysColor of
  clHintColor:
    Result := TColorRef(Application.HintColor);
  clDeskTop:
    Result := TColorRef(QColorColor(QWidget_BackgroundColor(QApplication_desktop)));
  else
    Result := TColorRef(Application.Palette.GetColor(SysColor));
  end;
end;

const
  ColorRoles: array[1..15] of TColorRole =(
    crForeground, crButton, crLight, crMidlight, crDark, crMid,
    crText, crBrightText, crButtonText, crBase, crBackground, crShadow,
    crHighlight, crHighlightText, crNoRole);

function SetSysColor(RefColor: TColor; TrueColor: TColorRef): boolean;
var
  QC: QColorH;
begin
  with Application.Palette do
    if (TrueColor >= TColor(0)) and (TrueColor <= TColor($FFFFFF)) then
    begin
      Result := true;
      case RefColor of
      clNormalNoRole..clNormalForeground:
        SetColor(cgInactive, ColorRoles[-(RefColor+cloNormal)], TrueColor);
      clDisabledNoRole..clDisabledForeground:
        SetColor(cgDisabled, ColorRoles[-(RefColor+cloDisabled)], TrueColor);
      clActiveNoRole..clActiveForeground:
        SetColor(cgActive, ColorRoles[-(RefColor+cloActive)], TrueColor);
      clHintColor:
        Application.HintColor := TrueColor;
      clDeskTop:
        begin
          QC := QColor(TrueColor);
          QWidget_setBackGroundColor(QApplication_desktop, QC);
          QColor_destroy(QC);
        end;
      else   // case
        Result := False
      end;
    end
    else  // if
      Result := false;   // only rgb values are accepted
end;


function SetSysColors(Elements: Integer; const lpaElements;
  const lpaRgbValues): LongBool;
var
  i: integer;
  refcolor : PColor;
  realcolor : PColor;
begin
  Result := true;
  refcolor := PColor(lpaElements);
  realcolor := PColor(lpaRGBvalues);
  Application.Palette.BeginUpdate;
  for i := 0 to Elements-1 do
  begin
    if not SetSysColor( refcolor^, realcolor^)
    then
      Result := false;
    inc(refcolor);
    inc(realcolor);
  end;
  Application.Palette.EndUpdate;
end;

function CreatePen(Style, Width: Integer; Color: TColorRef): QPenH;
begin
  Result := QPen_create(QColorEx(Color).Handle, Width, PenStyle(Style));
end;

function DeleteObject(Handle: QPenH): LongBool;
begin
  try
    QPen_destroy(Handle);
    Result := True;
  except
    Result := False;
  end;
end;

function CreateSolidBrush(crColor: TColorRef): QBrushH;
begin
  Result := QBrush_create(QColorEx(crColor).Handle, BrushStyle_SolidPattern);
end;

function CreateHatchBrush(bStyle: BrushStyle; crColor: TColorRef): QBrushH;
begin
  Result := QBrush_create(QColorEx(crColor).Handle, bStyle);
end;

function DeleteObject(Handle: QBrushH): LongBool;
begin
  Result := False;
  if Handle <> nil then
  begin
    try
      QBrush_destroy(Handle);
      Result := True;
    except
    end;
  end;
end;

function EnableWindow(Handle: QWidgetH; Value: Boolean): LongBool;
begin
  try
    QWidget_setEnabled(Handle, Value);
    Result := True;
  except
    Result := False;
  end;
end;

function SetWindowPlacement(Handle: QWidgetH; W: PWindowPlacement): LongBool;
begin
  try
    with W.rcNormalPosition do
       QWidget_setGeometry(Handle, Left, Top, Right - Left, Bottom - Top);
    Result := ShowWindow(Handle, W.ShowCmd);
  except
    Result := False;
  end;
end;

{function SetWindowPos(Handle: QWidgetH; W: PWindowPlacement): LongBool;
begin // (ahuser) unused and not in the interface section
  try
    with W.rcNormalPosition do
       QWidget_setGeometry(Handle, Left, Top, Right - Left, Bottom - Top);
    Result := ShowWindow(Handle, W.ShowCmd);
  except
    Result := False;
  end;
end;}

function GetWindowPlacement(Handle: QWidgetH; W: PWindowPlacement): LongBool;
var
  R: TRect;
begin
  try
    QWidget_geometry(Handle, @R);
    W.rcNormalPosition.Left := R.Left;
    W.rcNormalPosition.Top := R.Top;
    W.rcNormalPosition.Right := R.Right;
    W.rcNormalPosition.Bottom := R.Left;
    if QWidget_isMinimized(Handle) then
      W.showCmd := SW_SHOWMINIMIZED
    else if QWidget_isMaximized(Handle) then
      W.showCmd := SW_SHOWMAXIMIZED
    else if not QWidget_isVisible(Handle) then
      W.showCmd := SW_HIDE
    else
      W.showCmd := SW_SHOWNORMAL;
    Result := True;
  except
    Result := False;
  end;
end;

function GetWindowRect(Handle: QWidgetH; var R: TRect): LongBool;
begin
  try
    QWidget_frameGeometry(Handle, @R);
    Result := True;
  except
    Result := False;
  end;
end;

function GetClientRect(Handle: QWidgetH; var R: TRect): LongBool;
begin
  try
    QWidget_rect(Handle, @R);
    Result := True;
  except
    Result := False;
  end;
end;

function ShowWindow(Handle: QWidgetH; showCmd: UInt): LongBool;
var
  ActWidget: QWidgetH;
begin
  try
    case ShowCmd of
      SW_MINIMIZE, SW_SHOWMINIMIZED:
        QWidget_showMinimized(Handle);
      SW_MAXIMIZE:
        QWidget_showMaximized(Handle);
      SW_HIDE:
        QWidget_hide(Handle);
      SW_SHOWNOACTIVATE, SW_SHOWMINNOACTIVE:
        begin
          ActWidget := QApplication_activeWindow(Application.Handle);
          if ShowCmd = SW_SHOWNOACTIVATE then
            QWidget_showNormal(Handle)
          else
            QWidget_showMinimized(Handle);
          if Assigned(ActWidget) then
            QWidget_setActiveWindow(ActWidget);
        end;
    else
      QWidget_showNormal(Handle);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

type
  TOpenWidgetControl = class(TWidgetControl);

function SetWindowPos(Wnd, WndInsertAfter: QWidgetH; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool;
var
  R, Geometry: TRect;
  WidgetFlags: Cardinal;
  Control: TOpenWidgetControl;
  LastActiveWidget: QWidgetH;
  LastActiveWinId: Cardinal;
begin
  Result := False;
  if Wnd = nil then
    Exit;
  try
    LastActiveWidget := QApplication_activeWindow(Application.Handle);
    LastActiveWinId := QWidget_winId(LastActiveWidget);

    // we must use CLX methods or CLX will be a pain.
    Control := TOpenWidgetControl(FindControl(Wnd));

    if Control <> nil then
      Geometry := Control.BoundsRect
    else
      QWidget_geometry(Wnd, @Geometry);

    if uFlags and SWP_HIDEWINDOW <> 0 then
    begin
      if Control <> nil then
        Control.Hide
      else
        QWidget_hide(Wnd);
    end;

    if uFlags and SWP_NOSIZE <> 0 then
    begin
      cx := Geometry.Right - Geometry.Left;
      cy := Geometry.Bottom - Geometry.Top;
    end;
    if uFlags and SWP_NOMOVE <> 0 then
    begin
      X := Geometry.Left;
      Y := Geometry.Top;
    end;
    R := Rect(X, Y, X + cx, Y + cy);
    if not EqualRect(R, Geometry) then
    begin
      if Control <> nil then
        Control.BoundsRect := R
      else
        QWidget_setGeometry(Wnd, X, Y, cx, cy);
    end;

    if uFlags and SWP_FRAMECHANGED <> 0 then
    begin
      QWidget_adjustSize(Wnd);
      if Control <> nil then
        Control.AdjustSize;
    end;

    if (uFlags and SWP_NOOWNERZORDER = 0) then
      if (not QWidget_isTopLevel(Wnd)) and (QWidget_parentWidget(Wnd) <> nil) then
        SetWindowPos(QWidget_parentWidget(Wnd), WndInsertAfter, 0, 0, 0, 0,
          SWP_NOSIZE or SWP_NOMOVE or SWP_NOREDRAW or SWP_NOACTIVATE or
          SWP_NOCOPYBITS or SWP_NOSENDCHANGING);

    if (uFlags and SWP_NOZORDER = 0) then
    begin
      WidgetFlags := QOpenWidget_getWFlags(QOpenWidgetH(Wnd));

      case Cardinal(WndInsertAfter) of
        HWND_TOP:
          QWidget_raise(Wnd);
        HWND_BOTTOM:
          QWidget_lower(Wnd);
        HWND_TOPMOST:
          if (Control <> nil) and (TWidgetControl(Control) is TForm) then
            TForm(Control).FormStyle := fsStayOnTop
          else
            QOpenWidget_setWFlags(QOpenWidgetH(Wnd),
              WidgetFlags or Cardinal(WidgetFlags_WStyle_StaysOnTop));
        HWND_NOTOPMOST:
          if (Control <> nil) and (TWidgetControl(Control) is TForm) then
            TForm(Control).FormStyle := fsNormal
          else
            QOpenWidget_setWFlags(QOpenWidgetH(Wnd),
              WidgetFlags and not Cardinal(WidgetFlags_WStyle_StaysOnTop));
      else
       // remove top most state
        if WidgetFlags and Cardinal(WidgetFlags_WStyle_StaysOnTop) <> 0 then
        begin
          if (Control <> nil) and (TWidgetControl(Control) is TForm) then
            TForm(Control).FormStyle := fsNormal
          else
            QOpenWidget_setWFlags(QOpenWidgetH(Wnd),
              WidgetFlags and not Cardinal(WidgetFlags_WStyle_StaysOnTop));
        end;
        // after widget
        QWidget_stackUnder(Wnd, WndInsertAfter);
      end;
    end;

    if uFlags and SWP_SHOWWINDOW <> 0 then
    begin
      if Control <> nil then
        Control.Show
      else
        QWidget_show(Wnd);
    end;

    if (uFlags and SWP_NOACTIVATE = 0) and (QWidget_isVisible(Wnd)) then
      QWidget_setActiveWindow(Wnd);

    if (uFlags and SWP_NOREDRAW = 0) and (QWidget_isVisible(Wnd)) then
      QWidget_update(Wnd);

    if (uFlags and SWP_NOACTIVATE <> 0) and Assigned(LastActiveWidget) then
      if QWidget_find(LastActiveWinId) = LastActiveWidget then // valid LastActiveWidget
        QWidget_setActiveWindow(LastActiveWidget);
  except
    Result := False;
  end;
end;

function SetWindowPos(Wnd, WndInsertAfter: Cardinal; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool;
begin
  Result := SetWindowPos(QWidgetH(Wnd), QWidgetH(WndInsertAfter), X, Y, cx, cy, uFlags);
end;

function SetWindowPos(Wnd: QWidgetH; WndInsertAfter: Cardinal; X, Y, cx, cy: Integer;
  uFlags: LongWord): LongBool;
begin
  Result := SetWindowPos(Wnd, QWidgetH(WndInsertAfter), X, Y, cx, cy, uFlags);
end;

function IsWindowVisible(Handle: QWidgetH): LongBool;
begin
  Result := QWidget_isVisible(Handle);
end;

function IsWindowEnabled(Handle: QWidgetH): LongBool;
begin
  Result := QWidget_isEnabled(Handle);
end;

function SetFocus(Handle: QWidgetH): QWidgetH;
begin
  try
    Result := GetFocus;
    QWidget_setFocus(Handle);
  except
    Result := nil;
  end;
end;

function GetFocus: QWidgetH;
begin
  Result := QApplication_focusWidget(Application.Handle);
end;

function GetBkMode(Handle: QPainterH): Integer;
begin
  case QPainter_BackgroundMode(Handle) of
    BGMode_TransparentMode:
      Result := TRANSPARENT; // BGMode_TransparentMode
    BGMode_OpaqueMode:
      Result := OPAQUE; // BGMode_OpaqueMode
  else
    Result := OPAQUE;
  end;
end;

function SetBkMode(Handle: QPainterH; BkMode: Integer): Integer;
begin
  Result := GetBkMode(Handle);
  case BkMode of
    TRANSPARENT:
      QPainter_setBackgroundMode(Handle, BGMode_TransparentMode);
    OPAQUE:
      QPainter_setBackgroundMode(Handle, BGMode_OpaqueMode);
  end;
end;

function SetPenColor(Handle: QPainterH; Color: TColor): TColor;
begin
  Result :=  QColorColor(QPen_color(QPainter_pen(Handle)));
  QPainter_setPen(Handle, QColorEx(Color).Handle);
end;

function SetTextColor(Handle: QPainterH; Color: TColor): TColor;
begin
  Result := SetPenColor(Handle, Color);
end;

function SetBkColor(Handle: QPainterH; Color: TColor): TColor;
begin
  Result := QColorColor(QPainter_backgroundColor(Handle));
  QPainter_setBackGroundColor(Handle, QColorEx(Color).Handle);
end;

function SetDCBrushColor(Handle: QPainterH; Color: TColorRef): TColorRef;
begin
  Result := QColorColor(QBrush_color(QPainter_brush(Handle)));
  QPainter_setBrush(Handle, QColorEx(Color).Handle);
end;

function SetDCPenColor(Handle: QPainterH; Color: TColorRef): TColorRef;
begin
  Result := SetPenColor(Handle, Color);
end;

function GetParent(Handle: QWidgetH): QWidgetH;
begin
  Result := QWidget_parentWidget(Handle);
end;

function SetParent(hWndChild, hWndNewParent: QWidgetH): QWidgetH;
var
  Pt: TPoint;
begin
  try
    Result := GetParent(hWndChild);
    QWidget_pos(hWndChild, @Pt);
    QWidget_reparent(hWndChild, hWndNewParent, @Pt, QWidget_isVisible(hWndChild));
  except
    Result := nil;
  end;
end;

function RasterOpToWinRop(Rop: RasterOp): cardinal;
begin
  case Rop of
    RasterOp_ClearROP   : Result := BLACKNESS;
    RasterOp_NotROP     : Result := DSTINVERT;
    RasterOp_NotOrRop   : Result := MERGEPAINT;
    RasterOp_NotCopyROP : Result := NOTSRCCOPY;
    RasterOp_NorROP     : Result := NOTSRCERASE;
    RasterOp_AndROP     : Result := SRCAND;
    RasterOp_CopyROP    : Result := SRCCOPY;
    RasterOp_AndNotROP  : Result := SRCERASE;
    RasterOp_XorROP     : Result := SRCINVERT;
    RasterOp_OrROP      : Result := SRCPAINT;
    RasterOp_SetROP     : Result := WHITENESS;
    RasterOp_NotAndROP  : Result := ROP_DSna;
    RasterOp_NopROP     : Result := ROP_D;
    RasterOp_OrNotROP   : Result := ROP_SDno;
    RasterOp_NandROP    : Result := ROP_DSan;
  else
    Result := 0;   // to satisfy compiler
  end;
end;

function WinRopToRasterOp(WinRop: Cardinal; var Rop: RasterOp): Boolean;
begin
  Result := True;
  case WinRop of
    BLACKNESS  : Rop := RasterOp_ClearROP;
    DSTINVERT  : Rop := RasterOp_NotROP;
//    MERGECOPY  : Rop := RasterOp_OrROP;     {DSa}
    MERGEPAINT : Rop := RasterOp_NotOrRop;
    NOTSRCCOPY : Rop := RasterOp_NotCopyROP;
    NOTSRCERASE: Rop := RasterOp_NorROP;
    SRCAND     : Rop := RasterOp_AndROP;
    SRCCOPY    : Rop := RasterOp_CopyROP;
    SRCERASE   : Rop := RasterOp_AndNotROP;
    SRCINVERT  : Rop := RasterOp_XorROP;
    SRCPAINT   : Rop := RasterOp_OrROP;
    WHITENESS  : Rop := RasterOp_SetROP;
    ROP_DSna   : Rop := RasterOp_NotAndROP;
    ROP_D      : Rop := RasterOp_NopROP;
    ROP_SDno   : Rop := RasterOp_OrNotROP;
    ROP_DSan   : Rop := RasterOp_NandROP;
  else
    Rop := RasterOp(-1);
    Result := False;
  end;
end;

function PatternPaint(DestDC: QPainterH; X, Y, W, H: Integer; rop: RasterOp): LongBool;
var
  trop: RasterOp;
  bkmode: Integer;
begin
  try
    trop := QPainter_rasterOp(DestDC);
    bkmode := SetBkMode(DestDC, OPAQUE);
    try
      QPainter_setRasterOp(DestDC, rop);    // asn: or use current ?
      QPainter_fillRect(DestDC, X, Y, W, H, QPainter_brush(DestDC)); // current brush
    finally
      QPainter_setRasterOp(DestDC, trop);
      SetBkMode(DestDC, bkmode);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function BitBlt(DestDC: QPainterH; X, Y, Width, Height: Integer; SrcDC: QPainterH;
  XSrc, YSrc: Integer; WinRop: Cardinal): LongBool;
var
  TempDC: QPainterH;
  Rop: RasterOp;
begin
  if WinRopToRasterOp(WinRop, Rop) then  // directly maps ?
    Result := BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, Rop)
  else // no
  begin
    case WinRop of
      MERGECOPY: { PSa: Dest := Pattern AND Source }
        begin
          try
            TempDC := CreateCompatibleDC(DestDC, Width, Height);
            try
              PatternPaint(TempDc, 0, 0, Width, Height, RasterOp_CopyROP); // Create Pattern
              BitBlt(TempDc, 0, 0, Width, Height, SrcDC, XSrc, YSrc, RasterOp_AndRop); {PSa}
              Result := BitBlt(DestDc, X, Y, Width, Height, tempDC, XSrc, YSrc, RasterOp_CopyROP);
            except
              Result := false;
            end;
            QPainter_destroy(tempDC);
          except
            Result := false;
          end;
        end;

      PATCOPY:
        Result := PatternPaint(DestDC, X, Y, Width, Height, RasterOp_CopyROP);

      PATINVERT:
        Result := PatternPaint(DestDC, X, Y, Width, Height, RasterOp_XorROP);

      PATPAINT:
        begin  // DPSnoo   = PDSnoo
          Result := BitBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc,
                           RasterOp_NotOrRop); // DSno
          if Result then
            Result := PatternPaint(DestDC, X, Y, Width, Height, RasterOp_XOrROP);
        end;

      ROP_DSPDxax:
        begin
          TempDC := CreateCompatibleDC(DestDC, Width, Height);
          try
            // copy DestDC to pixmap
            BitBlt(TempDC, 0, 0, Width, Height, DestDC, X, Y,  RasterOp_CopyROP);
            BitBlt(TempDC, 0, 0, Width, Height, TempDC, 0, 0, PATINVERT);  // PDx
            BitBlt(TempDC, 0, 0, Width, Height, SrcDC, XSrc, YSrc, RasterOp_AndROP); // SPDxa
            Result := BitBlt(DestDC, X, Y, Width, Height, TempDC, 0, 0, RasterOp_XorROP); // DSPDxax
          except
            Result := False;
          end;
          DeleteObject(TempDC);
        end;
    else
      Result := False;
    end;
  end
end;

function BitBlt(DestDC: QPainterH; X, Y, Width, Height: Integer; SrcDC: QPainterH;
  XSrc, YSrc: Integer; Rop: RasterOp): LongBool;
var
  d_dx, d_dy, d_sx, d_sy, d_sw, d_sh, d_dw, d_dh: Integer;
begin
  if (DestDC = nil) or (SrcDC = nil) then
    Result := False
  else
  begin
    Result := True;
    try
     // Windows's BitBlt uses logical units
      d_dx := X;d_dy := Y;d_dw := Width;d_dh := Height;
      d_sx := XSrc; d_sy := YSrc;d_sw := Width; d_sh := Height;
      MapPainterLP(DestDC, d_dx, d_dy);
      MapPainterLPwh(DestDC, d_dw, d_dh);
      MapPainterLP(SrcDC, d_sx, d_sy);
      MapPainterLPwh(SrcDC, d_sw, d_sh);

      if (d_dw = d_sw) and (d_dh = d_sh) then // device bitBlt possible
        Qt.bitBlt(QPainter_device(DestDC), d_dx, d_dy, QPainter_device(SrcDC),
          d_sx, d_sy, d_sw, d_sh, Rop,
          True) // ignore the Mask because Windows's BitBlt does not use Masks
      else
        StretchBlt(DestDC, X, Y, Width, Height, SrcDC, XSrc, YSrc, Width, Height,
          Rop);  
    except
      Result := False;
    end;
  end;
end;

function PatBlt(Handle: QPainterH; X, Y, Width, Height: Integer; WinRop: Cardinal): LongBool;
begin
  Result := BitBlt(Handle, X, Y, Width, Height, Handle, X, Y, WinRop);
end;

function StretchBlt(dst: QPainterH; dx, dy, dw, dh: Integer;
  src: QPainterH; sx, sy, sw, sh: Integer;
  winrop: Cardinal): LongBool;
var
  bmp1, bmp2: QPixmapH;
  painter : QPainterH;
  d_sx, d_sy, d_sw, d_sh: Integer;
  d_dx, d_dy, d_dw, d_dh: Integer;
begin
  Result := False;
  if (dst = nil) and (QPainter_isActive(dst)) then
    Exit;

 // Windows's StretchBlt uses logical units
  d_sx := sx;d_sy := sy;d_sw := sw;d_sh := sh;
  d_dx := dx;d_dy := dy;d_dw := dw;d_dh := dh;
  MapPainterLP(dst, d_dx, d_dy);
  MapPainterLPwh(dst, d_dw, d_dh);
  MapPainterLP(src, d_sx, d_sy);
  MapPainterLPwh(src, d_sw, d_sh);

  if (d_dw = d_sw) and (d_dh = d_sh) then // device bitBlt possible
    Result := BitBlt(dst, dx, dy, dw, dh, src, sx, sy, winrop)
  else
  begin
    if not QPainter_isActive(src) then
      Exit;
    // written by Andr� Snepvangers
    // - supports same winrop as bitblt(..., winrop)
    // - destination and source don't have to be compatible with one and another
    try
      bmp1 := nil;
      bmp2 := nil;
      try
       // temporary bitmaps are in device units
        bmp1 := CreateCompatibleBitmap(src, d_sw, d_sh);
        bmp2 := CreateCompatibleBitmap(dst, d_dw, d_dh);
        Qt.bitBlt(bmp1, 0, 0, QPainter_device(src), d_sx, d_sy, d_sw, d_sh,
          RasterOp_CopyROP, True); // use device units
        painter := QPainter_create(bmp2);
        QPainter_save(painter);
        QPainter_scale(painter, d_dw/d_sw, d_dh/d_sh);
        QPainter_drawPixmap(painter, 0, 0, bmp1, 0, 0, d_sw, d_sh);
        QPainter_restore(painter);
        Result := BitBlt(dst, dx, dy, dw, dh, Painter, 0, 0, winrop); // maps logical units
        QPainter_destroy(Painter);
      finally
        if Assigned(bmp1) then
          QPixmap_destroy(bmp1);
        if Assigned(bmp2) then
          QPixmap_destroy(bmp2);
      end;
    except
      Result := False;
    end;
  end;
end;

function StretchBlt(dst: QPainterH; dx, dy, dw, dh: Integer; src: QPainterH;
  sx, sy, sw, sh: Integer; Rop: RasterOp): LongBool;
begin
  Result := StretchBlt(dst, dx, dy, dw, dh,
                       src, sx, sy, sw, sh,
                       RasterOpToWinRop(Rop));
end;

function GetStretchBltMode(DC: QPainterH): Integer;
var
  P: PPainterInfo;
begin
  if DC <> nil then
  begin
    if GetPainterInfo(DC, P) then
      Result := P.StetchBltMode
    else
      Result := STRETCH_DELETESCANS;
  end
  else
    Result := 0;
end;

function SetStretchBltMode(DC: QPainterH; StretchMode: Integer): Integer;
begin
  try
    Result := GetStretchBltMode(DC);
    SetPainterInfo(DC).StetchBltMode := StretchMode;
  except
    Result := 0;
  end;
end;

function SetROP2(Handle: QPainterH; Rop: Integer): Integer;
var
  rop2: RasterOp;
begin
  case Rop of
    R2_BLACK      : rop2 := RasterOp_ClearROP;
    R2_WHITE      : rop2 := RasterOp_SetROP;
    R2_NOP        : rop2 := RasterOp_NopROP;
    R2_NOT        : rop2 := RasterOp_NotROP;
    R2_COPYPEN    : rop2 := RasterOp_CopyROP;
    R2_NOTCOPYPEN : rop2 := RasterOp_NotCopyROP;
    R2_MERGEPENNOT: rop2 := RasterOp_OrNotROP;
    R2_MASKPENNOT : rop2 := RasterOp_AndNotROP;
    R2_MERGEPEN   : rop2 := RasterOp_OrROP;
    R2_NOTMERGEPEN: rop2 := RasterOp_NorROP;
    R2_MASKPEN    : rop2 := RasterOp_AndROP;
    R2_NOTMASKPEN : rop2 := RasterOp_NandROP;
    R2_XORPEN     : rop2 := RasterOp_XorROP;
    R2_NOTXORPEN  : rop2 := RasterOp_NotXorROP;
    R2_MASKNOTPEN : rop2 := RasterOp_NotAndROP;
    R2_MERGENOTPEN: rop2 := RasterOp_NotOrROP;
  else
    Result := -1;
    Exit;
  end;
  Result := GetROP2(Handle);
  QPainter_setRasterOp(Handle, rop2);
end;

function GetROP2(Handle: QPainterH): Integer;
var
  rop2: RasterOp;
begin
  rop2 := QPainter_rasterOp(Handle);
  case rop2 of
    RasterOp_ClearROP  : Result := R2_BLACK;
    RasterOp_SetROP    : Result := R2_WHITE;
    RasterOp_NopROP    : Result := R2_NOP;
    RasterOp_NotROP    : Result := R2_NOT;
    RasterOp_CopyROP   : Result := R2_COPYPEN;
    RasterOp_NotCopyROP: Result := R2_NOTCOPYPEN;
    RasterOp_OrNotROP  : Result := R2_MERGEPENNOT;
    RasterOp_AndNotROP : Result := R2_MASKPENNOT;
    RasterOp_OrROP     : Result := R2_MERGEPEN;
    RasterOp_NorROP    : Result := R2_NOTMERGEPEN;
    RasterOp_AndROP    : Result := R2_MASKPEN;
    RasterOp_NandROP   : Result := R2_NOTMASKPEN;
    RasterOp_XorROP    : Result := R2_XORPEN;
    RasterOp_NotXorROP : Result := R2_NOTXORPEN;
    RasterOp_NotAndROP : Result := R2_MASKNOTPEN;
    RasterOp_NotOrROP  : Result := R2_MERGENOTPEN;
  else
    Result := -1;
  end;
end;

function SetForegroundWindow(Handle: QWidgetH): LongBool;
begin
  try
    Result := QWidget_isTopLevel(Handle);
    if Result then
      QWidget_raise(Handle);
  except
    Result := False;
  end;
end;

function BringWindowToTop(Handle: QWidgetH): LongBool;
begin
  try
    while not QWidget_isTopLevel(Handle) do
      Handle := QWidget_parentWidget(Handle);
    Result := Handle <> nil;
    if Result then
    begin
      QWidget_show(Handle);
      QWidget_raise(Handle);
    end;
  except
    Result := False;
  end;
end;

function SwitchToThisWindow(Handle: QWidgetH; Restore: Boolean): LongBool;
begin
  try
    Result := QWidget_isTopLevel(Handle);
    if Result then
    begin
      if Restore then
        QWidget_show(Handle);
      QWidget_setActiveWindow(Handle);
    end;
  except
    Result:= True;
  end;
end;

function CloseWindow(Handle: QWidgetH): LongBool;
begin
  try
    Result := QWidget_isTopLevel(Handle);
    if Result then
      QWidget_close(Handle)
  except
    Result := False;
  end;
end;

function DestroyWindow(Handle: QWidgetH): LongBool;
begin
  try
    Result := QWidget_isTopLevel(Handle);
    if Result then
      QWidget_destroy(Handle);
  except
    Result := False;
  end;
end;

function WindowFromDC(Handle: QPainterH): QWidgetH;
var
  WinId: Cardinal;
  {$IFDEF MSWINDOWS}
  WinDC: Windows.HDC;
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  dev: QPaintDeviceH;
  {$ENDIF LINUX}
begin
  Result := nil;
  try
    WinId := 0;
    {$IFDEF MSWINDOWS}
    WinDC := QPainter_handle(Handle);
    if WinDC <> 0 then
      WinId := Cardinal(Windows.WindowFromDC(WinDC));
    {$ENDIF MSWINDOWS}
    {$IFDEF LINUX}
    dev := QPainter_device(Handle);
    if dev <> nil then
      WinId := Cardinal(QPaintDevice_handle(dev));
    {$ENDIF LINUX}
    if WinId <> 0 then
      Result := QWidget_find(WinId);
  except
    Result := nil;
  end;
end;

function ChildWindowFromPoint(hWndParent: QWidgetH; Point: TPoint): QWidgetH;
{$IFDEF MSWINDOWS}
var
  WinId, ChildWinId: Cardinal;
  Widget: QWidgetH;
  Pt: TPoint;
{$ENDIF MSWINDOWS}
begin
  Result := nil;
  if hWndParent = nil then
    Exit;
  try
    {$IFDEF MSWINDOWS}
    WinId := QWidget_winId(hWndParent);
    if WinId <> 0 then
    begin
      Widget := QWidget_find(WinId);
      if Widget <> nil then
      begin
        Pt := Point;
        QWidget_mapFromGlobal(Widget, @Pt, @Pt); // missing in QApplicatin::WidgetAt() Windows implementation
        ChildWinId := Cardinal(Windows.ChildWindowFromPoint(WinId, Pt));
        if (ChildWinId <> 0) and (ChildWinId <> WinId) then
          Result := QWidget_find(ChildWinId)
        else
          Result := Widget;
      end;
    end;
    {$ENDIF MSWINDOWS}
    {$IFDEF LINUX}
    Result := QApplication_widgetAt(@Point, True);
    {$ENDIF LINUX}
  except
    Result := nil;
  end;
end;

function WindowFromPoint(Point: TPoint): QWidgetH;
begin
  try
    Result := QApplication_widgetAt(@Point, False);
  except
    Result := nil;
  end;
end;

function GetClassName(Handle: QWidgetH; Buffer: PChar; MaxCount: Integer): Integer;
begin
  Result := 0;
  if Handle <> nil then
  begin
    Result := Length(QObject_className(Handle));
    if Buffer <> nil then
      StrLCopy(Buffer, QObject_className(Handle), MaxCount);
  end;
end;

function ClientToScreen(Handle: QWidgetH; var Point: TPoint): LongBool;
begin
  try
    QWidget_mapToGlobal(Handle, @Point, @Point);
    Result := True;
  except
    Result := False;
  end;
end;

function ScreenToClient(Handle: QWidgetH; var Point: TPoint): LongBool;
begin
  try
    QWidget_mapFromGlobal(Handle, @Point, @Point);
    Result := True;
  except
    Result := False;
  end;
end;

function SmallPointToPoint(const P: TSmallPoint): TPoint;
begin
  Result := Point(P.x, P.y);
end;

function PointToSmallPoint(const P: TPoint): TSmallPoint;
begin
  Result.x := SmallInt(P.X);
  Result.y := SmallInt(P.Y);
end;

function MapWindowPoints(WidgetTo, WidgetFrom: QWidgetH; var Points; nr: Cardinal): Integer;
var
  i: Integer;
  p1: PPoint;
  p2: TPoint;
begin
  p1 := @Points;
  try
    if (IsChild(WidgetTo, WidgetFrom)) and (nr > 0) then
    begin
      QWidget_mapTo(WidgetFrom, p1, WidgetTo, @p2);
      Result := (((p2.Y - p1.Y) shl 16) {and Integer($FFFF0000)}) +
                ((p2.X - p1.X) and $0000FFFF);
      for i:= 0 to nr - 1 do
      begin
        QWidget_mapTo(WidgetFrom, p1, WidgetTo, p1);
        Inc(p1);
      end;
    end
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

function InvalidateRect(Handle: QWidgetH; R: PRect; EraseBackground: Boolean): LongBool;
begin
  Result := False;
  if Handle <> nil then
    Exit;
  try
    QWidget_repaint(Handle, R, erasebackground);
    Result := True;
  except
    Result := False;
  end;
end;

function UpdateWindow(Handle: QWidgetH): LongBool;
begin
  Result := False;
  if Handle <> nil then
    Exit;
  try
    QWidget_update(Handle);
    Result := True;
  except
    Result := False;
  end;
end;

function IsChild(ParentHandle, ChildHandle: QWidgetH): LongBool;
var
  ParentH: QWidgetH;
begin
  Result := False;
  ParentH := QWidget_parentWidget(ChildHandle);
  while (ParentH <> nil) and (not Result) do
  begin
    Result := ParentH = ParentHandle;
    ParentH := QWidget_parentWidget(ParentH);
  end;
end;

function MessageBox(parent: QWidgetH; Text, Caption: WideString; WinFlags: Cardinal): Integer; overload;
var
  Button0, Button1, Button2: Integer;
const
  ButtonOk = 1;
  ButtonCancel = 2;
  ButtonYes = 3;
  ButtonNo = 4;
  ButtonAbort = 5;
  ButtonRetry = 6;
  ButtonIgnore = 7;
  ButtonDefault = $100;
  ButtonEscape = $200;
begin
  case (WinFlags and $7) of
    MB_OKCANCEL:
      begin
        Button0 := ButtonOk;
        Button1 := ButtonCancel or ButtonEscape;
        Button2 := 0;
      end;
    MB_ABORTRETRYIGNORE:
      begin
        Button0 := ButtonAbort;
        Button1 := ButtonRetry or ButtonDefault;
        Button2 := ButtonIgnore;
      end;
    MB_YESNOCANCEL:
      begin
        Button0 := ButtonYes;
        Button1 := ButtonNo;
        Button2 := ButtonCancel or ButtonEscape;
      end;
    MB_YESNO:
      begin
        Button0 := ButtonYes;
        Button1 := ButtonNo or ButtonEscape;
        Button2 := 0;
      end;
    MB_RETRYCANCEL:
      begin
        Button0 := ButtonRetry;
        Button1 := ButtonCancel or ButtonEscape;
        Button2 := 0;
      end;
  else     // MB_OK and non supported
    begin
      Button0 := ButtonOk or ButtonEscape;
      Button1 := 0;
      Button2 := 0;
    end;
  end;
  case (WinFlags and $300) of
    MB_DEFBUTTON2: Button1 := Button1 or ButtonDefault;
    MB_DEFBUTTON3: Button2 := Button2 or ButtonDefault;
  else
  // MB_DEFBUTTON1:
    Button0 := Button0 or ButtonDefault;
  end;
  case (WinFlags and $F0) of
    MB_ICONINFORMATION:
      Result := QMessageBox_information(parent, @caption, @text,
                                        button0, button1, button2);
    MB_ICONWARNING:
      Result := QMessageBox_warning(parent, @caption, @text,
                                        button0, button1, button2);
    MB_ICONQUESTION:
      Result := QMessageBox_information(parent, @caption, @text,
                                        button0, button1, button2);
  else
//  MB_ICONSTOP:
    Result := QMessageBox_critical(parent, @caption, @text,
                                      button0, button1, button2);
  end;
end;

function MessageBox(parent: QWidgetH; pText, pCaption: PChar; WinFlags: Cardinal): Integer;
var
  wsText, wsCaption: WideString;
begin
  wsText := pText;
  wsCaption := pCaption;
  Result := MessageBox(parent, wsText, wsCaption, WinFlags);
end;

function MessageBox(parent: QWidgetH; Text, Caption: String; WinFlags: Cardinal): Integer; overload;
begin
  Result := MessageBox(parent, Text, Caption, WinFlags);
end;

function MessageBoxW(parent: QWidgetH; pText, pCaption: PWideChar; WinFlags: Cardinal): Integer;
var
  wsText, wsCaption: WideString;
begin
  wsText := pText;
  wsCaption := pCaption;
  Result := MessageBox(parent, wsText, wsCaption, WinFlags);
end;

function SelectObject(Handle: QPainterH; Font: QFontH): QFontH;
begin
  Result := QPainter_font(Handle);
  QPainter_setFont(Handle, Font);
end;

function SelectObject(Handle: QPainterH; Brush: QBrushH): QBrushH;
begin
  Result := QPainter_brush(Handle);
  QPainter_setBrush(Handle, Brush);
end;

function SelectObject(Handle: QPainterH; Pen: QPenH): QPenH;
begin
  Result := QPainter_pen(Handle);
  QPainter_setPen(Handle, Pen);
end;

function SelectObject(Handle: QPainterH; Bitmap: QPixmapH): QPixmapH;
var
  P: PPainterInfo;
begin
  if GetPainterInfo(Handle, P) and (P.IsCompatibleDC) then
  begin
    Result := QPixmapH(QPainter_device(Handle)); // IsCompatihbleDC -> device is QPixmapH
    if QPainter_isActive(Handle) then
      QPainter_end(Handle);

    QPainter_begin(Handle, Bitmap);
  end
  else
    Result := nil;
end;

function GetRegionType(rgn: QRegionH): Integer;
var
  R: TRect;
begin
  try
    if QRegion_isEmpty(rgn) then
      Result := NULLREGION
    else
    begin
      QRegion_boundingRect(rgn, @R);
      if QRegion_contains(rgn, PRect(@R)) then
        Result := SIMPLEREGION
      else
        Result := COMPLEXREGION;
    end;
  except
    Result := RGN_ERROR;
  end;
end;

function CreateEllipticRgn(Left, Top, Right, Bottom: Integer): QRegionH;
begin
  Result := QRegion_create(Left, Top, Right - Left, Bottom - Top, QRegionRegionType_Ellipse);
end;

function CreateEllipticRgnIndirect(Rect: TRect): QRegionH;
begin
  Result := QRegion_create(@Rect, QRegionRegionType_Ellipse);
end;

function CreateRectRgn(Left, Top, Right, Bottom: Integer): QRegionH;
var
  R: TRect;
begin
  SetRect(R, Left, Top, Right, Bottom);
  Result := QRegion_create(@R, QRegionRegionType_Rectangle);
end;

function CreateRectRgnIndirect(Rect: TRect): QRegionH;
begin
  Result := QRegion_create(@Rect, QRegionRegionType_Rectangle);
end;

function CreateRoundRectRgn(x1, y1, x2, y2, WidthEllipse, HeightEllipse: Integer): QRegionH;
var
  bmp: QBitmapH;
  painter: QPainterH;
begin
  bmp := QBitmap_create(x2-x1+1, y2-y1+1, true, QPixmapOptimization_DefaultOptim);
  painter := QPainter_create(bmp);
  QPainter_setBrush(painter, QPen_color(QPainter_pen(painter)));
  QPainter_drawRoundRect(painter, 0, 0, x2-x1, y2-y1, WidthEllipse, HeightEllipse);
  QPainter_destroy(painter);
  Result := QRegion_create(bmp);
  QBitmap_destroy(bmp);
  QRegion_translate(Result, x1, y1);
end;

function CreatePolygonRgn(const Points; Count, FillMode: Integer): QRegionH;
var
  pts: TPointArray;
  i: Integer;
  p: PPoint;
begin
  SetLength(pts, Count);
  p := PPoint(Points);
  for i := 0 to Count - 1 do
  begin
    pts[i].X := p.X;
    pts[i].Y := p.Y;
    Inc(p);
  end;
  Result := QRegion_create(@pts[0], Fillmode = WINDING);
end;

function SelectClipRgn(Handle: QPainterH; Region: QRegionH): Integer;
begin
  try
    QPainter_setClipRegion(Handle, Region);
    QPainter_setClipping(Handle, True);
    Result := GetRegionType(Region);
  except
    Result := RGN_ERROR;
  end;
end;

function ExcludeClipRect(Handle: QPainterH; X1, Y1, X2, Y2: Integer): Integer;
var
  ExcludeRgn, Rgn: QRegionH;
begin
  MapPainterLP(Handle, X1, Y1, X2, Y2);
  ExcludeRgn := QRegion_create(X1, Y1, X2 - X1, Y2 - Y1, QRegionRegionType_Rectangle);
  try
    Rgn := QPainter_clipRegion(Handle);
    QRegion_subtract(Rgn, Rgn, ExcludeRgn);
    QPainter_setClipRegion(Handle, Rgn); // otherwide the new clip region is not accepter
    QPainter_setClipping(Handle, True);
    Result := GetRegionType(Rgn);
  except
    Result := RGN_ERROR;
  end;
  QRegion_destroy(ExcludeRgn);
end;

function ExcludeClipRect(Handle: QPainterH; const R: TRect): Integer;
begin
  with R do
    Result := ExcludeClipRect(Handle, Left, Top, Right, Bottom);
end;

function IntersectClipRect(Handle: QPainterH; X1, Y1, X2, Y2: Integer): Integer;
var
  IntersectRgn, Rgn: QRegionH;
begin
  MapPainterLP(Handle, X1, Y1, X2, Y2);
  IntersectRgn := QRegion_create(X1, Y1, X2 - X1, Y2 - Y1, QRegionRegionType_Rectangle);
  try
    Rgn := QPainter_clipRegion(Handle);
    if QRegion_isNull(Rgn) then
      QRegion_unite(Rgn, Rgn, IntersectRgn)
    else
      QRegion_intersect(Rgn, Rgn, IntersectRgn);
    QPainter_setClipping(Handle, True);
    Result := GetRegionType(Rgn);
  except
    Result := RGN_ERROR;
  end;
  QRegion_destroy(IntersectRgn);
end;

function IntersectClipRect(Handle: QPainterH; const R: TRect): Integer;
begin
  with R do
    Result := IntersectClipRect(Handle, Left, Top, Right, Bottom);
end;

function SetRectRgn(Rgn: QRegionH; X1, Y1, X2, Y2: Integer): LongBool;
var
  rgn2: QRegionH;
  R: TRect;
begin
  SetRect(R, X1, Y1, X2, Y2);
  rgn2 := QRegion_create(@R, QRegionRegionType_Rectangle);
  try
    QRegion_unite(rgn2, rgn, rgn2);
    Result := True;
  except
    Result := False;
  end;
  QRegion_destroy(rgn2);
end;

function EqualRgn(Rgn1, Rgn2: QRegionH): LongBool;
var
  tmpRgn: QRegionH;
begin
  tmpRgn := QRegion_create;
  try
    Result := CombineRgn(tmpRgn, Rgn1, Rgn2, RGN_XOR) = NULLREGION
  except
    Result := False;
  end;
  QRegion_destroy(tmpRgn);
end;

function GetClipRgn(Handle: QPainterH; rgn: QRegionH): Integer;
begin
  if QPainter_hasClipping(Handle)
  then
  begin
    QRegion_unite(QPainter_clipRegion(Handle), rgn, QPainter_clipRegion(Handle));
    Result := GetRegionType(rgn);
  end
  else
    Result := NULLREGION;
end;

function CombineRgn(DestRgn, Source1, Source2: QRegionH;
  Operation: TCombineMode): Integer;
begin
  try
    case Operation of
      RGN_OR:
        QRegion_unite(Source1, DestRgn, Source2);
      RGN_AND:
        QRegion_intersect(Source1, DestRgn, Source2);
      // RGN_DIFF Subtracts Source2 from Source1
      RGN_DIFF:
        QRegion_subtract(Source1, DestRgn, Source2);
      // RGN_XOR creates the union of two combined regions except for any
      // overlapping areas.
      RGN_XOR:
        QRegion_eor(Source1, DestRgn, Source2);
      // RGN_COPY: Creates a copy of the region identified by Source1.
      RGN_COPY:
        QRegion_unite(Source1, DestRgn, Source1)
    else
      Result := RGN_ERROR;
      Exit;
    end;
    Result := GetRegionType(DestRgn);
  except
    Result := RGN_ERROR;
  end;
end;

function OffsetRgn(Region: QRegionH; X, Y:Integer): Integer;
begin
  QRegion_translate(Region, X, Y);
  Result := GetRegionType(Region);
end;

function OffsetClipRgn(Handle: QPainterH; X, Y: Integer): Integer;
begin
  try
    if QPainter_hasClipping(Handle) then
    begin
      OffsetRgn(QPainter_clipRegion(Handle), X, Y);
      Result := GetRegionType(QPainter_clipRegion(Handle));
    end
    else
      Result := RGN_ERROR;
  except
    Result := RGN_ERROR;
  end;
end;

function InvertRgn(Handle: QPainterH; Region: QRegionH): LongBool;
var
  Rgn: QRegionH;
  R: TRect;
begin
  try
    QPainter_window(Handle, @R);
    OffsetRect(R, -R.Left, -R.Top);
    rgn := QRegion_create(@R, QRegionRegionType_Rectangle);
    try
      QRegion_subtract(rgn, Region, Region);
      Result := True;
    except
      Result := False;
    end;
    QRegion_destroy(rgn);
  except
    Result := False;
  end;
end;

function FillRgn(Handle: QPainterH; Region: QRegionH; Brush: QBrushH): LongBool;
var
  OldRgn: QRegionH;
  R: TRect;
  hasClipping: Boolean;
begin
  OldRgn := nil;
  Result := False;
  QPainter_save(Handle);
  try
    hasClipping := QPainter_hasClipping(Handle);
    if hasClipping then
      OldRgn := QPainter_clipRegion(Handle);
    if SelectClipRgn(Handle, Region) <> RGN_ERROR then
    begin
      QRegion_boundingRect(Region, @R);
      QPainter_fillRect(Handle, @R, Brush);
      if hasClipping then
        SelectClipRgn(Handle, OldRgn);
      Result := True;
    end;
  finally
    QPainter_restore(Handle);
  end;
end;

function DeleteObject(Region: QRegionH): LongBool;
begin
  try
    QRegion_destroy(Region);
    Result := True;
  except
    Result := False;
  end;
end;

function PtInRegion(Rgn: QRegionH; X, Y: Integer): Boolean;
var
  P :TPoint;
begin
  P.X := X;
  P.Y := Y;
  Result := QRegion_contains(Rgn, PPoint(@P));
end;

function RectInRegion(Rgn: QRegionH; const Rect: TRect): LongBool;
{var
  tmpRgn: QRegionH;
  retval: Integer;}
begin
  try
    Result := QRegion_contains(Rgn, PRect(@Rect));
  except
    Result := False;
  end;
{  tmpRgn := CreateRectRgnIndirect(Rect);
  try
    Retval := CombineRgn(tmpRgn, Rgn, TmpRgn, RGN_And);
    Result := (RetVal = SIMPLEREGION) or (RetVal = COMPLEXREGION);
  except
    Result := False;
  end;
  DeleteObject(tmpRgn);}
end;

function LPtoDP(Handle: QPainterH; var Points; Count: Integer): LongBool;
var
  Matrix: QWMatrixH;
  P: PPoint;
begin
  Result := True;
  try
    if QPainter_hasWorldXForm(Handle) then
    begin
      Matrix := QPainter_worldMatrix(Handle);
      P := @Points;
      while Count > 0 do
      begin
        Dec(Count);
        QWMatrix_map(Matrix, P, P);
        Inc(P);
      end;
    end;
  except
    Result := False;
  end;
end;

function DPtoLP(Handle: QPainterH; var Points; Count: Integer): LongBool;
var
  Matrix, InvertedMatrix: QWMatrixH;
  P: PPoint;
  Invertable: Boolean;
begin
  Result := True;
  try
    if QPainter_hasWorldXForm(Handle) then
    begin
      Matrix := QPainter_worldMatrix(Handle);
      InvertedMatrix := QWMatrix_create;
      try
        Invertable := False;
        QWMatrix_invert(Matrix, InvertedMatrix, @Invertable);
        if Invertable then
        begin
          P := @Points;
          while Count > 0 do
          begin
            Dec(Count);
            QWMatrix_map(InvertedMatrix, P, P);
            Inc(P);
          end;
        end;
      finally
        QWMatrix_destroy(InvertedMatrix);
      end;
    end;
  except
    Result := False;
  end;
end;

function SetViewPortOrgEx(Handle: QPainterH; X, Y: Integer; OldOrg: PPoint): LongBool;
var
  R :TRect;
begin
  try
    QPainter_viewport(Handle, @R);
    if OldOrg <> nil then
    begin
      OldOrg.X := R.Left;
      OldOrg.Y := R.Top;
    end;
    QPainter_setViewport(Handle, X, Y, R.Right - R.Left, R.Bottom - R.Top);
    Result := True;
  except
    Result := False;
  end;
end;

function SetViewportExtEx(Handle: QPainterH; XExt, YExt: Integer; Size: PSize): LongBool;
var
  R :TRect;
begin
  Result := True;
  try
    QPainter_viewport(Handle, @R);
    if size <> nil then
    begin
      Size.cx := R.Right - R.Left;
      Size.cy := R.Bottom - R.Top;
    end;
    QPainter_setViewport(Handle, R.Left, R.Top, XExt, YExt);
  except
    Result := False;
  end;
end;

function GetViewportExtEx(Handle: QPainterH; Size: PSize): LongBool;
var
  R :TRect;
begin
  Result := True;
  try
    QPainter_viewport(Handle, @R);
    Size.cx := R.Right - R.Left;
    Size.cy := R.Bottom - R.Top;
  except
    Result := False;
  end;
end;

function GetWindowOrgEx(Handle: QPainterH; Org: PPoint): LongBool;
var
  R :TRect;
begin
  try
    QPainter_window(Handle, @R);
    Org.X := R.Left;
    Org.Y := R.Top;
    Result := True;
  except
    Result := False;
  end;
end;

function SetWindowOrgEx(Handle: QPainterH; X, Y: Integer; OldOrg: PPoint): LongBool;
var
  R :TRect;
begin
  try
    QPainter_window(Handle, @R);
    with R do
    begin
      if OldOrg <> nil then
      begin
        OldOrg.X := Left;
        OldOrg.Y := Top;
      end;
      QPainter_setWindow(Handle, X, Y, Right - Left, Bottom - Top);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure CopyMemory(Dest: Pointer; Src: Pointer; Len: Cardinal);
begin
  Move(Src^, Dest^, Len);
end;

procedure FillMemory(Dest: Pointer; Len: Cardinal; Fill: Byte);
begin
  FillChar(Dest^, Len, Fill);
end;

procedure MoveMemory(Dest: Pointer; Src: Pointer; Len: Cardinal);
begin
  Move(Src^, Dest^, Len);
end;

procedure ZeroMemory(Dest: Pointer; Len: Cardinal);
begin
  FillChar(Dest^, Len, 0);
end;

function GetDoubleClickTime: Cardinal;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetDoubleClickTime;
{$ELSE}
  Result := QApplication_doubleClickInterval;
{$ENDIF}
end;

function SetDoubleClickTime(Interval: Cardinal): LongBool;
begin
  try
    QApplication_setDoubleClickInterval(Interval);
    {$IFDEF MSWINDOWS}
    if not Windows.SetDoubleClickTime(Interval) then
      Result := False
    else
    {$ENDIF}
    Result := True;
  except
    Result := False;
  end;
end;

// limited implementation of
function GetSystemMetrics(PropItem: TSysMetrics): Integer;
var
  size: TSize;
begin
  case PropItem of
    SM_CXVSCROLL, SM_CXHSCROLL:
      begin
        QStyle_scrollBarExtent(QApplication_Style, @size);
        Result := size.cx;
      end;
    SM_CYVSCROLL, SM_CYHSCROLL:
      begin
        QStyle_scrollBarExtent(QApplication_Style, @size);
        Result := size.cy;
      end;
    SM_CXSMICON, SM_CYSMICON:
      Result := 16;
    SM_CXICON, SM_CYICON:
      Result := 32;
    SM_CXSCREEN:
      Result := QWidget_width(QApplication_desktop);
    SM_CYSCREEN:
      Result := QWidget_height(QApplication_desktop);
    SM_CXBORDER, SM_CYBORDER:
      Result := QStyle_DefaultFrameWidth(QApplication_style); // (probably) wrong ?
    SM_CXFRAME, SM_CYFRAME:
      Result := QStyle_DefaultFrameWidth(QApplication_style); // or this one
    SM_CYCAPTION:
      Result := 24;
  else
    raise Exception.Create('GetSystemMetrics: unsupported property')
  end;
end;

{ limited implementation of}
function GetDeviceCaps(Handle: QPainterH; devcap: TDeviceCap): Integer;
var
  pdm:  QPaintDeviceMetricsH;
begin
  Result := 0;
  pdm := QPaintDeviceMetrics_create(QPainter_device(Handle));
  try
    case devcap of
      HORZSIZE:
        Result := QPaintDeviceMetrics_widthMM(pdm);
      VERTSIZE:
        Result := QPaintDeviceMetrics_heightMM(pdm);
      PHYSICALWIDTH, HORZRES:
        Result := QPaintDeviceMetrics_width(pdm); // Horizontal width in pixels
      BITSPIXEL:
        Result := QPaintDeviceMetrics_Depth(pdm); // Number of bits per pixel
      NUMCOLORS:
        Result := QPaintDeviceMetrics_numColors(pdm);
      LOGPIXELSX:
        Result := QPaintDeviceMetrics_logicalDpiX(pdm); // Logical pixelsinch in X
      LOGPIXELSY:
        Result := QPaintDeviceMetrics_logicalDpiY(pdm); // Logical pixelsinch in Y
      PHYSICALOFFSETX:
        Result := 0;
      PHYSICALOFFSETY:
        Result := 0;
      PHYSICALHEIGHT, VERTRES:
        Result := QPaintDeviceMetrics_height(pdm); // Vertical height in pixels
    else
      raise Exception.Create('GetDeviceCaps: unsupported capability');
    end;
  finally
    QPaintDeviceMetrics_destroy(pdm);
  end;
end;

{ a very limited implementation of }
function GetTextMetrics(Handle: QPainterH; tt: TTextMetric): Integer;
var
  tm: QFontMetricsH;
begin
  QPainter_fontMetrics(Handle, @tm);
  with tt do
  begin
    tmHeight := QFontMetrics_height(tm);
    tmAscent := QFontMetrics_ascent(tm);
    tmDescent := QFontMetrics_descent(tm);
  end;
  Result := 0;
end;

function RGB(Red, Green, Blue: Integer): TColorRef;
begin
  Result := (Blue shl 16) or (Green shl 8) or Red;
end;

function GetBValue(Col: TColorRef): Byte;
begin
  Result := Byte((Col shr 16) and $FF);
end;

function GetGValue(Col: TColorRef): Byte;
begin
  Result := Byte((Col shr 8) and $FF);
end;

function GetRValue(Col: TColorRef): Byte;
begin
  Result := Byte(Col and $FF);
end;

function SetRect(var R: TRect; Left, Top, Right, Bottom: Integer): LongBool;
begin
  R := Rect(Left, Top, Right, Bottom);
  Result := True;
end;

function CopyRect(var Dst: TRect; const Src: TRect): LongBool;
begin
  Dst := Src;
  Result := True;
end;

function UnionRect(var Dst: TRect; R1, R2: TRect): LongBool;
begin
  Result := True;
  if IsRectEmpty(R1) then
  begin
    if IsRectEmpty(R2) then
      Result := False  // both empty
    else
    begin
      Dst := R2;
      Result := True;
    end;
  end
  else if IsRectEmpty(R2) then
    Dst := R1
  else
    with Dst do
    begin
      Left := Min(R1.Left, R2.Left);
      Top := Min(R1.Top, R2.Top);
      Right := Max(R1.Right, R2.Right);
      Bottom := Max(R1.Bottom, R2.Bottom);
    end;
end;

function IsRectEmpty(R: TRect): LongBool;
begin
  with R do
    Result := (Right <= Left) or (Bottom <= Top);
end;

function EqualRect(R1, R2: TRect): LongBool;
begin
  Result := (R1.Left = R2.Left) and (R1.Right = R2.Right) and
            (R1.Top = R2.Top) and (R1.Bottom = R2.Bottom)
end;

procedure TextOutAngle(Handle: QPainterH; Angle, Left, Top: Integer; Text: WideString);
begin
  try
    QPainter_save(Handle);
    QPainter_translate(Handle, Left, Top);
    QPainter_rotate(Handle, -Angle);
    QPainter_drawText(Handle, 0, 0, @Text, -1);
  finally
    QPainter_restore(Handle);
  end;
end;

procedure TextOutAngle(ACanvas: TCanvas; Angle, Left, Top: Integer; Text: WideString);
begin
  ACanvas.Start;
  TextOutAngle(ACanvas.Handle, Angle, Left, Top, Text);
  ACanvas.Stop;
end;

function TextWidth(Handle: QPainterH; Caption: WideString;
  Flags: Integer): Integer;
var
  R :TRect;
begin
  QPainter_boundingRect(Handle, @R, @R, Flags, PWideString(@Caption), -1, nil);
  Result := R.Right - R.Left;
end;

function TextHeight(Handle: QPainterH; Caption: WideString; R: TRect;
  Flags: Integer): Integer;
var
  R1, R2: TRect;
begin
  R1 := R;
  R1.Bottom := MaxInt;
  QPainter_boundingRect(Handle, @R1, @R2, Flags, PWideString(@Caption), -1, nil);
  Result := R2.Bottom - R2.Top;
end;

function GetTextExtentPoint32(Handle: QPainterH; const Text: WideString; Len: Integer;
  var Size: TSize): LongBool;
var
  R: TRect;
begin
  try
    QPainter_boundingRect(Handle, @R, @R, 0, @Text, Len, nil);
    with R do
    begin
      Size.cx := Right - Left;
      Size.cy := Bottom - Top;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function GetTextExtentPoint32(Handle: QPainterH; pText: PChar; Len: Integer;
  var Size: TSize): LongBool;
var
  Text: WideString;
begin
  Text := pText;
  Result := GetTextExtentPoint32(Handle, Text, Len, Size);
end;

function GetTextExtentPoint32W(Handle: QPainterH; pText: PWideChar; Len: Integer;
  var Size :TSize): LongBool;
var
  Text: WideString;
begin
  Text := pText;
  Result := GetTextExtentPoint32(Handle, Text, Len, Size);
end;

function TextExtent(Handle: QPainterH; const Caption: WideString; R: TRect;
  Flags: Integer): TRect;
var
  R2: TRect;
begin
  R2 := R;
  R2.Bottom := MaxInt;
  QPainter_boundingRect(Handle, @R2, @Result, Flags, PWideString(@Caption), -1, nil);
end;

const
  Ellipses = '...';

function NameEllipsis(const Name: WideString; Handle: QPainterH;
  MaxLen: Integer): WideString;
var
  I: Integer;
begin
  if TextWidth(Handle, Name, 0) > MaxLen then
  begin
    Result := Ellipses;
    I := 0;
    while TextWidth(Handle, Result, 0) <= MaxLen do
    begin
      Inc(I);
      Result := LeftStr(Name, I) + Ellipses;
    end;
    if I <> 0 then
      Result := LeftStr(Name, I-1) + Ellipses;
  end
  else
    Result := name;
end;

function WordEllipsis(Words: WideString; Handle: QPainterH; const R: TRect;
  Flags: Integer): WideString;
var
  R2, R1: TRect;
  ShortedText: WideString;
  I: Integer;

  function RectInsideRect(const R1, R2: TRect): Boolean;
  begin
    with R1 do
      Result := (Left >= R2.Left) and (Right  <= R2.Right) and
                (Top  >= R2.Top)  and (Bottom <= R2.Bottom);
  end;

begin
  Result := ShortedText;
  R1 := R;
  R1.Bottom := MaxInt;
  QPainter_boundingRect(Handle, @R1, @R2, Flags, PWideString(@Result), -1, nil);
  if not RectInsideRect(R2, R) then
  begin
    I := 1;
    ShortedText := '';
    while RectInsideRect(R2, R) and (I <= Length(Words)) do
    begin
      repeat                 // one more word
        ShortedText := LeftStr(Words, I);
        if Words[I] = ' ' then
          Break;
        Inc(I);
      until I > Length(Words);
      Result := ShortedText + '...';
      QPainter_boundingRect(Handle, @R1, @R2, Flags, PWideString(@Result), -1, nil);
    end;
    While not RectInsideRect(R2, R) and (I > 0) do
    begin
      repeat // one word less
        Dec(I);
        ShortedText := LeftStr(Words, I);
        if ShortedText[I] = ' ' then
          Break;
      until I <= 1;
      Result := ShortedText + '...';
      QPainter_boundingRect(Handle, @R1, @R2, Flags, PWideString(@Result), -1, nil);
    end;
  end;
end;

function FileEllipsis(const FilePath: AnsiString; Handle: QPainterH; MaxLen: Integer): string;
var
  Paths: TStrings;
  k, i, Start: Integer;
  CurPath, F: AnsiString;
begin
  if TextWidth(Handle, FilePath, SingleLine) <= MaxLen then
    Result := FilePath
  else
  begin    // FilePath too long
    F := FilePath;
    {$IFDEF LINUX}
    CurPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'));
    if AnsiStartsStr(CurPath, FilePath) then
    begin
      F := '~/' + AnsiRightStr(FilePath, Length(FilePath) - Length(CurPath));
      if TextWidth(Handle, F, 0) <= MaxLen then
      begin
        Result := F;
        Exit;
      end
    end;
    {$ENDIF LINUX}
    Paths := TStringList.Create;
    try
      Paths.Delimiter := PathDelim;
      Paths.DelimitedText := F; // splits the filepath
      if Paths[0] = '' then
        Start := 1     // absolute path
      else
        Start := 0;    // relative path
      for k := Start to Paths.Count - 2 do
      begin
        CurPath := Paths[k];
        if Length(CurPath) > 2 then   // this excludes '~' '..'
        begin
          Paths[k] := CurPath; // replace with ellipses
          I := Length(CurPath);
          while (I > 0) and (TextWidth(Handle, Paths.DelimitedText, 0) > MaxLen) do
          begin
            Dec(I);
            Paths[k] := LeftStr(CurPath, I) + Ellipses;// remove a character
          end;
          if TextWidth(Handle, Paths.DelimitedText, 0) <= MaxLen then
          begin
            Result := Paths.DelimitedText;
            Exit;
          end;
        end
      end;
      // not succeeded.
      // replace /.../.../.../<filename> with .../<filename>
      // before starting to minimize filename
      for k := Paths.Count - 2 downto 1 do
        Paths.Delete(k);
      Paths[0] := Ellipses;
      if TextWidth(Handle, Paths.DelimitedText, 0) > MaxLen then
      begin
        CurPath := Paths[1];
        Paths[1] := Ellipses; // replace with ellipses
        //I := 1;
        //Paths[1] := CurPath; // replace with ellipses
        I:= Length(CurPath);
        while (I > 0)  and (TextWidth(Handle, Paths.DelimitedText, 0) > MaxLen) do
        begin
          Dec(I);
          Paths[I] := LeftStr(CurPath, I) + Ellipses;// remove a character
        end;
      end;
      Result := Paths.DelimitedText;    // will be something .../Progr...
    finally
      Paths.Free;
    end;
  end;
end;

function TruncatePath(const FilePath: string; Canvas: TCanvas; MaxLen: Integer): string;
begin
  Canvas.Start;
  try
    Result := FileEllipsis(FilePath, Canvas.Handle, MaxLen);
  finally
    Canvas.Stop;
  end;
end;

function TruncateName(const Name: WideString; Canvas: TCanvas; MaxLen: Integer): WideString;
begin
  Canvas.Start;
  try
    Result := NameEllipsis(Name, Canvas.Handle, MaxLen);
  finally
    Canvas.Stop;
  end;
end;

function DrawText(Handle: QPainterH; var Text: WideString; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer;
var
  Flags: Integer;
  R2: TRect;  // bliep bliep bl...
  Caption: WideString;
  FontSaved, FontSet: QFontH;

  function HidePrefix(const Text: WideString): WideString;
  var
    i, Len: Integer;
  begin
    Result := Text;
    Len := Length(Result);
    i := 1;
    while i <= Len do
    begin
      if (Result[i] = '&') then
      begin
        Delete(Result, i, 1);
        Dec(Len);
        if (Result[i] = '&') and (Result[i + 1] = '&') then
        begin
          Delete(Result, i, 1);
          Dec(Len);
        end;
      end;
      Inc(i);
    end;
  end;

  function OnlyPrefix(const Text: WideString): WideString;
  var
    i, Len: Integer;
  begin
    Result := Text;
    Len := Length(Result);
    i := 1;
    while i <= Len do
    begin
      if (Result[i] = '&') then
      begin
        Delete(Result, i, 1);
        Dec(Len);
        if (Result[i] = '&') and (Result[i + 1] = '&') then
        begin
          Delete(Result, i, 1);
          Dec(Len);
        end;
        Result[i] := '&';
      end
      else
        Result[i] := ' ';
      Inc(i);
    end;
  end;

  function CheckTabStop(WinFlags: Integer): Integer;
  var
    Size: Integer;
  begin
    if WinFlags and DT_TABSTOP <> 0 then
    begin
      Size := WinFlags and $FF00;
      WinFlags := WinFlags - Size;
      Size := (Size shr 8) and $FF;
      QPainter_setTabStops(Handle, Size);
    end;
    Result := WinFlags;
  end;

begin
  if Len = -1 then
    Len := Length(Text);
  FontSaved := nil;
  FontSet := nil;
  if WinFlags and DT_INTERNAL <> 0 then
  begin
    FontSaved := QPainter_Font(Handle);
    QApplication_font(FontSet, nil);
    QPainter_setFont(Handle, FontSet);
  end;
  Flags := Win2QtAlign(CheckTabStop(WinFlags));
  if WinFlags and DT_PREFIXONLY <> 0 then
  begin
    Flags := Flags or ShowPrefix;
    Caption := OnlyPrefix(Text);
  end
  else if WinFlags and DT_HIDEPREFIX <> 0 then
  begin
    Flags := Flags and not ShowPrefix;
    Caption := HidePrefix(Text);
  end;
  if Flags and CalcRect = 0 then
  begin
    if ClipName and Flags <> 0 then
      Caption := NameEllipsis(Text, Handle, R.Right - R.Left)
    else if ClipPath and Flags <> 0 then
      Caption := FileEllipsis(Text, Handle, R.Right - R.Left)
    else if ClipToWord and Flags <> 0 then
      Caption := WordEllipsis(Text, Handle, R, flags)
    else
      Caption := Text;
{    if QBrush_style(QPainter_brush(Handle)) <> BrushStyle_NoBrush then
      FillRect(Handle, R, QPainter_brush(Handle));}
    QPainter_DrawText(Handle, @R, Flags, PWideString(@Caption), Len, @R2, nil);
    if ModifyString and Flags <> 0 then
      Text := Caption;
    Result := R2.Bottom - R2.Top;
  end
  else
  begin
    R2.Left := R.Left;
    R2.Top := R.Top;
    QPainter_boundingRect(Handle, @R, @R, Flags and not $3F{Alignment}, PWideString(@Text), -1, nil);
    OffsetRect(R, R2.Left, R2.Top);
    Result := R.Bottom - R.Top;
  end;
  if WinFlags and DT_INTERNAL <> 0 then
    QPainter_setFont(Handle, FontSaved);
end;

function DrawText(Handle :QPainterH; Text: PAnsiChar; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer;
var
  WText: WideString;
  AText: string;
begin
  WText := Text;
  Result := DrawText(Handle, WText, Len, R, WinFlags);
  if (DT_MODIFYSTRING and WinFlags <> 0) and (Text <> nil) then
  begin
    AText := WText;
    StrCopy(Text, PChar(AText));
  end;
end;

function DrawTextW(Handle :QPainterH; Text: PWideChar; Len: Integer;
  var R: TRect; WinFlags: Integer): Integer;
var
  WText: WideString;
begin
  WText := Text;
  Result := DrawText(Handle, WText, Len, R, WinFlags);
  if (DT_MODIFYSTRING and WinFlags <> 0) and (Text <> nil) then
  begin
    Move(WText[1], Text^, Length(WText) * SizeOf(WideChar));
    //WStrCopy(Text, PChar(AText));
  end;
end;

function ExtTextOut(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; const Text: WideString; Len: Integer; lpDx: Pointer): LongBool;
{TODO missing feature: horizontal/vertical text alignment }
var
  WS: WideString;
  Index, Width: Integer;
  Dx: PInteger;
  RR{, CellRect}: TRect;
  TextLen: Integer;
  Canvas: TCanvas;
begin
  Result := False;
  if (Text = '') then
    Exit;
  if (WinFlags and ETO_CLIPPED <> 0) and (R = nil) then
    WinFlags := WinFlags and not ETO_CLIPPED;

  Canvas := TCanvas.Create;
  try
    Canvas.Handle := Handle;
    Canvas.Start(False);
    with Canvas do
    begin
      Result := True;
      if WinFlags and ETO_OPAQUE <> 0 then
      begin
        if Brush.Style <> bsSolid then
          Brush.Style := bsSolid;
        if R <> nil then
          FillRect(R^);
      end
      else
        if Brush.Style = bsSolid then
          Brush.Style := bsClear;

      if lpDx = nil then
      begin
        if (WinFlags and ETO_CLIPPED <> 0) then
          TextRect(R^, X, Y, Text)
        else
          TextOut(X, Y, Text);
      end
      else
      begin
       // put each char into its cell
        TextLen := Length(Text);
        if (WinFlags and ETO_OPAQUE <> 0) and (R = nil) then
        begin
          Dx := lpDx;
          Width := 0;
          for Index := 1 to TextLen do
          begin
            Inc(Width, Dx^);
            Inc(Dx);
          end;
          RR.Left := X;
          RR.Right := X + Width;
          RR.Top := Y;
          RR.Bottom := Y + TextHeight(Text);
          FillRect(RR);
        end;

        Dx := lpDx;
        SetLength(WS, 1);
        for Index := 1 to TextLen do
        begin
          if (R <> nil) and (X >= R^.Right) then
            Break;

          WS[1] := Text[Index];
          if WinFlags and ETO_CLIPPED <> 0 then
          begin
            {CellRect.Left := X;
            CellRect.Right := X + Dx^;
            CellRect.Top := R^.Top;
            CellRect.Bottom := R^.Bottom;
            if CellRect.Right > R^.Right then
              CellRect.Right := R^.Right;}
            TextRect(RR, X, Y, WS);
          end
          else
            TextOut(X, Y, WS);

          if Index = TextLen then
            Break;

          Inc(X, Dx^);
          Inc(Dx);
        end;
      end;
    end;
  finally
    Canvas.Stop;
    Canvas.Free;
    QPainter_restore(Handle);
  end;
end;

function ExtTextOut(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; pText: PChar; Len: Integer; lpDx: Pointer): LongBool;
var
  ws: WideString;
begin
  ws := pText;
  Result := ExtTextOut(Handle, X, Y, WinFlags, R, ws, Len, lpDx);
end;

function ExtTextOutW(Handle: QPainterH; X, Y: Integer; WinFlags: Cardinal;
  R: PRect; pText: PWideChar; Len: Integer; lpDx: Pointer): LongBool;
var
  ws: WideString;
begin
  ws := pText;
  Result := ExtTextOut(Handle, X, Y, WinFlags, R, ws, Len, lpDx);
end;

function GetTextAlign(Handle: QPainterH): Cardinal;
var
  P: PPainterInfo;
begin
  if GetPainterInfo(Handle, P) then
    Result := P.TextAlignment
  else
    Result := TA_LEFT or TA_TOP;
end;

function SetTextAlign(Handle: QPainterH; Mode: Cardinal): Cardinal;
begin
  Result := GetTextAlign(Handle);
  if Result <> Mode then
    SetPainterInfo(Handle).TextAlignment := Mode;
end;

function FillRect(Handle: QPainterH; const R: TRect; Brush: QBrushH): LongBool;
begin
  try
    QPainter_fillRect(Handle, @R, Brush);
    Result := True;
  except
    Result := False;
  end;
end;

function DrawIcon(Handle: QPainterH; X, Y: Integer; hIcon: QPixMapH): LongBool;
var
  point: TPoint;
begin
  point.X := X;
  point.Y := Y;
  try
    QPainter_drawPixmap(Handle, @point, hIcon);
    Result := True;
  except
    Result := False;
  end;
end;

function DrawIconEx(Handle: QPainterH; X, Y: Integer; hIcon: QPixmapH; W, H: Integer;
  istepIfAniCur: Integer; hbrFlickerFreeDraw: QBrushH; diFlags: Cardinal): LongBool;
var
  TempDC: QPainterH;
  R: TRect;
begin
  if diFlags = DI_DEFAULTSIZE then
  begin
    if W = 0 then
    begin
      W := GetSystemMetrics(SM_CYICON);
      istepIfAniCur := 0;
    end;
    if H = 0 then
      H := GetSystemMetrics(SM_CXICON);
  end
  else
  begin         // DI_NORMAL / DI_IMAGE / DI_MASK
    if W = 0 then
    begin
      W := QPixmap_width(hIcon);
      istepIfAniCur := 0;
    end;
    if H = 0 then
      H := QPixmap_height(hIcon);
    if (DiFlags and DI_MASK) = 0 then    // DI_NORMAL / DT_IMAGE
      QPixmap_setMask(hIcon, nil);
  end;

  if QPixmap_width(hIcon) < ((istepIfAniCur + 1) * W) then
    istepIfAniCur := 0;

  if hbrFlickerFreeDraw <> nil then
  begin
    R := Bounds(0, 0, W, H);
    try
      TempDC := CreateCompatibleDC(Handle, W, H);
      try
        FillRect(TempDC, R, hbrFlickerFreeDraw);
        QPainter_drawPixmap(TempDC, 0, 0, hIcon, istepIfAniCur * W, 0, W, H);
        MapPainterLP(Handle, X, Y);
        BitBlt(Handle, X, Y, W, H, TempDC, 0, 0, RasterOp_CopyRop);
        Result := True;
      except
        Result := False;
      end;
      DeleteObject(TempDC);
    except
      Result := False;
    end;
  end
  else
  begin
    try
      QPainter_drawPixmap(Handle, X, Y, hIcon, istepIfAniCur * W, 0, W, H);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

function InvertRect(Handle: QPainterH; const R: TRect): LongBool;
begin
  with R do
    Result := BitBlt(Handle, Left, Top, Right - Left, Bottom-Top,
                     Handle, Left, Top, DSTINVERT);
end;

function Rectangle(Handle: QPainterH; Left, Top, Right, Bottom: Integer): LongBool;
begin
  try
    QPainter_drawRect(Handle, Left, Top, Right, Bottom);
    Result := True;
  except
    Result := False;
  end;
end;

function RoundRect(Handle: QPainterH; Left, Top, Right, Bottom, X3, Y3: Integer): LongBool;
begin
  try
    QPainter_drawRoundRect(Handle, Left, Top, Right, Bottom, X3, Y3);
    Result := True;
  except
    Result := False;
  end;
end;

function Ellipse(Handle: QPainterH; Left, Top, Right, Bottom: Integer): LongBool;
begin
  try
    QPainter_drawEllipse(Handle, Left, Top, Right, Bottom);
    Result := True;
  except
    Result := False;
  end;
end;

function FrameRect(Handle: QPainterH; const R: TRect; Brush: QBrushH): LongBool;
var
  Pen: QPenH;
begin
  Result := False;
  if (Handle = nil) or (R.Right - R.Left <= 0) or (R.Bottom - R.Top <= 0) or
     (Brush = nil) then
    Exit;
  try
    Pen := nil;
    QPainter_save(Handle);
    try
      Pen := QPen_create(QBrush_color(Brush), 1, PenStyle_SolidLine);
      QPainter_setPen(Handle, Pen);
      QPainter_setBrush(Handle, BrushStyle_NoBrush);
      QPainter_drawRect(Handle, @R);
    finally
      if Assigned(Pen) then
        QPen_destroy(Pen);
      QPainter_restore(Handle);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure FrameRect(Canvas: TCanvas; const R: TRect);
begin
  Canvas.Start;
  try
    FrameRect(Canvas.Handle, R, Canvas.Brush.Handle);
  finally
    Canvas.Stop;
  end;
end;

function DrawFocusRect(Handle: QPainterH; const R: TRect): LongBool;
begin
  try
    QPainter_drawWinFocusRect(Handle, @R);
    Result := True;
  except
    Result := False;
  end;
end;

function DrawFrameControl(Handle: QPainterH; const Rect: TRect; uType, uState: LongWord): LongBool;
const
  Mask = $00FF;
var
  Canvas: TCanvas;
  InnerRect, R: TRect;
  Pts: array of TPoint;
  i: Integer;
begin
  Result := False;
  if (Handle = nil) or (not QPainter_isActive(Handle)) then
    Exit;
  try
    Canvas := TCanvas.Create;
    try
      QPainter_save(Handle);
      Canvas.Handle := Handle;
      Canvas.Start(False);
      case uType of
        DFC_CAPTION:
          begin
            if uState and Mask <> 0 then
            begin
             // draw button
              Result := DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONPUSH or (uState and not Mask));
              if Result then
              begin
                R := Rect;
                Dec(R.Right);
                Dec(R.Bottom);

                Canvas.Pen.Style := psSolid;
                Canvas.Pen.Color := clBlack;
                Canvas.Pen.Width := 1;
                Canvas.Brush.Style := bsClear;
                // draw image
                case uState and Mask of
                  DFCS_CAPTIONCLOSE:
                    begin
                      Canvas.Pen.Width := 2;
                      Dec(R.Right);
                      Dec(R.Bottom);
                      Canvas.MoveTo(R.Left + 4, R.Top + 4);
                      Canvas.LineTo(R.Right - 4, R.Bottom - 4);
                      Canvas.MoveTo(R.Left + 4, R.Bottom - 4);
                      Canvas.LineTo(R.Right - 4, R.Top + 4);
                    end;
                  DFCS_CAPTIONMIN:
                    begin
                      Canvas.MoveTo(R.Left + 4, R.Bottom - 4);
                      Canvas.LineTo(R.Right - 4 - 5, R.Bottom - 4);
                      Canvas.MoveTo(R.Left + 4, R.Bottom - 5);
                      Canvas.LineTo(R.Right - 4 - 5, R.Bottom - 5);
                    end;
                  DFCS_CAPTIONMAX:
                    begin
                      Canvas.Rectangle(R.Left + 4, R.Top + 4, R.Right - 4, R.Bottom - 4);
                      Canvas.MoveTo(R.Left + 5, R.Top + 5);
                      Canvas.LineTo(R.Right - 5, R.Top + 5);
                    end;
                  DFCS_CAPTIONRESTORE:
                    begin
                      QPainter_save(Handle);
                      ExcludeClipRect(Handle, R.Left + 4, R.Top + 8, R.Right - 8, R.Bottom - 4);

                      Canvas.Rectangle(R.Left + 8, R.Top + 4, R.Right - 4, R.Bottom - 8);
                      Canvas.MoveTo(R.Left + 9, R.Top + 5);
                      Canvas.LineTo(R.Right - 5, R.Top + 5);

                      QPainter_restore(Handle);

                      Canvas.Rectangle(R.Left + 4, R.Top + 8, R.Right - 8, R.Bottom - 4);
                      Canvas.MoveTo(R.Left + 5, R.Top + 9);
                      Canvas.LineTo(R.Right - 9, R.Top + 9);
                    end;
                  DFCS_CAPTIONHELP:
                    begin
                      Canvas.Font.Style := [fsBold];
                      QPainter_setFont(Handle, Canvas.Font.Handle);
                      DrawText(Handle, '?', 1, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
                    end;
                end;
              end;
            end;
          end;

        DFC_MENU:
          begin
            Canvas.Brush.Color := clWhite;
            Canvas.Pen.Style := psSolid;
            Canvas.Brush.Style := bsSolid;
            Canvas.Pen.Color := clBlack;
            case uState and Mask of
              DFCS_MENUARROW, DFCS_MENUARROWRIGHT:
                begin
                  Canvas.FillRect(Rect); // white background
                  R := Types.Rect(0, 0, 5, 10);
                  OffsetRect(R,
                    ((Rect.Right - Rect.Left) - R.Right) div 2,
                    ((Rect.Bottom - Rect.Top) - R.Bottom) div 2);

                  SetLength(Pts, 3);
                  if (uState and Mask) = DFCS_MENUARROW then
                  begin
                    Pts[0] := Point(R.Left + 0, R.Top + 0);
                    Pts[1] := Point(R.Left + 0, R.Top + 10);
                    Pts[2] := Point(R.Left + 5, R.Top + 5);
                  end
                  else
                  begin
                    Pts[0] := Point(R.Left + 5, R.Top + 0);
                    Pts[1] := Point(R.Left + 5, R.Top + 10);
                    Pts[2] := Point(R.Left + 0, R.Top + 5);
                  end;
                  Canvas.Brush.Color := clBlack;
                  Canvas.Polygon(Pts);

                  Result := True;
                end;
              DFCS_MENUCHECK:
                begin
                  Canvas.FillRect(Rect); // white background
                  R := Types.Rect(0, 0, 12, 12);
                  OffsetRect(R,
                    ((Rect.Right - Rect.Left) - R.Right) div 2,
                    ((Rect.Bottom - Rect.Top) - R.Bottom) div 2);


                  Canvas.Brush.Color := clBlack;
                  SetLength(Pts, 3);
                  for i := 0 to 3 do
                  begin
                    Pts[0] := Point(R.Left + 0, R.Top + 8 - i);
                    Pts[1] := Point(R.Left + 4, R.Top + 12 - i);
                    Pts[2] := Point(R.Left + 12, R.Top + 4 - i);
                    Canvas.Polyline(Pts);
                  end;

                  Result := True;
                end;
              DFCS_MENUBULLET:
                begin
                  Canvas.FillRect(Rect); // white background
                  R := Types.Rect(0, 0, 7, 7);
                  OffsetRect(R,
                    ((Rect.Right - Rect.Left) - R.Right) div 2,
                    ((Rect.Bottom - Rect.Top) - R.Bottom) div 2);
                  Canvas.Brush.Color := clBlack;
                  Canvas.Ellipse(R);

                  Result := True;
                end;
            end;
          end;

        DFC_SCROLL:
          begin
            // not implemented
            raise Exception.Create('not implemented');

            case uState and Mask of
              DFCS_SCROLLCOMBOBOX:
                begin
                  {if uState and DFCS_INACTIVE <> 0 then
                    ComboBox := tcDropDownButtonDisabled
                  else
                  if uState and DFCS_PUSHED <> 0 then
                    ComboBox := tcDropDownButtonPressed
                  else
                  if uState and DFCS_HOT <> 0 then
                    ComboBox := tcDropDownButtonHot
                  else
                    ComboBox := tcDropDownButtonNormal;

                  Details := ThemeServices.GetElementDetails(ComboBox);
                  ThemeServices.DrawElement(DC, Details, R);}
                  Result := True;
                end;
              DFCS_SCROLLUP:
                if uState and (DFCS_TRANSPARENT {or DFCS_FLAT}) = 0 then
                begin
                  {if uState and DFCS_INACTIVE <> 0 then
                    ScrollBar := tsArrowBtnUpDisabled
                  else
                  if uState and DFCS_PUSHED <> 0 then
                    ScrollBar := tsArrowBtnUpPressed
                  else
                  if uState and DFCS_HOT <> 0 then
                    ScrollBar := tsArrowBtnUpHot
                  else
                    ScrollBar := tsArrowBtnUpNormal;

                  Details := ThemeServices.GetElementDetails(ScrollBar);
                  ThemeServices.DrawElement(DC, Details, R);}
                  Result := True;
                end;
              DFCS_SCROLLDOWN:
                if uState and (DFCS_TRANSPARENT {or DFCS_FLAT}) = 0 then
                begin
                  {if uState and DFCS_INACTIVE <> 0 then
                    ScrollBar := tsArrowBtnDownDisabled
                  else
                  if uState and DFCS_PUSHED <> 0 then
                    ScrollBar := tsArrowBtnDownPressed
                  else
                  if uState and DFCS_HOT <> 0 then
                    ScrollBar := tsArrowBtnDownHot
                  else
                    ScrollBar := tsArrowBtnDownNormal;

                  Details := ThemeServices.GetElementDetails(ScrollBar);
                  ThemeServices.DrawElement(DC, Details, R);}
                  Result := True;
                end;
            end;
          end; // DFC_SCROLL

        DFC_BUTTON:
          case uState and Mask of
            DFCS_BUTTONPUSH:
              begin
                InnerRect := Rect;
                InflateRect(InnerRect, -2, -2);
                if uState and (DFCS_TRANSPARENT) <> 0 then
                  ExcludeClipRect(Handle, InnerRect);

                if uState and DFCS_INACTIVE <> 0 then
                  R := DrawButtonFace(Canvas, Rect, 1, False, False, uState and DFCS_FLAT <> 0)
                else
                if uState and DFCS_PUSHED <> 0 then
                  R := DrawButtonFace(Canvas, Rect, 1, True, False, uState and DFCS_FLAT <> 0)
                else
                if uState and DFCS_HOT <> 0 then
                  R := DrawButtonFace(Canvas, Rect, 1, False, False, uState and DFCS_FLAT <> 0, clSilver)
                else
                if uState and DFCS_MONO <> 0 then
                begin
                  Canvas.Pen.Style := psSolid;
                  Canvas.Pen.Color := clBlack;
                  Canvas.Pen.Width := 1;
                  if uState and (DFCS_TRANSPARENT) <> 0 then
                    Canvas.Brush.Style := bsClear
                  else
                    Canvas.Brush.Color := clButton;
                  Canvas.Rectangle(Rect);
                  R := Rect;
                  InflateRect(R, -1, -1);
                end
                else
                  R := DrawButtonFace(Canvas, Rect, 1, False, False, uState and DFCS_FLAT <> 0);

                if uState and DFCS_ADJUSTRECT <> 0 then
                  PRect(@Rect)^ := R;
                Result := True;
              end;
          else
            // not implemented
            raise Exception.Create('not implemented');
          end;

        DFC_POPUPMENU:
          begin
            // not implemented
            raise Exception.Create('not implemented');
          end;
      end;
    finally
      QPainter_restore(Handle);
      Canvas.Free;
    end;
  except
    Result := False;
  end;
(*  DFC_CAPTION = 1;
  DFC_MENU = 2;
  DFC_SCROLL = 3;
  DFC_BUTTON = 4;
  DFC_POPUPMENU = 5;

  DFCS_SCROLLUP = 0;
  DFCS_SCROLLDOWN = 1;
  DFCS_SCROLLLEFT = 2;
  DFCS_SCROLLRIGHT = 3;
  DFCS_SCROLLCOMBOBOX = 5;
  DFCS_SCROLLSIZEGRIP = 8;
  DFCS_SCROLLSIZEGRIPRIGHT = $10;

  DFCS_BUTTONCHECK = 0;
  DFCS_BUTTONRADIOIMAGE = 1;
  DFCS_BUTTONRADIOMASK = 2;
  DFCS_BUTTONRADIO = 4;
  DFCS_BUTTON3STATE = 8;

  DFCS_INACTIVE = $100;
  DFCS_PUSHED = $200;
  DFCS_CHECKED = $400;
  DFCS_TRANSPARENT = $800;
  DFCS_HOT = $1000;
  DFCS_ADJUSTRECT = $2000;
  DFCS_FLAT = $4000;
  DFCS_MONO = $8000;
*)
end;

function GetCurrentPositionEx(Handle: QPainterH; pos: PPoint): LongBool;
begin
  try
    QPainter_pos(Handle, pos);
    Result := True;
  except
    Result := False;
  end;
end;

function LineTo(Handle: QPainterH; X, Y:Integer): LongBool;
begin
  try
    QPainter_lineTo(Handle, X, Y);
    Result := True;
  except
    Result := False;
  end;
end;

function MoveToEx(Handle: QPainterH; X, Y:Integer; oldpos: PPoint): LongBool;
begin
  try
    if oldpos <> nil
    then
      QPainter_pos(Handle, oldpos);
    QPainter_moveTo(Handle, X, Y);
    Result := True;
  except
    Result := False;
  end;
end;

function GetDC(Handle: QWidgetH): QPainterH;
var
  PaintDevice: QPaintDeviceH;
begin
  try
    if Handle = nil then
      Handle := QApplication_desktop;
    PaintDevice := QWidget_to_QPaintDevice(Handle);
    Result := QPainter_create(PaintDevice, Handle);
    if not QPainter_isActive(Result) then
      QPainter_begin(Result, PaintDevice, Handle);
  except
    Result := nil;
  end;
end;

function GetDC(Handle: Integer): QPainterH;
begin
  Result := GetDC(QWidgetH(Handle));
end;

function GetWindowDC(Handle: QWidgetH): QPainterH;
begin
  Result := GetDC(Handle);
end;

function ReleaseDC(wdgtH: QWidgetH; Handle: QPainterH): Integer;
begin
  try
    // asn: wdgtH ignored
    QPainter_end(Handle);
    QPainter_destroy(Handle);
    Result := 1;
  except
    Result := 0;
  end;
end;

function ReleaseDC(wdgtH: Integer; Handle: QPainterH): Integer;
begin
  Result := ReleaseDC(QWidgetH(wdgtH), Handle);
end;

function DeleteDC(Handle: QPainterH): LongBool;
var
  P: PPainterInfo;
begin
  if GetPainterInfo(Handle, P) and P.IsCompatibleDC then
    Result := DeleteObject(Handle)
  else
    Result := ReleaseDC(0, Handle) = 1;
end;

function CreateCompatibleDC(Handle: QPainterH; Width: Integer = 1; Height: Integer = 1): QPainterH;
var
  Pixmap: QPixmapH;
begin
  Result := nil;
  try
    Pixmap := CreateCompatibleBitmap(Handle, Width, Height);
    if Pixmap = nil then
      Exit;
    Result := QPainter_create(Pixmap);
    try
      SetPainterInfo(Result).IsCompatibleDC := True;
      QPainter_setPen(Result, QPainter_pen(Handle));
      QPainter_setBackgroundColor(Result, QPainter_BackgroundColor(Handle));
      QPainter_setFont(Result, QPainter_Font(Handle));
      QPainter_begin(Result, QPainter_device(Result));
    except
      DeleteObject(Result);
      Result := nil;
    end;
  except
    Result := nil;
  end;
end;

function CreateCompatibleBitmap(Handle: QPainterH; Width, Height: Integer): QPixmapH;
var
  pdm: QPaintDeviceMetricsH;
begin
  if (Width <= 0) or (Height <= 0) or (QPainter_device(Handle) = nil) then
    Result := nil
  else
  begin
    try
      pdm := QPaintDeviceMetrics_create(QPainter_device(Handle));
      Result := QPixmap_create(Width, Height, QPaintDeviceMetrics_depth(pdm),
        QPixmapOptimization_DefaultOptim);
      QPaintDeviceMetrics_destroy(pdm);
    except
      Result := nil;
    end;
  end;
end;

function CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer): QPixmapH;
begin
  if (Width <= 0) or (Height <= 0) or (Planes <= 0) or (BitCount <= 0) then
    Result := nil
  else
  begin
    try
      Result := QPixmap_create(Width, Height, BitCount, QPixmapOptimization_DefaultOptim);
      if (Result <> nil) and (Bits <> nil) then
      begin
        QPixmap_loadFromData(Result, Bits, (Width * Height * BitCount) div 8,
          'XBM', // (ahuser) is this correct?
          QPixmapColorMode_Auto);
      end;
    except
      Result := nil;
    end;
  end;
end;

function GetObject(Handle: QPixmapH; Size: Cardinal; Data: PtagBITMAP): Boolean;
begin
  Result := False;
  if (Handle <> nil) and (Size > 0) and (Data <> nil) then
  begin
    try
      Data.bmWidth := QPixmap_width(Handle);
      Data.bmHeight := QPixmap_height(Handle);
      Data.bmBitsPixel := QPixmap_depth(Handle);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

function SetPixel(Handle: QPainterH; X, Y: Integer; Color: TColorRef): TColorRef;
var
  Brush: QBrushH;
  OldRop: RasterOp;
  R: TRect;
begin
  R := Bounds(X, Y, 1, 1);
  Brush := CreateSolidBrush(Color);
  OldRop := QPainter_rasterOp(Handle);
  if OldRop <> RasterOp_CopyROP then
    QPainter_setRasterOp(Handle, RasterOp_CopyROP);
  FillRect(Handle, R, Brush);
  if OldRop <> RasterOp_CopyROP then
    QPainter_setRasterOp(Handle, OldRop);
  QBrush_destroy(Brush);
  Result := GetPixel(Handle, X, Y);
end;

function GetPixel(Handle: QPainterH; X, Y: Integer): TColorRef;
{$IFDEF LINUX}
var
  depth: Integer;
  pixmap: QPixmapH;
  pdm: QPaintDeviceMetricsH;
  tempDC: QPainterH;
  img: QImageH;
{$ENDIF LINUX}
begin
  try
    {$IFDEF MSWINDOWS}
    MapPainterLP(Handle, X, Y); // GetPixel does not know about the world matrix
    Result := Windows.GetPixel(QPainter_handle(Handle), X, Y);
    {$ENDIF MSWINDOWS}
    {$IFDEF LINUX}
    pdm := QPaintDeviceMetrics_create(QPainter_device(Handle));
    depth := QPaintDeviceMetrics_depth(pdm);
    QPaintDeviceMetrics_destroy(pdm);
    img := nil;
    tempdc := nil;
    pixmap := nil;
    try
      pixmap := QPixmap_create(2, 2, depth, QPixmapOptimization_NoOptim);
      tempDC := QPainter_create(pixmap);
      BitBlt(tempDC, 0, 0, 1, 1, Handle, X, Y, SRCCOPY);
      img := QImage_create;
      QPixmap_convertToImage(pixmap, img);
      Result := QImage_pixelIndex(img, 0, 0);
    finally
      if Assigned(img) then
        QImage_destroy(img);
      if Assigned(tempdc) then
        QPainter_destroy(tempdc);
      if Assigned(pixmap) then
        QPixmap_destroy(pixmap);
    end;
    {$ENDIF LINUX}
  except
    Result := 0;
  end;
end;

function DeleteObject(Handle: QPainterH): LongBool;
var
  Pixmap: QPaintDeviceH;
  P: PPainterInfo;
  IsCompatible: Boolean;
begin
  if Handle = nil then
    Result := False
  else
  try
    Pixmap := QPainter_device(Handle); // get paintdevice
    if QPainter_isActive(Handle) then
      QPainter_end(Handle);

    IsCompatible := GetPainterInfo(Handle, P) and (P.IsCompatibleDC);
    if P <> nil then
      DeletePainterInfo(Handle);
    QPainter_destroy(Handle);  // destroy painter
    if IsCompatible then
      QPixmap_destroy(QPixmapH(Pixmap)); // destroy pixmap paintdevice
    Result := True;
  except
    Result := False;
  end;
end;

function DeleteObject(Handle: QPixmapH): LongBool;
begin
  try
    QPixmap_destroy(Handle);
    Result := True;
  except
    Result := False;
  end;
end;

function SaveDC(Handle: QPainterH): Integer;
begin
  try
    QPainter_save(Handle);
    Result := -1;
  except
    Result := 0;
  end;
end;

{ only negative and zero values of nSaveDC are supported }
function RestoreDC(Handle: QPainterH; nSavedDC: Integer): LongBool;
var
  i: Integer;
begin
  if nSavedDC < 0 then
  begin
    try
      for i:= nSavedDC - 1 to 0 do // nSavedDC
        QPainter_restore(Handle);
      Result := True;
    except
      Result := False;
    end;
  end
  else // limited implementation
  begin
    Result := True;
    QPainter_restore(Handle);
  end;
end;

function HWND_DESKTOP: QWidgetH;
begin
  Result := QApplication_desktop;
end;

// maps DT_ alignment flags to Qt (extended) alignment flags
function Win2QtAlign(Flags: Integer): Integer;
begin
  Result := 0;
  // Singleline & multiline
  if Flags and DT_SINGLELINE <> 0 then
     Result := SingleLine
  // multiline:
  else if Flags and DT_WORDBREAK <> 0 then
    Result := Result or WordBreak;
//  else
//    Result := Result or BreakAnywhere;
  // <tab> and '&' prefix
  if Flags and DT_EXPANDTABS <> 0 then
    Result := Result or ExpandTabs;
  if Flags and DT_NOPREFIX = 0 then
    Result := Result or ShowPrefix;
  // Horizontal alignment
  if Flags and DT_RIGHT <> 0 then
    Result := Result or AlignRight
  else if Flags and DT_CENTER <> 0 then
    Result := Result or AlignHCenter
  else
    Result := Result or AlignLeft; // default
  // vertical alignment
  if Flags and DT_BOTTOM <> 0 then
    Result := Result or AlignTop
  else if Flags and DT_VCENTER <> 0 then
    Result := Result or AlignVCenter
  else
    Result := Result or AlignTop;  // default
  // extended Qt alignments
  if Flags and DT_CALCRECT <> 0 then
    Result := Result or CalcRect
  else
  begin                            //
    if Flags and DT_ELLIPSIS <> 0 then
      Result := Result or ClipName or SingleLine
    else if Flags and DT_PATH_ELLIPSIS <> 0 then
      Result := Result or ClipPath or SingleLine
    else if Flags and DT_WORD_ELLIPSIS <> 0 then
      Result := Result or ClipToWord;
    if Flags and DT_MODIFYSTRING <> 0 then
      Result := Result or ModifyString;
  end;
end;

// strips Qt extended alignment from flags
function QtStdAlign(Flags: Integer): Word;
begin
  Result := Word(Flags and QtAlignMask);
end;

{$IFDEF LINUX}

function FileGetAttr(const FileName: string): Integer;
var
  sr: TSearchRec;
  valid: Boolean;
begin
  Result := 0;
  valid := FindFirst(FileName, faAnyFile, sr) = 0;
  if valid then
  begin
    Result := sr.attr;
    FindClose(sr);
  end;
end;

function FileGetSize(const FileName: string): Cardinal;
var
  sr: TSearchRec;
  valid: Boolean;
begin
  Result := 0;
  valid := FindFirst(FileName, faAnyFile, sr) = 0;
  if valid then
  begin
    Result := sr.size;
    FindClose(sr);
  end;
end;

function CopyFile(const source: string; const destination: string; FailIfExists: Boolean): LongBool;
const
  ChunkSize = 8192;
var
  CopyBuffer: Pointer;
  Src, Dest: Integer;
  {FSize,} BytesCopied {, TotalCopied}: Longint;
  DestName: string;
begin
  Result := False;
  if DirectoryExists(Destination) then
    DestName := IncludeTrailingPathDelimiter(Destination) + ExtractFileName(Source)
  else
    DestName := Destination;
  if FailIfExists and FileExists(DestName) then
    Exit;
  Result := ForceDirectories(ExtractFilePath(Destination));
  if Result then
  begin
    GetMem(CopyBuffer, ChunkSize);
    try
      Dest := FileCreate(DestName);
      if Dest < 0 then
        raise EFCreateError.CreateFmt(SFCreateError, [DestName]);
      try
        // TotalCopied := 0;
        Src := FileOpen(source, fmShareDenyWrite);
        if Src < 0 then
          raise EFOpenError.CreateFmt(SFOpenError, [source]);
        try
          //FSize := GetFileSize(source);
          repeat
            BytesCopied := FileRead(Src, CopyBuffer^, ChunkSize);
            if BytesCopied = -1 then
              raise EReadError.Create(SReadError);
            // TotalCopied := TotalCopied + BytesCopied;
            if BytesCopied > 0 then
            begin
              if FileWrite(Dest, CopyBuffer^, BytesCopied) = -1 then
                raise EWriteError.Create(SWriteError);
            end;
          until BytesCopied < ChunkSize;
          FileSetDate(DestName, FileGetDate(Src));
          Result := True;
        finally
          FileClose(Dest);
        end;
      finally
        FileClose(Src);
      end;
    finally
      FreeMem(CopyBuffer, ChunkSize);
    end;
  end;
end;

function CopyFile(lpExistingFileName, lpNewFileName: PChar;
  bFailIfExists: LongBool): LongBool;
var
  EF, NF: string;
begin
  EF := lpExistingFileName;
  NF := lpNewFilename;
  Result := CopyFile(EF, NF, Boolean(bFailIfExists));
end;

function CopyFileA(lpExistingFileName, lpNewFileName: PAnsiChar;
  bFailIfExists: LongBool): LongBool;
var
  EF, NF: string;
begin
  EF := lpExistingFileName;
  NF := lpNewFilename;
  Result := CopyFile(EF, NF, Boolean(bFailIfExists));
end;

function CopyFileW(lpExistingFileName, lpNewFileName: PWideChar;
  bFailIfExists: LongBool): LongBool;
var
  EF, NF: string;
begin
  EF := lpExistingFileName;
  NF := lpNewFilename;
  Result := CopyFile(EF, NF, bFailIfExists);
end;

function MakeIntResource(Value: Integer): PChar;
begin
  Result := PChar(Value and $0000ffff);
end;

procedure MessageBeep(Value: Integer);
begin
  QApplication_beep;
end;

var
  StartTimeVal: TTimeVal;

// linux systems tend to run for months,
// rolls over after 49.7 days since application start
// predictable !
// return value: number of milliseconds since application start

function GetTickCount: Cardinal;
var
  TimeVal: TTimeVal;
begin
  gettimeofday(TimeVal, nil);
  Result := 1000 * (TimeVal.tv_sec - StartTimeVal.tv_sec) +
    (TimeVal.tv_usec- StartTimeVal.tv_usec) div 1000;
end;

procedure InitGetTickCount;
begin
  gettimeofday(StartTimeVal, nil);
end;

{$ENDIF LINUX}

const
  QEventType_CMDispatchMessagePost = QEventType(Integer(QEventType_ClxUser) - 1);
  QEventType_CMDispatchMessageSend = QEventType(Integer(QEventType_ClxUser) - 2);

type
  PMessageData = ^TMessageData;
  TMessageData = record
    Control: TWidgetControl;
    Event: TEvent;
    Msg: TMessage;
  end;

function AppEventFilter(App: TApplication; Sender: QObjectH; Event: QEventH): Boolean; cdecl;
var
  Msg: PMessageData;
begin
  try
    Result := False;
    if QEvent_isQCustomEvent(Event) then
    begin
      Msg := QCustomEvent_data(QCustomEventH(Event));
      case QEvent_type(Event) of
        QEventType_CMDispatchMessagePost:
          begin
            Result := True;
            if Msg <> nil then
              try
                Msg^.Control.Dispatch(Msg^.Msg);
              finally
                Dispose(Msg);
              end;
            Exit;
          end;
        QEventType_CMDispatchMessageSend:
          begin
            Result := True;
            try
              if Msg <> nil then
                Msg^.Control.Dispatch(Msg^.Msg);
            finally
              if Msg^.Event <> nil then
                Msg^.Event.SetEvent;
            end;
            Exit;
          end;
      end;
    end;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Result := False;
    end;
  end;
end;

var
  AppEventFilterHook: QObject_hookH = nil;

procedure InstallAppEventFilter;
var
  Method: TMethod;
begin
  if AppEventFilterHook <> nil then
    Exit;

  Method.Code := @AppEventFilter;
  Method.Data := Application;

  AppEventFilterHook := QObject_hook_create(Application.Handle);
  Qt_hook_hook_events(AppEventFilterHook, Method);
end;

function Perform(Control: TControl; Msg: Cardinal; WParam, LParam: Longint): Longint;
var
  M: TMessage;
begin
  M.Msg := Msg;
  M.WParam := WParam;
  M.LParam := LParam;
  M.Result := 0;
  Control.Dispatch(M);
  Result := M.Result;
end;

function PostMsg(Handle: QWidgetH; Msg: Integer; WParam, LParam: Longint): LongBool;
var
  M: PMessageData;
  Control: TWidgetControl;
begin
  Result := False;
  if Handle = nil then
    Exit;
  Control := FindControl(Handle);
  if Control = nil then
    Exit;
  try
    New(M);
    M^.Control := Control;
    M.Event := nil;
    M^.Msg.Msg := Msg;
    M^.Msg.WParam := WParam;
    M^.Msg.LParam := LParam;
    M^.Msg.Result := 0;
    InstallAppEventFilter;

    QApplication_postEvent(Handle, QCustomEvent_create(QEventType_CMDispatchMessagePost, M));
    Result := True;
  except
    Result := False;
  end;
end;

function SendMsg(Handle: QWidgetH; Msg: Integer; WParam, LParam: Longint): Integer;
var
  Event: QCustomEventH;
  M: TMessageData;
  Control: TWidgetControl;
begin
  Result := 0;
  if Handle = nil then
    Exit;
  Control := FindControl(Handle);
  if Control = nil then
    Exit;
  try
    M.Control := Control;
    M.Event := nil;
    M.Msg.Msg := Msg;
    M.Msg.WParam := WParam;
    M.Msg.LParam := LParam;
    M.Msg.Result := 0;

    InstallAppEventFilter;

    Event := QCustomEvent_create(QEventType_CMDispatchMessageSend, @M);
    try
      if GetCurrentThreadId = MainThreadID then
        QApplication_sendEvent(Handle, Event)
      else
      begin
       // synchronize with main thread
        M.Event := TSimpleEvent.Create;
        try
          QApplication_postEvent(Handle, Event);
          M.Event.WaitFor(INFINITE);
        finally
          M.Event.Free;
          M.Event := nil;
        end;
      end;
      Result := M.Msg.Result;
    finally
      if GetCurrentThreadId = MainThreadID then
        QCustomEvent_destroy(Event);
    end;
  except
  end;
end;


{ ------------ Caret -------------- }
{ (C) 2003 Andreas Hausladen <Andreas.Hausladen@gmx.de> }
type
  TEmulatedCaret = class(TObject)
  private
    FTimer: TTimer;
    FWndId: Cardinal;
    FWidget: QWidgetH;
    FPixmap: QPixmapH;
    FWidth, FHeight: Integer;
    FPos: TPoint;
    FVisible: Boolean;
    FShown: Boolean;
    FCritSect: TRTLCriticalSection;
    procedure SetPos(const Value: TPoint);
  protected
    procedure DoTimer(Sender: TObject);
    procedure DrawCaret; virtual;
    function CreateColorPixmap(Color: Cardinal): QPixmapH;
    procedure SetWidget(AWidget: QWidgetH);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;

    function CreateCaret(AWidget: QWidgetH; Pixmap: QPixmapH; Width, Height: Integer): Boolean;
    function DestroyCaret: Boolean;

    function IsValid: Boolean;

    function Show(AWidget: QWidgetH): Boolean;
    function Hide: Boolean;

    property Timer: TTimer read FTimer;
    property Pos: TPoint read FPos write SetPos;
  end;

var
  GlobalCaret: TEmulatedCaret;

function CreateCaret(Widget: QWidgetH; Pixmap: QPixmapH; Width, Height: Integer): Boolean;
begin
  GlobalCaret.Lock;
  try
    Result := GlobalCaret.CreateCaret(Widget, Pixmap, Width, Height);
  finally
    GlobalCaret.Unlock;
  end;
end;

function CreateCaret(Widget: QWidgetH; ColorCaret: Cardinal; Width, Height: Integer): Boolean;
begin
  Result := CreateCaret(Widget, QPixmapH(ColorCaret), Width, Height);
end;

function GetCaretBlinkTime: Cardinal;
begin
  {$IFDEF MSWINDOWS}
  Result := Windows.GetCaretBlinkTime;
  {$ELSE}
  Result := QApplication_cursorFlashTime;
  {$ENDIF MSWINDOWS}
end;

function SetCaretBlinkTime(uMSeconds: Cardinal): LongBool;
begin
  Result := True;
  try
    {$IFDEF MSWINDOWS}
    Windows.SetCaretBlinkTime(uMSeconds);
    {$ENDIF MSWINDOWS}
    QApplication_setCursorFlashTime(uMSeconds);
    GlobalCaret.Lock;
    try
      GlobalCaret.Timer.Interval := GetCaretBlinkTime;
    finally
      GlobalCaret.Unlock;
    end;
  except
    Result := False;
  end;
end;

function HideCaret(Widget: QWidgetH): Boolean;
begin
  GlobalCaret.Lock;
  try
    Result := GlobalCaret.Hide;
  finally
    GlobalCaret.Unlock;
  end;
end;

function ShowCaret(Widget: QWidgetH): Boolean;
begin
  GlobalCaret.Lock;
  try
    Result := GlobalCaret.Show(Widget);
  finally
    GlobalCaret.Unlock;
  end;
end;

function SetCaretPos(X, Y: Integer): Boolean;
begin
  Result := True;
  GlobalCaret.Lock;
  try
    GlobalCaret.Pos := Point(X, Y);
  finally
    GlobalCaret.Unlock;
  end;
end;

function GetCaretPos(var Pt: TPoint): Boolean;
begin
  Result := True;
  GlobalCaret.Lock;
  try
    Pt := GlobalCaret.Pos;
  finally
    GlobalCaret.Unlock;
  end;
end;

function DestroyCaret: Boolean;
begin
  GlobalCaret.Lock;
  try
    Result := GlobalCaret.DestroyCaret;
  finally
    GlobalCaret.Unlock;
  end;
end;

{ TEmulatedCaret }

constructor TEmulatedCaret.Create;
begin
  inherited Create;
  InitializeCriticalSection(FCritSect);

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := GetCaretBlinkTime;
  FTimer.OnTimer := DoTimer;
end;

destructor TEmulatedCaret.Destroy;
begin
  DestroyCaret;
  FTimer.Free;
  DeleteCriticalSection(FCritSect);
  inherited Destroy;
end;

function TEmulatedCaret.CreateCaret(AWidget: QWidgetH; Pixmap: QPixmapH;
  Width, Height: Integer): Boolean;
begin
  DestroyCaret;
  SetWidget(AWidget);
  FWidth := Width;
  FHeight := Height;
  if Cardinal(Pixmap) > $FFFF then
    FPixmap := QPixmap_create(Pixmap)
  else
    FPixmap := CreateColorPixmap(Integer(Pixmap));

  Result := IsValid;
end;

function TEmulatedCaret.DestroyCaret: Boolean;
begin
  Hide;
  if Assigned(FPixmap) then
    QPixmap_destroy(FPixmap);
  FWidget := nil;
  FPixmap := nil;
  FWidth := 0;
  FHeight := 0;
  Result := not IsValid;
end;

procedure TEmulatedCaret.DrawCaret;
var
  DestDev: QPaintDeviceH;
  R: TRect;
begin
  if IsValid then
  begin
    DestDev := QWidget_to_QPaintDevice(FWidget);
    R := Rect(0, 0, QPixmap_width(FPixmap), QPixmap_height(FPixmap));

    Qt.bitBlt(DestDev, @FPos, FPixmap, @R, RasterOp_XorROP);
    FShown := not FShown;
  end;
end;

function TEmulatedCaret.Show(AWidget: QWidgetH): Boolean;
begin
  if FWidget <> AWidget then
    Hide;
  SetWidget(AWidget);
  Result := IsValid;
  if Result then
  begin
    FVisible := True;
    FTimer.Enabled := True;
    DrawCaret;
  end;
end;

function TEmulatedCaret.Hide: Boolean;
begin
  Result := IsValid;
  if Result then
  begin
    FVisible := False;
    FTimer.Enabled := False;
    if FShown then
      DrawCaret;
    FShown := False;
  end;
end;

procedure TEmulatedCaret.SetPos(const Value: TPoint);
begin
  if FVisible then
  begin
    Hide;
    try
      FPos := Value;
    finally
      Show(FWidget);
    end;
  end
  else
    FPos := Value;
end;

procedure TEmulatedCaret.DoTimer(Sender: TObject);
begin
  DrawCaret;
end;

procedure TEmulatedCaret.Lock;
begin
  EnterCriticalSection(FCritSect);
end;

procedure TEmulatedCaret.Unlock;
begin
  LeaveCriticalSection(FCritSect);
end;

function TEmulatedCaret.CreateColorPixmap(Color: Cardinal): QPixmapH;
var
  QC: QColorH;
begin
  if (FWidth <= 0) or (FHeight <= 0) then
    Result := nil
  else
  begin
    case Color of
      0: QC := QColor(clWhite);
      1: QC := QColor(clGray);
    else
      Result := nil;
      Exit;
    end;
    try
      Result := QPixmap_create(FWidth, FHeight, 32, QPixmapOptimization_MemoryOptim);
      try
        QPixmap_fill(Result, QC);
      except
        QPixmap_destroy(Result);
        Result := nil;
      end;
    finally
      QColor_destroy(QC);
    end;
  end;
end;

function TEmulatedCaret.IsValid: Boolean;
begin
  Result := (FWidget <> nil) and (FPixmap <> nil) and
    (QWidget_find(FWndId) <> nil);
end;

procedure TEmulatedCaret.SetWidget(AWidget: QWidgetH);
begin
  FWidget := AWidget;
  if FWidget <> nil then
    FWndId := QWidget_winId(FWidget)
  else
    FWndId := 0;
end;

initialization
  {$IFDEF LINUX}
  InitGetTickCount;
  {$ENDIF LINUX}
  GlobalCaret := TEmulatedCaret.Create;

finalization
  GlobalCaret.Free;
  if Assigned(AppEventFilterHook) then
    QObject_hook_destroy(AppEventFilterHook);
  FreePainterInfos;

end.
