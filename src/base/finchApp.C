/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "finchApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
finchApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  params.set<bool>("use_legacy_material_output") = false;

  return params;
}

finchApp::finchApp(InputParameters parameters) : MooseApp(parameters)
{
  finchApp::registerAll(_factory, _action_factory, _syntax);
}

finchApp::~finchApp() {}

void
finchApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"finchApp"});
  Registry::registerActionsTo(af, {"finchApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
finchApp::registerApps()
{
  registerApp(finchApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
finchApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  finchApp::registerAll(f, af, s);
}
extern "C" void
finchApp__registerApps()
{
  finchApp::registerApps();
}
