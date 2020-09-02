//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("dxscene_cb5.res");
USERES("..\dx_reg.dcr");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEUNIT("..\dx_directx.pas");
USEUNIT("..\dx_objects.pas");
USEUNIT("..\dx_scene.pas");
USEUNIT("..\dx_timer.pas");
USEUNIT("..\dx_utils.pas");
USEUNIT("..\dx_version.pas");
USEUNIT("..\dx_ani.pas");
USEUNIT("..\dx_viewport.pas");
USEUNIT("..\dx_resource.pas");
USEUNIT("..\dx_controls.pas");
USEUNIT("..\dx_textbox.pas");
USEUNIT("..\dx_physics_newton.pas");
USEUNIT("..\dx_vgcore.pas");
USEUNIT("..\dx_vglayer.pas");
USEUNIT("..\dx_dsgn_material.pas");
USEUNIT("..\dx_dynamics.pas");
USEUNIT("..\dx_dsgn_particle.pas");
USEUNIT("..\dx_vgdb.pas");
USEUNIT("..\dx_reg.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
