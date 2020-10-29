#pragma once

#include "Material.h"

class Porosity : public Material
{
public:
  static InputParameters validParams();

  Porosity(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

private:
  MaterialProperty<Real> & _porosity;
  const VariableValue & _porosity_value;
};
