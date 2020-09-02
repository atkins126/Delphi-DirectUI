{*******************************************************************************}
{                                                                               }
{      Newton Game Dynamics Delphi-Headertranslation                            }
{       Current SDK version 2.26 (Beta)                                         }
{                                                                               }
{      Copyright (c) 2004,05,06,09,10 Sascha Willems                            }
{                                     Stuart "Stucuk" Carey                     }
{                                     Jon Walton                                }
{                                     Dominique Louis                           }
{                                                                               }
{      Initial Author : S.Spasov (Sury)                                         }
{                                                                               }
{      Portions created by Eugene Kryukov are    			       	}
{      Copyright (C) 2001 Eugene Kryukov 			  		}
{                                                                               }
{      Copyright (c) 2004,05,06,09,10 Sascha Willems                            }
{                                                                               }
{*******************************************************************************}
{                                                                               }
{ License :                                                                     }
{                                                                               }
{  The contents of this file are used with permission, subject to               }
{  the Mozilla Public License Version 1.1 (the "License"); you may              }
{  not use this file except in compliance with the License. You may             }
{  obtain a copy of the License at                                              }
{  http://www.mozilla.org/MPL/MPL-1.1.html                                      }
{                                                                               }
{  Software distributed under the License is distributed on an                  }
{  "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or               }
{  implied. See the License for the specific language governing                 }
{  rights and limitations under the License.                                    }
{                                                                               }
{*******************************************************************************}

{$IFNDEF FPC}
  {$IFDEF __GPC__}
    {$I-}
    {$W-}
    {$X+}
  {$ELSE} {__GPC__}
    {$IFDEF Debug}
      {$F+,D+,Q-,L+,R+,I-,S+,Y+,A+}
    {$ELSE}
      {$F+,Q-,R-,S-,I-,A+}
    {$ENDIF}
  {$ENDIF} {__GPC__}
{$ELSE}  {FPC}
  {$M+}
{$ENDIF} {FPC}

{$IFDEF LINUX}
{$DEFINE UNIX}
{$ENDIF}

{$IFDEF ver70}
   {$IFDEF Windows}
     {$DEFINE Win16}
   {$ENDIF Windows}
   {$IFDEF MSDOS}
     {$DEFINE NO_EXPORTS}
   {$ENDIF MSDOS}
   {$IFDEF DPMI}
     {$DEFINE BP_DPMI}
   {$ENDIF}
   {$DEFINE OS_16_BIT}
   {$DEFINE __OS_DOS__}
{$ENDIF ver70}

{$IFDEF ver80}
   {$DEFINE Delphi}      {Delphi 1.x}
   {$DEFINE Delphi16}
   {$DEFINE Win16}
   {$DEFINE OS_16_BIT}
   {$DEFINE __OS_DOS__}
{$ENDIF ver80}

{$IFDEF ver90}
   {$DEFINE Delphi}      {Delphi 2.x}
   {$DEFINE Delphi32}
{$ENDIF ver90}

{$IFDEF ver100}
   {$DEFINE Delphi}      {Delphi 3.x}
   {$DEFINE Delphi32}
   {$DEFINE WINDOWS}
{$ENDIF ver100}

{$IFDEF ver93}
   {$DEFINE Delphi}      {C++ Builder 1.x}
   {$DEFINE Delphi32}
{$ENDIF ver93}

{$IFDEF ver110}
   {$DEFINE Delphi}      {C++ Builder 3.x}
   {$DEFINE Delphi32}
{$ENDIF ver110}

{$IFDEF ver120}
   {$DEFINE Delphi}      {Delphi 4.x}
   {$DEFINE Delphi32}
   {$DEFINE Has_Int64}
{$ENDIF ver120}

{$IFDEF ver130}
   {$DEFINE Delphi}      {Delphi 5.x}
   {$DEFINE Delphi32}
   {$DEFINE Has_Int64}
{$ENDIF ver130}

{$IFDEF ver140}
   {$DEFINE Delphi}      {Delphi 6.x}
   {$DEFINE Delphi32}
   {$DEFINE Has_Int64}
{$ENDIF ver140}

{$IFDEF ver150}
   {$DEFINE Delphi}      {Delphi 7.x}
   {$DEFINE Delphi32}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types in Delphi 7}
   {$DEFINE Has_Int64}
{$ENDIF ver150}
{$IFDEF VER150}
{$ENDIF}

{$IFDEF ver160}
   {$DEFINE Delphi}      {Delphi 8??}
   {$DEFINE Delphi32}
   {$DEFINE Has_Int64}
{$ENDIF ver160}

{$IFDEF ver170}
   {$DEFINE Delphi}      {Delphi 9??}
   {$DEFINE Delphi32}
   {$DEFINE Has_Int64}
{$ENDIF ver170}

{$IFDEF UNIX}
  {$ifdef VER150}
    {$define KYLIX}
  {$endif}

  {$ifdef VER140}
    {$define KYLIX}
  {$endif}

  {$ifdef VER140}
    {$define KYLIX}
  {$endif}
{$ENDIF UNIX}

{$IFDEF VirtualPascal} {  Virtual Pascal 2.x }
   {$DEFINE Delphi}    {  Use Delphi Syntax }
   {$DEFINE VP2}
   {&Delphi+}
{$ENDIF VirtualPascal}

{$IFDEF Delphi}
  {$DEFINE Windows}
  {$DEFINE USE_STDCALL}
{$ENDIF Delphi}

{$IFDEF FPC}
  {$MODE Delphi}          { use Delphi compatibility mode }
  {$H+}
  {$PACKRECORDS 4}        // Added for record
  {$MACRO ON}             // Added For OpenGL
  {$THREADING on}
  {$DEFINE Delphi}
  {$DEFINE UseAT}
  {$UNDEF USE_STDCALL}
  {$DEFINE OS_BigMem}
  {$DEFINE NO_EXPORTS}
  {$DEFINE Has_Int64}
  {$DEFINE NOCRT}
  {$IFDEF unix}
     {$DEFINE fpc_unix}
  {$ELSE}
     {$DEFINE __OS_DOS__}
  {$ENDIF}
  {$IFDEF WINDOWS}
   {$DEFINE UseWin}
  {$ENDIF}
{$ENDIF FPC}

{$IFDEF Win16}
  {$K+}   {smart callbacks}
{$ENDIF Win16}

 {$IFDEF OS2}
    {$UNDEF Windows}
    {$DEFINE UseWin}
    {$DEFINE OS_BigMem}
 {$ENDIF OS2}

{$IFDEF __GPC__}
  {$UNDEF UseWin}
  {$UNDEF USE_STDCALL}
  {$DEFINE OS_BigMem}
  {$DEFINE NO_EXPORTS}
  {$DEFINE NOCRT}
  {$DEFINE cdecl attribute(cdecl)}
{$ENDIF}

{$IFDEF __TMT__}
  {$DEFINE OS_BigMem}
  {$DEFINE NO_EXPORTS}
  {$DEFINE __OS_DOS__}
  {$DEFINE UseAT}
  {$IFNDEF MSDOS}
    {$DEFINE USE_STDCALL}
  {$ENDIF}

  {$IFDEF __WINDOWS__}
    {$DEFINE Win32}
    {$DEFINE UseWin}
    {$DEFINE NOCRT}
    {$DEFINE Win32}
    {$IFNDEF __CON__}
      {$DEFINE Windows}
    {$ENDIF}
  {$ENDIF}

  {$A+}  // Word alignment data
  {$OA+} // Objects and structures align
{$ENDIF}

{$IFDEF Win32}
  {$H-}                    { no long strings, please! }
  {$DEFINE OS_BigMem}
{$ELSE Win32}
  {$IFDEF ver70}
    {$DEFINE assembler}
  {$ENDIF} { use 16-bit assembler! }
{$ENDIF Win32}

{ ************************** dos/dos-like platforms **************}
{$IFDEF Windows}
   {$DEFINE __OS_DOS__}
   {$DEFINE UseWin}
   {$DEFINE MSWINDOWS}
{$ENDIF Delphi}

{$IFDEF OS2}
   {$DEFINE __OS_DOS__}
   {$DEFINE Can_Use_DLL}
{$ENDIF Delphi}

{$IFDEF UseWin}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF Win16}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF BP_DPMI}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF USE_STDCALL}
   {$IFNDEF __TMT__}
     {$DEFINE BY_NAME}
   {$ENDIF}
{$ENDIF}

{$IFNDEF ver70}
  {$UNDEF assembler}
{$ENDIF}

//{$DEFINE NEWTON_DOUBLE_PRECISION} // This is needed when you want to use double precision

const
{$IFDEF WINDOWS}
  NewtonDLL = 'Newton.dll';
{$ENDIF}

{$IFDEF UNIX}
{$IFDEF DARWIN} // MacOS X
  NewtonDLL = 'libnewton.dylib';
{$ELSE}
  NewtonDLL = 'libnewton.so';
{$ENDIF}
{$ENDIF}

{$IFDEF MACOS}
  NewtonDLL = 'libnewton';
{$ENDIF}

(*Comment this line if you get weird errors*)
{$DEFINE NICE_CODE_PARAMS}

