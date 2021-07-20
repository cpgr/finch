/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "IndicatorMarker.h"

class ValueJumpMarker : public IndicatorMarker
{
public:
  static InputParameters validParams();
  ValueJumpMarker(const InputParameters & parameters);

protected:
  virtual MarkerValue computeElementMarker() override;

  const Real _refine;
  const Real _coarsen;
};
