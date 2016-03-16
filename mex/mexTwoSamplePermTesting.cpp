/**
 * To compile:
 * In matlab terminal run:
 * setenv('LAPACK_VERSION', '/usr/local/Cellar/lapack/3.5.0/lib/liblapack.dylib')
 * setenv('BLAS_VERSION', '/usr/local/Cellar/lapack/3.5.0/lib/libblas.dylib')
 * mex -compatibleArrayDims -larmadillo -llapack -lblas mexPermTestSerial.cpp
 **/

#include <iostream>
#include <math.h>
#include <matrix.h>
#include <mex.h>
#include "/usr/include/armadillo"



void matlab2arma(arma::mat& A, const mxArray *mxdata)
{
    arma::access::rw(A.mem)=mxGetPr(mxdata);
    arma::access::rw(A.n_rows)=mxGetM(mxdata); // transposed!
    arma::access::rw(A.n_cols)=mxGetN(mxdata);
    arma::access::rw(A.n_elem)=A.n_rows*A.n_cols;
};

void freeVar(arma::mat& A, const double *ptr)
{
    arma::access::rw(A.mem)=ptr;
    arma::access::rw(A.n_rows)=1; // transposed!
    arma::access::rw(A.n_cols)=1;
    arma::access::rw(A.n_elem)=1;
};

/**
 * Inputs: prhs (list of pointers to inputs), nrhs = number of inputs
 * Outputs nlhs (list of pointers to outputs)
 *
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    if (nrhs != 6){
         mexErrMsgTxt("Incorrect number of input arguments");
    }

    arma::mat g1Mean;
    arma::mat g2Mean;
    arma::mat g1Var;
    arma::mat g2Var;
    arma::mat tStatMatrix;
    
    //declare variables
    mxArray *data_in, *dataSquared_in, *nPermutations_in, *nGroup1_in, *nGroup2_in; // Input
    mxArray *tStatMatrix_out; //Output
    
    // Get data_in info
    const mwSize *dims_data_in = mxGetDimensions(prhs[0]);
    int rows_data_in = (int)dims_data_in[0]; //ydim 
    int cols_data_in = (int)dims_data_in[1]; //xdim
    int numdims_data_in =  mxGetNumberOfDimensions(prhs[0]);     

    // Get dataSquared_in info
    const mwSize *dims_dataSquared_in = mxGetDimensions(prhs[1]);
    int rows_dataSquared_in = (int)dims_dataSquared_in[0]; //ydim 
    int cols_dataSquared_in = (int)dims_dataSquared_in[1]; //xdim
    int numdims_dataSquared_in =  mxGetNumberOfDimensions(prhs[1]);
    

    // Get permutationMatrix1_in info
    const mwSize *dims_permutationMatrix1_in = mxGetDimensions(prhs[2]);
    int rows_permutationMatrix1_in = (int)dims_permutationMatrix1_in[0]; //ydim 
    int cols_permutationMatrix1_in = (int)dims_permutationMatrix1_in[1]; //xdim
    int numdims_permutationMatrix1_in =  mxGetNumberOfDimensions(prhs[2]);
    
    // Get permutationMatrix2_in info
    const mwSize *dims_permutationMatrix2_in = mxGetDimensions(prhs[3]);
    int rows_permutationMatrix2_in = (int)dims_permutationMatrix2_in[0]; //ydim 
    int cols_permutationMatrix2_in = (int)dims_permutationMatrix2_in[1]; //xdim
    int numdims_permutationMatrix2_in =  mxGetNumberOfDimensions(prhs[3]);
    
    // Get nGroup1/2_in info
    int nGroup1 = mxGetScalar(prhs[4]);
    int nGroup2 = mxGetScalar(prhs[5]);

    // Allocate memory for data_in
    arma::mat data(rows_data_in, cols_data_in);
    const double* data_mem = arma::access::rw(data.mem);
    arma::mat dataSquared(rows_dataSquared_in, cols_dataSquared_in);
    const double* dataSquared_mem = arma::access::rw(dataSquared.mem);
    arma::mat permutationMatrix1(rows_permutationMatrix1_in, cols_permutationMatrix1_in);
    const double* permutationMatrix1_mem = arma::access::rw(permutationMatrix1.mem);
    arma::mat permutationMatrix2(rows_permutationMatrix2_in, cols_permutationMatrix2_in);
    const double* permutationMatrix2_mem = arma::access::rw(permutationMatrix2.mem);
    // Convert data to armadillo matrix
    matlab2arma(data, prhs[0]);
    matlab2arma(dataSquared, prhs[1]);
    matlab2arma(permutationMatrix1, prhs[2]);
    matlab2arma(permutationMatrix2, prhs[3]);

    
    // Do permutation testing!
    // nPermutations x V matrix
    tStatMatrix = arma::zeros(rows_permutationMatrix1_in, cols_data_in);
    // Allocate memory for T
    const double* tStatMatrix_mem = arma::access::rw(tStatMatrix.mem);
    
    //associate 
    tStatMatrix_out = plhs[0] = mxCreateDoubleMatrix(tStatMatrix.n_rows,tStatMatrix.n_cols, mxREAL);
//     
//     
//     g1Mean = (permutationMatrix1 * data) / nGroup1;
//     g2Mean = (permutationMatrix2 * data) / nGroup2;
//     g1Var = ((permutationMatrix1 * dataSquared) / (nGroup1)) - (g1Mean % g1Mean); 
//     g2Var = ((permutationMatrix2 * dataSquared) / (nGroup2)) - (g2Mean % g2Mean);
//     tStatMatrix = (g1Mean - g2Mean) / (sqrt((g1Var/(nGroup1-1)) + (g2Var/(nGroup2-1)))); 
//     
    matlab2arma(tStatMatrix, plhs[0]);
  
    freeVar(data, data_mem);
    freeVar(dataSquared, dataSquared_mem);
    freeVar(tStatMatrix, tStatMatrix_mem);

}