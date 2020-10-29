//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FVMassTimeDerivative.h"

registerADMooseObject("finchApp", FVMassTimeDerivative);

InputParameters
FVMassTimeDerivative::validParams()
{
  InputParameters params = FVTimeKernel::validParams();
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

FVMassTimeDerivative::FVMassTimeDerivative(const InputParameters & parameters)
  : FVTimeKernel(parameters),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _porosity(getMaterialProperty<Real>("porosity")),
    _density(getADMaterialProperty<Real>("density" + _ext)),
    _sw_dot(adCoupledDot("saturation_w"))
{
}

ADReal
FVMassTimeDerivative::computeQpResidual()
{
  if (_nwphase)
    return -_porosity[_qp] * _density[_qp] * _sw_dot[_qp];
  else
    return _porosity[_qp] * _density[_qp] * _sw_dot[_qp];
}
