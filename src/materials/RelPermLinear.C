/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "RelPermLinear.h"

registerMooseObject("finchApp", RelPermLinear);

InputParameters
RelPermLinear::validParams()
{
  InputParameters params = RelPermBase::validParams();
  return params;
}

RelPermLinear::RelPermLinear(const InputParameters & parameters) : RelPermBase(parameters) {}

void
RelPermLinear::computeQpProperties()
{
  if (_sw[_qp].value() <= 0.0)
  {
    _relperm_w[_qp] = 0.0;
    _relperm_nw[_qp] = 1.0;
  }
  else if (_sw[_qp].value() >= 1.0)
  {
    _relperm_w[_qp] = 1.0;
    _relperm_nw[_qp] = 0.0;
  }
  else
  {
    _relperm_w[_qp] = _sw[_qp];
    _relperm_nw[_qp] = (1.0 - _sw[_qp]);
  }
}
