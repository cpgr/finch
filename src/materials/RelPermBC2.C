#include "RelPermBC2.h"

registerMooseObject("finchApp", RelPermBC2);

InputParameters
RelPermBC2::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<Real>("w_coeff", "The Brooks-Corey exponent of the wetting phase");
  params.addRequiredParam<Real>("nw_coeff", "The Brooks-Corey exponent of the non-wetting phase");
  params.addRequiredParam<Real>("swirr", "The irreducible saturation of the wetting phase");
  params.addRequiredParam<Real>("krw_end", "The endpoint relative permeability the wetting phase");
  params.addRequiredParam<Real>("krnw_end", "The endpoint relative permeability the non-wetting phase");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  return params;
}

RelPermBC2::RelPermBC2(const InputParameters & parameters)
  : Material(parameters),
    _w_coeff(getParam<Real>("w_coeff")),
    _nw_coeff(getParam<Real>("nw_coeff")),
    _krw_end(getParam<Real>("krw_end")),
    _krnw_end(getParam<Real>("krnw_end")),
    _swirr(getParam<Real>("swirr")),
    _relperm_w(declareADProperty<Real>("relperm_w")),
    _relperm_nw(declareADProperty<Real>("relperm_nw")),
    _sw(adCoupledValue("saturation_w"))
{
}

void
RelPermBC2::computeQpProperties()
{
  _relperm_w[_qp] =  _krw_end*std::pow(( (_sw[_qp]- _swirr)/(1 - _swirr)), _w_coeff);
  _relperm_nw[_qp] =  _krnw_end*std::pow(1-( (_sw[_qp]- _swirr)/(1 - _swirr)), _nw_coeff);

}
