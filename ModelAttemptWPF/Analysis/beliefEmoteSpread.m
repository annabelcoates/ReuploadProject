% s : nSharesAll
% v : nViewsAll
% newsInfo
% nF : number of fake news
% nF : number of true news
function spreadByTime(s,v,newsInfo,nF,nT)
    view(3);
    n = nT + nF;
    inputs = s.extra.varParamVals;
    %should be the same for both
    % Total shares
    figAAll = figure();
    % A : Shares
    % B : Views
    % C : Viral
    % T : True
    % F : Flase
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
        
        %% Shares
        % Sum along the runs (i.e. the 1st dimension)
        % Then divide by total runs to average over runs
        mata = sum(s.(inputs{i}),1)./runs;
        mata = squeeze(mata);
        ta = mata(:, size(mata, 2));
        X = squeeze(ta);
        mataF = mata(1:nF,:);
        taF = mataF(:, size(mataF, 2));
        XF = squeeze(taF);
        mataT = mata(nF+1:n,:);
        taT = mataT(:, size(mataT, 2));
        XT = squeeze(taT);

        
        %% Views
        matb = sum(v.(inputs{i}),1)./runs;
        matb = squeeze(matb);
        tb = matb(:, size(matb, 2));
        Y = squeeze(tb);
        matbF = matb(1:nF,:);
        tbF = matbF(:, size(matbF, 2));
        YF = squeeze(tbF);
        matbT = matb(nF+1:n,:);
        tbT = matbT(:, size(matbT, 2));
        YT = squeeze(tbT);

        %% Viral
        % A matrix of booleans rather than a matrix of integers
        viralThreshold=750;
        tc = tb > viralThreshold;
        tcF = tbF > viralThreshold;
        tcT = tbT > viralThreshold;
        Z = squeeze(tc);
        ZF = squeeze(tcF);
        ZT = squeeze(tcT);
        %%
        figure(figAAll);
        title("Total shares")
        hold on;
        scatter3(newsBel,newsEmo,X);
        %%
        figure(figAT);
        title("Total true shares")
        hold on;
        scatter3(newsBelT,newsEmoT,XT);
        %%
        figure(figAF);
        title("Total fake shares")
        hold on;
        scatter3(newsBelF,newsEmoF,XF);
        %%
        figure(figBAll);
        title("Total views")
        hold on;
        scatter3(newsBel,newsEmo,Y);
        %%
        figure(figBT);
        title("Total true views")
        hold on;
        scatter3(newsBelT,newsEmoT,YT);
        %%
        figure(figBF);
        title("Total fake views")
        hold on;
        scatter3(newsBelF,newsEmoF,YF);
        %%
        figure(figCAll);
        title("Total viral")
        hold on;
        scatter3(newsBel,newsEmo,Z);
        %%
        figure(figCT);
        title("Total true viral")
        hold on;
        scatter3(newsBelT,newsEmoT,ZT);
        %%
        figure(figCF);
        title("Total fake viral")
        hold on;
        scatter3(newsBelF,newsEmoF,ZF);
        %%
    end
    hold off;
end