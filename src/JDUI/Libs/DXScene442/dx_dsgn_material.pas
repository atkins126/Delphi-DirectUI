unit dx_dsgn_material;

interface

uses
  {$IFDEF FPC}
  LCLProc, LCLType, LMessages, LResources,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, dx_objects, dx_scene, StdCtrls, Buttons,
  dx_ani, ComCtrls, dx_vgcore, dx_vglayer, dx_utils, dx_controls;

type

  { TfrmMaterialDesign }

  TfrmMaterialDesign = class(TForm)
    dxScene1: TdxScene;
    Root1: TdxVisualObject;
    Light1: TdxLight;
    rotate: TdxFloatAnimation;
    Cube1: TdxCylinder;
    GUIObjectLayer1: TdxGUIObjectLayer;
    Root2: TvxLayout;
    checkLight: TvxCheckBox;
    popupBitmap: TvxCompoundPopupBox;
    popupModulation: TvxCompoundPopupBox;
    popupFillMode: TvxCompoundPopupBox;
    popupShadeMode: TvxCompoundPopupBox;
    GroupBox1: TvxGroupBox;
    trackTileX: TvxCompoundTrackBar;
    trackTileY: TvxCompoundTrackBar;
    Cube2: TdxCube;
    FloatAnimation1: TdxFloatAnimation;
    GroupBox2: TvxGroupBox;
    colorList: TvxStringListBox;
    ColorQuad1: TvxColorQuad;
    ColorPicker1: TvxColorPicker;
    ColorBox1: TvxColorBox;
    Layout1: TvxLayout;
    Label1: TvxLabel;
    numR: TvxNumberBox;
    numG: TvxNumberBox;
    Label2: TvxLabel;
    textRGBA: TvxTextBox;
    numB: TvxNumberBox;
    numA: TvxNumberBox;
    Background1: TvxBackground;
    GUIImage1: TdxGUIImage;
    modalLayout: TdxGUIObjectLayer;
    Root3: TvxLayout;
    Background2: TvxBackground;
    Button1: TvxButton;
    Button2: TvxButton;
    btnAddBitmap: TvxButton;
    procedure Button1Click(Sender: TObject);
    procedure rgModulationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbBitmapListChange(Sender: TObject);
    procedure rgFillModeClick(Sender: TObject);
    procedure rgShadeModeClick(Sender: TObject);
    procedure tbBitmaptileXChange(Sender: TObject);
    procedure tbBitmaptileYChange(Sender: TObject);
    procedure checkLightChange(Sender: TObject);
    procedure ColorQuad1Change(Sender: TObject);
    procedure colorListChange(Sender: TObject);
    procedure numRChange(Sender: TObject);
    procedure textRGBAChange(Sender: TObject);
    procedure btnAddBitmapClick(Sender: TObject);
  private
    FMaterial: TdxMaterial;
    FParentScene: TdxScene;
    procedure SetMaterial(const Value: TdxMaterial);
    procedure RebuildBitmapList;
    { Private declarations }
  public
    { Public declarations }
    property Material: TdxMaterial read FMaterial write SetMaterial;
    property ParentScene: TdxScene read FParentScene write FParentScene;
  end;

  TdxMaterialDialog = class(TComponent)
  private
    FMaterial: TdxMaterial;
    procedure SetMaterial(const Value: TdxMaterial);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean;
    property Material: TdxMaterial read FMaterial write SetMaterial;
  published
  end;

var
  frmMaterialDesign: TfrmMaterialDesign;

implementation

{$ifndef fpc}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$endif}

procedure TfrmMaterialDesign.FormCreate(Sender: TObject);
begin
  RebuildBitmapList;
end;

procedure TfrmMaterialDesign.RebuildBitmapList;
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

procedure TfrmMaterialDesign.Button1Click(Sender: TObject);
begin   
  Close;
end;

procedure TfrmMaterialDesign.SetMaterial(const Value: TdxMaterial);
var
  i: integer;
begin
  FMaterial := Value;
  if Assigned(FMaterial) then
  begin
    Cube1.Material.Assign(FMaterial);
    Cube2.Material.Assign(FMaterial);

    ColorPicker1.Color := Cube1.Material.NativeDiffuse;

    RebuildBitmapList;
    if FMaterial.Bitmap = '' then
      popupBitmap.Value := 0
    else
      for i := 1 to popupBitmap.PopupBox.Items.Count - 1 do
      begin
        if FMaterial.Bitmap = popupBitmap.PopupBox.Items[i] then
        begin
          popupBitmap.Value := i;
          Break;
        end;
      end;
    checkLight.IsChecked := FMaterial.Lighting;
    popupModulation.Value := Integer(FMaterial.BitmapMode);
    popupFillMode.Value := Integer(FMaterial.FillMode);
    popupShadeMode.Value := Integer(FMaterial.ShadeMode);
    trackTileX.Value := Round(FMaterial.BitmapTileX);
    trackTileY.Value := Round(FMaterial.BitmapTileY);
  end;
end;

procedure TfrmMaterialDesign.rgModulationClick(Sender: TObject);
begin
  { cube }
  Cube1.Material.BitmapMode := TdxTexMode(popupModulation.Value);
  Cube2.Material.BitmapMode := TdxTexMode(popupModulation.Value);
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.cbBitmapListChange(Sender: TObject);
begin
  { cube }
  if popupBitmap.Value = 0 then
    Cube1.Material.Bitmap := ''
  else
    Cube1.Material.Bitmap := popupBitmap.PopupBox.Items[popupBitmap.Value];
  Cube2.Material.Bitmap := Cube1.Material.Bitmap;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.rgFillModeClick(Sender: TObject);
