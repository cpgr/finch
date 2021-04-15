#include "ValueChangeMarker.h"
#include "MooseUtils.h"

registerMooseObject("finchApp", ValueChangeMarker);

InputParameters
ValueChangeMarker::validParams()
{
  InputParameters params = QuadraturePointMarker::validParams();
  params.addParam<Real>(
      "lower_bound", 0.1, "The lower bound value for the range (default is 0.1).");
  params.addParam<Real>("upper_bound", 1, "The upper bound value for the range (default is 1).");
  params.addClassDescription("Mark elements for adaptivity based on the supplied upper and lower "
                             "bounds and the change in specified variable.");
  return params;
}

ValueChangeMarker::ValueChangeMarker(const InputParameters & parameters)
  : QuadraturePointMarker(parameters),
    _u_old(valueOld()),
    _lower_bound(parameters.get<Real>("lower_bound")),
    _upper_bound(parameters.get<Real>("upper_bound")),
    _inside(REFINE),
    _outside(COARSEN)
{
}

Marker::MarkerValue
ValueChangeMarker::computeQpMarker()
{
  // If _u is zero, mark for coarsening
  if (MooseUtils::absoluteFuzzyEqual(_u[_qp], 0.0))
    return _outside;

  // _u_old != zero here
  if (std::abs((_u[_qp] - _u_old[_qp]) / _u[_qp]) >= _lower_bound &&
      std::abs((_u[_qp] - _u_old[_qp]) / _u[_qp]) <= _upper_bound)
    return _inside;

  return _outside;
}
