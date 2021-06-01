/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "ElementIntegralPostprocessor.h"

/**
 * Calculates total pore volume of mesh
 */
class TotalPoreVolume : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  TotalPoreVolume(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const MaterialProperty<Real> & _porosity;
};
