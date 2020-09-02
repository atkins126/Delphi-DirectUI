unit JDUIWidgetfrm;

interface

uses
  WinApi.Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms, JDUIUtils, jinUtils,
  Dialogs, dx_vgcore, dx_scene, dx_vglayer, dx_ani, PngImage2, Gr32;

type
  T3DSwithType = (d3dType1, d3dType2, d3dType3, d3dType4, d3dType5);
  T3DSwithEvent = procedure(ADC: Cardinal; AWidth, AHeight: Integer; ATicket: Cardinal) of object;
  TJDUIWidget3DSwithForm = class(TForm)
    dxScene: TdxScene;
    Root1: TdxVisualObject;
    WidgetLayout: TdxGUIObjectLayer;
    Root2: TvxLayout;
    Front: TvxRectangle;
    Back: TvxRectangle;
    procedure dxSceneUpdateLayer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FDestroying: Boolean;
    FStartTicket: Cardinal;
    F3DSwithCallBack: T3DSwithEvent;
    procedure Switch4(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
    procedure Switch5(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
    procedure Switch2(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
    procedure Switch3(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
    procedure Switch1(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
    procedure AnimateFinished(Sender: TObject);
    procedure AnimateFirstStepFinished(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
  end;

  procedure Switch3D(ABitmap1, ABitmap2: TBitmap32;
    AWidth, AHeight: Integer;
    AInterpolation: TvxInterpolationType;
    ADuration: single;
    A3DSwithCallBack: T3DSwithEvent;
    A3DSwithType: T3DSwithType;
    AWait: Boolean = True);

var
  Widget3DSwithForm: TJDUIWidget3DSwithForm;
  Switching3D: Boolean;

implementation

{$R *.dfm}

procedure Switch3D(ABitmap1, ABitmap2: TBitmap32;
  AWidth, AHeight: Integer;
  AInterpolation: TvxInterpolationType;
  ADuration: single;
  A3DSwithCallBack: T3DSwithEvent;
  A3DSwithType: T3DSwithType;
  AWait: Boolean);
var
  Widget3DSwithForm: TJDUIWidget3DSwithForm;
begin
  Switching3D := True;
  Widget3DSwithForm := TJDUIWidget3DSwithForm.Create(nil);
  try
    Widget3DSwithForm.dxScene.BeginUpdate;
    try
      Widget3DSwithForm.SetBounds(-AWidth, -AHeight, AWidth, AHeight);
      Widget3DSwithForm.dxScene.SetBounds(0, 0, AWidth, AHeight);

      Widget3DSwithForm.WidgetLayout.Position.X := AWidth / 2;
      Widget3DSwithForm.WidgetLayout.Position.Y := AHeight / 2;
      Widget3DSwithForm.WidgetLayout.Width := AWidth;
      Widget3DSwithForm.WidgetLayout.Height := AHeight;

      if Assigned(ABitmap1) then
      begin
        try
          Widget3DSwithForm.Front.Fill.Bitmap.Bitmap.Assign(ABitmap1);
        except
        end;
      end;
      Widget3DSwithForm.Front.Position.X := 0;
      Widget3DSwithForm.Front.Position.Y := 0;
      Widget3DSwithForm.Front.Width := AWidth;
      Widget3DSwithForm.Front.Height := AHeight;

      if Assigned(ABitmap2) then
      begin
        try
          Widget3DSwithForm.Back.Fill.Bitmap.Bitmap.Assign(ABitmap2);
        except
        end;
      end;
      Widget3DSwithForm.Back.Position.X := 0;
      Widget3DSwithForm.Back.Position.Y := 0;
      Widget3DSwithForm.Back.Width := AWidth;
      Widget3DSwithForm.Back.Height := AHeight;

      Widget3DSwithForm.AlphaBlendValue := 0;
      Widget3DSwithForm.AlphaBlend := True;
      ShowWindow(Widget3DSwithForm.Handle, SW_SHOWNOACTIVATE);
      Widget3DSwithForm.Visible := True;
      //Widget3DSwithForm.Show;

      Application.ProcessMessages;

      Widget3DSwithForm.FStartTicket := 0;
      Widget3DSwithForm.F3DSwithCallBack := A3DSwithCallBack;
    finally
      Widget3DSwithForm.dxScene.EndUpdate;
    end;
    case A3DSwithType of
      d3dType1: Widget3DSwithForm.Switch1(AInterpolation, ADuration, AWait);
      d3dType2: Widget3DSwithForm.Switch2(AInterpolation, ADuration, AWait);
      d3dType3: Widget3DSwithForm.Switch3(AInterpolation, ADuration, AWait);
      d3dType4: Widget3DSwithForm.Switch4(AInterpolation, ADuration, AWait);
      d3dType5: Widget3DSwithForm.Switch5(AInterpolation, ADuration, AWait);
    end;

    //Widget3DSwithForm.Hide;
  finally
    if AWait then FreeAndNil(Widget3DSwithForm);
  end;
end;

procedure TJDUIWidget3DSwithForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    ExStyle := ExStyle or WS_EX_LAYERED;
    ExStyle := ExStyle or WS_EX_NOACTIVATE;
  end;
end;

procedure TJDUIWidget3DSwithForm.dxSceneUpdateLayer(Sender: TObject);
begin
  if FStartTicket = 0 then Exit;
  
  if Assigned(F3DSwithCallBack) then F3DSwithCallBack(dxScene.Canvas.BufferDC, Width, Height, GetTickCount - FStartTicket);
end;

procedure TJDUIWidget3DSwithForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDestroying := True;
  Action := caFree;
end;

procedure TJDUIWidget3DSwithForm.FormDestroy(Sender: TObject);
begin
  FDestroying := True;
  Switching3D := False;
end;

procedure TJDUIWidget3DSwithForm.AnimateFinished(Sender: TObject);
begin
  if FDestroying then Exit;
  
  TdxAnimation(Sender).Free;
  if Assigned(F3DSwithCallBack) then
  begin
    F3DSwithCallBack(0, 0, 0, 0);
    F3DSwithCallBack := nil;
  end;
  Close;
end;

procedure TJDUIWidget3DSwithForm.Switch5(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
begin
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.Position.Z := Height * 1.5;//800;
  FStartTicket := GetTickCount;
  WidgetLayout.AnimateFloat('Position.Z', 0, ADuration, vgAnimationOut, AInterpolation);
  WidgetLayout.RotateAngle.X := 270;

  if AWait then
    WidgetLayout.AnimateFloatWait('RotateAngle.X', 360, ADuration, vgAnimationOut, AInterpolation)
  else
    WidgetLayout.AnimateFloat('RotateAngle.X', 360, ADuration, vgAnimationOut, AInterpolation, AnimateFinished);
end;

procedure TJDUIWidget3DSwithForm.Switch4(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
begin
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.Position.Z := Height * 1.5;//800;
  FStartTicket := GetTickCount;
  WidgetLayout.AnimateFloat('Position.Z', 0, ADuration, vgAnimationOut, AInterpolation);
  WidgetLayout.RotateAngle.X := 90;

  if AWait then
    WidgetLayout.AnimateFloatWait('RotateAngle.X', 0, ADuration, vgAnimationOut, AInterpolation)
  else
    WidgetLayout.AnimateFloat('RotateAngle.X', 0, ADuration, vgAnimationOut, AInterpolation, AnimateFinished);
end;

procedure TJDUIWidget3DSwithForm.Switch3(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
begin
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.Position.Z := Width * 1.5;//800;
  FStartTicket := GetTickCount;
  WidgetLayout.AnimateFloat('Position.Z', 0, ADuration, vgAnimationOut, AInterpolation);
  WidgetLayout.RotateAngle.Y := 90;

  if AWait then
    WidgetLayout.AnimateFloatWait('RotateAngle.Y', 0, ADuration, vgAnimationOut, AInterpolation)
  else
    WidgetLayout.AnimateFloat('RotateAngle.Y', 0, ADuration, vgAnimationOut, AInterpolation, AnimateFinished);
end;

procedure TJDUIWidget3DSwithForm.Switch1(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
begin
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.Position.Z := Width * 1.5;//800;
  FStartTicket := GetTickCount;
  WidgetLayout.AnimateFloat('Position.Z', 0, ADuration, vgAnimationOut, AInterpolation);
  WidgetLayout.RotateAngle.Y := 270;

  if AWait then
    WidgetLayout.AnimateFloatWait('RotateAngle.Y', 360, ADuration, vgAnimationOut, AInterpolation)
  else
    WidgetLayout.AnimateFloat('RotateAngle.Y', 360, ADuration, vgAnimationOut, AInterpolation, AnimateFinished);
end;

procedure TJDUIWidget3DSwithForm.AnimateFirstStepFinished(Sender: TObject);
begin
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.RotateAngle.Y := 270;

  WidgetLayout.AnimateFloat('Position.Z', 0, TdxAnimation(Sender).Duration, vgAnimationOut, TdxAnimation(Sender).Interpolation);
  WidgetLayout.AnimateFloat('RotateAngle.Y', 360, TdxAnimation(Sender).Duration, vgAnimationOut, TdxAnimation(Sender).Interpolation, AnimateFinished);

  TdxAnimation(Sender).Free;
end;

procedure TJDUIWidget3DSwithForm.Switch2(AInterpolation: TvxInterpolationType; ADuration: single; AWait: Boolean);
begin
  FStartTicket := GetTickCount;
  WidgetLayout.AnimateFloat('Position.Z', Width / 1.5, ADuration, vgAnimationIn, AInterpolation);
  if not AWait then
  begin
    WidgetLayout.AnimateFloat('RotateAngle.Y', 90, ADuration, vgAnimationIn, AInterpolation, AnimateFirstStepFinished);
    Exit;
  end;

  WidgetLayout.AnimateFloatWait('RotateAngle.Y', 90, ADuration, vgAnimationIn, AInterpolation);
  Back.Visible := true;
  Front.Visible := false;
  WidgetLayout.RotateAngle.Y := 270;

  WidgetLayout.AnimateFloat('Position.Z', 0, ADuration, vgAnimationOut, AInterpolation);
  WidgetLayout.AnimateFloatWait('RotateAngle.Y', 360, ADuration, vgAnimationOut, AInterpolation);
end;

end.
