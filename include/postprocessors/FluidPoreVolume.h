/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "ElementIntegralPostprocessor.h"

/**
 * Calculates pore volume of a given fluid component in a region as a fraction
 * of total pore volume
 */
class FluidPoreVolume : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  FluidPoreVolume(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _saturation;
};
