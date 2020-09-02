unit dx_physics_newton;

{$I dx_define.inc}

interface

uses
  {$IFDEF FPC}
  dynlibs, ctypes,
  {$ENDIF }
  {$IFDEF linux}
  X, XUtil, Xlib, Types,
  {$ENDIF}
  {$IFDEF WIN32}
  WinApi.Windows, WinApi.ActiveX,
  {$ENDIF}
  SysUtils, Classes, dx_scene, dx_utils;

implementation {===============================================================}

{$I dx_physics_newton_intf.inc}

type

  { Newton dynamic engine }

  TdxNewtonPhysics = class(TdxPhysics)
  private
    FNeedSimulation: boolean;
    FDestroyBodyList: TList;
    FBodies: TList;
    FJoins: TList;
    FNewtonExists: boolean;
  protected
    function CheckWorld(const AOwner: TdxVisualObject): PNewtonWorld;
    procedure IntDestroyBody(ABody: integer);
  public
    constructor Create(const Scene: TdxScene); override;
    destructor Destroy; override;
    { Worlds }
    function CreateWorld: Integer; override;
    procedure DestroyWorld(const AWorld: Integer); override;
    procedure UpdateWorld(const AWorld: Integer; const DeltaTime: single); override;
    { Collision }
    function Collise(const AOwner: TdxVisualObject; var AList: TList): integer; override;
    function ComplexCollise(const AOwner: TdxVisualObject; var AList: TList): integer; override;
    { Objects }
    function ObjectByBody(const Body: Integer): TdxVisualObject; override;
    function CreateBox(const AOwner: TdxVisualObject;
      const ASize: TdxVector): Integer; override;
    function CreateSphere(const AOwner: TdxVisualObject;
      const ASize: TdxVector): Integer; override;
    function CreateCone(const AOwner: TdxVisualObject;
      const ASize: TdxVector): Integer; override;
    function CreateCylinder(const AOwner: TdxVisualObject;
      const ASize: TdxVector): Integer; override;
    procedure DestroyBody(var ABody: integer); override;
    { Action }
    procedure AddForce(const AOwner: TdxVisualObject; const Force: TdxVector); override;
    procedure Explode(const AWorld: Integer; const Position: TdxVector; const Radius, Force: single); override;
    procedure Wind(const AWorld: Integer; const Dir: TdxVector; const Force: single); override;
    { Callbacks }
    procedure SetBodyMatrix(const Body: Integer; const M: TdxMatrix); override;
    function GetBodyMatrix(const Body: Integer): TdxMatrix; override;
  end;

const
  ScreenDepth = 10.0;

var
  ActiveBodies: integer = 0;

type
  TCollisionRec = record
    o1, o2: Pointer;
  end;

procedure PhysicsApplyForceAndTorque(const body: PNewtonBody); cdecl;
var
  Vec: TdxVector;
  M: TdxMatrix;
  O: TdxVisualObject;
begin
  NewtonBodyGetMatrix(Body, @M);

  O := TdxVisualObject(NewtonBodyGetUserData(PNewtonBody(Body)));
  if O <> nil then
  begin
    if O.Projection = dxProjectionScreen then
    begin
      M.m43 := 0;
      vec.X := 0;
      vec.Y := 49; // gravity
      NewtonBodySetForce(body, @vec);
    end
    else
    begin
      vec.X := 0;
      vec.Y := 0; // gravity
      vec.Z := -8.9;
      NewtonBodySetForce(body, @vec);
    end;
  end;

  NewtonBodySetMatrix(Body, @M);
end;

procedure TrackActivesBodies( const body : PNewtonBody; state : unsigned_int ); cdecl;
begin
  if state = 1 then
    System.Inc(ActiveBodies)
  else
    System.Dec(ActiveBodies)
end;

{ TdxNewtonPhysics ===============================================================}

var
  NewtonLoaded: integer = 0;
  
constructor TdxNewtonPhysics.Create;
begin
  if NewtonLoaded = 0 then
  begin
    LoadNewton;
  end;
  NewtonLoaded := NewtonLoaded + 1;
  FNewtonExists := Assigned(@NewtonCreate);

  inherited;
  FBodies := TList.Create;
  FJoins := TList.Create;
end;

