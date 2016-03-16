%% Efficient permutation testing using Matrix completion
% % the following function computes the max Null statistic distribution 
% % in its current format, the code only uses t-statistics

%%% Corresponding paper :
% % Speeding up Permutation Testing in Neuroimaging 
% % C Hinrichs, VK Ithapu, Q Sun, SC Johnson, V Singh
% % NIPS 2013

%%% Arguments    
% % 
% %     %%% INPUTS
% %     A structure filed with following arguments
% %     inputs.datapath    :       path to mat file containing the data matrix 
% %                                (REQUIRED) Two fields : data and labeling
% %                                data - a matrix of size N X V
% %                                labels - a vector of length N (2 groups)
% %                                CONTENTS SHOULD BE NAMED "data" and "labels"                                
% %                                (N : number of instances , V : data dimension) 
% %     inputs.sub         :       sub-sampling rate (0 to 1) (DEFAULT = 0.05)
% %     inputs.T           :       number of permutations (DEFAULT = 10^4)
% %     inputs.maxrank     :       rank for estimating the low rank subspace (DEFAULT = N)
% %     inputs.traintime   :       number of permutations for training (DEFAULT = 100)
% %     inputs.maxCycles   :       number of cycles for training (DEFAULT = 3)
% %     inputs.iter        :       number of iterations for matrix completion (DEFAULT = 30)  
% %     inputs.writing     :       if 0 - outputs only maxnull (SEE BELOW) 
% %                                if 1 - outputs maxnull, U and W (DEFAULT = 0)
% %     inputs.save        :       path to save the outputs (DEFAULT : working folder)  
% % 
% %     %%% OUTPUTS
% %     outputs.maxnull     :       estimated distribution of max Null statistic
% %     outputs.U           :       orthogonal matrix spanning low rank subspace
% %                                 (dimension : V X maxrank) 
% %                                 optional output (DEFAULT : No)

%%% Support codes for matrix completion
% % GRASTA : https://sites.google.com/site/hejunzz/grasta
% % Codes already included in the package

%%% Usage 
% %     inputs.data = '/home/user/mydata/pt_data.mat';
% %     inputs.maxrank = 30; input.T = 1000; input.traintime = 50; 
% %     inputs.display = 1;
% %     outputs = Efficient_PT(inputs);

function [ outputs ] = RapidPermutationTesting( inputs )
% RapidPermutationTesting 
%   Modified permutation testing algorithm described in the following paper
%   Speeding up Permutation Testing in Neuroimaging  C Hinrichs, VK Ithapu, Q Sun, SC Johnson, V Singh, NIPS 2013

    fprintf('Starting RapidPermutationTesting...\n');
    tTotal = tic;
    fprintf('\nStarting Preprocessing...\n');
    fprintf('Validate Required Inputs...\n');
    ValidateInputs(inputs);
    data = inputs.data;
    dataSquared = data.*data;
    labels = inputs.labels;
    rapidPTLibraryPath = inputs.rapidPTLibraryPath;
    
    fprintf('Adding Paths...\n');
    AddPaths(rapidPTLibraryPath);
    
    fprintf('Processing Input Parameters...\n');
    N = size(data,1); % N: number of instances/subjects (rows in data matrix)
    V = size(data,2); % V: Number of statistics/voxel measurements (cols) 
    uniqueLabels = unique(labels); % Unique labels
    nGroup1 = length(find(labels==uniqueLabels(1))); % Number of patients in group 1
    nGroup2 = N - nGroup1;
    [sub, numPermutations, maxRank, trainNum, maxCycles, iter, write, saveDir, timingDir] = ProcessInput(inputs, N);

    fprintf('Initializing matrix completion parameters (GRASTA parameters) \n');
    [ options, opts, opts2, status ] = InitGrastaParams(maxRank, iter, V);
    
    fprintf('Initializing permutation matrices... \n');
    % indexMatrix is what indexMatrix used to be..
    [indexMatrix, permutationMatrix1, permutationMatrix2] = GetPermutationMatrices(labels, numPermutations, N, nGroup1, nGroup2);
   
    binRes = 0.05; 
    maxnullBins = -9:binRes:9; %% bin resolution in maxnull histogram computation
    subV = round(sub*V); %% number of samples used per permutation
    subBatch = trainNum; %% number of permutations handled at once -- for commputational ease
    batches = ceil(numPermutations/subBatch); %% number of such batches
    maxTStatistics = zeros(1, numPermutations); %% estimated max statistics for all permutations

