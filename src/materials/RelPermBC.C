/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "RelPermBC.h"

registerMooseObject("finchApp", RelPermBC);

InputParameters
RelPermBC::validParams()
{
  InputParameters params = RelPermBase::validParams();
  params.addRequiredParam<Real>("lambda_w", "The Brooks-Corey exponent of the wetting phase");
  params.addRequiredParam<Real>("lambda_nw", "The Brooks-Corey exponent of the non-wetting phase");
  return params;
}

RelPermBC::RelPermBC(const InputParameters & parameters)
  : RelPermBase(parameters),
    _lambda_w(getParam<Real>("lambda_w")),
    _lambda_nw(getParam<Real>("lambda_nw"))
{
}

void
RelPermBC::computeQpProperties()
{
  _relperm_w[_qp] = std::pow(_sw[_qp], (2.0 + 3.0 * _lambda_w) / _lambda_w);
  _relperm_nw[_qp] = (1.0 - _sw[_qp]) * (1.0 - _sw[_qp]) *
                     (1.0 - std::pow(_sw[_qp], (2.0 + _lambda_nw) / _lambda_nw));
}
