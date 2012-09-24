//============================================================================
// Name        : RandomCallGenerator
// Author      : Dipl.-Ing. Gary Grutzek
// Version     : 1.0
// Copyright   : Copyright 2011 Fachhochschule Koeln
// Description : Generate Random Features with non-uniform distribution
//============================================================================

#include <fstream>
#include <iostream>
#include <vector>
#include <boost/random.hpp>
#include <boost/cstdint.hpp>
#include <stdio.h>
#include <stdlib.h>


#define UNIFORM

using namespace std;

// write data 
int writeToCSV(string csvName, vector<uint64_t>data, int len)
{
	std::ofstream csvFile;
    csvFile.open(csvName.c_str());
    
    if (csvFile.is_open())
    {
        // write data
        // csvFile << "#3" << std::endl; // VIAT ID for Peak pattern
        for (int i=1; i<=len; i++) {
            //		 Position ,	   Feature
            csvFile << i << "," << data[i-1] << std::endl;
        }
        csvFile.close();
        
    }
    else
        cout << "file error! sure directory exists?" << endl;
    return 0;
}

// random with normal distribution
double randNorm(uint64_t max)
{
    boost::random::mt19937 rng; // produces randomness out of thin air
    rng.seed((int)clock());     // seed 
    boost::random::normal_distribution<>normalDist(1,max);
    return normalDist(rng);
}

// random with uniform distribution between 0..1
double randUni()
{
    //    boost::random::mt19937 rng;      // produces randomness out of thin air
    //    rng.seed((int)clock());     // seed 
    //    boost::random::uniform_int_distribution<>uniDist(1,max);
    //    return uniDist(rng);
    boost::mt19937 rng;
    rng.seed((int)clock());     // seed 
    boost::uniform_01<boost::mt19937> uniDist(rng);
    return uniDist();
}

//
void getSeed(int* numbers, int len)
{
    ifstream rand("/dev/urandom");
    char tmp[len*sizeof(int)];
    rand.read(tmp,len*sizeof(int));
    rand.close();
    memcpy(numbers, &tmp, len*sizeof(int));
}

uint64_t randUniInt64(uint64_t max, int seed)
{
  //  struct timeval tv;
    boost::mt19937 randGen;
    randGen.seed(seed);
    boost::uniform_int<uint64_t> uInt64Dist(0, max);
    boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t> > getRand(randGen, uInt64Dist);
    uint64_t clock_seq_= getRand();
    return clock_seq_;
}



int main(int argc, char* argv[]) {
    
	if (argc != 6) {
		cout << "Usage: " << argv[0] << " <bit depth> <length> <csv path> <no of files> <offset>" << endl;
		return 1;
	}
    
    // input parameters
    int len = atoi(argv[2]); // length
    unsigned long features = (unsigned long)pow(2.0, atoi(argv[1]))-1; // 2^bitDepth
    int noOfFiles = atoi(argv[4]);
    int offset = atoi(argv[5]);
    
    //  cout << len << " " << features << " " << argv[1] << endl;
    
    for (int files=0; files<noOfFiles; files++) {
        
        // init random data vector
        vector<uint64_t> randVector(len);
        
#ifdef UNIFORM
        
        
        int* randNums = (int*) malloc(len * sizeof(int));
        getSeed(randNums, len);
        
        for (int i=0; i<len; i++) {
            randVector[i] = randUniInt64(features, randNums[i]);
        }
        free(randNums);
#else
        if (atoi(argv[1]) == 64) {
            
            for (int i=0; i<len; i++) {
                
                // multiple gauss
                if (i<len * 0.2) 
                    randVector[i] = features*0.2 + randNorm(features/(16*2));
                else if (i < len * 0.4)
                    randVector[i] = features*0.5 + randNorm(features/(20*2));
                else if (i < len * 0.6)
                    randVector[i] = features*0.8 + randNorm(features/(12*2)) ;
                else 
                    randVector[i] = features * randUni();
                
                // limit
                if (randVector[i] > features) 
                    randVector[i] = 1 + features * 0.99999 * randUni();
                else if (randVector[i] <= 0)
                    randVector[i] = 1 + features * 0.99999 * randUni();
                //   cout << randVector[i] << endl;
            }
        }
        else {
            for (int i=0; i<len; i++) {
                
                // multiple gauss
                if (i<len * 0.2) 
                    randVector[i] = features*0.2 + randNorm(features/16);
                else if (i < len * 0.4)
                    randVector[i] = features*0.5 + randNorm(features/20);
                else if (i < len * 0.6)
                    randVector[i] = features*0.8 + randNorm(features/12) ;
                else 
                    randVector[i] = features * randUni();
                
                // limit
                if (randVector[i] > features) 
                    randVector[i] = 1 + features * 0.999 * randUni();
                else if (randVector[i] <= 0)
                    randVector[i] = 1 + features * 0.999 * randUni();
                //   cout << randVector[i] << endl;
            }
        }
        // permute vector
        random_shuffle(randVector.begin(), randVector.end());
#endif
        // filename  
        stringstream filepath;
        filepath << argv[3] << '/' << files+1+offset << ".csv";
        //  cout << filepath.str() << endl;
        writeToCSV(filepath.str(), randVector, len);
    }
    
	return 0;
}

