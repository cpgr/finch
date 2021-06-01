/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#pragma once

#include "RelPermBase.h"

class RelPermLinear : public RelPermBase
{
public:
  static InputParameters validParams();
  RelPermLinear(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;
};