destructor TdxNewtonPhysics.Destroy;
begin
  if FDestroyBodyList <> nil then
    FDestroyBodyList.Free;
  FBodies.Free;
  FJoins.Free;
  inherited;
  NewtonLoaded := NewtonLoaded - 1;
  if (NewtonLoaded = 0) then
  begin
    FreeNewton;
  end;
end;

{ worlds }

function TdxNewtonPhysics.CreateWorld: Integer;
begin
  Result := 0;
  if not FNewtonExists then Exit;
  Result := Integer(NewtonCreate(nil, nil));
  NewtonSetSolverModel(PNewtonWorld(Result), 8);
  NewtonSetPlatformArchitecture(PNewtonWorld(Result), 2);
  NewtonSetFrictionModel(PNewtonWorld(Result), 1);
end;

procedure TdxNewtonPhysics.DestroyWorld(const AWorld: Integer);
begin
  if not FNewtonExists then Exit;
  NewtonDestroy(PNewtonWorld(AWorld));
end;

var
  ColliseColList: array [0..1000] of PNewtonBody;
  ColliseColListCount: integer;

  procedure ColliseBodyIterAABB(const body : PNewtonBody); cdecl;
  begin
    ColliseColList[ColliseColListCount] := body;
    System.Inc(ColliseColListCount);
  end;

function TdxNewtonPhysics.Collise(const AOwner: TdxVisualObject; var AList: TList): integer;
var
  i: integer;
  b1, b2: PNewtonBody;
  c1, c2: PNewtonCollision;
  m1, m2: TdxMatrix;
  o: TdxVisualObject;
  P, N, Res: TdxVector;
  A, B: TdxVector;
begin
  Result := 0;
  if AOwner.Body = 0 then Exit;
  if not AOwner.Visible then Exit;
  if AList.IndexOf(AOwner) >= 0 then Exit;

  b1 := PNewtonBody(AOwner.Body);
  if (FDestroyBodyList <> nil) and (FDestroyBodyList.IndexOf(b1) >= 0) then Exit;

  NewtonBodyGetAABB(b1, @A, @B);
  ColliseColListCount := 0;
  NewtonWorldForEachBodyInAABBDo(CheckWorld(AOwner), @A, @B, @ColliseBodyIterAABB);
  for i := 0 to ColliseColListCount - 1 do
  begin
    b2 := ColliseColList[i];
    if b1 = b2 then Continue;
    if (FDestroyBodyList <> nil) and (FDestroyBodyList.Count > 0) then
    begin
      if FDestroyBodyList.IndexOf(b2) >= 0 then
      begin
        Continue;
      end;
    end;

    o := ObjectByBody(Integer(b2));
//    if o.PreparedForDispose then Continue;
    if not o.Visible then Continue;

    c1 := NewtonBodyGetCollision(b1);
    c2 := NewtonBodyGetCollision(b2);

    NewtonBodyGetMatrix(b1, @m1);
    NewtonBodyGetMatrix(b2, @m2);

    if NewtonCollisionCollide(CheckWorld(AOwner), 1, c1, @m1, c2, @m2, @P, @N, @Res) > 0 then
    begin
      N.W := 1;
      P.W := 1;
      AOwner.Collision(O, P, N);
    end;
  end;
end;

var
  ComplexColList: array of PNewtonBody;

  procedure ComplexBodyIterAABB( const body : PNewtonBody ); cdecl;
  begin
    SetLength(ComplexColList, Length(ComplexColList) + 1);
    ComplexColList[High(ComplexColList)] := body;
  end;

function TdxNewtonPhysics.ComplexCollise(const AOwner: TdxVisualObject;
  var AList: TList): integer;
var
  i: integer;
  b1, b2: PNewtonBody;
  c1, c2: PNewtonCollision;
  m1, m2: TdxMatrix;
  o: TdxVisualObject;
  P, N, Res: TdxVector;
  A, B: TdxVector;
  SaveColList: array of PNewtonBody;