%% Training for low rank subsapace and residual priors

    fprintf('\nStarting Algorithm...\n');
    fprintf('Training for low rank subspace and residual priors \n');

    tTraining = tic;

    labelsCurrent = indexMatrix(1:1:trainNum,:);
    %permutationMatrix1Current = permutationMatrix1(1:1:trainNum,:);
    %permutationMatrix2Current = permutationMatrix2(1:1:trainNum,:);

    
    tTrainPermTestIterative = tic;
    % Calculate some full permutations for training U (A good number would be the number of labels).
    TCurrent = mexPermTestIterative(data,labelsCurrent,nGroup1);
    tTrainPermTestIterative = toc(tTrainPermTestIterative);
    timings.tTrainPermTestIterative = tTrainPermTestIterative;
    

    
    framesOrder = zeros(trainNum, maxCycles);
    for m = 1:1:maxCycles
        framesOrder(:,m) = randperm(trainNum);
    end
    
    % Estimate U using subsample matrix completion methods
    UHat = orth(randn(V,options.RANK)); 

    % Time the grasta function calls many times
    tAllGrastaStream = zeros(1, maxCycles*trainNum);
    
    counter = 1;
    for m = 1:1:maxCycles
        for f = 1:1:trainNum
            tGrastaStream = tic;
            r = randperm(V); 
            inds = r(1:subV)'; 
            I_inds = TCurrent(framesOrder(f,m),inds)';
            [UHat, status, opts] = grasta_stream(I_inds, inds, UHat, status, options, opts);
            fprintf('Subspace estimation on %s cycle with %s frame \n',num2str(m),num2str(f));
            tGrastaStream = toc(tGrastaStream);
            tAllGrastaStream(1, counter) = tGrastaStream;
            counter = counter + 1;
        end
    end 
    
    timings.tAvgGrastaStream = mean(tAllGrastaStream);
    tAllGrastaSrp = zeros(1, maxCycles*trainNum);
    counter = 1;
    
    diffForNormal = zeros(trainNum,maxCycles);
    for m = 1:1:maxCycles
        Ts_ac = zeros(V,trainNum); 
        Ts_tr = zeros(V,trainNum);
        for f = 1:1:trainNum
            Ts_ac(:,f) = TCurrent(framesOrder(f,m),:)';
            r = randperm(V); 
            inds = r(1:subV)'; 
            I_inds = Ts_ac(inds,f);
            % Time srp function
            tSrp = tic;
            [s, w, jnk] = mex_srp(UHat(inds,:), I_inds, opts2); 
            tSrp = toc(tSrp);
            tAllGrastaSrp(1,counter) = tSrp;
            counter = counter + 1;
            
            sall = zeros(V,1); 
            sall(inds) = s; 
            Ts_tr(:,f) = (UHat*w + sall)';
            fprintf('Training done on %s cycle with %s frame \n',num2str(m),num2str(f));
        end
        max_Ts_ac = max(Ts_ac,[],1); 
        max_Ts_tr = max(Ts_tr,[],1);
        diffForNormal(:,m) = max_Ts_ac - max_Ts_tr;
    end

    timings.tAvgGrastaSrpTraining = mean(tAllGrastaSrp);

    [muFit,varFit] = normfit(diffForNormal(:));

    tTraining = toc(tTraining);
    timings.tTraining = tTraining;

%% Recovery : Filling in W and residuals for all numPermutations
    fprintf('\n Recovering the subspace coefficients and residuals for all permutations \n');
    tRecovery = tic;
    tAllPermTest = zeros(1, numPermutations);
    tAllGrastaSrp = zeros(1, numPermutations);
    counter = 1;
    
    outputs = 0;
%
    W = cell(numPermutations,1); 
    t = 1;
    for c = 1:1:batches
        labelsCurrent = indexMatrix(1+(c-1)*subBatch:c*subBatch,:);
        for frameNum = 1:1:subBatch
            r = randperm(V); 
            inds = r(1:subV)';
            tPermTest = tic;
            TCurrent = mexPermTestIterative(data(:,inds),labelsCurrent(frameNum,:),nGroup1);
            tPermTest = toc(tPermTest);
            tAllPermTest(1, counter) = tPermTest;
            %
            U_inds = UHat(inds,:);
            tSrp = tic;
            [s, w, jnk] = mex_srp(U_inds, TCurrent', opts2);
            tSrp = toc(tSrp);
            tAllGrastaSrp(1,counter) = tSrp;
            %
            W{t,1} = w; 
            t = t + 1;
            sAll = zeros(V,1); 
            sAll(inds) = sAll(inds) + s; 
            TRec = UHat*w + sAll + muFit;
            %
            maxTStatistics(1,(c-1)*subBatch+frameNum) = max(TRec);
            fprintf('Completion done on trial %d/%d (block %d) \n',(c-1)*subBatch+frameNum,numPermutations,c);  
            counter = counter + 1;
        end
    end

    % Save timings
    tRecovery = toc(tRecovery);
    tAvgPermTime = mean(tAllPermTest);
    tAvgSrpTimeRecovery = mean(tAllGrastaSrp);
    timings.tRecovery = tRecovery;
    timings.tAvgPermTime = tAvgPermTime;
    timings.tAvgSrpTimeRecovery = tAvgSrpTimeRecovery;
    
    outputs.maxnull = gen_hist(maxTStatistics,maxnullBins); 
    outputs.maxT = maxTStatistics;

    if inputs.writing == 1 
        outputs.U = UHat; 
        outputs.W = W; 
    end
    
    description = strcat('_',num2str(sub),'_',num2str(trainNum),'_',num2str(numPermutations));
    outputFilename = strcat('outputs_adrc', description);
    save(sprintf(strcat('%s/',outputFilename,'.mat'), saveDir), 'outputs');
    fprintf('\n Outputs saved to output.mat .. DONE \n');
%
    tTotal = toc(tTotal);
    timings.tTotal = tTotal;
    timingsFilename = strcat(timingDir, 'timings', description,'.mat');
    save(timingsFilename, 'timings'); 
    

end
