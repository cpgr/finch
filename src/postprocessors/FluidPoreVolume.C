/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

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
