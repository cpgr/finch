//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "FVTimeKernel.h"

class FVMassTimeDerivative : public FVTimeKernel
{
public:
  static InputParameters validParams();
  FVMassTimeDerivative(const InputParameters & parameters);

protected:
  ADReal computeQpResidual() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _density;
  const ADVariableValue & _sw_dot;
};
