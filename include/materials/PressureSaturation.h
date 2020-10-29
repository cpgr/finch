//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

class PressureSaturation : public Material
{
public:
  static InputParameters validParams();
  PressureSaturation(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  ADMaterialProperty<Real> & _sw;
  ADMaterialProperty<Real> & _snw;
  ADMaterialProperty<Real> & _pw;
  ADMaterialProperty<Real> & _pnw;

  const ADMaterialProperty<Real> & _pc;

  const ADVariableValue & _pw_var;
  const ADVariableValue & _sw_var;
};
