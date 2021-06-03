/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "ValueJumpMarker.h"
#include "libmesh/error_vector.h"

registerMooseObject("finchApp", ValueJumpMarker);

InputParameters
ValueJumpMarker::validParams()
{
  InputParameters params = IndicatorMarker::validParams();
  params.addParam<Real>(
      "refine",
      0.1,
      "Refine when the magnitude of the jump is greater than this value (default is 0.1)");
  params.addParam<Real>("coarsen",
                        0,
                        "Coarsen when the magnitude of the jump is smaller than this value "
                        "(default is 0, or no coarsening)");
  params.addClassDescription(
      "Mark elements for adaptivity based on the supplied upper and lower "
      "bounds and the jump in specified variable supplied by the indicator.");
  return params;
}

ValueJumpMarker::ValueJumpMarker(const InputParameters & parameters)
  : IndicatorMarker(parameters),
    _refine(getParam<Real>("refine")),
    _coarsen(getParam<Real>("coarsen"))
{
}

Marker::MarkerValue
ValueJumpMarker::computeElementMarker()
{
  Real jump = _error_vector[_current_elem->id()];

  if (jump > _refine)
    return REFINE;
  else if (jump < _coarsen)
    return COARSEN;

  return DO_NOTHING;
}
