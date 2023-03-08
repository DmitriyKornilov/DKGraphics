{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DKGraphics;

{$warn 5023 off : no warning about unused units}
interface

uses
  DK_Graph, DK_PNGDrawer, DK_StatPlotter, DK_SVGWriter, DK_BGRADrawer, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('DKGraphics', @Register);
end.
