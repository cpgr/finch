//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ElementIntegralPostprocessor.h"

/**
 * Postprocessor produces the mass of a given fluid component in a region
 */
class FluidMass : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  FluidMass(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _density;
  const ADMaterialProperty<Real> & _saturation;
};