begin
  { cube }
  Cube1.Material.FillMode := TdxFillMode(popupFillMode.Value);
  Cube2.Material.FillMode := TdxFillMode(popupFillMode.Value);
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.rgShadeModeClick(Sender: TObject);
begin
  { cube }
  Cube1.Material.ShadeMode := TdxShadeMode(popupShadeMode.Value);
  Cube2.Material.ShadeMode := TdxShadeMode(popupShadeMode.Value);
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.tbBitmaptileXChange(Sender: TObject);
begin
  Cube1.Material.BitmapTileX := trackTileX.Value;
  Cube2.Material.BitmapTileX := trackTileX.Value;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.tbBitmaptileYChange(Sender: TObject);
begin
  Cube1.Material.BitmapTileY := trackTileY.Value;
  Cube2.Material.BitmapTileY := trackTileY.Value;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.checkLightChange(Sender: TObject);
begin
  { cube }
  Cube1.Material.Lighting := checkLight.IsChecked;
  Cube2.Material.Lighting := checkLight.IsChecked;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.ColorQuad1Change(Sender: TObject);
begin
  { cube }
  case colorList.ItemIndex of
    0: begin
      Cube1.Material.NativeAmbient := ColorBox1.Color;
      Cube2.Material.NativeAmbient := ColorBox1.Color;
      numR.Value := TdxColorRec(ColorBox1.Color).R;
      numG.Value := TdxColorRec(ColorBox1.Color).G;
      numB.Value := TdxColorRec(ColorBox1.Color).B;
      numA.Value := TdxColorRec(ColorBox1.Color).A;
      textRGBA.Text := dxColorToStr(ColorBox1.Color);
    end;
    1: begin
      Cube1.Material.NativeDiffuse := ColorBox1.Color;
      Cube2.Material.NativeDiffuse := ColorBox1.Color;
      numR.Value := TdxColorRec(ColorBox1.Color).R;
      numG.Value := TdxColorRec(ColorBox1.Color).G;
      numB.Value := TdxColorRec(ColorBox1.Color).B;
      numA.Value := TdxColorRec(ColorBox1.Color).A;
      textRGBA.Text := dxColorToStr(ColorBox1.Color);
    end;
  end;
  { material }
  if Assigned(FMaterial) then
    FMaterial.Assign(Cube1.Material);
end;

procedure TfrmMaterialDesign.colorListChange(Sender: TObject);
begin
  case colorList.ItemIndex of
    0: begin
      ColorPicker1.Color := Cube1.Material.NativeAmbient;
    end;
    1: begin
      ColorPicker1.Color := Cube1.Material.NativeDiffuse;
    end;
  end;
end;

procedure TfrmMaterialDesign.numRChange(Sender: TObject);
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
end;

procedure TfrmMaterialDesign.textRGBAChange(Sender: TObject);
begin
  ColorPicker1.Color := dxStrToColor(textRGBA.Text);
end;

procedure TfrmMaterialDesign.btnAddBitmapClick(Sender: TObject);
var
  B: TvxBitmap;
  BitmapObject: TdxBitmapObject;
  vgBitmapEditor: TvxBitmapEditor;
begin
  if ParentScene = nil then Exit;
  
  vgBitmapEditor := TvxBitmapEditor.Create(nil);
  if vgBitmapEditor.ShowModal = mrOk then
  begin
    B := TvxBitmap.Create(1, 1);
    vgBitmapEditor.AssignToBitmap(B);

    BitmapObject := TdxBitmapObject.Create(ParentScene.Owner);
    BitmapObject.Parent := ParentScene.Root;
    if dxDesigner <> nil then
      BitmapObject.Name := dxDesigner.UniqueName(ParentScene.Owner, BitmapObject.ClassName);
    BitmapObject.Bitmap.Assign(B);
    if vgBitmapEditor.FileName <> '' then
      BitmapObject.ResourceName := ExtractFileName(vgBitmapEditor.FileName);

    RebuildBitmapList;
    popupBitmap.PopupBox.ItemIndex := popupBitmap.PopupBox.Items.IndexOf(BitmapObject.ResourceName);
    
    B.Free;
  end;
  vgBitmapEditor.Free;
end;

{ TdxMaterialDialog }

constructor TdxMaterialDialog.Create(AOwner: TComponent);
begin
  inherited;
  FMaterial := TdxMaterial.Create;
end;

destructor TdxMaterialDialog.Destroy;
begin
  FMaterial.Free;
  inherited;
end;

function TdxMaterialDialog.Execute: boolean;
var
  Dialog: TfrmMaterialDesign;
  EditMaterial: TdxMaterial;
begin
  Dialog := TfrmMaterialDesign.Create(Application);

  Dialog.modalLayout.Visible := true;

  Dialog.Material := FMaterial;
  Result := Dialog.ShowModal = mrOk;
  Dialog.Free;
end;

procedure TdxMaterialDialog.SetMaterial(const Value: TdxMaterial);
begin
  FMaterial.Assign(Value);;
end;


end.