type
{I did this to speed up the translation process and avoid bugs}
{if you don't like me screw up the Delphi syntax with those
(C++ types just do a simple find and replace =)

{Pascal to C++}
  {simple types}
  Bool = Boolean;
  {$IFDEF NEWTON_DOUBLE_PRECISION}
   Float = Double;
  {$ELSE}
   Float = Single;
  {$ENDIF}
  Long_double = Extended;

  Int = Integer;
  __int8 = ShortInt;
  __int16 = SmallInt;
  __int32 = LongInt;
  __int64 = Int64;
  NChar = ShortInt;
  Unsigned_char = Byte;
  Short = SmallInt;
  Unsigned_short = Word;
  Long = LongInt;
  Unsigned_long = LongWord;
  Unsigned_int = Cardinal;
  size_t = Cardinal;

  {Pointer types}
  Pvoid = Pointer; //void pointer
  PBool = ^Bool;
  PFloat = ^Float;
  PLong_double = ^Long_double;

  PInt = ^Int;
  P__int8 = ^__int8;
  P__int16 = ^__int16;
  P__int32 = ^__int32;
  P__int64 = ^__int64;
  P2Char = ^NChar;
  PUnsigned_char = ^Unsigned_char;
  PShort = ^Short;
  PUnsigned_short = ^Unsigned_short;
  PLong = ^Long;
  PUnsigned_long = ^Unsigned_long;
  PUnsigned_int = ^Unsigned_int;
  Psize_t = ^size_t;

{end Pascal to C++}

  {well this might look stupid
  but i did it in order to make
  code complete and code parameters hint window
  to show the actual type for ex. PNewtonWorld
  instead of just "Pointer" , thus making programming a lot easier}
{$IFDEF NICE_CODE_PARAMS}
  PNewtonBody = ^Pointer;
  PNewtonWorld = ^Pointer;
  PNewtonJoint = ^Pointer;
  PNewtonContact = ^Pointer;
  PNewtonMaterial = ^Pointer;
  PNewtonCollision = ^Pointer;

  PNewtonRagDoll = ^Pointer;
  PNewtonRagDollBone = ^Pointer;
{$ELSE}

  PNewtonBody = Pointer;
  PNewtonWorld = Pointer;
  PNewtonJoint = Pointer;
  PNewtonContact = Pointer;
  PNewtonMaterial = Pointer;
  PNewtonCollision = Pointer;

  PNewtonRagDoll = Pointer;
  PNewtonRagDollBone = Pointer;
{$ENDIF}


  PNewtonUserMeshCollisionCollideDesc = ^NewtonUserMeshCollisionCollideDesc;
  NewtonUserMeshCollisionCollideDesc = record
    m_boxP0               : array[ 0..3 ] of float;
    m_boxP1               : array[ 0..3 ] of float;
    m_userData            : Pointer;
    m_faceCount           : int;
    m_vertex              : ^float;
    m_vertexStrideInBytes : int;
    m_userAttribute       : ^int;
    m_faceIndexCount      : ^int;
    m_faceVertexIndex     : ^int;
    m_objBody             : PNewtonBody;
    m_polySoupBody        : PNewtonBody;
  end;


  PNewtonUserMeshCollisionRayHitDesc = ^NewtonUserMeshCollisionRayHitDesc;
  NewtonUserMeshCollisionRayHitDesc = record
    m_p0        : array[ 0..3 ] of float;
    m_p1        : array[ 0..3 ] of float;
    m_normalOut : array[ 0..3 ] of float;
    m_userId    : int;
    m_thickness : float;
    m_userData  : Pointer;
  end;


  PNewtonHingeSliderUpdateDesc = ^NewtonHingeSliderUpdateDesc;
  NewtonHingeSliderUpdateDesc = record
    m_accel       : float;
    m_minFriction : float;
    m_maxFriction : float;
    m_timestep    : float;
  end;

// *****************************************************************************************************************************
//
//  Callbacks
//
// *****************************************************************************************************************************
NewtonAllocMemory = function( sizeInBytes : int ) : Pointer; cdecl;
PNewtonAllocMemory = ^NewtonAllocMemory;

NewtonFreeMemory = procedure( ptr : Pointer; sizeInBytes : int ); cdecl;
PNewtonFreeMemory = ^NewtonFreeMemory;

NewtonSerialize = procedure( serializeHandle : Pointer; const buffer : Pointer; size : size_t ); cdecl;
PNewtonSerialize = ^NewtonSerialize;

NewtonDeserialize = procedure( serializeHandle : Pointer; buffer : Pointer; size : size_t ); cdecl;
PNewtonDeserialize = ^NewtonDeserialize;

NewtonUserMeshCollisionCollideCallback = procedure( NewtonUserMeshCollisionCollideDesc : PNewtonUserMeshCollisionCollideDesc ); cdecl;
PNewtonUserMeshCollisionCollideCallback = ^NewtonUserMeshCollisionCollideCallback;

NewtonUserMeshCollisionRayHitCallback = function( NewtonUserMeshCollisionRayHitDesc : PNewtonUserMeshCollisionRayHitDesc ) : int; cdecl;
PNewtonUserMeshCollisionRayHitCallback = ^NewtonUserMeshCollisionRayHitCallback;

NewtonUserMeshCollisionDestroyCallback = procedure( descData : Pointer ); cdecl;
PNewtonUserMeshCollisionDestroyCallback = ^NewtonUserMeshCollisionDestroyCallback;

NewtonTreeCollisionCallback = procedure( const bodyWithTreeCollision : PNewtonBody; const body : PNewtonBody;
                                         const vertex : PFloat; vertexstrideInBytes : int;
                                         indexCount : int; const indexArray : PInt ); cdecl;
PNewtonTreeCollisionCallback = ^NewtonTreeCollisionCallback;

NewtonBodyDestructor = procedure( const body : PNewtonBody ); cdecl;
PNewtonBodyDestructor = ^NewtonBodyDestructor;

NewtonApplyForceAndTorque = procedure( const body : PNewtonBody ); cdecl;
PNewtonApplyForceAndTorque = ^NewtonApplyForceAndTorque;

NewtonBodyActivationState = procedure( const body : PNewtonBody; state : unsigned_int ); cdecl;
PNewtonBodyActivationState = ^NewtonBodyActivationState;

NewtonSetTransform = procedure( const body : PNewtonBody; const matrix : PFloat ); cdecl;
PNewtonSetTransform = ^NewtonSetTransform;

NewtonSetRagDollTransform = procedure( const bone : PNewtonRagDollBone ); cdecl;
PNewtonSetRagDollTransform = ^NewtonSetRagDollTransform;

NewtonGetBuoyancyPlane = function(const collisionID : Int; context : Pointer; const globalSpaceMatrix : PFloat; globalSpacePlane : PFloat ) : Int; cdecl;
PNewtonGetBuoyancyPlane = ^NewtonGetBuoyancyPlane;

NewtonVehicleTireUpdate = procedure( const vehicle: PNewtonJoint ); cdecl;
PNewtonVehicleTireUpdate = ^NewtonVehicleTireUpdate;

NewtonWorldRayFilterCallback = function( const body : PNewtonBody; const hitNormal: PFloat; collisionID : Int; userData: Pointer; intersetParam: Float ) : Float; cdecl;
PNewtonWorldRayFilterCallback = ^NewtonWorldRayFilterCallback;

NewtonBodyLeaveWorld = procedure( const body : PNewtonBody ); cdecl;
PNewtonBodyLeaveWorld = ^NewtonBodyLeaveWorld;

NewtonContactBegin = function( const material : PNewtonMaterial; const body0 : PNewtonBody; const body1 : PNewtonBody ) : int; cdecl;
PNewtonContactBegin = ^NewtonContactBegin;

NewtonContactProcess = function( const material : PNewtonMaterial; const contact : PNewtonContact ) : int; cdecl;
PNewtonContactProcess = ^NewtonContactProcess;

NewtonContactEnd = procedure( const material : PNewtonMaterial ); cdecl;
PNewtonContactEnd = ^NewtonContactEnd;

NewtonBodyIterator = procedure( const body : PNewtonBody ); cdecl;
PNewtonBodyIterator = ^NewtonBodyIterator;

NewtonCollisionIterator = procedure( const body : PNewtonBody; vertexCount : int; const FaceArray : PFloat; faceId : int ); cdecl;
PNewtonCollisionIterator = ^NewtonCollisionIterator;

NewtonBallCallBack = procedure( const ball : PNewtonJoint ); cdecl;
PNewtonBallCallBack = ^NewtonBallCallBack;

NewtonHingeCallBack = function( const hinge : PNewtonJoint; desc : PNewtonHingeSliderUpdateDesc ) : Unsigned_int; cdecl;
PNewtonHingeCallBack = ^NewtonHingeCallBack;

NewtonSliderCallBack = function( const slider : PNewtonJoint; desc : PNewtonHingeSliderUpdateDesc ) : Unsigned_int; cdecl;
PNewtonSliderCallBack = ^NewtonSliderCallBack;

NewtonUniversalCallBack = function( const universal : PNewtonJoint; desc : PNewtonHingeSliderUpdateDesc ) : Unsigned_int; cdecl;
PNewtonUniversalCallBack = ^NewtonUniversalCallBack;

NewtonCorkscrewCallBack = function( const corkscrew : PNewtonJoint; desc : PNewtonHingeSliderUpdateDesc ) : Unsigned_int; cdecl;
PNewtonCorkscrewCallBack = ^NewtonCorkscrewCallBack;

NewtonUserBilateralCallBack = function( const userJoint: PNewtonJoint): unsigned_int; cdecl;
PNewtonUserBilateralCallBack = ^NewtonUserBilateralCallBack;

NewtonConstraintDestructor = procedure( const me : PNewtonJoint ); cdecl;
PNewtonConstraintDestructor = ^NewtonConstraintDestructor;


// *****************************************************************************************************************************
//
// world control functions
//
// *****************************************************************************************************************************
var  NewtonCreate: function( malloc : NewtonAllocMemory; mfree : NewtonFreeMemory ) : PNewtonWorld; cdecl;
var NewtonDestroy: procedure( const newtonWorld : PNewtonWorld ); cdecl;
var NewtonDestroyAllBodies: procedure( const newtonWorld : PNewtonWorld ); cdecl;

var NewtonUpdate: procedure( const newtonWorld : PNewtonWorld; timestep : float ); cdecl;
var NewtonSetPlatformArchitecture : procedure(const newtonWorld : PNewtonWorld; mode : Integer); cdecl;
var NewtonSetSolverModel: procedure(const NewtonWorld : PNewtonWorld; Model : Int); cdecl;
var NewtonSetFrictionModel: procedure(const NewtonWorld : PNewtonWorld; Model : Int); cdecl;

var  NewtonGetTimeStep: function(const NewtonWorld : PNewtonWorld) :Float; cdecl;
var NewtonSetMinimumFrameRate: procedure( const newtonWorld : PNewtonWorld; frameRate : float ); cdecl;
var NewtonSetBodyLeaveWorldEvent: procedure( const newtonWorld : PNewtonWorld; callback : PNewtonBodyLeaveWorld ); cdecl;
var NewtonSetWorldSize: procedure( const newtonWorld : PNewtonWorld; const minPoint : PFloat; const maxPoint : PFloat ); cdecl;

var NewtonWorldFreezeBody: procedure( const newtonWorld : PNewtonWorld; const body : PNewtonBody ); cdecl;
var NewtonWorldUnfreezeBody: procedure( const newtonWorld : PNewtonWorld; const body : PNewtonBody ); cdecl;

var NewtonWorldForEachBodyDo: procedure( const newtonWorld : PNewtonWorld; callback : PNewtonBodyIterator ); cdecl;
var NewtonWorldForEachBodyInAABBDo: procedure  (const newtonWorld : PNewtonWorld; const p0 : PFloat; const p1 : PFloat; callback : PNewtonBodyIterator); cdecl;

var NewtonWorldSetUserData: procedure( const newtonWorld : PNewtonWorld; userData : Pointer); cdecl;
var  NewtonWorldGetUserData: function( const newtonWorld : PNewtonWorld) : Pointer; cdecl;
var  NewtonWorldGetVersion: function( const newtonWorld : PNewtonWorld) : int; cdecl;

var NewtonWorldRayCast: procedure( const newtonWorld : PNewtonWorld; const p0 : PFloat; const p1 : PFloat;                              filter : PNewtonWorldRayFilterCallback; userData: Pointer); cdecl;


// *****************************************************************************************************************************
//
//  Physics Material Section
//
// *****************************************************************************************************************************
var  NewtonMaterialGetDefaultGroupID: function( const newtonWorld : PNewtonWorld ) : int; cdecl;
var  NewtonMaterialCreateGroupID: function( const newtonWorld : PNewtonWorld ) : int; cdecl;
var NewtonMaterialDestroyAllGroupID: procedure( const newtonWorld : PNewtonWorld ); cdecl;

var NewtonMaterialSetDefaultSoftness: procedure( const newtonWorld : PNewtonWorld; id0 : int; id1 : int; value : float ); cdecl;
var NewtonMaterialSetDefaultElasticity: procedure( const newtonWorld : PNewtonWorld; id0 : int; id1 : int; elasticCoef : float ); cdecl;
var NewtonMaterialSetDefaultCollidable: procedure( const newtonWorld : PNewtonWorld; id0 : int; id1 : int; state : int ); cdecl;
var NewtonMaterialSetContinuousCollisionMode : procedure(const newtonWorld : PNewtonWOrld; id0, id1, state : int);  cdecl;
var NewtonMaterialSetDefaultFriction: procedure( const newtonWorld : PNewtonWorld; id0 : int; id1 : int; staticFriction : float; kineticFriction : float ); cdecl;
var NewtonMaterialSetCollisionCallback: procedure( const newtonWorld : PNewtonWorld; id0 : int; id1 : int; userData : Pointer; _begin : PNewtonContactBegin; process : PNewtonContactProcess; _end : PNewtonContactEnd ); cdecl;

var  NewtonMaterialGetUserData: function( const NewtonWorld: PNewtonWorld; id0: int; id1: int): Pointer; cdecl;


// *****************************************************************************************************************************
//
// Physics Contact control functions
//
// *****************************************************************************************************************************
var NewtonMaterialDisableContact: procedure( const material : PNewtonMaterial ); cdecl;
var  NewtonMaterialGetCurrentTimestep: function( const material : PNewtonMaterial) : float; cdecl;
var  NewtonMaterialGetMaterialPairUserData: function( const material : PNewtonMaterial) : Pointer; cdecl;
var  NewtonMaterialGetContactFaceAttribute: function( const material : PNewtonMaterial) : Unsigned_int; cdecl;
var  NewtonMaterialGetBodyCollisionID: function( const material : PNewtonMaterial; body : PNewtonBody) : Unsigned_int; cdecl;
var  NewtonMaterialGetContactNormalSpeed: function( const material : PNewtonMaterial; const contactlHandle : PNewtonContact ) : float; cdecl;
var NewtonMaterialGetContactForce: procedure( const material : PNewtonMaterial; force : PFloat); cdecl;
var NewtonMaterialGetContactPositionAndNormal: procedure( const material : PNewtonMaterial; posit : PFloat; normal : PFloat); cdecl;
var NewtonMaterialGetContactTangentDirections: procedure( const material : PNewtonMaterial; dir0 : PFloat; dir : PFloat); cdecl;
var  NewtonMaterialGetContactTangentSpeed: function( const material : PNewtonMaterial; const contactlHandle : PNewtonContact; index : int ) : float; cdecl;

var NewtonMaterialSetContactSoftness: procedure( const material : PNewtonMaterial; softness : float ); cdecl;
var NewtonMaterialSetContactElasticity: procedure( const material : PNewtonMaterial; restitution : float ); cdecl;
var NewtonMaterialSetContactFrictionState: procedure( const material : PNewtonMaterial; state : int; index : int ); cdecl;
var NewtonMaterialSetContactStaticFrictionCoef: procedure( const material : PNewtonMaterial; coef : float; index : int ); cdecl;
var NewtonMaterialSetContactKineticFrictionCoef: procedure( const material : PNewtonMaterial; coef : float; index : int ); cdecl;

var NewtonMaterialSetContactNormalAcceleration : procedure(const material : PNewtonMaterial; accel : float); cdecl;
var NewtonMaterialSetContactNormalDirection: procedure(const material : PNewtonMaterial; directionVector : PFloat); cdecl;

var NewtonMaterialSetContactTangentAcceleration: procedure( const material : PNewtonMaterial; accel : float; index : int ); cdecl;
var NewtonMaterialContactRotateTangentDirections: procedure( const material : PNewtonMaterial; const directionVector : PFloat ); cdecl;


// *****************************************************************************************************************************
//
// convex collision primitives creation functions
//
// *****************************************************************************************************************************
var  NewtonCreateNull: function( const newtonWorld : PNewtonWorld) : PNewtonCollision; cdecl;
var  NewtonCreateSphere: function( const newtonWorld : PNewtonWorld; radiusX, radiusY, radiusZ : float; const offsetMatrix : PFloat ) : PNewtonCollision; cdecl;
var  NewtonCreateBox: function( const newtonWorld : PNewtonWorld; dx : float; dy : float; dz : float; const offsetMatrix : PFloat ) : PNewtonCollision; cdecl;
var  NewtonCreateCone: function( const newtonWorld : PNewtonWorld; radius : Float; height : Float; const offsetMatrix : PFloat) : PNewtonCollision; cdecl;
var  NewtonCreateCapsule: function( const newtonWorld : PNewtonWorld; radius : Float; height : Float; const offsetMatrix : PFloat) : PNewtonCollision; cdecl;
var  NewtonCreateCylinder: function( const newtonWorld : PNewtonWorld; radius : Float; height : Float; const offsetMatrix : PFloat) : PNewtonCollision; cdecl;
var  NewtonCreateChamferCylinder: function( const newtonWorld : PNewtonWorld; raduis : Float; height : Float; const offsetMatrix : PFloat) : PNewtonCollision; cdecl;
var  NewtonCreateConvexHull: function( const newtonWorld : PNewtonWorld; count : int; vertexCloud : PFloat; strideInBytes : int; offsetMatrix : PFloat) : PNewtonCollision; cdecl;
var  NewtonCreateConvexHullModifier: function( const newtonWorld : PNewtonWorld; const convexHullCollision : PNewtonCollision): PNewtonCollision; cdecl;
var NewtonConvexHullModifierGetMatrix: procedure(const convexHullCollision : PNewtonCollision; matrix : PFloat); cdecl;
var NewtonConvexHullModifierSetMatrix: procedure(const convexHullCollision : PNewtonCollision; const matrix : PFloat); cdecl;

var NewtonConvexCollisionSetUserID: procedure( const convexCollision : PNewtonCollision; id : unsigned_int ); cdecl;
var  NewtonConvexCollisionGetUserID: function( const convexCollision : PNewtonCollision) : unsigned_int; cdecl;

var  NewtonConvexCollisionCalculateVolume: function(const convexCollision : PNewtonCollision) : Float;  cdecl;
var NewtonConvexCollisionCalculateInertialMatrix : procedure(const convexCollision : PNewtonCollision; inertia, origin : PFloat);  cdecl;

var NewtonCollisionMakeUnique : procedure(const newtonWorld : PNewtonWorld; const collision : PNewtonCollision); cdecl;
var NewtonReleaseCollision: procedure( const newtonWorld : PNewtonWorld; const collision : PNewtonCollision ); cdecl;


// *****************************************************************************************************************************
//
// complex collision primitives creation functions
// note: can only be used with static bodies (bodies with infinite mass)
//
// *****************************************************************************************************************************
type
  TCollisionPrimitiveArray = array of PNewtonCollision;

var NewtonCreateCompoundCollision: function( const newtonWorld : PNewtonWorld; count : int;const collisionPrimitiveArray : TcollisionPrimitiveArray ) : PNewtonCollision; cdecl;

var NewtonCreateUserMeshCollision: function ( const newtonWorld : PNewtonWorld; const minBox : PFloat; const maxBox : PFloat; userData : Pointer; collideCallback : NewtonUserMeshCollisionCollideCallback;rayHitCallback : NewtonUserMeshCollisionRayHitCallback; destroyCallback : NewtonUserMeshCollisionDestroyCallback ) : PNewtonCollision; cdecl;


// *****************************************************************************************************************************
//
// CollisionTree Utility functions
//
// *****************************************************************************************************************************
var  NewtonCreateTreeCollision: function( const newtonWorld : PNewtonWorld; userCallback : NewtonTreeCollisionCallback ) : PNewtonCollision; cdecl;
var NewtonTreeCollisionBeginBuild: procedure( const treeCollision : PNewtonCollision ); cdecl;
var NewtonTreeCollisionAddFace: procedure( const treeCollision : PNewtonCollision; vertexCount : int; const vertexPtr : PFloat;strideInBytes : int; faceAttribute : int ); cdecl;
var NewtonTreeCollisionEndBuild: procedure( const treeCollision : PNewtonCollision; optimize : int ); cdecl;

var NewtonTreeCollisionSerialize: procedure( const treeCollision : PNewtonCollision; serializeFunction : NewtonSerialize;serializeHandle : Pointer ); cdecl;

var  NewtonCreateTreeCollisionFromSerialization: function( const newtonWorld : PNewtonWorld; userCallback : NewtonTreeCollisionCallback; deserializeFunction : NewtonDeserialize; serializeHandle : Pointer ) : PNewtonCollision; cdecl;

var  NewtonTreeCollisionGetFaceAtribute: function( const treeCollision : PNewtonCollision; const faceIndexArray : Pint ) : int; cdecl;
var NewtonTreeCollisionSetFaceAtribute: procedure( const treeCollision : PNewtonCollision; const faceIndexArray : Pint; attribute : int ); cdecl;


// *****************************************************************************************************************************
//
// General purpose collision library functions
//
// *****************************************************************************************************************************
var  NewtonCollisionPointDistance : function(const newtonWorld : PNewtonWorld; const point : PFloat;const collision : PNewtonCollision; const matrix : PFloat;	contact : PFloat; normal : PFloat) : Int;cdecl;

var  NewtonCollisionClosestPoint : function(const newtonWorld : PNewtonWorld; const collsionA : PNewtonCollision;const matrixA : PFloat; const collisionB : PNewtonCollision; const matrixB : PFloat;contactA, contactB, normalAB : PFloat) : Int;cdecl;

var  NewtonCollisionCollide : function(const newtonWorld : PNewtonWorld; maxSize : Int; const collsionA : PNewtonCollision;const matrixA : PFloat; const collisionB : PNewtonCollision; const matrixB : PFloat;contacts, normals, penetration : PFloat) : Int;cdecl;

var NewtonCollisionCollideContinue : function(const newtonWorld : PNewtonWorld; maxSize : Int; const timestep : Float;const collsionA : PNewtonCollision; const matrixA : PFloat; const velocA : PFloat; const omegaA : Float;const collsionB : PNewtonCollision; const matrixB : PFloat; const velocB : PFloat; const omegaB : Float;timeOfImpact : PFloat; contacts : PFloat; normals : PFloat; penetration : PFloat) : Int;cdecl;


var  NewtonCollisionRayCast: function(const collision : PNewtonCollision; const p0: PFloat; const p1: PFloat; normals: PFloat; attribute: pint): float; cdecl;
var NewtonCollisionCalculateAABB: procedure( const collision : PNewtonCollision; const matrix : PFloat; p0 : PFloat; p1 : PFloat ); cdecl;


// *****************************************************************************************************************************
//
// transforms utility functions
//
// *****************************************************************************************************************************
var NewtonGetEulerAngle: procedure( const matrix : PFloat; eulersAngles : PFloat ); cdecl;
var NewtonSetEulerAngle: procedure( const eulersAngles : PFloat; matrix : PFloat ); cdecl;

// *****************************************************************************************************************************
//
// body manipulation functions
//
// *****************************************************************************************************************************
var  NewtonCreateBody: function( const newtonWorld : PNewtonWorld; const collision : PNewtonCollision ) : PNewtonBody; cdecl;
var NewtonDestroyBody: procedure( const newtonWorld : PNewtonWorld; const body : PNewtonBody ); cdecl;

var NewtonBodyAddForce: procedure( const body : PNewtonBody; const force : PFloat ); cdecl;
var NewtonBodyAddTorque: procedure( const body : PNewtonBody; const torque : PFloat ); cdecl;

var NewtonBodySetMatrix: procedure( const body : PNewtonBody; const matrix : PFloat ); cdecl;
var NewtonBodySetMatrixRecursive: procedure( const body : PNewtonBody; const matrix : PFloat ); cdecl;
var NewtonBodySetMassMatrix: procedure( const body : PNewtonBody; mass : float; Ixx : float; Iyy : float; Izz : float ); cdecl;
var NewtonBodySetMaterialGroupID: procedure( const body : PNewtonBody; id : int ); cdecl;
var NewtonBodySetContinuousCollisionMode: procedure(const body : PNewtonbody; state : unsigned_int); cdecl;

var NewtonBodySetJointRecursiveCollision: procedure( const body : PNewtonBody; state : unsigned_int ); cdecl;
var NewtonBodySetOmega: procedure( const body : PNewtonBody; const omega : PFloat ); cdecl;
var NewtonBodySetVelocity: procedure( const body : PNewtonBody; const velocity : PFloat ); cdecl;
var NewtonBodySetForce: procedure( const body : PNewtonBody; const force : PFloat ); cdecl;
var NewtonBodySetTorque: procedure( const body : PNewtonBody; const torque : PFloat ); cdecl;

var NewtonBodySetCentreOfMass: procedure(const body : PNewtonBody; const com : PFloat); cdecl;
var NewtonBodySetLinearDamping: procedure( const body : PNewtonBody; linearDamp : float ); cdecl;
var NewtonBodySetAngularDamping: procedure( const body : PNewtonBody; const angularDamp : PFloat ); cdecl;
var NewtonBodySetUserData: procedure( const body : PNewtonBody; userData : Pointer ); cdecl;
var NewtonBodyCoriolisForcesMode: procedure( const body : PNewtonBody; mode : int); cdecl;
var NewtonBodySetCollision: procedure( const body : PNewtonBody; const collision : PNewtonCollision ); cdecl;
var NewtonBodySetAutoFreeze: procedure( const body : PNewtonBody; state : int ); cdecl;
var NewtonBodySetFreezeTreshold: procedure( const body : PNewtonBody; freezeSpeed2 : float; freezeOmega2 : float; framesCount : int ); cdecl;

var NewtonBodySetTransformCallback: procedure( const body : PNewtonBody; callback : NewtonSetTransform ); cdecl;
var NewtonBodySetDestructorCallback: procedure( const body : PNewtonBody; callback : NewtonBodyDestructor ); cdecl;
var NewtonBodySetAutoactiveCallback: procedure( const body : PNewtonBody; callback : NewtonBodyActivationState ); cdecl;
var NewtonBodySetForceAndTorqueCallback: procedure( const body : PNewtonBody; callback : NewtonApplyForceAndTorque ); cdecl;

var  NewtonBodyGetWorld: function( const body : PNewtonBody) : PNewtonWorld; cdecl;
var  NewtonBodyGetUserData: function( const body : PNewtonBody ) : Pointer; cdecl;
var  NewtonBodyGetCollision: function( const body : PNewtonBody ) : PNewtonCollision; cdecl;
var  NewtonBodyGetMaterialGroupID: function( const body : PNewtonBody ) : Int; cdecl;
var  NewtonBodyGetContinuousCollisionMode: function( const body : PNewtonBody ) : Int; cdecl;
var  NewtonBodyGetJointRecursiveCollision: function( const body : PNewtonBody ) : Int; cdecl;
var NewtonBodyGetMatrix: procedure( const body : PNewtonBody; matrix : PFloat ); cdecl;
var NewtonBodyGetMassMatrix: procedure( const body : PNewtonBody; mass : PFloat; Ixx : PFloat; Iyy : PFloat; Izz : PFloat ); cdecl;
var NewtonBodyGetInvMass: procedure( const body : PNewtonBody; invMass : PFloat; invIxx : PFloat; invIyy : PFloat; invIzz : PFloat ); cdecl;
var NewtonBodyGetOmega: procedure( const body : PNewtonBody; vector : PFloat ); cdecl;
var NewtonBodyGetVelocity: procedure( const body : PNewtonBody; vector : PFloat ); cdecl;
var NewtonBodyGetForce: procedure( const body : PNewtonBody; vector : PFloat ); cdecl;
var NewtonBodyGetTorque: procedure( const body : PNewtonBody; vector : PFloat); cdecl;
var NewtonBodyGetCentreOfMass: procedure(const body : PNewtonBody; com : PFloat); cdecl;

var  NewtonBodyGetSleepingState: function( const body : PNewtonBody) : Int; cdecl;
var  NewtonBodyGetAutoFreeze: function( const body : PNewtonBody ) : Int; cdecl;
var  NewtonBodyGetLinearDamping: function( const body : PNewtonBody ) : float; cdecl;
var NewtonBodyGetAngularDamping: procedure( const body : PNewtonBody; vector : PFloat ); cdecl;
var NewtonBodyGetAABB: procedure( const body : PNewtonBody; p0 : PFloat; p1 : PFloat ); cdecl;
var NewtonBodyGetFreezeTreshold: procedure( const body : PNewtonBody; freezeSpeed2 : PFloat; freezeOmega2 : PFloat ); cdecl;
var NewtonBodyAddBuoyancyForce: procedure( const body : PNewtonBody; fluidDensity : float; fluidLinearViscosity : float; fluidAngularViscosity : float;const gravityVector : PFloat; buoyancyPlane : NewtonGetBuoyancyPlane; context : Pointer ); cdecl;
var NewtonBodyForEachPolygonDo: procedure( const body : PNewtonBody; callback : NewtonCollisionIterator ); cdecl;
var NewtonAddBodyImpulse: procedure(const body : PNewtonBody; const pointDeltaVeloc : PFloat; const pointPosit : PFloat ); cdecl;


// *****************************************************************************************************************************
//
// Common joint funtions
//
// *****************************************************************************************************************************
var  NewtonJointGetUserData: function( const joint : PNewtonJoint ) : Pointer; cdecl;
var NewtonJointSetUserData: procedure( const joint : PNewtonJoint; userData : Pointer ); cdecl;

var  NewtonJointGetCollisionState: function( const joint : PNewtonJoint ) : int; cdecl;
var NewtonJointSetCollisionState: procedure( const joint : PNewtonJoint; state : int ); cdecl;

var  NewtonJointGetStiffness: function( const joint : PNewtonJoint): float; cdecl;
var NewtonJointSetStiffness: procedure( const joint: PNewtonJoint; state: float); cdecl;

var NewtonDestroyJoint: procedure( const newtonWorld : PNewtonWorld; const joint : PNewtonJoint ); cdecl;
var NewtonJointSetDestructor: procedure( const joint : PNewtonJoint; _destructor : NewtonConstraintDestructor ); cdecl;

// *****************************************************************************************************************************
//
// Ball and Socket joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateBall: function( const newtonWorld : PNewtonWorld; const pivotPoint : PFloat;const childBody : PNewtonBody; const parentBody : PNewtonBody ) : PNewtonJoint; cdecl;

var NewtonBallSetUserCallback: procedure( const ball : PNewtonJoint; callback : NewtonBallCallBack ); cdecl;
var NewtonBallGetJointAngle: procedure( const ball : PNewtonJoint; angle : PFloat ); cdecl;
var NewtonBallGetJointOmega: procedure( const ball : PNewtonJoint; omega : PFloat ); cdecl;
var NewtonBallGetJointForce: procedure( const ball : PNewtonJoint; force : PFloat ); cdecl;
var NewtonBallSetConeLimits: procedure( const ball : PNewtonJoint; const pin : PFloat; maxConeAngle : float; maxTwistAngle : float ); cdecl;

// *****************************************************************************************************************************
//
// Hinge joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateHinge: function( const newtonWorld : PNewtonWorld;const pivotPoint : PFloat; const pinDir : PFloat;const childBody : PNewtonBody; const parentBody : PNewtonBody ) : PNewtonJoint; cdecl;

var NewtonHingeSetUserCallback: procedure( const hinge : PNewtonJoint; callback : NewtonHingeCallBack ); cdecl;
var  NewtonHingeGetJointAngle: function( const hinge : PNewtonJoint ) : float; cdecl;
var  NewtonHingeGetJointOmega: function( const hinge : PNewtonJoint ) : float; cdecl;
var NewtonHingeGetJointForce: procedure( const hinge : PNewtonJoint; force : PFloat ); cdecl;
var  NewtonHingeCalculateStopAlpha: function( const hinge : PNewtonJoint; const desc : PNewtonHingeSliderUpdateDesc; angle : float ) : float; cdecl;

// *****************************************************************************************************************************
//
// Slider joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateSlider: function( const newtonWorld : PNewtonWorld; const pivotPoint : PFloat; const pinDir : PFloat; const childBody : PNewtonBody; const parentBody : PNewtonBody ) : PNewtonJoint; cdecl;

var NewtonSliderSetUserCallback: procedure( const slider : PNewtonJoint; callback : NewtonSliderCallBack ); cdecl;
var  NewtonSliderGetJointPosit: function( const slider : PNewtonJoint ) : float; cdecl;
var  NewtonSliderGetJointVeloc: function( const slider : PNewtonJoint ) : float; cdecl;
var NewtonSliderGetJointForce: procedure( const slider : PNewtonJoint; force : PFloat ); cdecl;
var  NewtonSliderCalculateStopAccel: function( const slider : PNewtonJoint; const desc : PNewtonHingeSliderUpdateDesc; position : float ) : float; cdecl;


// *****************************************************************************************************************************
//
// Corkscrew joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateCorkscrew: function( const newtonWorld : PNewtonWorld;const pivotPoint : PFloat; const pinDir : PFloat;const childBody : PNewtonBody; const parentBody : PNewtonBody ) : PNewtonJoint; cdecl;

var NewtonCorkscrewSetUserCallback: procedure( const corkscrew : PNewtonJoint; callback : NewtonCorkscrewCallBack ); cdecl;
var  NewtonCorkscrewGetJointPosit: function( const corkscrew : PNewtonJoint ) : float; cdecl;
var  NewtonCorkscrewGetJointAngle: function( const corkscrew : PNewtonJoint ) : float; cdecl;
var  NewtonCorkscrewGetJointVeloc: function( const corkscrew : PNewtonJoint ) : float; cdecl;
var  NewtonCorkscrewGetJointOmega: function( const corkscrew : PNewtonJoint ) : float; cdecl;
var NewtonCorkscrewGetJointForce: procedure( const corkscrew : PNewtonJoint; force : PFloat ); cdecl;
var  NewtonCorkscrewCalculateStopAlpha: function( const corkscrew : PNewtonJoint; const desc : PNewtonHingeSliderUpdateDesc; angle : float ) : float; cdecl;
var  NewtonCorkscrewCalculateStopAccel: function( const corkscrew : PNewtonJoint; const desc : PNewtonHingeSliderUpdateDesc; position : float ) : float; cdecl;


// *****************************************************************************************************************************
//
// Universal joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateUniversal: function( const newtonWorld: PNewtonWorld; const pivotPoint: PFloat; const pinDir0: PFloat;                                          const pinDir1: PFloat; const childBody: PNewtonBody; const parentBody: PNewtonBody): PNewtonJoint; cdecl;
var NewtonUniversalSetUserCallback: procedure(const universal: PNewtonJoint; callback: NewtonUniversalCallback); cdecl;
var  NewtonUniversalGetJointAngle0: function(const universal: PNewtonJoint):float; cdecl;
var  NewtonUniversalGetJointAngle1: function(const universal: PNewtonJoint):float; cdecl;
var  NewtonUniversalGetJointOmega0: function(const universal: PNewtonJoint):float; cdecl;
var  NewtonUniversalGetJointOmega1: function(const universal: PNewtonJoint):float; cdecl;
var NewtonUniversalGetJointForce: procedure(const universal: PNewtonJoint; force: PFloat); cdecl;
var  NewtonUniversalCalculateStopAlpha0: function(const universal : PNewtonJoint; const desc: PNewtonHingeSliderUpdateDesc; angle: float): float; cdecl;
var  NewtonUniversalCalculateStopAlpha1: function(const universal : PNewtonJoint; const desc: PNewtonHingeSliderUpdateDesc; angle: float): float; cdecl;

// *****************************************************************************************************************************
//
// Up vector joint unctions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateUpVector: function( const newtonWorld : PNewtonWorld; const pinDir : PFloat; const body : PNewtonBody ) : PNewtonJoint; cdecl;
var NewtonUpVectorGetPin: procedure( const upVector : PNewtonJoint; pin : PFloat ); cdecl;
var NewtonUpVectorSetPin: procedure( const upVector : PNewtonJoint; const pin : PFloat ); cdecl;

// *****************************************************************************************************************************
//
// User defined bilateral Joint
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateUserJoint: function(const NewtonWorld : PNewtonWorld; MaxDOF : Integer; Callback : PNewtonUserBilateralCallBack;const ChildBody: PNewtonBody; const parentBody: PNewtonBody): PNewtonJoint;cdecl;
var NewtonUserJointAddLinearRow: procedure(const Joint : PNewtonJoint; const pivot0 : PFloat; const pivot1 : PFloat; const Dir : PFloat); cdecl;
var NewtonUserJointAddAngularRow: procedure(const Joint : PNewtonJoint; RelativeAngle : Float; const Dir : PFloat); cdecl;
var NewtonUserJointAddGeneralRow: procedure(const Joint : PNewtonJoint; const Jacobian0 : PFloat; const Jacobian1 : PFloat); cdecl;
var NewtonUserJointSetRowMinimumFriction: procedure(const Joint : PNewtonJoint; Friction : Float); cdecl;
var NewtonUserJointSetRowMaximumFriction: procedure(const Joint : PNewtonJoint; Friction : Float); cdecl;
var NewtonUserJointSetRowAcceleration: procedure(const Joint : PNewtonJoint; Acceleration : Float); cdecl;
var NewtonUserJointSetRowStiffness: procedure(const Joint : PNewtonJoint; Stiffness : Float); cdecl;
var NewtonUserJointSetRowSpringDamperAcceleration: procedure(const joint : PNewtonJoint; springK : Float; springD : Float); cdecl;
var  NewtonUserJointGetRowForce : function(const Joint : PNewtonJoint; Row : Int) : Float; cdecl;


// *****************************************************************************************************************************
//
// Ragdoll joint contatiner funtion
//
// *****************************************************************************************************************************
var  NewtonCreateRagDoll: function( const newtonWorld : PNewtonWorld ) : PNewtonRagDoll; cdecl;
var NewtonDestroyRagDoll: procedure( const newtonWorld : PNewtonWorld; const ragDoll : PNewtonRagDoll ); cdecl;

var NewtonRagDollBegin: procedure( const ragDoll : PNewtonRagDoll ); cdecl;
var NewtonRagDollEnd: procedure( const ragDoll : PNewtonRagDoll ); cdecl;

var  NewtonRagDollFindBone: function( const ragDoll : PNewtonRagDoll; id : int ) : PNewtonRagDollBone; cdecl;
var  NewtonRagDollGetRootBone: function( const ragDoll : PNewtonRagDoll ) : PNewtonRagDollBone; cdecl;

var NewtonRagDollSetForceAndTorqueCallback: procedure( const ragDoll : PNewtonRagDoll; callback : NewtonApplyForceAndTorque ); cdecl;
var NewtonRagDollSetTransformCallback: procedure( const ragDoll : PNewtonRagDoll; callback : NewtonSetRagDollTransform ); cdecl;
var  NewtonRagDollAddBone: function( const RagDoll : PNewtonRagDoll; const Parent : PNewtonRagDollBone; userData : Pointer; mass : Float; const matrix : PFloat;const BoneCollision : PNewtonCollision; const Size : PFloat) : PNewtonRagDollBone; cdecl;

var  NewtonRagDollBoneGetUserData: function( const bone : PNewtonRagDollBone ) : Pointer; cdecl;
var  NewtonRagDollBoneGetBody: function( const bone : PNewtonRagDollBone ) : PNewtonBody; cdecl;
var NewtonRagDollBoneSetID: procedure( const bone : PNewtonRagDollBone; id : int ); cdecl;

var NewtonRagDollBoneSetLimits: procedure( const bone : PNewtonRagDollBone;const coneDir : PFloat; minConeAngle : float; maxConeAngle : float; maxTwistAngle : float;const bilateralConeDir : PFloat; negativeBilateralConeAngle : float; positiveBilateralConeAngle : float ); cdecl;

var NewtonRagDollBoneGetLocalMatrix: procedure( const bone : PNewtonRagDollBone; matrix : PFloat ); cdecl;
var NewtonRagDollBoneGetGlobalMatrix: procedure( const bone : PNewtonRagDollBone; matrix : PFloat ); cdecl;

// *****************************************************************************************************************************
//
// Vehicle joint functions
//
// *****************************************************************************************************************************
var  NewtonConstraintCreateVehicle: function( const newtonWorld : PNewtonWorld; const upDir : PFloat; const body : PNewtonBody) : PNewtonJoint; cdecl;
var NewtonVehicleReset: procedure( const vehicle : PNewtonJoint); cdecl;
var NewtonVehicleSetTireCallback: procedure( const vehicle : PNewtonJoint; update : PNewtonVehicleTireUpdate); cdecl;
var  NewtonVehicleAddTire: function( const vehicle : PNewtonJoint; const localMatrix : PFloat; const pin : PFloat; mass : Float; width : Float; radius : Float;suspensionShock : Float; suspensionSpring : Float; suspensionLength : Float; userData : Pointer; collisionID : int) : Pointer; cdecl;
var NewtonVehicleRemoveTire: procedure( const vehicle : PNewtonJoint; tireID : Pointer); cdecl;

var  NewtonVehicleGetFirstTireID: function( const vehicle : PNewtonJoint) : Pointer; cdecl;
var  NewtonVehicleGetNextTireID: function( const vehicle : PNewtonJoint; tireId : Pointer) : Pointer; cdecl;

var  NewtonVehicleTireIsAirBorne: function( const vehicle : PNewtonJoint; tireId : Pointer) : int; cdecl;
var  NewtonVehicleTireLostSideGrip: function( const vehicle : PNewtonJoint; tireId : Pointer) : int; cdecl;
var  NewtonVehicleTireLostTraction: function( const vehicle : PNewtonJoint; tireId : Pointer) : int;  cdecl;

var  NewtonVehicleGetTireUserData: function( const vehicle : PNewtonJoint; tireId : Pointer) : Pointer; cdecl;
var  NewtonVehicleGetTireOmega: function( const vehicle : PNewtonJoint; tireId : Pointer) : float; cdecl;
var  NewtonVehicleGetTireNormalLoad: function( const vehicle : PNewtonJoint; tireId : Pointer) : Float; cdecl;
var  NewtonVehicleGetTireSteerAngle: function( const vehicle : PNewtonJoint; tireId : Pointer) : Float; cdecl;
var  NewtonVehicleGetTireLateralSpeed: function( const vehicle : PNewtonJoint; tireId : Pointer) : float; cdecl;
var  NewtonVehicleGetTireLongitudinalSpeed: function( const vehicle : PNewtonJoint; tireId : Pointer) : float; cdecl;
var NewtonVehicleGetTireMatrix: procedure( const vehicle : PNewtonJoint; tireId : Pointer; matrix : PFloat); cdecl;

var NewtonVehicleSetTireTorque: procedure( const vehicle : PNewtonJoint; tireId : Pointer; torque : Float); cdecl;
var NewtonVehicleSetTireSteerAngle: procedure( const vehicle : PNewtonJoint; tireId : Pointer; angle : Float); cdecl;

var NewtonVehicleSetTireMaxSideSleepSpeed: procedure( const vehicle : PNewtonJoint; tireId : Pointer; speed : float); cdecl;
var NewtonVehicleSetTireSideSleepCoeficient: procedure(const vehicle : PNewtonJoint; tireId : Pointer; coeficient : float); cdecl;
var NewtonVehicleSetTireMaxLongitudinalSlideSpeed: procedure(const vehicle : PNewtonJoint; tireId : Pointer; speed : float); cdecl;
var NewtonVehicleSetTireLongitudinalSlideCoeficient: procedure(const vehicle : PNewtonJoint; tireId : Pointer; coeficient : float); cdecl;

var  NewtonVehicleTireCalculateMaxBrakeAcceleration: function(const vehicle : PNewtonJoint; tireId : Pointer) : float; cdecl;
var NewtonVehicleTireSetBrakeAcceleration: procedure( const vehicle : PNewtonJoint; tireId : Pointer; accelaration : float; torqeLimit : float); cdecl;

var
  LibHandle: cardinal;

procedure LoadNewton;
begin
  LibHandle := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + NewtonDLL));
  if LibHandle <> 0 then
  begin
    @NewtonCreate := GetProcAddress(LibHandle, 'NewtonCreate');
    @NewtonDestroy := GetProcAddress(LibHandle, 'NewtonDestroy');
    @NewtonDestroyAllBodies := GetProcAddress(LibHandle, 'NewtonDestroyAllBodies');
    @NewtonUpdate := GetProcAddress(LibHandle, 'NewtonUpdate');
    @NewtonSetPlatformArchitecture  := GetProcAddress(LibHandle, 'NewtonSetPlatformArchitecture');
    @NewtonSetSolverModel := GetProcAddress(LibHandle, 'NewtonSetSolverModel');
    @NewtonSetFrictionModel := GetProcAddress(LibHandle, 'NewtonSetFrictionModel');
    @NewtonGetTimeStep := GetProcAddress(LibHandle, 'NewtonGetTimeStep');
    @NewtonSetMinimumFrameRate := GetProcAddress(LibHandle, 'NewtonSetMinimumFrameRate');
    @NewtonSetBodyLeaveWorldEvent := GetProcAddress(LibHandle, 'NewtonSetBodyLeaveWorldEvent');
    @NewtonSetWorldSize := GetProcAddress(LibHandle, 'NewtonSetWorldSize');
    @NewtonWorldFreezeBody := GetProcAddress(LibHandle, 'NewtonWorldFreezeBody');
    @NewtonWorldUnfreezeBody := GetProcAddress(LibHandle, 'NewtonWorldUnfreezeBody');
    @NewtonWorldForEachBodyDo := GetProcAddress(LibHandle, 'NewtonWorldForEachBodyDo');
    @NewtonWorldForEachBodyInAABBDo := GetProcAddress(LibHandle, 'NewtonWorldForEachBodyInAABBDo');
    @NewtonWorldSetUserData := GetProcAddress(LibHandle, 'NewtonWorldSetUserData');
    @NewtonWorldGetUserData := GetProcAddress(LibHandle, 'NewtonWorldGetUserData');
    @NewtonWorldGetVersion := GetProcAddress(LibHandle, 'NewtonWorldGetVersion');
    @NewtonWorldRayCast := GetProcAddress(LibHandle, 'NewtonWorldRayCast');
    @NewtonMaterialGetDefaultGroupID := GetProcAddress(LibHandle, 'NewtonMaterialGetDefaultGroupID');
    @NewtonMaterialCreateGroupID := GetProcAddress(LibHandle, 'NewtonMaterialCreateGroupID');
    @NewtonMaterialDestroyAllGroupID := GetProcAddress(LibHandle, 'NewtonMaterialDestroyAllGroupID');
    @NewtonMaterialSetDefaultSoftness := GetProcAddress(LibHandle, 'NewtonMaterialSetDefaultSoftness');
    @NewtonMaterialSetDefaultElasticity := GetProcAddress(LibHandle, 'NewtonMaterialSetDefaultElasticity');
    @NewtonMaterialSetDefaultCollidable := GetProcAddress(LibHandle, 'NewtonMaterialSetDefaultCollidable');
    @NewtonMaterialSetContinuousCollisionMode  := GetProcAddress(LibHandle, 'NewtonMaterialSetContinuousCollisionMode');
    @NewtonMaterialSetDefaultFriction := GetProcAddress(LibHandle, 'NewtonMaterialSetDefaultFriction');
    @NewtonMaterialSetCollisionCallback := GetProcAddress(LibHandle, 'NewtonMaterialSetCollisionCallback');
    @NewtonMaterialGetUserData := GetProcAddress(LibHandle, 'NewtonMaterialGetUserData');
    @NewtonMaterialDisableContact := GetProcAddress(LibHandle, 'NewtonMaterialDisableContact');
    @NewtonMaterialGetCurrentTimestep := GetProcAddress(LibHandle, 'NewtonMaterialGetCurrentTimestep');
    @NewtonMaterialGetMaterialPairUserData := GetProcAddress(LibHandle, 'NewtonMaterialGetMaterialPairUserData');
    @NewtonMaterialGetContactFaceAttribute := GetProcAddress(LibHandle, 'NewtonMaterialGetContactFaceAttribute');
    @NewtonMaterialGetBodyCollisionID := GetProcAddress(LibHandle, 'NewtonMaterialGetBodyCollisionID');
    @NewtonMaterialGetContactNormalSpeed := GetProcAddress(LibHandle, 'NewtonMaterialGetContactNormalSpeed');
    @NewtonMaterialGetContactForce := GetProcAddress(LibHandle, 'NewtonMaterialGetContactForce');
    @NewtonMaterialGetContactPositionAndNormal := GetProcAddress(LibHandle, 'NewtonMaterialGetContactPositionAndNormal');
    @NewtonMaterialGetContactTangentDirections := GetProcAddress(LibHandle, 'NewtonMaterialGetContactTangentDirections');
    @NewtonMaterialGetContactTangentSpeed := GetProcAddress(LibHandle, 'NewtonMaterialGetContactTangentSpeed');
    @NewtonMaterialSetContactSoftness := GetProcAddress(LibHandle, 'NewtonMaterialSetContactSoftness');
    @NewtonMaterialSetContactElasticity := GetProcAddress(LibHandle, 'NewtonMaterialSetContactElasticity');
    @NewtonMaterialSetContactFrictionState := GetProcAddress(LibHandle, 'NewtonMaterialSetContactFrictionState');
    @NewtonMaterialSetContactStaticFrictionCoef := GetProcAddress(LibHandle, 'NewtonMaterialSetContactStaticFrictionCoef');
    @NewtonMaterialSetContactKineticFrictionCoef := GetProcAddress(LibHandle, 'NewtonMaterialSetContactKineticFrictionCoef');
    @NewtonMaterialSetContactNormalAcceleration  := GetProcAddress(LibHandle, 'NewtonMaterialSetContactNormalAcceleration');
    @NewtonMaterialSetContactNormalDirection := GetProcAddress(LibHandle, 'NewtonMaterialSetContactNormalDirection');
    @NewtonMaterialSetContactTangentAcceleration := GetProcAddress(LibHandle, 'NewtonMaterialSetContactTangentAcceleration');
    @NewtonMaterialContactRotateTangentDirections := GetProcAddress(LibHandle, 'NewtonMaterialContactRotateTangentDirections');
    @NewtonCreateNull := GetProcAddress(LibHandle, 'NewtonCreateNull');
    @NewtonCreateSphere := GetProcAddress(LibHandle, 'NewtonCreateSphere');
    @NewtonCreateBox := GetProcAddress(LibHandle, 'NewtonCreateBox');
    @NewtonCreateCone := GetProcAddress(LibHandle, 'NewtonCreateCone');
    @NewtonCreateCapsule := GetProcAddress(LibHandle, 'NewtonCreateCapsule');
    @NewtonCreateCylinder := GetProcAddress(LibHandle, 'NewtonCreateCylinder');
    @NewtonCreateChamferCylinder := GetProcAddress(LibHandle, 'NewtonCreateChamferCylinder');
    @NewtonCreateConvexHull := GetProcAddress(LibHandle, 'NewtonCreateConvexHull');
    @NewtonCreateConvexHullModifier := GetProcAddress(LibHandle, 'NewtonCreateConvexHullModifier');
    @NewtonConvexHullModifierGetMatrix := GetProcAddress(LibHandle, 'NewtonConvexHullModifierGetMatrix');
    @NewtonConvexHullModifierSetMatrix := GetProcAddress(LibHandle, 'NewtonConvexHullModifierSetMatrix');
    @NewtonConvexCollisionSetUserID := GetProcAddress(LibHandle, 'NewtonConvexCollisionSetUserID');
    @NewtonConvexCollisionGetUserID := GetProcAddress(LibHandle, 'NewtonConvexCollisionGetUserID');
    @NewtonConvexCollisionCalculateVolume := GetProcAddress(LibHandle, 'NewtonConvexCollisionCalculateVolume');
    @NewtonConvexCollisionCalculateInertialMatrix  := GetProcAddress(LibHandle, 'NewtonConvexCollisionCalculateInertialMatrix');
    @NewtonCollisionMakeUnique  := GetProcAddress(LibHandle, 'NewtonCollisionMakeUnique');
    @NewtonReleaseCollision := GetProcAddress(LibHandle, 'NewtonReleaseCollision');
    @NewtonCreateTreeCollision := GetProcAddress(LibHandle, 'NewtonCreateTreeCollision');
    @NewtonTreeCollisionBeginBuild := GetProcAddress(LibHandle, 'NewtonTreeCollisionBeginBuild');
    @NewtonTreeCollisionAddFace := GetProcAddress(LibHandle, 'NewtonTreeCollisionAddFace');
    @NewtonTreeCollisionEndBuild := GetProcAddress(LibHandle, 'NewtonTreeCollisionEndBuild');
    @NewtonTreeCollisionSerialize := GetProcAddress(LibHandle, 'NewtonTreeCollisionSerialize');
    @NewtonCreateTreeCollisionFromSerialization := GetProcAddress(LibHandle, 'NewtonCreateTreeCollisionFromSerialization');
    @NewtonTreeCollisionGetFaceAtribute := GetProcAddress(LibHandle, 'NewtonTreeCollisionGetFaceAtribute');
    @NewtonTreeCollisionSetFaceAtribute := GetProcAddress(LibHandle, 'NewtonTreeCollisionSetFaceAtribute');
    @NewtonCollisionPointDistance  := GetProcAddress(LibHandle, 'NewtonCollisionPointDistance');
    @NewtonCollisionClosestPoint  := GetProcAddress(LibHandle, 'NewtonCollisionClosestPoint');
    @NewtonCollisionCollide  := GetProcAddress(LibHandle, 'NewtonCollisionCollide');
    @NewtonCollisionRayCast := GetProcAddress(LibHandle, 'NewtonCollisionRayCast');
    @NewtonCollisionCalculateAABB := GetProcAddress(LibHandle, 'NewtonCollisionCalculateAABB');
    @NewtonGetEulerAngle := GetProcAddress(LibHandle, 'NewtonGetEulerAngle');
    @NewtonSetEulerAngle := GetProcAddress(LibHandle, 'NewtonSetEulerAngle');
    @NewtonCreateBody := GetProcAddress(LibHandle, 'NewtonCreateBody');
    @NewtonDestroyBody := GetProcAddress(LibHandle, 'NewtonDestroyBody');
    @NewtonBodyAddForce := GetProcAddress(LibHandle, 'NewtonBodyAddForce');
    @NewtonBodyAddTorque := GetProcAddress(LibHandle, 'NewtonBodyAddTorque');
    @NewtonBodySetMatrix := GetProcAddress(LibHandle, 'NewtonBodySetMatrix');
    @NewtonBodySetMatrixRecursive := GetProcAddress(LibHandle, 'NewtonBodySetMatrixRecursive');
    @NewtonBodySetMassMatrix := GetProcAddress(LibHandle, 'NewtonBodySetMassMatrix');
    @NewtonBodySetMaterialGroupID := GetProcAddress(LibHandle, 'NewtonBodySetMaterialGroupID');
    @NewtonBodySetContinuousCollisionMode := GetProcAddress(LibHandle, 'NewtonBodySetContinuousCollisionMode');
    @NewtonBodySetJointRecursiveCollision := GetProcAddress(LibHandle, 'NewtonBodySetJointRecursiveCollision');
    @NewtonBodySetOmega := GetProcAddress(LibHandle, 'NewtonBodySetOmega');
    @NewtonBodySetVelocity := GetProcAddress(LibHandle, 'NewtonBodySetVelocity');
    @NewtonBodySetForce := GetProcAddress(LibHandle, 'NewtonBodySetForce');
    @NewtonBodySetTorque := GetProcAddress(LibHandle, 'NewtonBodySetTorque');
    @NewtonBodySetCentreOfMass := GetProcAddress(LibHandle, 'NewtonBodySetCentreOfMass');
    @NewtonBodySetLinearDamping := GetProcAddress(LibHandle, 'NewtonBodySetLinearDamping');
    @NewtonBodySetAngularDamping := GetProcAddress(LibHandle, 'NewtonBodySetAngularDamping');
    @NewtonBodySetUserData := GetProcAddress(LibHandle, 'NewtonBodySetUserData');
    @NewtonBodyCoriolisForcesMode := GetProcAddress(LibHandle, 'NewtonBodyCoriolisForcesMode');
    @NewtonBodySetCollision := GetProcAddress(LibHandle, 'NewtonBodySetCollision');
    @NewtonBodySetAutoFreeze := GetProcAddress(LibHandle, 'NewtonBodySetAutoFreeze');
    @NewtonBodySetFreezeTreshold := GetProcAddress(LibHandle, 'NewtonBodySetFreezeTreshold');
    @NewtonBodySetTransformCallback := GetProcAddress(LibHandle, 'NewtonBodySetTransformCallback');
    @NewtonBodySetDestructorCallback := GetProcAddress(LibHandle, 'NewtonBodySetDestructorCallback');
    @NewtonBodySetAutoactiveCallback := GetProcAddress(LibHandle, 'NewtonBodySetAutoactiveCallback');
    @NewtonBodySetForceAndTorqueCallback := GetProcAddress(LibHandle, 'NewtonBodySetForceAndTorqueCallback');
    @NewtonBodyGetWorld := GetProcAddress(LibHandle, 'NewtonBodyGetWorld');
    @NewtonBodyGetUserData := GetProcAddress(LibHandle, 'NewtonBodyGetUserData');
    @NewtonBodyGetCollision := GetProcAddress(LibHandle, 'NewtonBodyGetCollision');
    @NewtonBodyGetMaterialGroupID := GetProcAddress(LibHandle, 'NewtonBodyGetMaterialGroupID');
    @NewtonBodyGetContinuousCollisionMode := GetProcAddress(LibHandle, 'NewtonBodyGetContinuousCollisionMode');
    @NewtonBodyGetJointRecursiveCollision := GetProcAddress(LibHandle, 'NewtonBodyGetJointRecursiveCollision');
    @NewtonBodyGetMatrix := GetProcAddress(LibHandle, 'NewtonBodyGetMatrix');
    @NewtonBodyGetMassMatrix := GetProcAddress(LibHandle, 'NewtonBodyGetMassMatrix');
    @NewtonBodyGetInvMass := GetProcAddress(LibHandle, 'NewtonBodyGetInvMass');
    @NewtonBodyGetOmega := GetProcAddress(LibHandle, 'NewtonBodyGetOmega');
    @NewtonBodyGetVelocity := GetProcAddress(LibHandle, 'NewtonBodyGetVelocity');
    @NewtonBodyGetForce := GetProcAddress(LibHandle, 'NewtonBodyGetForce');
    @NewtonBodyGetTorque := GetProcAddress(LibHandle, 'NewtonBodyGetTorque');
    @NewtonBodyGetCentreOfMass := GetProcAddress(LibHandle, 'NewtonBodyGetCentreOfMass');
    @NewtonBodyGetSleepingState := GetProcAddress(LibHandle, 'NewtonBodyGetSleepingState');
    @NewtonBodyGetAutoFreeze := GetProcAddress(LibHandle, 'NewtonBodyGetAutoFreeze');
    @NewtonBodyGetLinearDamping := GetProcAddress(LibHandle, 'NewtonBodyGetLinearDamping');
    @NewtonBodyGetAngularDamping := GetProcAddress(LibHandle, 'NewtonBodyGetAngularDamping');
    @NewtonBodyGetAABB := GetProcAddress(LibHandle, 'NewtonBodyGetAABB');
    @NewtonBodyGetFreezeTreshold := GetProcAddress(LibHandle, 'NewtonBodyGetFreezeTreshold');
    @NewtonBodyAddBuoyancyForce := GetProcAddress(LibHandle, 'NewtonBodyAddBuoyancyForce');
    @NewtonBodyForEachPolygonDo := GetProcAddress(LibHandle, 'NewtonBodyForEachPolygonDo');
    @NewtonAddBodyImpulse := GetProcAddress(LibHandle, 'NewtonAddBodyImpulse');
    @NewtonJointGetUserData := GetProcAddress(LibHandle, 'NewtonJointGetUserData');
    @NewtonJointSetUserData := GetProcAddress(LibHandle, 'NewtonJointSetUserData');
    @NewtonJointGetCollisionState := GetProcAddress(LibHandle, 'NewtonJointGetCollisionState');
    @NewtonJointSetCollisionState := GetProcAddress(LibHandle, 'NewtonJointSetCollisionState');
    @NewtonJointGetStiffness := GetProcAddress(LibHandle, 'NewtonJointGetStiffness');
    @NewtonJointSetStiffness := GetProcAddress(LibHandle, 'NewtonJointSetStiffness');
    @NewtonDestroyJoint := GetProcAddress(LibHandle, 'NewtonDestroyJoint');
    @NewtonJointSetDestructor := GetProcAddress(LibHandle, 'NewtonJointSetDestructor');
    @NewtonConstraintCreateBall := GetProcAddress(LibHandle, 'NewtonConstraintCreateBall');
    @NewtonBallSetUserCallback := GetProcAddress(LibHandle, 'NewtonBallSetUserCallback');
    @NewtonBallGetJointAngle := GetProcAddress(LibHandle, 'NewtonBallGetJointAngle');
    @NewtonBallGetJointOmega := GetProcAddress(LibHandle, 'NewtonBallGetJointOmega');
    @NewtonBallGetJointForce := GetProcAddress(LibHandle, 'NewtonBallGetJointForce');
    @NewtonBallSetConeLimits := GetProcAddress(LibHandle, 'NewtonBallSetConeLimits');
    @NewtonConstraintCreateHinge := GetProcAddress(LibHandle, 'NewtonConstraintCreateHinge');
    @NewtonHingeSetUserCallback := GetProcAddress(LibHandle, 'NewtonHingeSetUserCallback');
    @NewtonHingeGetJointAngle := GetProcAddress(LibHandle, 'NewtonHingeGetJointAngle');
    @NewtonHingeGetJointOmega := GetProcAddress(LibHandle, 'NewtonHingeGetJointOmega');
    @NewtonHingeGetJointForce := GetProcAddress(LibHandle, 'NewtonHingeGetJointForce');
    @NewtonHingeCalculateStopAlpha := GetProcAddress(LibHandle, 'NewtonHingeCalculateStopAlpha');
    @NewtonConstraintCreateSlider := GetProcAddress(LibHandle, 'NewtonConstraintCreateSlider');
    @NewtonSliderSetUserCallback := GetProcAddress(LibHandle, 'NewtonSliderSetUserCallback');
    @NewtonSliderGetJointPosit := GetProcAddress(LibHandle, 'NewtonSliderGetJointPosit');
    @NewtonSliderGetJointVeloc := GetProcAddress(LibHandle, 'NewtonSliderGetJointVeloc');
    @NewtonSliderGetJointForce := GetProcAddress(LibHandle, 'NewtonSliderGetJointForce');
    @NewtonSliderCalculateStopAccel := GetProcAddress(LibHandle, 'NewtonSliderCalculateStopAccel');
    @NewtonConstraintCreateCorkscrew := GetProcAddress(LibHandle, 'NewtonConstraintCreateCorkscrew');
    @NewtonCorkscrewSetUserCallback := GetProcAddress(LibHandle, 'NewtonCorkscrewSetUserCallback');
    @NewtonCorkscrewGetJointPosit := GetProcAddress(LibHandle, 'NewtonCorkscrewGetJointPosit');
    @NewtonCorkscrewGetJointAngle := GetProcAddress(LibHandle, 'NewtonCorkscrewGetJointAngle');
    @NewtonCorkscrewGetJointVeloc := GetProcAddress(LibHandle, 'NewtonCorkscrewGetJointVeloc');
    @NewtonCorkscrewGetJointOmega := GetProcAddress(LibHandle, 'NewtonCorkscrewGetJointOmega');
    @NewtonCorkscrewGetJointForce := GetProcAddress(LibHandle, 'NewtonCorkscrewGetJointForce');
    @NewtonCorkscrewCalculateStopAlpha := GetProcAddress(LibHandle, 'NewtonCorkscrewCalculateStopAlpha');
    @NewtonCorkscrewCalculateStopAccel := GetProcAddress(LibHandle, 'NewtonCorkscrewCalculateStopAccel');
    @NewtonConstraintCreateUniversal := GetProcAddress(LibHandle, 'NewtonConstraintCreateUniversal');
    @NewtonUniversalSetUserCallback := GetProcAddress(LibHandle, 'NewtonUniversalSetUserCallback');
    @NewtonUniversalGetJointAngle0 := GetProcAddress(LibHandle, 'NewtonUniversalGetJointAngle0');
    @NewtonUniversalGetJointAngle1 := GetProcAddress(LibHandle, 'NewtonUniversalGetJointAngle1');
    @NewtonUniversalGetJointOmega0 := GetProcAddress(LibHandle, 'NewtonUniversalGetJointOmega0');
    @NewtonUniversalGetJointOmega1 := GetProcAddress(LibHandle, 'NewtonUniversalGetJointOmega1');
    @NewtonUniversalGetJointForce := GetProcAddress(LibHandle, 'NewtonUniversalGetJointForce');
    @NewtonUniversalCalculateStopAlpha0 := GetProcAddress(LibHandle, 'NewtonUniversalCalculateStopAlpha0');
    @NewtonUniversalCalculateStopAlpha1 := GetProcAddress(LibHandle, 'NewtonUniversalCalculateStopAlpha1');
    @NewtonConstraintCreateUpVector := GetProcAddress(LibHandle, 'NewtonConstraintCreateUpVector');
    @NewtonUpVectorGetPin := GetProcAddress(LibHandle, 'NewtonUpVectorGetPin');
    @NewtonUpVectorSetPin := GetProcAddress(LibHandle, 'NewtonUpVectorSetPin');
    @NewtonConstraintCreateUserJoint := GetProcAddress(LibHandle, 'NewtonConstraintCreateUserJoint');
    @NewtonUserJointAddLinearRow := GetProcAddress(LibHandle, 'NewtonUserJointAddLinearRow');
    @NewtonUserJointAddAngularRow := GetProcAddress(LibHandle, 'NewtonUserJointAddAngularRow');
    @NewtonUserJointAddGeneralRow := GetProcAddress(LibHandle, 'NewtonUserJointAddGeneralRow');
    @NewtonUserJointSetRowMinimumFriction := GetProcAddress(LibHandle, 'NewtonUserJointSetRowMinimumFriction');
    @NewtonUserJointSetRowMaximumFriction := GetProcAddress(LibHandle, 'NewtonUserJointSetRowMaximumFriction');
    @NewtonUserJointSetRowAcceleration := GetProcAddress(LibHandle, 'NewtonUserJointSetRowAcceleration');
    @NewtonUserJointSetRowStiffness := GetProcAddress(LibHandle, 'NewtonUserJointSetRowStiffness');
    @NewtonUserJointSetRowSpringDamperAcceleration := GetProcAddress(LibHandle, 'NewtonUserJointSetRowSpringDamperAcceleration');
    @NewtonUserJointGetRowForce  := GetProcAddress(LibHandle, 'NewtonUserJointGetRowForce');
    @NewtonCreateRagDoll := GetProcAddress(LibHandle, 'NewtonCreateRagDoll');
    @NewtonDestroyRagDoll := GetProcAddress(LibHandle, 'NewtonDestroyRagDoll');
    @NewtonRagDollBegin := GetProcAddress(LibHandle, 'NewtonRagDollBegin');
    @NewtonRagDollEnd := GetProcAddress(LibHandle, 'NewtonRagDollEnd');
    @NewtonRagDollFindBone := GetProcAddress(LibHandle, 'NewtonRagDollFindBone');
    @NewtonRagDollGetRootBone := GetProcAddress(LibHandle, 'NewtonRagDollGetRootBone');
    @NewtonRagDollSetForceAndTorqueCallback := GetProcAddress(LibHandle, 'NewtonRagDollSetForceAndTorqueCallback');
    @NewtonRagDollSetTransformCallback := GetProcAddress(LibHandle, 'NewtonRagDollSetTransformCallback');
    @NewtonRagDollAddBone := GetProcAddress(LibHandle, 'NewtonRagDollAddBone');
    @NewtonRagDollBoneGetUserData := GetProcAddress(LibHandle, 'NewtonRagDollBoneGetUserData');
    @NewtonRagDollBoneGetBody := GetProcAddress(LibHandle, 'NewtonRagDollBoneGetBody');
    @NewtonRagDollBoneSetID := GetProcAddress(LibHandle, 'NewtonRagDollBoneSetID');
    @NewtonRagDollBoneSetLimits := GetProcAddress(LibHandle, 'NewtonRagDollBoneSetLimits');
    @NewtonRagDollBoneGetLocalMatrix := GetProcAddress(LibHandle, 'NewtonRagDollBoneGetLocalMatrix');
    @NewtonRagDollBoneGetGlobalMatrix := GetProcAddress(LibHandle, 'NewtonRagDollBoneGetGlobalMatrix');
    @NewtonConstraintCreateVehicle := GetProcAddress(LibHandle, 'NewtonConstraintCreateVehicle');
    @NewtonVehicleReset := GetProcAddress(LibHandle, 'NewtonVehicleReset');
    @NewtonVehicleSetTireCallback := GetProcAddress(LibHandle, 'NewtonVehicleSetTireCallback');
    @NewtonVehicleAddTire := GetProcAddress(LibHandle, 'NewtonVehicleAddTire');
    @NewtonVehicleRemoveTire := GetProcAddress(LibHandle, 'NewtonVehicleRemoveTire');
    @NewtonVehicleGetFirstTireID := GetProcAddress(LibHandle, 'NewtonVehicleGetFirstTireID');
    @NewtonVehicleGetNextTireID := GetProcAddress(LibHandle, 'NewtonVehicleGetNextTireID');
    @NewtonVehicleTireIsAirBorne := GetProcAddress(LibHandle, 'NewtonVehicleTireIsAirBorne');
    @NewtonVehicleTireLostSideGrip := GetProcAddress(LibHandle, 'NewtonVehicleTireLostSideGrip');
    @NewtonVehicleTireLostTraction := GetProcAddress(LibHandle, 'NewtonVehicleTireLostTraction');
    @NewtonVehicleGetTireUserData := GetProcAddress(LibHandle, 'NewtonVehicleGetTireUserData');
    @NewtonVehicleGetTireOmega := GetProcAddress(LibHandle, 'NewtonVehicleGetTireOmega');
    @NewtonVehicleGetTireNormalLoad := GetProcAddress(LibHandle, 'NewtonVehicleGetTireNormalLoad');
    @NewtonVehicleGetTireSteerAngle := GetProcAddress(LibHandle, 'NewtonVehicleGetTireSteerAngle');
    @NewtonVehicleGetTireLateralSpeed := GetProcAddress(LibHandle, 'NewtonVehicleGetTireLateralSpeed');
    @NewtonVehicleGetTireLongitudinalSpeed := GetProcAddress(LibHandle, 'NewtonVehicleGetTireLongitudinalSpeed');
    @NewtonVehicleGetTireMatrix := GetProcAddress(LibHandle, 'NewtonVehicleGetTireMatrix');
    @NewtonVehicleSetTireTorque := GetProcAddress(LibHandle, 'NewtonVehicleSetTireTorque');
    @NewtonVehicleSetTireSteerAngle := GetProcAddress(LibHandle, 'NewtonVehicleSetTireSteerAngle');
    @NewtonVehicleSetTireMaxSideSleepSpeed := GetProcAddress(LibHandle, 'NewtonVehicleSetTireMaxSideSleepSpeed');
    @NewtonVehicleSetTireSideSleepCoeficient := GetProcAddress(LibHandle, 'NewtonVehicleSetTireSideSleepCoeficient');
    @NewtonVehicleSetTireMaxLongitudinalSlideSpeed := GetProcAddress(LibHandle, 'NewtonVehicleSetTireMaxLongitudinalSlideSpeed');
    @NewtonVehicleSetTireLongitudinalSlideCoeficient := GetProcAddress(LibHandle, 'NewtonVehicleSetTireLongitudinalSlideCoeficient');
    @NewtonVehicleTireCalculateMaxBrakeAcceleration := GetProcAddress(LibHandle, 'NewtonVehicleTireCalculateMaxBrakeAcceleration');
    @NewtonVehicleTireSetBrakeAcceleration := GetProcAddress(LibHandle, 'NewtonVehicleTireSetBrakeAcceleration');
    @NewtonCreateCompoundCollision := GetProcAddress(LibHandle, 'NewtonCreateCompoundCollision');
    @NewtonCreateUserMeshCollision := GetProcAddress(LibHandle, 'NewtonCreateUserMeshCollision');
    @NewtonCollisionCollideContinue := GetProcAddress(LibHandle, 'NewtonCollisionCollideContinue');
  end;
end;

procedure FreeNewton();
begin
  if LibHandle <> 0 then
    FreeLibrary(LibHandle);
end;


