#include "RelPermChi.h"

registerMooseObject("finchApp", RelPermChi);

InputParameters
RelPermChi::validParams()
{
  InputParameters params = RelPermBase::validParams();
  params.addRequiredParam<Real>("A_water", "Chierici A parameter for the wetting phase");
  params.addRequiredParam<Real>("L_water", "Chierici L parameter for the wetting phase");
  params.addRequiredParam<Real>("B_gas", "Chierici B parameter for the non-wetting phase");
  params.addRequiredParam<Real>("M_gas", "Chierici M parameter for the non-wetting phase");
  params.addRangeCheckedParam<Real>(
      "swirr", 0, "swirr >= 0 & swirr < 1", "The irreducible saturation of the wetting phase");
  params.addRequiredParam<Real>("krw_end", "The endpoint relative permeability the wetting phase");
  params.addRequiredParam<Real>("krnw_end",
                                "The endpoint relative permeability the non-wetting phase");
  return params;
}

RelPermChi::RelPermChi(const InputParameters & parameters)
  : RelPermBase(parameters),
    _A_water(getParam<Real>("A_water")),
    _L_water(getParam<Real>("L_water")),
    _B_gas(getParam<Real>("B_gas")),
    _M_gas(getParam<Real>("M_gas")),
    _krw_end(getParam<Real>("krw_end")),
    _krnw_end(getParam<Real>("krnw_end")),
    _swirr(getParam<Real>("swirr"))
{
}

void
RelPermChi::computeQpProperties()
{

  if ((1.0 - _sw[_qp]) < 1.0e-15) // We are at sw == 1
  {
    _relperm_w[_qp] = _krw_end;
    _relperm_nw[_qp] = 0.0;
  }
  else
  {
    _relperm_w[_qp] =
        _krw_end * std::exp((-1.0 * _A_water *
                             std::pow(((_sw[_qp] - _swirr) / (1.0 - _sw[_qp])), -1.0 * _L_water)));
    _relperm_nw[_qp] =
        _krnw_end *
        std::exp((-1.0 * _B_gas * std::pow(((_sw[_qp] - _swirr) / (1.0 - _sw[_qp])), _M_gas)));
  }
}