begin
  Result := 0;
  if AOwner.Body = 0 then Exit;
  if not AOwner.Visible then Exit;
  if AList.IndexOf(AOwner) >= 0 then Exit;

  SetLength(ComplexColList, 0);
  AList.Add(AOwner);

  b1 := PNewtonBody(AOwner.Body);
  if (FDestroyBodyList <> nil) and (FDestroyBodyList.IndexOf(b1) >= 0) then Exit;
  
  NewtonBodyGetAABB(b1, @A, @B);
  NewtonWorldForEachBodyInAABBDo(CheckWorld(AOwner), @A, @B, @ComplexBodyIterAABB);
  for i := 0 to High(ComplexColList) do
  begin
    b2 := ComplexColList[i];
    if b2 = b1 then Continue;

    if (FDestroyBodyList <> nil) and (FDestroyBodyList.Count > 0) then
    begin
      if FDestroyBodyList.IndexOf(b2) >= 0 then
      begin
        Continue;
      end;
    end;

    o := ObjectByBody(Integer(ComplexColList[i]));
//    if o.PreparedForDispose then Continue;
    if not o.Visible then Continue;

    c1 := NewtonBodyGetCollision(b1);
    c2 := NewtonBodyGetCollision(b2);

    NewtonBodyGetMatrix(b1, @m1);
    NewtonBodyGetMatrix(b2, @m2);

    if NewtonCollisionCollide(CheckWorld(AOwner), 1, c1, @m1, c2, @m2, @P, @N, @Res) > 0 then
    begin
(*      Applet(AppletObject).EventObject.ParamResult := false;
      Applet(AppletObject).EventObject.PushParamObject(o);
      AOwner.CallScript(AOwner.OnComplexCollise);
      if Applet(AppletObject).EventObject.ParamResult then
      begin
        { Add to list }
        if AList.IndexOf(o) < 0 then
        begin
          SetLength(SaveColList, Length(ComplexColList));
          Move(ComplexColList[0], SaveColList[0], Length(ComplexColList) * SizeOf(ComplexColList[0]));
          ComplexCollise(o, AList);
          SetLength(ComplexColList, Length(SaveColList));
          Move(SaveColList[0], ComplexColList[0], Length(ComplexColList) * SizeOf(ComplexColList[0]));
        end;
      end; *)
    end;
  end;
end;

procedure TdxNewtonPhysics.UpdateWorld(const AWorld: Integer; const DeltaTime: single);
var
  i: integer;
  simt: single;
begin
  if not FNewtonExists then Exit;
  simt := FScene.Time;
  if FNeedSimulation then
  begin
    NewtonUpdate(PNewtonWorld(AWorld), DeltaTime);
    if FDestroyBodyList <> nil then
    begin
      for i := FDestroyBodyList.Count - 1 downto 0 do
        IntDestroyBody(Integer(FDestroyBodyList[i]));
      FDestroyBodyList.Clear;
    end;
  end;
end;

{ actions }

procedure TdxNewtonPhysics.Wind(const AWorld: Integer; const Dir: TdxVector; const Force: single);
begin
end;

const
  cEps = 0.0000000001;
var
  ExplodeCenter: TdxVector;
  ExplodeForce: single;

  procedure BodyExplodeAABB(const body : PNewtonBody); cdecl;
  var
    ray, force: TdxVector;
    m: TdxMatrix;
  begin
    NewtonBodyGetMatrix(body, @m);
    if (Abs(m.M[3].X - ExplodeCenter.X) > cEps) or (Abs(m.M[3].Y - ExplodeCenter.Y) > cEps) or (Abs(m.M[3].Z - ExplodeCenter.Z) > cEps) then
    begin
      ray := dxVectorScale(dxVectorNormalize(dxVectorSubtract(m.M[3], ExplodeCenter)), ExplodeForce);
      force := dxVector(10, 0, 0);
      NewtonAddBodyImpulse(body, @ray, @m.M[3]);
    end;
  end;

procedure TdxNewtonPhysics.Explode(const AWorld: Integer; const Position: TdxVector; const Radius,
  Force: single);
var
  A, B: TdxVector;
begin
  if not FNewtonExists then Exit;
  A.X := Position.X - Radius;
  A.Y := Position.Y - Radius;
  A.Z := Position.Z - Radius;
  B.X := Position.X + Radius;
  B.Y := Position.Y + Radius;
  B.Z := Position.Z + Radius;
  ExplodeCenter := Position;
  ExplodeForce := Force;
  NewtonWorldForEachBodyInAABBDo(PNewtonWorld(AWorld), @A, @B, @BodyExplodeAABB);
