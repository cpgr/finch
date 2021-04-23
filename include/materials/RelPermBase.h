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

class RelPermBase : public Material
{
public:
  static InputParameters validParams();
  RelPermBase(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  /// Relative permeability of wetting and non-wetting phases
  ADMaterialProperty<Real> & _relperm_w;
  ADMaterialProperty<Real> & _relperm_nw;

  /// Wetting phase saturation
  const ADVariableValue & _sw;
};
