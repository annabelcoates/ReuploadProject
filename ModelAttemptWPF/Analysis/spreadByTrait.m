% s : nSharesAll
% v : nViewsAll
% newsInfo
% nF : number of fake news
% nF : number of true news
function spreadByTrait(s,v,newsInfo,nF,nT)
    n = nT + nF;
    hold on;
    inputs = s.extra.varParamVals;
    %should be the same for both
    % Total shares
    figAAll = figure();
    % A : Shares
    % B : Views
    % C : Viral
    % T : True
    % F : False
    % Total true shares
    figAT = figure();
    % Total fake shares
    figAF = figure();
    % Total views
    figBAll = figure();
    % Total true views
    figBT = figure();
    % Total fake views
    figBF = figure();
    % Total viral
    figCAll = figure();
    % Total true viral
    figCT = figure();
    % Total fake viral
    figCF = figure();
    % Iterate over parameter 
    for i = 1:s.extra.varParamVals_len
        % Get the number of runs
        [runs, ~] = size(s.(inputs{i}));

        newsProps = sum(newsInfo.(inputs{i}),1)./runs;
        newsProps = squeeze(newsProps);
        newsBel = newsProps(:,1);
        newsBelF = newsBel(1:nF);
        newsBelT = newsBel(nF+1:n);
        newsEmo = newsProps(:,2);
        newsEmoF = newsEmo(1:nF);
        newsEmoT = newsEmo(nF+1:n);
        newsPol = newsProps(:,3);
        newsPolF = newsPol(1:nF);
        newsPolT = newsPol(nF+1:n);
        
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

        %% Viral
        % A matrix of booleans rather than a matrix of integers
        viralThreshold=750
        tc = sum(matb > viralThreshold,2)./n;
        tcF = sum(matbF > viralThreshold,2)./nF;
        tcT = sum(matbT > viralThreshold,2)./nT;
        Z = squeeze(tc);
        ZF = squeeze(tcF);
        ZT = squeeze(tcT);
        %%
        figure(figAAll);
        title("Total shares")
        hold on;
        plot(X);
        %%
        figure(figAT);
        title("Total true shares")
        hold on;
        plot(XT);
        %%
        figure(figAF);
        title("Total fake shares")
        hold on;
        plot(XF);
        %%
        figure(figBAll);
        title("Total views")
        hold on;
        plot(Y);
        %%
        figure(figBT);
        title("Total true views")
        hold on;
        plot(YT);
        %%
        figure(figBF);
        title("Total fake views")
        hold on;
        plot(YF);
        %%
        figure(figCAll);
        title("Total viral")
        hold on;
        plot(Z);
        %%
        figure(figCT);
        title("Total true viral")
        hold on;
        plot(ZT);
        %%
        figure(figCF);
        title("Total fake viral")
        hold on;
        plot(ZF);
        %%
    end
    hold off;
end