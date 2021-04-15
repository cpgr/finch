#pragma once

#include "QuadraturePointMarker.h"

class ValueChangeMarker : public QuadraturePointMarker
{
public:
  static InputParameters validParams();
  ValueChangeMarker(const InputParameters & parameters);

protected:
  virtual MarkerValue computeQpMarker() override;

  const VariableValue & _u_old;

  Real _lower_bound;
  Real _upper_bound;

  MarkerValue _inside;
  MarkerValue _outside;
};
