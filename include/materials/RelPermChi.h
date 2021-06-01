/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

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
