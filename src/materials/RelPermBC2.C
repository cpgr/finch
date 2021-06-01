/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "RelPermBC2.h"

registerMooseObject("finchApp", RelPermBC2);

InputParameters
RelPermBC2::validParams()
{
  InputParameters params = RelPermBase::validParams();
  params.addRequiredParam<Real>("w_coeff", "The Brooks-Corey exponent of the wetting phase");
  params.addRequiredParam<Real>("nw_coeff", "The Brooks-Corey exponent of the non-wetting phase");
  params.addRangeCheckedParam<Real>(
      "swirr", 0, "swirr >= 0 & swirr < 1", "The irreducible saturation of the wetting phase");
  params.addRequiredParam<Real>("krw_end", "The endpoint relative permeability the wetting phase");
  params.addRequiredParam<Real>("krnw_end",
                                "The endpoint relative permeability the non-wetting phase");
  return params;
}

RelPermBC2::RelPermBC2(const InputParameters & parameters)
  : RelPermBase(parameters),
    _w_coeff(getParam<Real>("w_coeff")),
    _nw_coeff(getParam<Real>("nw_coeff")),
    _krw_end(getParam<Real>("krw_end")),
    _krnw_end(getParam<Real>("krnw_end")),
    _swirr(getParam<Real>("swirr"))
{
}

void
RelPermBC2::computeQpProperties()
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
