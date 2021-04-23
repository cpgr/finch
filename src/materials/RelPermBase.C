#include "RelPermBase.h"

InputParameters
RelPermBase::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  return params;
}

RelPermBase::RelPermBase(const InputParameters & parameters)
  : Material(parameters),
    _relperm_w(declareADProperty<Real>("relperm_w")),
    _relperm_nw(declareADProperty<Real>("relperm_nw")),
    _sw(adCoupledValue("saturation_w"))
{
}

void
RelPermBase::computeQpProperties()
{
  mooseError("computeQpProperties() must be overridden in derived classes");
}
