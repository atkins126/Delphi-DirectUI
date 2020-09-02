unit dx_dsgn_particle;

interface

uses
  {$IFDEF FPC}
  LCLProc, LCLType, LMessages, LResources,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, dx_objects, dx_scene, StdCtrls, Buttons,
  dx_ani, ComCtrls, dx_vgcore, dx_vglayer, dx_utils, dx_controls,
  dx_dynamics;

type
  TfrmParticleDesign = class(TForm)
    dxScene1: TdxScene;
    Root1: TdxVisualObject;
    PropertiesLeft: TdxGUIObjectLayer;
    Root2: TvxLayout;
    popupBitmap: TvxCompoundPopupBox;
    popupBlendMode: TvxCompoundPopupBox;
    GroupBox1: TvxGroupBox;
    GroupBox2: TvxGroupBox;
    Label1: TvxLabel;
    numR: TvxNumberBox;
    numG: TvxNumberBox;
    Label2: TvxLabel;
    textRGBA: TvxTextBox;
    numB: TvxNumberBox;
    numA: TvxNumberBox;
    Background1: TvxBackground;
    GUIImage1: TdxGUIImage;
    Emitter: TdxParticleEmitter;
    Camera1: TdxCamera;
    trackParticleCount: TvxCompoundTrackBar;
    imageTexture: TvxImage;
    resizeLayout: TvxLayout;
    rectSelection: TvxSelection;
    trackLifetime: TvxCompoundTrackBar;
    PropertiesRight: TdxGUIObjectLayer;
    Root4: TvxLayout;
    Background2: TvxBackground;
    modalLayout: TvxLayout;
    partGradBack: TvxRectangle;
    partGrad: TvxRectangle;
    ColorQuad1: TvxColorQuad;
    ColorQuad2: TvxColorQuad;
    ColorPicker1: TvxColorPicker;
    ColorPicker2: TvxColorPicker;
    ColorBox1: TvxColorBox;
    ColorBox2: TvxColorBox;
    Layout1: TvxLayout;
    Layout2: TvxLayout;
    numR2: TvxNumberBox;
    numG2: TvxNumberBox;
    numB2: TvxNumberBox;
    numA2: TvxNumberBox;
    textRGBA2: TvxTextBox;
    trackSpinMin: TvxCompoundTrackBar;
    trackSpinMax: TvxCompoundTrackBar;
    trackScaleMax: TvxCompoundTrackBar;
    btnAddBitmap: TvxButton;
    trackScaleMin: TvxCompoundTrackBar;
    trackGravityZ: TvxCompoundTrackBar;
    trackRadialMin: TvxCompoundTrackBar;
    trackRadialMax: TvxCompoundTrackBar;
    trackTangentMin: TvxCompoundTrackBar;
    trackVelocityMax: TvxCompoundTrackBar;
    trackTangentMax: TvxCompoundTrackBar;
    trackSpread: TvxCompoundTrackBar;
    trackDirectionAngle: TvxCompoundTrackBar;
    Plane1: TdxPlane;
    trackGravityX: TvxCompoundTrackBar;
    trackPositionDispersionX: TvxCompoundTrackBar;
    trackGravityY: TvxCompoundTrackBar;
    trackPositionDispersionY: TvxCompoundTrackBar;
    trackPositionDispersionZ: TvxCompoundTrackBar;
    trackVelocityMin: TvxCompoundTrackBar;
    trackFriction: TvxCompoundTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbBitmapListChange(Sender: TObject);
    procedure rgFillModeClick(Sender: TObject);
    procedure rgShadeModeClick(Sender: TObject);
    procedure tbBitmaptileXChange(Sender: TObject);
    procedure tbBitmaptileYChange(Sender: TObject);
    procedure checkLightChange(Sender: TObject);
    procedure ColorQuad1Change(Sender: TObject);
    procedure numRChange(Sender: TObject);
    procedure textRGBAChange(Sender: TObject);
    procedure trackScaleMinChange(Sender: TObject);
    procedure trackSpinMinChange(Sender: TObject);
    procedure trackParticleCountChange(Sender: TObject);
    procedure trackLifetimeChange(Sender: TObject);
    procedure rectSelectionChange(Sender: TObject);
    procedure trackVelocityMinChange(Sender: TObject);
    procedure trackVelocityMaxChange(Sender: TObject);
    procedure numR2Change(Sender: TObject);
    procedure textRGBA2Change(Sender: TObject);
    procedure ColorQuad2Change(Sender: TObject);
    procedure trackSpinMaxChange(Sender: TObject);
    procedure trackScaleMaxChange(Sender: TObject);
    procedure trackGravityXChange(Sender: TObject);
    procedure trackGravityYChange(Sender: TObject);
    procedure trackGravityZChange(Sender: TObject);
    procedure trackRadialMinChange(Sender: TObject);
    procedure trackRadialMaxChange(Sender: TObject);
    procedure btnAddBitmapClick(Sender: TObject);
    procedure trackTangentMinChange(Sender: TObject);
    procedure trackTangentMaxChange(Sender: TObject);
    procedure trackSpreadChange(Sender: TObject);
    procedure trackDirectionAngleChange(Sender: TObject);
    procedure Plane1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single; rayPos, rayDir: TdxVector);
    procedure Plane1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single; rayPos, rayDir: TdxVector);
    procedure Plane1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single; rayPos, rayDir: TdxVector);
    procedure trackPositionDispersionXChange(Sender: TObject);
    procedure trackPositionDispersionYChange(Sender: TObject);
    procedure trackPositionDispersionZChange(Sender: TObject);
    procedure trackFrictionChange(Sender: TObject);
  private
    FParentScene: TdxScene;
    FMousePressed: boolean;
    { Private declarations }
    procedure RebuildBitmapList;
    procedure SetParentScene(const Value: TdxScene);
  public
    { Public declarations }
    procedure AssignFromEmitter(const AEmitter: TdxParticleEmitter);
    procedure AssignToEmitter(var AEmitter: TdxParticleEmitter);
    property ParentScene: TdxScene read FParentScene write SetParentScene;
  end;

  TdxParticleDialog = class(TComponent)
  private
    FEmitter: TdxParticleEmitter;
    procedure SetEmitter(const Value: TdxParticleEmitter);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(AScene: TdxScene): boolean;
    property Emitter: TdxParticleEmitter read FEmitter write SetEmitter;
  published
  end;

