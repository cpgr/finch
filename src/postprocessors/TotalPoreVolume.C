/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "TotalPoreVolume.h"

registerADMooseObject("finchApp", TotalPoreVolume);

InputParameters
TotalPoreVolume::validParams()
{
  InputParameters params = ElementIntegralPostprocessor::validParams();
  return params;
}

TotalPoreVolume::TotalPoreVolume(const InputParameters & params)
  : ElementIntegralPostprocessor(params), _porosity(getMaterialProperty<Real>("porosity"))
{
}

Real
TotalPoreVolume::computeQpIntegral()
{
  return _porosity[_qp];
}
