/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "FVGradientIndicator.h"

registerMooseObject("finchApp", FVGradientIndicator);

InputParameters
FVGradientIndicator::validParams()
{
  InputParameters params = InternalSideIndicator::validParams();
  params.addClassDescription("Computes the gradient of the FV variable between elements");
  return params;
}

FVGradientIndicator::FVGradientIndicator(const InputParameters & parameters)
  : InternalSideIndicator(parameters)
{
}

Real
FVGradientIndicator::computeQpIntegral()
{
  const Real jump = (_u[_qp] - _u_neighbor[_qp]);

  const Real dist = (_current_elem->centroid() - _neighbor_elem->centroid()).norm();

  mooseAssert(dist > 0.0, "The distance between centroids is zero. Something is very wrong!");
  return std::abs(jump) / dist;
}
