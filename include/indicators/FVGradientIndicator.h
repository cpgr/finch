/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "InternalSideIndicator.h"

class FVGradientIndicator : public InternalSideIndicator
{
public:
  static InputParameters validParams();
  FVGradientIndicator(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;
};
