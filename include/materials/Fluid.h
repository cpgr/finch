/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "Material.h"
#include "SinglePhaseFluidProperties.h"

class Fluid : public Material
{
public:
  static InputParameters validParams();
  Fluid(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

private:
  const bool _nwphase;
  const std::string _ext;

  ADMaterialProperty<Real> & _density;
  ADMaterialProperty<Real> & _viscosity;

  const ADMaterialProperty<Real> & _pc;

  const ADVariableValue & _pw;
  const ADVariableValue & _T;

  const SinglePhaseFluidProperties & _fp;
};
