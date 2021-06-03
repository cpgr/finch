/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "QuadraturePointMarker.h"

class ValueChangeMarker : public QuadraturePointMarker
{
public:
  static InputParameters validParams();
  ValueChangeMarker(const InputParameters & parameters);

protected:
  virtual MarkerValue computeQpMarker() override;

  const VariableValue & _u_old;

  Real _lower_bound;
};
