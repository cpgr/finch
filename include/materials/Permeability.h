#pragma once

#include "Material.h"

class Permeability : public Material
{
public:
  static InputParameters validParams();

  Permeability(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

private:
  MaterialProperty<RealTensorValue> & _permeability;
  const VariableValue & _perm_xx;
  const VariableValue & _perm_yy;
  const VariableValue & _perm_zz;
};