var
  frmParticleDesign: TfrmParticleDesign;

implementation

{$ifndef fpc}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$endif}

{ TdxParticleDialog }

constructor TdxParticleDialog.Create(AOwner: TComponent);
begin
  inherited;
  FEmitter := TdxParticleEmitter.Create(Self);
end;

destructor TdxParticleDialog.Destroy;
begin
  FEmitter.Free;
  inherited;
end;

function TdxParticleDialog.Execute(AScene: TdxScene): boolean;
var
  frmParticleDesign: TfrmParticleDesign;
begin
  frmParticleDesign := TfrmParticleDesign.Create(Self);
  frmParticleDesign.ParentScene := AScene;
  frmParticleDesign.modalLayout.Visible := true;
  frmParticleDesign.AssignFromEmitter(FEmitter);
  Result := frmParticleDesign.ShowModal = mrOk;
  frmParticleDesign.AssignToEmitter(FEmitter);
  frmParticleDesign.Free;
end;

procedure TdxParticleDialog.SetEmitter(const Value: TdxParticleEmitter);
begin
  FEmitter.Assign(Value);
end;

{ TfrmParticleDesign }

procedure TfrmParticleDesign.FormCreate(Sender: TObject);
begin
  RebuildBitmapList;
end;

procedure TfrmParticleDesign.AssignFromEmitter(  const AEmitter: TdxParticleEmitter);
begin
  popupBitmap.Value := popupBitmap.PopupBox.Items.IndexOf(AEmitter.Bitmap);
  cbBitmapListChange(Self);
  popupBlendMode.Value := integer(AEmitter.BlendingMode);
  trackGravityX.Value := AEmitter.Gravity.X;
  trackGravityY.Value := AEmitter.Gravity.Y;
  trackGravityZ.Value := AEmitter.Gravity.Z;
  trackParticleCount.Value := AEmitter.ParticlePerSecond;
  trackSpread.Value := AEmitter.SpreadAngle;
  trackDirectionAngle.Value := AEmitter.DirectionAngle;
  trackLifetime.Value := AEmitter.LifeTime;

  trackFriction.Value := AEmitter.Friction;

  trackRadialMin.Value := AEmitter.CentrifugalVelMin;
  trackRadialMax.Value := AEmitter.CentrifugalVelMax;

  trackVelocityMin.Value := AEmitter.VelocityMin;
  trackVelocityMax.Value := AEmitter.VelocityMax;

  trackTangentMin.Value := AEmitter.TangentVelMin;
  trackTangentMax.Value := AEmitter.TangentVelMax;

  trackSpinMin.Value := AEmitter.SpinBegin;
  trackSpinMax.Value := AEmitter.SpinEnd;

  trackScaleMin.Value := AEmitter.ScaleBegin;
  trackScaleMax.Value := AEmitter.ScaleEnd;

  ColorPicker1.Color := dxStrToColor(AEmitter.ColorBegin);
  ColorPicker2.Color := dxStrToColor(AEmitter.ColorEnd);

  trackPositionDispersionX.Value := AEmitter.PositionDispersion.X;
  trackPositionDispersionY.Value := AEmitter.PositionDispersion.Y;
  trackPositionDispersionZ.Value := AEmitter.PositionDispersion.Z;

  with AEmitter.Rect do
  begin
    rectSelection.SetBounds(left * resizeLayout.Width, top * resizeLayout.Height, (right - left) * resizeLayout.Width,
      (bottom - top) * resizeLayout.Height);
  end;
