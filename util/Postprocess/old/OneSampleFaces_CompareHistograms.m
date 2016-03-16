addpath('functions');

load('~/PermTest/outputs/OneSample_Faces/snpm/outputs_512.mat');
MaxTsnpm = MaxT(:,2);
load('~/PermTest/outputs/OneSample_Faces/regularpt/output_512.mat');
MaxTregular = MaxT;
load('~/PermTest/outputs/OneSample_Faces/rapidpt/outputs_matrix_0.005_60_100_3_512.mat');
MaxTrapidpt = outputs.maxT;
disp('kldivergence regular vs snpm for 512: ');
CompareHistograms(MaxTsnpm, MaxTregular)
disp('kldivergence rapidpt vs snpm for 512: ');
CompareHistograms(MaxTsnpm, MaxTrapidpt)



load('~/PermTest/outputs/OneSample_Faces/snpm/outputs_1024.mat');
MaxTsnpm = MaxT(:,2);
load('~/PermTest/outputs/OneSample_Faces/regularpt/output_1024.mat');
MaxTregular = MaxT;
load('~/PermTest/outputs/OneSample_Faces/rapidpt/outputs_matrix_0.005_60_100_3_1024.mat');
MaxTrapidpt = outputs.maxT;
disp('kldivergence regular vs snpm for 1024: ');
CompareHistograms(MaxTsnpm, MaxTregular)
disp('kldivergence rapidpt vs snpm for 1024: ');
CompareHistograms(MaxTsnpm, MaxTrapidpt)
CompareHistogramsVisually(MaxTregular, MaxTrapidpt)


load('~/PermTest/outputs/OneSample_Faces/snpm/outputs_2048.mat');
MaxTsnpm = MaxT(:,2);
load('~/PermTest/outputs/OneSample_Faces/regularpt/output_2048.mat');
MaxTregular = MaxT;
load('~/PermTest/outputs/OneSample_Faces/rapidpt/outputs_matrix_0.005_60_100_3_2048.mat');
MaxTrapidpt = outputs.maxT;
disp('kldivergence regular vs snpm for 2048: ');
CompareHistograms(MaxTsnpm, MaxTregular)
disp('kldivergence rapidpt vs snpm for 2048: ');
CompareHistograms(MaxTsnpm, MaxTrapidpt)


load('~/PermTest/outputs/OneSample_Faces/snpm/outputs_4095.mat');
MaxTsnpm = MaxT(:,2);
load('~/PermTest/outputs/OneSample_Faces/regularpt/output_4095.mat');
MaxTregular = MaxT;
load('~/PermTest/outputs/OneSample_Faces/rapidpt/outputs_matrix_0.005_60_100_3_4095.mat');
MaxTrapidpt = outputs.maxT;
disp('kldivergence regular vs snpm for 4095: ');
CompareHistograms(MaxTsnpm, MaxTregular)
disp('kldivergence rapidpt vs snpm for 4095: ');
CompareHistograms(MaxTsnpm, MaxTrapidpt)



disp('kldivergence rapidpt vs snpm for 4095 for tails point > 6: ');
CompareHistograms(MaxTsnpm(MaxTsnpm > 6), MaxTrapidpt(MaxTrapidpt > 6))