end;

procedure TdxNewtonPhysics.AddForce(const AOwner: TdxVisualObject;
  const Force: TdxVector);
var
  P: TdxVector;
begin
  if AOwner.Body = 0 then Exit;
  if not AOwner.Visible then Exit;
  P := AOwner.AbsolutePosition;
  NewtonAddBodyImpulse(PNewtonBody(AOwner.Body), @Force, @P);
end;

{ bodies }

function TdxNewtonPhysics.ObjectByBody(const Body: Integer): TdxVisualObject;
begin
  Result := nil;
  if not FNewtonExists then Exit;
  Result := TdxVisualObject(NewtonBodyGetUserData(PNewtonBody(Body)));
end;

function TdxNewtonPhysics.CheckWorld(const AOwner: TdxVisualObject): PNewtonWorld;
var
  A, B: TdxVector;
begin
  Result := nil;
  if not FNewtonExists then Exit;
  if (AOwner.Projection = dxProjectionScreen) and (FScreenWorld = 0) then
  begin
    FScreenWorld := CreateWorld;
    Result := PNewtonWorld(FScreenWorld);

    A := dxVector(-1000, -1000, -ScreenDepth);
    B := dxVector(2000, 2000, ScreenDepth);
    NewtonSetWorldSize(PNewtonWorld(FScreenWorld), @A, @B);

    Exit;
  end;
  if (AOwner.Projection = dxProjectionCamera) and (FSpaceWorld = 0) then
  begin
    FSpaceWorld := CreateWorld;
    Result := PNewtonWorld(FSpaceWorld);

    A := dxVector(-1000, -1000, -1000);
    B := dxVector(1000, 1000, 1000);
    NewtonSetWorldSize(PNewtonWorld(FSpaceWorld), @A, @B);

    Exit;
  end;

  case AOwner.Projection of
    dxProjectionScreen: Result := Pointer(FScreenWorld);
    dxProjectionCamera: Result := Pointer(FSpaceWorld);
  end;
end;

function TdxNewtonPhysics.CreateBox(const AOwner: TdxVisualObject;
  const ASize: TdxVector): Integer;
var
  Collision: PNewtonCollision;
  Matrix: TdxMatrix;
  Inertia: TdxVector;
  World: PNewtonWorld;
  Mass: single;
  NJ: PNewtonJoint;
begin
  Result := 0;
  if not FNewtonExists then Exit;
  World := CheckWorld(AOwner);

  if AOwner.Body <> 0 then
  begin
    Result := 0;
    Exit;
  end;

  NJ := nil;
  Collision := NewtonCreateBox(World, ASize.X, ASize.Y, ASize.Z, nil);
  Result := Integer(NewtonCreateBody(World, Collision));

  NewtonBodySetUserData(PNewtonBody(Result), AOwner);

  Matrix := AOwner.AbsoluteMatrix;
  SetBodyMatrix(Result, Matrix);

  if AOwner.Dynamic then
    Mass := 1
  else
    Mass := 0;
  Inertia.x := Mass * ASize.z;
  Inertia.y := Mass * ASize.y;
  Inertia.z := Mass * ScreenDepth;
  NewtonBodySetMassMatrix(PNewtonBody(Result), Mass, Inertia.x, Inertia.y, Inertia.z);

  if AOwner.Dynamic then
  begin
    FNeedSimulation := true;
    
    NewtonBodySetForceAndTorqueCallback(PNewtonBody(Result), PhysicsApplyForceAndTorque);
    Inertia := dxVector(0, 0, 1);

    NewtonBodySetAutoFreeze(PNewtonBody(Result), 1);
  	NewtonBodySetAutoactiveCallback(PNewtonBody(Result), TrackActivesBodies);

    if Integer(World) = FScreenWorld then
    begin
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 1, 1, 5);
      NJ := NewtonConstraintCreateUpVector(World, @Inertia, PNewtonBody(Result));
    end
    else
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 0.05, 0.05, 5);
  end
  else
    NJ := nil;

  NewtonReleaseCollision(World, Collision);
  FBodies.Add(Pointer(Result));
  FJoins.Add(NJ);
end;

function TdxNewtonPhysics.CreateCone(const AOwner: TdxVisualObject;
  const ASize: TdxVector): Integer;
