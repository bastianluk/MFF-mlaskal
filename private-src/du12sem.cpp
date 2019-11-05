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
	
	tuple<int, bool> parse_int(char* rawInput)
	{
		long value = 0;
		auto error = false;
		
		string input = _strdup(rawInput);
		auto lastDigitIndex = 0;

		for (int i = 0; i < input.length(); i++)
		{
			if (!isdigit(input[i]))
			{
				break;
			}
			lastDigitIndex = i;
		}
		
		for (int i = max(0, lastDigitIndex - 7); i <= lastDigitIndex; i++)
		{
			value = value * 10 + (int)(input[i] - '0');
		}

		if (lastDigitIndex > 7)
		{
			error = true;
		}
		
		return make_tuple((int)value, error);
	}

	
	tuple<float, bool> parse_real(char* rawInput)
	{
		float value = 0;
		auto error = false;
		try
		{
			value = stof(string(_strdup(rawInput)));
		}
		catch (const out_of_range& oor)
		{
			error = true;
		}
		return make_tuple(value, error);
	}

};

/*****************************************/