//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "FVFluxBC.h"

class FVDarcyOutflowBC : public FVFluxBC
{
public:
  static InputParameters validParams();
  FVDarcyOutflowBC(const InputParameters & params);

protected:
  virtual ADReal computeQpResidual() override;

  const bool _nwphase;
  const std::string _ext;

  const ADMaterialProperty<Real> & _density;
  const ADMaterialProperty<Real> & _density_neighbor;

  const ADMaterialProperty<Real> & _viscosity;
  const ADMaterialProperty<Real> & _viscosity_neighbor;

  const ADMaterialProperty<Real> & _relperm;
  const ADMaterialProperty<Real> & _relperm_neighbor;

  const MaterialProperty<RealTensorValue> & _permeability;
  const MaterialProperty<RealTensorValue> & _permeability_neighbor;

  const ADMaterialProperty<Real> & _pc;
  const ADMaterialProperty<Real> & _pc_neighbor;

  const ADVariableValue & _pw;
  const ADVariableValue & _pw_neighbor;

  const RealVectorValue & _gravity;
};
