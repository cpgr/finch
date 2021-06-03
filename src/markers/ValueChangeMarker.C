/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "ValueChangeMarker.h"
#include "MooseUtils.h"

registerMooseObject("finchApp", ValueChangeMarker);

InputParameters
ValueChangeMarker::validParams()
{
  InputParameters params = QuadraturePointMarker::validParams();
  params.addParam<Real>("lower_bound",
                        0.1,
                        "The lower bound value for the range (default is 0.1). The element will be "
                        "refined when the variable changes by a percentage greater than this");
  params.addClassDescription("Mark elements for adaptivity based on the supplied lower "
                             "bounds and the percentage change in specified variable.");
  return params;
}

ValueChangeMarker::ValueChangeMarker(const InputParameters & parameters)
  : QuadraturePointMarker(parameters),
    _u_old(valueOld()),
    _lower_bound(parameters.get<Real>("lower_bound"))
{
}

Marker::MarkerValue
ValueChangeMarker::computeQpMarker()
{
  // If _u is zero, then do nothing
  if (MooseUtils::absoluteFuzzyEqual(_u[_qp], 0.0))
    return DO_NOTHING;

  // _u != zero here so can safely find percentage change and refine if > lower bound
  if (std::abs((_u[_qp] - _u_old[_qp]) / _u[_qp]) >= _lower_bound)
    return REFINE;

  // If the chage is less than the lower bound, then coarsen the element
  return COARSEN;
}
