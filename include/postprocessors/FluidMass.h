/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "ElementIntegralPostprocessor.h"

/**
 * Postprocessor produces the mass of a given fluid component in a region
 */
class FluidMass : public ElementIntegralPostprocessor
{
public:
  static InputParameters validParams();

  FluidMass(const InputParameters & parameters);

  virtual Real computeQpIntegral() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _density;
  const ADMaterialProperty<Real> & _saturation;
};