//    FVelocityMode := TdxParticleEmitter(Source).VelocityMode;
//    FFollowToOwner := TdxParticleEmitter(Source).FollowToOwner;
//    FDispersionMode := TdxParticleEmitter(Source).DispersionMode;
//    FDirectionAngle := TdxParticleEmitter(Source).DirectionAngle;
//    FFriction := TdxParticleEmitter(Source).Friction;

  Emitter.Assign(AEmitter);
end;

procedure TfrmParticleDesign.AssignToEmitter(var AEmitter: TdxParticleEmitter);
begin
  AEmitter.Assign(Emitter);
end;

procedure TfrmParticleDesign.RebuildBitmapList;
var
  i: integer;
begin
  popupBitmap.PopupBox.Items.Clear;
  popupBitmap.PopupBox.Items.Add('(empty)');
  for i := 0 to BitmapList.Count - 1 do
  begin
    if (GetBitmapParent(BitmapList[i]) = ParentScene) or (GetBitmapParent(BitmapList[i]) is TdxBitmapList) then 
      popupBitmap.PopupBox.Items.Add(BitmapList[i]);
  end;
end;

procedure TfrmParticleDesign.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmParticleDesign.cbBitmapListChange(Sender: TObject);
var
  B: TdxBitmap;
begin
  if popupBitmap.Value = 0 then
    Emitter.Bitmap := ''
  else
    Emitter.Bitmap := popupBitmap.PopupBox.Items[popupBitmap.Value];

  B := GetBitmapByName(Emitter.Bitmap);
  if B <> nil then
  begin
    imageTexture.Bitmap.SetSize(B.Width, B.Height);
    Move(B.Bits^, imageTexture.Bitmap.StartLine^, B.Width * B.Height * 4);
    if (B.Width < imageTexture.Width) and (B.Height < imageTexture.Height) then
    begin
      resizeLayout.SetBounds(0, 0, B.Width, B.Height);
      resizeLayout.Align := vaCenter;
    end
    else
    begin
      resizeLayout.SetBounds(0, 0, B.Width, B.Height);
      resizeLayout.Align := vaFit;
    end;
    rectSelection.Visible := true;
  end
  else
  begin
    imageTexture.Bitmap.SetSize(1, 1);
    rectSelection.Visible := false;
  end;
  imageTexture.Repaint;
end;

procedure TfrmParticleDesign.rgFillModeClick(Sender: TObject);
begin
(*  { cube }
  Cube1.Material.FillMode := TdxFillMode(popupFillMode.Value);
  Cube2.Material.FillMode := TdxFillMode(popupFillMode.Value);
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material); *)
end;

procedure TfrmParticleDesign.rgShadeModeClick(Sender: TObject);
begin
  Emitter.BlendingMode := TdxBlendingMode(popupBlendMode.Value);
end;

procedure TfrmParticleDesign.tbBitmaptileXChange(Sender: TObject);
begin
(*  Cube1.Material.BitmapTileX := trackTileX.Value;
  Cube2.Material.BitmapTileX := trackTileX.Value;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material); *)
end;

procedure TfrmParticleDesign.tbBitmaptileYChange(Sender: TObject);
begin
(*  Cube1.Material.BitmapTileY := trackTileY.Value;
  Cube2.Material.BitmapTileY := trackTileY.Value;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material); *)
end;

procedure TfrmParticleDesign.checkLightChange(Sender: TObject);
begin
(*  { cube }
  Cube1.Material.Lighting := checkLight.IsChecked;
  Cube2.Material.Lighting := checkLight.IsChecked;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material); *)
end;

procedure TfrmParticleDesign.numRChange(Sender: TObject);
var
  Color: TdxColor;
