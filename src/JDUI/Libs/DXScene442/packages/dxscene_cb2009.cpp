//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("..\dx_dsgn_particle.pas", Dx_dsgn_particle, frmParticleDesign);
USEFORMNS("..\dx_dsgn_material.pas", Dx_dsgn_material, frmMaterialDesign);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------


#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
	return 1;
}
//---------------------------------------------------------------------------