var
  Collision: PNewtonCollision;
  Matrix: TdxMatrix;
  Inertia: TdxVector;
  World: PNewtonWorld;
  Mass: single;
  NJ: PNewtonJoint;
  S: TdxVector;
begin
  Result := 0;
  if not FNewtonExists then Exit;
  World := CheckWorld(AOwner);

  if AOwner.Body <> 0 then
  begin
    Result := 0;
    Exit;
  end;

  Collision := NewtonCreateCone(World, ASize.X / 2, ASize.Z, nil);
  Result := Integer(NewtonCreateBody(World, Collision));

  NewtonBodySetUserData(PNewtonBody(Result), AOwner);

  Matrix := AOwner.AbsoluteMatrix;
  SetBodyMatrix(Result, Matrix);

  if AOwner.Dynamic then
    Mass := 1
  else
    Mass := 0;
  Inertia.x := Mass * ASize.z;
  Inertia.y := Mass * ASize.y;
  Inertia.z := Mass * ScreenDepth;
  NewtonBodySetMassMatrix(PNewtonBody(Result), Mass, Inertia.x, Inertia.y, Inertia.z);

  NJ := nil;
  if AOwner.Dynamic then
  begin
    FNeedSimulation := true;

    NewtonBodySetForceAndTorqueCallback(PNewtonBody(Result), PhysicsApplyForceAndTorque);
    Inertia := dxVector(0, 0, 1);

    NewtonBodySetAutoFreeze(PNewtonBody(Result), 1);
  	NewtonBodySetAutoactiveCallback(PNewtonBody(Result), TrackActivesBodies);

    if Integer(World) = FScreenWorld then
    begin
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 1, 1, 5);
      NJ := NewtonConstraintCreateUpVector(World, @Inertia, PNewtonBody(Result));
    end
    else
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 0.05, 0.05, 5);
  end;

  NewtonReleaseCollision(World, Collision);
  FBodies.Add(Pointer(Result));
  FJoins.Add(NJ);
end;

function TdxNewtonPhysics.CreateCylinder(const AOwner: TdxVisualObject;
  const ASize: TdxVector): Integer;
var
  Collision: PNewtonCollision;
  Matrix: TdxMatrix;
  Inertia: TdxVector;
  World: PNewtonWorld;
  Mass: single;
  NJ: PNewtonJoint;
  S: TdxVector;
begin
  Result := 0;
  if not FNewtonExists then Exit;
  World := CheckWorld(AOwner);

  if AOwner.Body <> 0 then
  begin
    Result := 0;
    Exit;
  end;

  Collision := NewtonCreateCylinder(World, ASize.X / 2, ASize.Z, nil);
  Result := Integer(NewtonCreateBody(World, Collision));

  NewtonBodySetUserData(PNewtonBody(Result), AOwner);

  Matrix := AOwner.AbsoluteMatrix;
  SetBodyMatrix(Result, Matrix);

  if AOwner.Dynamic then
    Mass := 1
  else
    Mass := 0;
  Inertia.x := Mass * ASize.z;
  Inertia.y := Mass * ASize.y;
  Inertia.z := Mass * ScreenDepth;
  NewtonBodySetMassMatrix(PNewtonBody(Result), Mass, Inertia.x, Inertia.y, Inertia.z);

  NJ := nil;
  if AOwner.Dynamic then
  begin
    FNeedSimulation := true;

    NewtonBodySetForceAndTorqueCallback(PNewtonBody(Result), PhysicsApplyForceAndTorque);
    Inertia := dxVector(0, 0, 1);

    NewtonBodySetAutoFreeze(PNewtonBody(Result), 1);
  	NewtonBodySetAutoactiveCallback(PNewtonBody(Result), TrackActivesBodies);

    if Integer(World) = FScreenWorld then
    begin
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 1, 1, 5);
      NJ := NewtonConstraintCreateUpVector(World, @Inertia, PNewtonBody(Result));
    end
    else
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 0.05, 0.05, 5);
  end;

  NewtonReleaseCollision(World, Collision);
  FBodies.Add(Pointer(Result));
  FJoins.Add(NJ);
end;

function TdxNewtonPhysics.CreateSphere(const AOwner: TdxVisualObject;
  const ASize: TdxVector): Integer;