begin
  Color := ColorPicker1.Color;
  TdxColorRec(Color).R := trunc(numR.Value);
  TdxColorRec(Color).G := trunc(numG.Value);
  TdxColorRec(Color).B := trunc(numB.Value);
  TdxColorRec(Color).A := trunc(numA.Value);
  textRGBA.Text := dxColorToStr(ColorBox1.Color);
  ColorPicker1.Color := Color;
  partGrad.Fill.Gradient.Points[0].Color := textRGBA.Text;
  partGrad.Repaint;
end;

procedure TfrmParticleDesign.textRGBAChange(Sender: TObject);
begin
  ColorPicker1.Color := dxStrToColor(textRGBA.Text);
end;

procedure TfrmParticleDesign.ColorQuad1Change(Sender: TObject);
begin
  Emitter.ColorBegin := dxColorToStr(ColorBox1.Color);
  numR.Value := TdxColorRec(ColorBox1.Color).R;
  numG.Value := TdxColorRec(ColorBox1.Color).G;
  numB.Value := TdxColorRec(ColorBox1.Color).B;
  numA.Value := TdxColorRec(ColorBox1.Color).A;
  textRGBA.Text := dxColorToStr(ColorBox1.Color);
  partGrad.Fill.Gradient.Points[0].Color := textRGBA.Text;
  partGrad.Repaint;
end;

procedure TfrmParticleDesign.trackScaleMinChange(Sender: TObject);
begin
  Emitter.ScaleBegin := trackScaleMin.Value;
end;

procedure TfrmParticleDesign.trackScaleMaxChange(Sender: TObject);
begin
  Emitter.ScaleEnd := trackScaleMax.Value;
end;

procedure TfrmParticleDesign.trackSpinMinChange(Sender: TObject);
begin
  Emitter.SpinBegin := trackSpinMin.Value;
end;

procedure TfrmParticleDesign.trackSpinMaxChange(Sender: TObject);
begin
  Emitter.Spinend := trackSpinMax.Value;
end;

procedure TfrmParticleDesign.trackParticleCountChange(Sender: TObject);
begin
  Emitter.ParticlePerSecond := trackParticleCount.Value;
end;

procedure TfrmParticleDesign.trackLifetimeChange(Sender: TObject);
begin
  Emitter.LifeTime := trackLifetime.Value;
end;

procedure TfrmParticleDesign.rectSelectionChange(Sender: TObject);
begin
  with rectSelection.ParentedRect do
    Emitter.Rect.Rect := vgRect(left / resizeLayout.Width, top / resizeLayout.Height,
      right / resizeLayout.Width, bottom / resizeLayout.Height);
end;

procedure TfrmParticleDesign.trackVelocityMinChange(Sender: TObject);
begin
  Emitter.VelocityMin := trackVelocityMin.Value;
end;

procedure TfrmParticleDesign.trackVelocityMaxChange(Sender: TObject);
begin
  Emitter.VelocityMax := trackVelocityMax.Value;
end;

procedure TfrmParticleDesign.numR2Change(Sender: TObject);
var
  Color: TdxColor;
begin
  Color := ColorPicker2.Color;
  TdxColorRec(Color).R := trunc(numR2.Value);
  TdxColorRec(Color).G := trunc(numG2.Value);
  TdxColorRec(Color).B := trunc(numB2.Value);
  TdxColorRec(Color).A := trunc(numA2.Value);
  textRGBA2.Text := dxColorToStr(ColorBox2.Color);
  partGrad.Fill.Gradient.Points[1].Color := textRGBA2.Text;
  partGrad.Repaint;
  ColorPicker2.Color := Color;
end;

procedure TfrmParticleDesign.textRGBA2Change(Sender: TObject);
begin
  ColorPicker2.Color := dxStrToColor(textRGBA.Text);
end;

procedure TfrmParticleDesign.ColorQuad2Change(Sender: TObject);
begin
  Emitter.ColorEnd := dxColorToStr(ColorBox2.Color);
  numR2.Value := TdxColorRec(ColorBox2.Color).R;
  numG2.Value := TdxColorRec(ColorBox2.Color).G;
  numB2.Value := TdxColorRec(ColorBox2.Color).B;
  numA2.Value := TdxColorRec(ColorBox2.Color).A;
  textRGBA2.Text := dxColorToStr(ColorBox2.Color);
  partGrad.Fill.Gradient.Points[1].Color := textRGBA2.Text;
  partGrad.Repaint;
end;

