//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "RelPermBase.h"

class RelPermChi : public RelPermBase
{
public:
  static InputParameters validParams();
  RelPermChi(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

private:
  const Real _A_water;
  const Real _L_water;
  const Real _B_gas;
  const Real _M_gas;
  const Real _krw_end;
  const Real _krnw_end;
  const Real _swirr;
};
