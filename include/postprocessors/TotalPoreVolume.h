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
 * Calculates total pore volume of mesh
 */
class TotalPoreVolume : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  TotalPoreVolume(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const MaterialProperty<Real> & _porosity;
};
