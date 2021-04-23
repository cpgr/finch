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

class CapillaryPressureBC2 : public Material
{
public:
  static InputParameters validParams();
  CapillaryPressureBC2(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const Real _lambda;
  const VariableValue & _pe;
  const Real _swirr;
  const Real _pc_max;

  ADMaterialProperty<Real> & _pc;
  const ADVariableValue & _sw;
};
