/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "RelPermBase.h"

class RelPermBC : public RelPermBase
{
public:
  static InputParameters validParams();
  RelPermBC(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

private:
  const Real _w_coeff;
  const Real _nw_coeff;
  const Real _krw_end;
  const Real _krnw_end;
  const Real _swirr;
  const bool _use_legacy_form;
};
