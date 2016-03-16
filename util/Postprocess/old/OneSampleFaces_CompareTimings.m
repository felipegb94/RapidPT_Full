addpath('functions');

numPermutations = [512, 1024, 2048, 4095];
timingsSnpm = zeros(1,4);
timingsRegularpt = zeros(1,4);
timingsRapidpt = zeros(1,4);
name1 = 'Rapidpt';
name2 = 'Regularpt';
name3 = 'SnPM';


load('~/PermTest/timings/OneSample_Faces/snpm/timings_512.mat');
timingsSnpm(1) = snpmPermTime;
load('~/PermTest/timings/OneSample_Faces/regularpt/timings_512.mat');
timingsRegularpt(1) = timing;
load('~/PermTest/timings/OneSample_Faces/rapidpt/timings_matrix_0.005_60_100_3_512.mat');
timingsRapidpt(1) = timings.tTotal;

load('~/PermTest/timings/OneSample_Faces/snpm/timings_1024.mat');
timingsSnpm(2) = snpmPermTime;
load('~/PermTest/timings/OneSample_Faces/regularpt/timings_1024.mat');
timingsRegularpt(2) = timing;
load('~/PermTest/timings/OneSample_Faces/rapidpt/timings_matrix_0.005_60_100_3_1024.mat');
timingsRapidpt(2) = timings.tTotal;

load('~/PermTest/timings/OneSample_Faces/snpm/timings_2048.mat');
timingsSnpm(3) = snpmPermTime;
load('~/PermTest/timings/OneSample_Faces/regularpt/timings_2048.mat');
timingsRegularpt(3) = timing;
load('~/PermTest/timings/OneSample_Faces/rapidpt/timings_matrix_0.005_60_100_3_2048.mat');
timingsRapidpt(3) = timings.tTotal;

load('~/PermTest/timings/OneSample_Faces/snpm/timings_4095.mat');
timingsSnpm(4) = snpmPermTime;
load('~/PermTest/timings/OneSample_Faces/regularpt/timings_4095.mat');
timingsRegularpt(4) = timing;
load('~/PermTest/timings/OneSample_Faces/rapidpt/timings_matrix_0.005_60_100_3_4095.mat');
timingsRapidpt(4) = timings.tTotal;


CompareTimings(numPermutations,timingsRapidpt,timingsRegularpt,timingsSnpm,name1,name2,name3)








