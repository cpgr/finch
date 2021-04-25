#include "CapillaryPressureBC2.h"

registerMooseObject("finchApp", CapillaryPressureBC2);

InputParameters
CapillaryPressureBC2::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<Real>("lambda", "The Brooks-Corey exponent");
  params.addRequiredCoupledVar("pe", "The Brooks-Corey capillary entry pressure");
  params.addRangeCheckedParam<Real>(
      "swirr", 0, "swirr >= 0 & swirr < 1", "The irreducible saturation of the wetting phase");
  params.addParam<Real>(
      "pc_max",
      1e5,
      "The maximum Brooks-Corey capillary entry pressure at Sw = 0 (default is 1e5)");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  return params;
}

CapillaryPressureBC2::CapillaryPressureBC2(const InputParameters & parameters)
  : Material(parameters),
    _lambda(getParam<Real>("lambda")),
    _pe(coupledValue("pe")),
    _swirr(getParam<Real>("swirr")),
    _pc_max(getParam<Real>("pc_max")),
    _pc(declareADProperty<Real>("pc")),
    _sw(adCoupledValue("saturation_w"))
{
}

void
CapillaryPressureBC2::computeQpProperties()
{
  if (_sw[_qp].value() <= _swirr)
    _pc[_qp] = _pc_max;

  ADReal pc = _pe[_qp] * std::pow(((_sw[_qp] - _swirr) / (1 - _swirr)), -1.0 / _lambda);

  if (pc.value() < _pc_max)
    _pc[_qp] = pc;
  else
    _pc[_qp] = _pc_max;
}