var
  Collision: PNewtonCollision;
  Matrix: TdxMatrix;
  Inertia: TdxVector;
  World: PNewtonWorld;
  Mass: single;
  NJ: PNewtonJoint;
begin
  Result := 0;
  if not FNewtonExists then Exit;
  World := CheckWorld(AOwner);

  if AOwner.Body <> 0 then
  begin
    Result := 0;
    Exit;
  end;

  Collision := NewtonCreateSphere(World, ASize.X / 2, ASize.Y / 2, ASize.Z / 2, nil);
  Result := Integer(NewtonCreateBody(World, Collision));

  NewtonBodySetUserData(PNewtonBody(Result), AOwner);

  Matrix := AOwner.AbsoluteMatrix;
  SetBodyMatrix(Result, Matrix);

  if AOwner.Dynamic then
    Mass := 1
  else
    Mass := 0;
  Inertia.x := Mass * ASize.z;
  Inertia.y := Mass * ASize.y;
  Inertia.z := Mass * ScreenDepth;
  NewtonBodySetMassMatrix(PNewtonBody(Result), Mass, Inertia.x, Inertia.y, Inertia.z);

    NJ := nil;
  if AOwner.Dynamic then
  begin
    FNeedSimulation := true;

    NewtonBodySetForceAndTorqueCallback(PNewtonBody(Result), PhysicsApplyForceAndTorque);
    Inertia := dxVector(0, 0, 1);

    NewtonBodySetAutoFreeze(PNewtonBody(Result), 1);
  	NewtonBodySetAutoactiveCallback(PNewtonBody(Result), TrackActivesBodies);

    if Integer(World) = FScreenWorld then
    begin
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 1, 1, 5);
      NJ := NewtonConstraintCreateUpVector(World, @Inertia, PNewtonBody(Result));
    end
    else
      NewtonBodySetFreezeTreshold(PNewtonBody(Result), 0.05, 0.05, 5);
  end;

  NewtonReleaseCollision(World, Collision);
  FBodies.Add(Pointer(Result));
  FJoins.Add(NJ);
end;

procedure TdxNewtonPhysics.IntDestroyBody(ABody: integer);
var
  Idx: Integer;
begin
  if Integer(NewtonBodyGetWorld(PNewtonBody(ABody))) = FScreenWorld then
  begin
    Idx := FBodies.IndexOf(Pointer(ABody));
    if Idx >= 0 then
    begin
      NewtonDestroyBody(NewtonBodyGetWorld(PNewtonBody(ABody)), PNewtonBody(ABody));
      FBodies.Delete(Idx);
      FJoins.Delete(Idx);
    end;
  end
  else
  begin
    NewtonDestroyBody(NewtonBodyGetWorld(PNewtonBody(ABody)), PNewtonBody(ABody));
    FBodies.Remove(PNewtonBody(ABody));
  end;
end;

procedure TdxNewtonPhysics.DestroyBody(var ABody: integer);
var
  M: TdxMatrix;
begin
  if ABody = 0 then Exit;
  if (FDestroyBodyList <> nil) and (FDestroyBodyList.IndexOf(Pointer(ABody)) >= 0) then
  begin
    ABody := 0;
    Exit;
  end;

  { just remove from world and delete later }
  M := IdentityMatrix;
  M.m41 := $FFFFFF;
  M.m42 := $FFFFFF;
  M.m43 := $FFFFFF;
  NewtonBodySetMatrix(PNewtonBody(ABody), @M);
  { }

  if FDestroyBodyList = nil then
    FDestroyBodyList := TList.Create;
  FDestroyBodyList.Add(Pointer(ABody));

  ABody := 0;
end;

function TdxNewtonPhysics.GetBodyMatrix(const Body: Integer): TdxMatrix;
begin
  Result := IdentityMatrix;
  if not FNewtonExists then Exit;
  NewtonBodyGetMatrix(PNewtonBody(Body), @Result);
end;

procedure TdxNewtonPhysics.SetBodyMatrix(const Body: Integer;
  const M: TdxMatrix);
begin
  if not FNewtonExists then Exit;
  NewtonBodySetMatrix(PNewtonBody(Body), @M);
end;

initialization
  DefaultPhysicsClass := TdxNewtonPhysics;
end.
