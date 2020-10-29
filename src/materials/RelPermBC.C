#include "RelPermBC.h"

registerMooseObject("finchApp", RelPermBC);

InputParameters
RelPermBC::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<Real>("lambda_w", "The Brooks-Corey exponent of the wetting phase");
  params.addRequiredParam<Real>("lambda_nw", "The Brooks-Corey exponent of the non-wetting phase");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  return params;
}

RelPermBC::RelPermBC(const InputParameters & parameters)
  : Material(parameters),
    _lambda_w(getParam<Real>("lambda_w")),
    _lambda_nw(getParam<Real>("lambda_nw")),
    _relperm_w(declareADProperty<Real>("relperm_w")),
    _relperm_nw(declareADProperty<Real>("relperm_nw")),
    _sw(adCoupledValue("saturation_w"))
{
}

void
RelPermBC::computeQpProperties()
{
  _relperm_w[_qp] = std::pow(_sw[_qp], (2.0 + 3.0 * _lambda_w) / _lambda_w);
  _relperm_nw[_qp] = (1.0 - _sw[_qp]) * (1.0 - _sw[_qp]) *
                     (1.0 - std::pow(_sw[_qp], (2.0 + _lambda_nw) / _lambda_nw));
}
