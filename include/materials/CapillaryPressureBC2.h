/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/
#pragma once

#include "Material.h"

class CapillaryPressureBC2 : public Material
{
public:
  static InputParameters validParams();
  CapillaryPressureBC2(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const Real _lambda;
  const VariableValue & _pe;
  const Real _swirr;
  const Real _pc_max;

  ADMaterialProperty<Real> & _pc;
  const ADVariableValue & _sw;
};
