% s : nSharesAll
% v : nViewsAll
% newsInfo
% nF : number of fake news
% nF : number of true news
function beliefEmoteSpread(s,v,newsInfo,nF,nT, threeD)
    view(3);
    n = nT + nF;
    inputs = s.extra.varParamVals;
    %should be the same for both
    % A : Shares
    % B : Views
    % C : Viral
    % T : True
    % F : Flase
    % Total shares
    figAAll = figure();
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
    if ~threeD
        figAAlltwo = figure();
        figATtwo = figure();
        figAFtwo = figure();
        figBAlltwo = figure();
        figBTtwo = figure();
        figBFtwo = figure();
        figCAlltwo = figure();
        figCTtwo = figure();
        figCFtwo = figure();
    end
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
        if threeD
            view(3);
        end
        if threeD
            figure(figAAll);
            scatter3(newsBel,newsEmo,X);
            title("Total shares")
            hold on;
            view(3);
        else
            figure(figAAll);
            scatter(newsBel,X);
            title("Total shares Belief")
            hold on;
            figure(figAAlltwo);
            scatter(newsEmo,X);
            title("Total shares Emo")
            hold on;
        end
        %%
        if threeD
            figure(figAT);
            scatter3(newsBelT,newsEmoT,XT);
            title("Total true shares")
            hold on;
            view(3);
        else
            figure(figAT);
            scatter(newsBelT,XT);
            title("Total true shares Belief")
            hold on;
            figure(figATtwo);
            scatter(newsEmoT,XT);
            title("Total true shares Emo")
            hold on;
        end
        %%
        if threeD
            figure(figAF);
            scatter3(newsBelF,newsEmoF,XF);
            title("Total fake shares")
            hold on;
            view(3);
        else
            figure(figAF);
            scatter(newsBelF,XF);
            title("Total fake shares Belief")
            hold on;
            figure(figAFtwo);
            scatter(newsEmoF,XF);
            title("Total fake shares Emo")
            hold on;
        end
        %%
        if threeD
            figure(figBAll);
            scatter3(newsBel,newsEmo,Y);
            title("Total views")
            hold on;
            view(3);
        else
            figure(figBAll);
            scatter(newsBel,Y);
            title("Total views Belief")
            hold on;
            figure(figBAlltwo);
            scatter(newsEmo,Y);
            title("Total views Emo")
            hold on;
        end
        %%
        if threeD
            figure(figBT);
            scatter3(newsBelT,newsEmoT,YT);
            title("Total true views")
            hold on;
            view(3);
        else
            figure(figBT);
            scatter(newsBelT,YT);
            title("Total true views Belief")
            hold on;
            figure(figBTtwo);
            scatter(newsEmoT,YT);
            title("Total true views Emo")
            hold on;
        end
        %%
        if threeD
            figure(figBF);
            scatter3(newsBelF,newsEmoF,YF);
            title("Total fake views")
            hold on;
            view(3);
        else
            figure(figBF);
            scatter(newsBelF,YF);
            title("Total fake views Belief")
            hold on;
            figure(figBFtwo);
            scatter(newsEmoF,YF);
            title("Total fake views Emo")
            hold on;
        end
        %%
        if threeD
            figure(figCAll);
            scatter3(newsBel,newsEmo,Z);
            title("Total viral")
            hold on;
            view(3);
        else
            figure(figCAll);
            scatter(newsBel,Z);
            title("Total viral Belief")
            hold on;
            figure(figCAlltwo);
            scatter(newsEmo,Z);
            title("Total viral Emo")
            hold on;
        end
        %%
        if threeD
            figure(figCT);
            scatter3(newsBelT,newsEmoT,ZT);
            title("Total true viral")
            hold on;
            view(3);
        else
            figure(figCT);
            scatter(newsBelT,ZT);
            title("Total true viral Belief")
            hold on;
            figure(figCTtwo);
            scatter(newsEmoT,ZT);
            title("Total true viral Emo")
            hold on;
        %%
        if threeD
            figure(figCF);
            scatter3(newsBelF,newsEmoF,ZF);
            title("Total fake viral")
            hold on;
            view(3);
        else
            figure(figCF);
            scatter(newsBelF,ZF);
            title("Total fake viral Belief")
            hold on;
            figure(figCFtwo);
            scatter(newsEmoF,ZF);
            title("Total fake viral Emo")
            hold on;
        end
        %%
    end
    hold off;
end