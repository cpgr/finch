/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "FluidMass.h"

registerADMooseObject("finchApp", FluidMass);

InputParameters
FluidMass::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

FluidMass::FluidMass(const InputParameters & params)
  : ElementIntegralPostprocessor(params),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _porosity(getMaterialProperty<Real>("porosity")),
    _density(getADMaterialProperty<Real>("density" + _ext)),
    _saturation(getADMaterialProperty<Real>("s" + _ext))
{
}

Real
FluidMass::computeQpIntegral()
{
  // Clip to zero to avoid small negative masses due to precision
  const Real mass = _porosity[_qp] * _saturation[_qp].value() * _density[_qp].value();

  return (mass > 0.0 ? mass : 0.0);
}
