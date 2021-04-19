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
 * Calculates pore volume of a given fluid component in a region as a fraction
 * of total pore volume
 */
class FluidPoreVolume : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  FluidPoreVolume(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _saturation;
};
