//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FluidPoreVolume.h"

registerADMooseObject("finchApp", FluidPoreVolume);

InputParameters
FluidPoreVolume::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

FluidPoreVolume::FluidPoreVolume(const InputParameters & params)
  : ElementIntegralPostprocessor(params),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _porosity(getMaterialProperty<Real>("porosity")),
    _saturation(getADMaterialProperty<Real>("s" + _ext))
{
}

Real
FluidPoreVolume::computeQpIntegral()
{
  // Clip to zero to avoid small negative masses due to precision
  const Real porevol = _porosity[_qp] * _saturation[_qp].value();

  return (porevol > 0.0 ? porevol : 0.0);
}
