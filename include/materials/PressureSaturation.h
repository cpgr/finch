/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "Material.h"

class PressureSaturation : public Material
{
public:
  static InputParameters validParams();
  PressureSaturation(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  ADMaterialProperty<Real> & _sw;
  ADMaterialProperty<Real> & _snw;
  ADMaterialProperty<Real> & _pw;
  ADMaterialProperty<Real> & _pnw;

  const ADMaterialProperty<Real> & _pc;

  const ADVariableValue & _pw_var;
  const ADVariableValue & _sw_var;
};
