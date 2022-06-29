// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  Must ensure g++ compiler is installed:
//	sudo apt-get install g++

// ***************************************************************************

#include <iostream>

using namespace std;

// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" bool getArguments(int, char* [], FILE **, FILE **, bool *);
extern "C" void countDigits(FILE*, int []);
extern "C" void int2aBin(int, char []);
extern "C" void writeString(FILE *, char []);

// ***************************************************************
//  Basic C++ program (does not use any objects).

int main(int argc, char* argv[])
{
// --------------------------------------------------------------------
//  Declare variables and simple display header
//	By default, C++ integers are doublewords (32-bits).

	FILE		*rdFileDesc, *wrFileDesc;
	bool		displayToScreen;
	int		digitCounts[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	int	sum = 0;
	int	scale = 0;
	int	starCount = 0;

	const	int MAX = 500;
	char	tmpStr[33] = {0};
	char	header1[] = "CS 218 Benfords Law\n";
	char	header2[] = "Test Results\n\n";
	char	totalStr[] = "Total Data Points: ";
	char	fileNameStr[] = "Source File: ";
	char	lineStr[] = " _  ";
	char	barStr[] = " | ";
	char	newLine[] = {10, 0};
	char	stars[MAX+1] = {0};

// --------------------------------------------------------------------
//  If command line arguments OK
//	count the digits
//	display results

	if (getArguments(argc, argv, &rdFileDesc, &wrFileDesc, &displayToScreen)) {

		countDigits(rdFileDesc, digitCounts);

		writeString(wrFileDesc, header1);
		writeString(wrFileDesc, header2);
		writeString(wrFileDesc, fileNameStr);
		writeString(wrFileDesc, argv[2]);
		writeString(wrFileDesc, newLine);
		writeString(wrFileDesc, newLine);
		writeString(wrFileDesc, totalStr);

		if (displayToScreen)
			cout << header1 << header2 << fileNameStr
				<< argv[2] << endl << endl << totalStr;
		
		for (int i=0; i < 10; i++)
			sum += digitCounts[i];
		int2aBin(sum, tmpStr);

		writeString(wrFileDesc, tmpStr);
		writeString(wrFileDesc, newLine);
		writeString(wrFileDesc, newLine);

		if (displayToScreen)
			cout << tmpStr << endl << endl;

		for (int i=0; i < 10; i++) {
			lineStr[1] = (i + '0');
			int2aBin(digitCounts[i], tmpStr);

			writeString(wrFileDesc, lineStr);
			writeString(wrFileDesc, tmpStr);
			writeString(wrFileDesc, barStr);

			if (displayToScreen)
				cout << lineStr << tmpStr << barStr;

			for (int i=0; i<MAX; i++)
				stars[i] = 0;
			switch (sum) {
				case 0:
					break;
				case 1 ... 50000:
					scale = 100;
					break;
				case 50001 ... 100000:
					scale = 650;
					break;
				case 100001 ... 500000:
					scale = 1000;
					break;
				case 500001 ... 1000000:
					scale = 2500;
					break;
				case 1000001 ... 2000000:
					scale = 8000;
					break;
				default:
					scale = 14500;
			}
			
			if (sum > 0) {
				starCount = digitCounts[i] / scale;
				for (int j=0; j < starCount; j++)
					stars[j] = '*';
				stars[starCount] = 0;
			}

			writeString(wrFileDesc, stars);
			writeString(wrFileDesc, newLine);

			if (displayToScreen)
				cout << stars << endl;
		}
		writeString(wrFileDesc, newLine);
		if (displayToScreen)
			cout << endl;
	}

// --------------------------------------------------------------------
//  Note, files are closed automatically by OS.
//  All done...

	return	EXIT_SUCCESS;
}

