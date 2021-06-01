/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "Material.h"

class ConstantFluid : public Material
{
public:
  static InputParameters validParams();
  ConstantFluid(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const bool _nwphase;
  const std::string _ext;
  const Real _input_density;
  const Real _input_viscosity;

  ADMaterialProperty<Real> & _density;
  ADMaterialProperty<Real> & _viscosity;
};
