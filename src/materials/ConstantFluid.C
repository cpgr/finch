/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "ConstantFluid.h"

registerMooseObject("finchApp", ConstantFluid);

InputParameters
ConstantFluid::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<Real>("density", "The density (kg/m^3)");
  params.addRequiredParam<Real>("viscosity", "The viscosity (Pa.s)");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

ConstantFluid::ConstantFluid(const InputParameters & parameters)
  : Material(parameters),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _input_density(getParam<Real>("density")),
    _input_viscosity(getParam<Real>("viscosity")),
    _density(declareADProperty<Real>("density" + _ext)),
    _viscosity(declareADProperty<Real>("viscosity" + _ext))
{
}

void
ConstantFluid::computeQpProperties()
{
  _density[_qp] = _input_density;
  _viscosity[_qp] = _input_viscosity;
}