procedure TfrmParticleDesign.trackGravityXChange(Sender: TObject);
begin
  Emitter.Gravity.X := trackGravityX.Value;
end;

procedure TfrmParticleDesign.trackGravityYChange(Sender: TObject);
begin
  Emitter.Gravity.Y := trackGravityY.Value;
end;

procedure TfrmParticleDesign.trackGravityZChange(Sender: TObject);
begin
  Emitter.Gravity.Z := trackGravityZ.Value;
end;

procedure TfrmParticleDesign.trackRadialMinChange(Sender: TObject);
begin
  Emitter.CentrifugalVelMin := trackRadialMin.Value;
end;

procedure TfrmParticleDesign.trackRadialMaxChange(Sender: TObject);
begin
  Emitter.CentrifugalVelMax := trackRadialMax.Value;
end;

procedure TfrmParticleDesign.btnAddBitmapClick(Sender: TObject);
var
  B: TvxBitmap;
  BitmapObject: TdxBitmapObject;
begin
  if ParentScene = nil then Exit;

  vgBitmapEditor := TvxBitmapEditor.Create(nil);
  if vgBitmapEditor.ShowModal = mrOk then
  begin
    B := TvxBitmap.Create(1, 1);
    vgBitmapEditor.AssignToBitmap(B);

    BitmapObject := TdxBitmapObject.Create(ParentScene.Owner);
    BitmapObject.Parent := ParentScene.Root;
    BitmapObject.Bitmap.Assign(B);
    if vgBitmapEditor.FileName <> '' then
      BitmapObject.ResourceName := ExtractFileName(vgBitmapEditor.FileName);

    RebuildBitmapList;
    popupBitmap.PopupBox.ItemIndex := popupBitmap.PopupBox.Items.IndexOf(BitmapObject.ResourceName);

    B.Free;
  end;
  vgBitmapEditor.Free;
end;

procedure TfrmParticleDesign.SetParentScene(const Value: TdxScene);
begin
  FParentScene := Value;
  RebuildBitmapList;
end;

procedure TfrmParticleDesign.trackTangentMinChange(Sender: TObject);
begin
  Emitter.TangentVelMin := trackTangentMin.Value;
end;

procedure TfrmParticleDesign.trackTangentMaxChange(Sender: TObject);
begin
  Emitter.TangentVelMax := trackTangentMax.Value;
end;

procedure TfrmParticleDesign.trackSpreadChange(Sender: TObject);
begin
  Emitter.SpreadAngle := trackSpread.Value;
end;

procedure TfrmParticleDesign.trackDirectionAngleChange(Sender: TObject);
begin
  Emitter.DirectionAngle := trackDirectionAngle.Value;
end;

procedure TfrmParticleDesign.Plane1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single; rayPos,
  rayDir: TdxVector);
var
  Int: TdxVector;
begin
  if Plane1.RayCastIntersect(rayPos, rayDir, Int) and (Button = mbLeft) then
  begin
    Emitter.AnimateFloat('Position.X', Int.X, 0.2);
    Emitter.AnimateFloat('Position.Z', Int.Z, 0.2);
    FMousePressed := true;
  end;
end;

procedure TfrmParticleDesign.Plane1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single; rayPos, rayDir: TdxVector);
var
  Int: TdxVector;
begin
  if FMousePressed and Plane1.RayCastIntersect(rayPos, rayDir, Int) then
  begin
    Emitter.Position.Point := dxPoint(Int);
    Application.ProcessMessages;
  end;
end;

procedure TfrmParticleDesign.Plane1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single; rayPos,
  rayDir: TdxVector);
begin
  if FMousePressed then
  begin
    Emitter.AnimateFloat('Position.X', 0, 0.3);
    Emitter.AnimateFloat('Position.Z', 0, 0.3);
    FMousePressed := false;
  end;
end;

procedure TfrmParticleDesign.trackPositionDispersionXChange(
  Sender: TObject);
begin
  Emitter.PositionDispersion.X := trackPositionDispersionX.Value;
end;

procedure TfrmParticleDesign.trackPositionDispersionYChange(
  Sender: TObject);
begin
  Emitter.PositionDispersion.Y := trackPositionDispersionY.Value;
end;

procedure TfrmParticleDesign.trackPositionDispersionZChange(
  Sender: TObject);
begin
  Emitter.PositionDispersion.Y := trackPositionDispersionY.Value;
end;

procedure TfrmParticleDesign.trackFrictionChange(Sender: TObject);
begin
  Emitter.Friction := trackFriction.Value;
end;

end.
