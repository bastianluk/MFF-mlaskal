/*

DU12SEM.CPP

JY

Mlaskal's semantic interface for DU1-2

*/

// CHANGE THIS LINE TO #include "du3456sem.hpp" WHEN THIS FILE IS COPIED TO du3456sem.cpp
#include "du12sem.hpp"
#include "duerr.hpp"
#include <cstdlib>
#include<cmath>

using namespace std;

namespace mlc {
	
	tuple<int, bool> parse_int(const string input)
	{
		int value = 0;
		auto error = false;			
		
		for (unsigned int i = 0; i < input.length(); i++)
		{
			if (isdigit(input[i]))
			{
				auto newValue = value * 10 + (int)(input[i] - '0');

				if (newValue <= value)
				{
					error = true;
				}

				value = newValue;
			}
			else
			{
				break;
			}
		}
		
		return make_tuple(value, error);
	}

	
	tuple<float, bool> parse_real(const string input)
	{
		float value = 0;
		auto error = false;
		try
		{
			value = stof(input);
		}
		catch (const out_of_range& oor)
		{
			error = true;
		}
		return make_tuple(value, error);
	}

};

/*****************************************/