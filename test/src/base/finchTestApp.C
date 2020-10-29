//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "finchTestApp.h"
#include "finchApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
finchTestApp::validParams()
{
  InputParameters params = finchApp::validParams();
  return params;
}

finchTestApp::finchTestApp(InputParameters parameters) : MooseApp(parameters)
{
  finchTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

finchTestApp::~finchTestApp() {}

void
finchTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  finchApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"finchTestApp"});
    Registry::registerActionsTo(af, {"finchTestApp"});
  }
}

void
finchTestApp::registerApps()
{
  registerApp(finchApp);
  registerApp(finchTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
finchTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  finchTestApp::registerAll(f, af, s);
}
extern "C" void
finchTestApp__registerApps()
{
  finchTestApp::registerApps();
}
