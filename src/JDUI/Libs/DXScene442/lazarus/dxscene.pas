{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit dxscene; 

interface

uses
    dx_ani, dx_controls, dx_objects, dx_scene, dx_utils, dx_reg, dx_vgcore, 
  dx_vglayer, dx_opengl, dx_directx, dx_dsgn_particle, dx_physics_newton, 
  dx_textbox, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('dx_reg', @dx_reg.Register); 
end; 

initialization
  RegisterPackage('dxscene', @Register); 
end.
