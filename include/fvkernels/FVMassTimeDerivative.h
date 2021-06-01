/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "FVTimeKernel.h"

class FVMassTimeDerivative : public FVTimeKernel
{
public:
  static InputParameters validParams();
  FVMassTimeDerivative(const InputParameters & parameters);

protected:
  ADReal computeQpResidual() override;

  const bool _nwphase;
  const std::string _ext;
  const MaterialProperty<Real> & _porosity;
  const ADMaterialProperty<Real> & _density;
  const ADVariableValue & _sw_dot;
};
