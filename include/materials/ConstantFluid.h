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

class ConstantFluid : public Material
{
public:
  static InputParameters validParams();
  ConstantFluid(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const bool _nwphase;
  const std::string _ext;
  const Real _input_density;
  const Real _input_viscosity;

  ADMaterialProperty<Real> & _density;
  ADMaterialProperty<Real> & _viscosity;
};
