% s : nSharesAll
% v : nViewsAll
% nF : number of fake news
% nF : number of true news
function spreadByPsych(s,v,nF,nT,k)
    n = nT + nF;
    inputs = s.extra.varParamVals;
    varNums = 0:1/(length(s.extra.varParamVals)-1):1;
    %should be the same for both
    % Total shares
    %figAAll = figure();
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
        matamax = max(s.(inputs{i}),[],1);
        matamin = min(s.(inputs{i}),[],1);
        % First nF rows are all false news
        mataF = mata(1,1:nF,:);
        mataFmax = matamax(1,1:nF,:);
        mataFmin = matamin(1,1:nF,:);
        % Last nT=n-nF rows are all true news
        mataT = mata(1,nF+1:n,:);
        mataTmax = matamax(1,nF+1:n,:);
        mataTmin = matamin(1,nF+1:n,:);
        % Sum over value per news item (i.e. sum over rows)
        % Then divide by the total number of news items `n` to get the proportional value (in this case of total shares)
        ta = sum(mata,2)./n;
        tamax = sum(matamax,2)./n;
        tamin = sum(matamin,2)./n;
        % Then for fake shares
        taF = sum(mataF,2)./nF;
        taFmax = sum(mataFmax,2)./nF;
        taFmin = sum(mataFmin,2)./nF;
        % Then for true shares
        taT = sum(mataT,2)./nT;
        taTmax = sum(mataTmax,2)./nT;
        taTmin = sum(mataTmin,2)./nT;
        % Squeeze gets takes the remaining (1, 1, #) matrix and makes it an (#) vector
        X = squeeze(ta);
        XF = squeeze(taF);
        XT = squeeze(taT);
        Xmax = squeeze(tamax);
        XFmax = squeeze(taFmax);
        XTmax = squeeze(taTmax);
        Xmin = squeeze(tamin);
        XFmin = squeeze(taFmin);
        XTmin = squeeze(taTmin);
        XList(i) = X(k);
        XFList(i) = XF(k);
        XTList(i) = XT(k);
        XListmax(i) = Xmax(k);
        XFListmax(i) = XFmax(k);
        XTListmax(i) = XTmax(k);
        XListmin(i) = Xmin(k);
        XFListmin(i) = XFmin(k);
        XTListmin(i) = XTmin(k);

        
        
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
        YList(i) = Y(k);
        YFList(i) = YF(k);
        YTList(i) = YT(k);

        %% Viral
        % A matrix of booleans rather than a matrix of integers
        viralThreshold=750;
        tc = sum(matb > viralThreshold,2)./n;
        tcF = sum(matbF > viralThreshold,2)./nF;
        tcT = sum(matbT > viralThreshold,2)./nT;
        Z = squeeze(tc);
        ZF = squeeze(tcF);
        ZT = squeeze(tcT);
        ZList(i) = Z(k);
        ZFList(i) = ZF(k);
        ZTList(i) = ZT(k);
        %%
    end
    figure();
    hold on;
    title("Shares");
    plot(varNums, XList);
    plot(varNums, XFList, '-.');
    plot(varNums, XTList, '--');
    hold off;
    figure();
    hold on;
    title("SharesMax");
    plot(varNums, XListmax);
    plot(varNums, XFListmax, '-.');
    plot(varNums, XTListmax, '--');
    hold off;
    figure();
    hold on;
    title("SharesMin");
    plot(varNums, XListmin);
    plot(varNums, XFListmin, '-.');
    plot(varNums, XTListmin, '--');
    hold off;
    figure();
    hold on;
    title("Views");
    plot(varNums, YList);
    plot(varNums, YFList, '-.');
    plot(varNums, YTList, '--');
    hold off;
    figure();
    hold on;
    title("Viral");
    plot(varNums, ZList);
    plot(varNums, ZFList, '-.');
    plot(varNums, ZTList, '--');
    hold off;
end