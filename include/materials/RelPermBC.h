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
  const Real _lambda_w;
  const Real _lambda_nw;
};
