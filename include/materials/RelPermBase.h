/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "Material.h"

class RelPermBase : public Material
{
public:
  static InputParameters validParams();
  RelPermBase(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  /// Relative permeability of wetting and non-wetting phases
  ADMaterialProperty<Real> & _relperm_w;
  ADMaterialProperty<Real> & _relperm_nw;

  /// Wetting phase saturation
  const ADVariableValue & _sw;
};
