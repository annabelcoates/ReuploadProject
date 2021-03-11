% s : nSharesAll
% v : nViewsAll
% nF : number of fake news
% nF : number of true news
function spreadByPsych(s,v,nF,nT)
    n = nT + nF;
    inputs = s.extra.varParamVals;
    varNums = s.extra.varParamValsNum;
    %should be the same for both
    % Total shares
    figAAll = figure();
    % A : Shares
    % B : Views
    % C : Viral
    % T : True
    % F : Flase
    % % Total true shares
    % figAT = figure();
    % % Total fake shares
    % figAF = figure();
    % % Total views
    % figBAll = figure();
    % % Total true views
    % figBT = figure();
    % % Total fake views
    % figBF = figure();
    % % Total viral
    % figCAll = figure();
    % % Total true viral
    % figCT = figure();
    % % Total fake viral
    % figCF = figure();
    % Iterate over parameter 
    XList = 1:s.extra.varParamVals_len;
    XFList = 1:s.extra.varParamVals_len;
    XTList = 1:s.extra.varParamVals_len;
    YList = 1:s.extra.varParamVals_len;
    YFList = 1:s.extra.varParamVals_len;
    YTList = 1:s.extra.varParamVals_len;
    ZList = 1:s.extra.varParamVals_len;
    ZFList = 1:s.extra.varParamVals_len;
    ZTList = 1:s.extra.varParamVals_len;
    for i = 1:s.extra.varParamVals_len;
        % Get the number of runs
        [runs, ~] = size(s.(inputs{i}));

        %% Shares
        % Sum along the runs (i.e. the 1st dimension)
        % Then divide by total runs to average over runs
        mata = sum(s.(inputs{i}),1)./runs;
        % First nF rows are all false news
        mataF = mata(1,1:nF,:);
        % Last nT=n-nF rows are all true news
        mataT = mata(1,nF+1:n,:);
        % Sum over value per news item (i.e. sum over rows)
        % Then divide by the total number of news items `n` to get the proportional value (in this case of total shares)
        ta = sum(mata,2)./n;
        % Then for fake shares
        taF = sum(mataF,2)./nF;
        % Then for true shares
        taT = sum(mataT,2)./nT;
        % Squeeze gets takes the remaining (1, 1, #) matrix and makes it an (#) vector
        X = squeeze(ta);
        XF = squeeze(taF);
        XT = squeeze(taT);
        XList(i) = X(n);
        XFList(i) = XF(nF);
        XTList(i) = XT(nT);

        
        
        %% Views
        matb = sum(v.(inputs{i}),1)./runs;
        matbF = matb(1,1:nF,:);
        matbT = matb(1,nF+1:n,:);
        tb = sum(matb,2)./n;
        tbF = sum(matbF,2)./nF;
        tbT = sum(matbT,2)./nT;
        Y = squeeze(tb);
        YF = squeeze(tbF);
        YT = squeeze(tbT);
        YList(i) = Y(n);
        YFList(i) = YF(nF);
        YTList(i) = YT(nT);

        %% Viral
        % A matrix of booleans rather than a matrix of integers
        viralThreshold=750;
        tc = sum(matb > viralThreshold,2)./n;
        tcF = sum(matbF > viralThreshold,2)./nF;
        tcT = sum(matbT > viralThreshold,2)./nT;
        Z = squeeze(tc);
        ZF = squeeze(tcF);
        ZT = squeeze(tcT);
        ZList(i) = Z(n);
        ZFList(i) = ZF(nF);
        ZTList(i) = ZT(nT);
        %%
    end
    figure();
    title("Total shares");
    plot(varNums, XList);
    figure();
    title("Total fake shares");
    plot(varNums, XFList);
    figure();
    title("Total true shares");
    plot(varNums, XTList);
    figure();
    title("Total views");
    plot(varNums, YList);
    figure();
    title("Total fake views");
    plot(varNums, YFList);
    figure();
    title("Total true views");
    plot(varNums, YTList);
    figure();
    title("Total viral");
    plot(varNums, ZList);
    figure();
    title("Total fake viral");
    plot(varNums, ZFList);
    figure();
    title("Total true viral");
    plot(varNums, ZTList);
end