/*

	DU12SEM.H

	DB

	Mlaskal's semantic interface for DU1-2

*/

#ifndef __DU12SEM_H
#define __DU12SEM_H

#include <string>
#include "literal_storage.hpp"
#include "flat_icblock.hpp"
#include "dutables.hpp"
#include "abstract_instr.hpp"
#include "gen_ainstr.hpp"
#include<tuple>
#include<cmath>
#include<cstdlib>

using namespace std;

namespace mlc {

	tuple<int, bool> parse_int(char* rawInput);
	
	tuple<float, bool> parse_real(char* rawInput);

}

#endif