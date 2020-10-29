#include "Porosity.h"

registerMooseObject("finchApp", Porosity);

InputParameters
Porosity::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredCoupledVar("porosity", "Porosity");
  params.addClassDescription("Porosity");
  return params;
}

Porosity::Porosity(const InputParameters & parameters)
  : Material(parameters),
    _porosity(declareProperty<Real>("porosity")),
    _porosity_value(coupledValue("porosity"))
{
}

void
Porosity::computeQpProperties()
{
  _porosity[_qp] = _porosity_value[_qp];
}
