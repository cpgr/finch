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
  params.addRequiredParam<Real>("w_coeff", "The Brooks-Corey exponent of the wetting phase");
  params.addRequiredParam<Real>("nw_coeff", "The Brooks-Corey exponent of the non-wetting phase");
  params.addRangeCheckedParam<Real>(
      "swirr", 0, "swirr >= 0 & swirr < 1", "The irreducible saturation of the wetting phase");
  params.addParam<Real>(
      "krw_end", 1, "The endpoint relative permeability the wetting phase (default is 1)");
  params.addParam<Real>(
      "krnw_end", 1, "The endpoint relative permeability the non-wetting phase (default is 1)");
  return params;
}

RelPermBC::RelPermBC(const InputParameters & parameters)
  : RelPermBase(parameters),
    _w_coeff(getParam<Real>("w_coeff")),
    _nw_coeff(getParam<Real>("nw_coeff")),
    _krw_end(getParam<Real>("krw_end")),
    _krnw_end(getParam<Real>("krnw_end")),
    _swirr(getParam<Real>("swirr"))
{
}

void
RelPermBC::computeQpProperties()
{
  if (_sw[_qp].value() - _swirr < 1.0e-15) // We are at sw == swirr
  {
    _relperm_w[_qp] = 0.0;
    _relperm_nw[_qp] = _krnw_end;
  }
  else
  {
    _relperm_w[_qp] = _krw_end * std::pow(((_sw[_qp] - _swirr) / (1.0 - _swirr)), _w_coeff);
    _relperm_nw[_qp] =
        _krnw_end * std::pow(1.0 - ((_sw[_qp] - _swirr) / (1.0 - _swirr)), _nw_coeff);
  }
}
