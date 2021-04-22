#include "RelPermChi.h"

registerMooseObject("finchApp", RelPermChi);

InputParameters
RelPermChi::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<Real>("A_water", "Chierici A parameter for the wetting phase");
  params.addRequiredParam<Real>("L_water", "Chierici L parameter for the wetting phase");
  params.addRequiredParam<Real>("B_gas", "Chierici B parameter for the non-wetting phase");
  params.addRequiredParam<Real>("M_gas", "Chierici M parameter for the non-wetting phase");
  params.addRequiredParam<Real>("swirr", "The irreducible saturation of the wetting phase");
  params.addRequiredParam<Real>("krw_end", "The endpoint relative permeability the wetting phase");
  params.addRequiredParam<Real>("krnw_end", "The endpoint relative permeability the non-wetting phase");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  return params;
}

RelPermChi::RelPermChi(const InputParameters & parameters)
  : Material(parameters),
    _A_water(getParam<Real>("A_water")),
    _L_water(getParam<Real>("L_water")),
    _B_gas(getParam<Real>("B_gas")),
    _M_gas(getParam<Real>("M_gas")),
    _krw_end(getParam<Real>("krw_end")),
    _krnw_end(getParam<Real>("krnw_end")),
    _swirr(getParam<Real>("swirr")),
    _relperm_w(declareADProperty<Real>("relperm_w")),
    _relperm_nw(declareADProperty<Real>("relperm_nw")),
    _sw(adCoupledValue("saturation_w"))
{
}

void
RelPermChi::computeQpProperties()
{
  _relperm_w[_qp] =  _krw_end*std::exp((-1*_A_water*std::pow( ((_sw[_qp]- _swirr)/(1 - _sw[_qp])), -1*_L_water)));
  _relperm_nw[_qp] =  _krnw_end*std::exp((-1*_B_gas*std::pow( ((_sw[_qp]- _swirr)/(1 - _sw[_qp])), _M_gas)));

}
