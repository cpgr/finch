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

class RelPermBC2 : public Material
{
public:
  static InputParameters validParams();
  RelPermBC2(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const Real _w_coeff;
  const Real _nw_coeff;
  const Real _krw_end;
  const Real _krnw_end;
  const Real _swirr;

  ADMaterialProperty<Real> & _relperm_w;
  ADMaterialProperty<Real> & _relperm_nw;
  const ADVariableValue & _sw;
};
