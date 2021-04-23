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
  _relperm_w[_qp] = _sw[_qp];
  _relperm_nw[_qp] = (1.0 - _sw[_qp]);
}
